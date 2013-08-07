#!/usr/bin/env python

## Merges a number of folders into a single virtual filesyste, - tailored for Geograph use

#    Copyright (C) 2013  Barry Hunter  <geo@barryhunter.co.uk>

# Based heavily on xmp.py from the fuse-python package, which is by:

#    Copyright (C) 2001  Jeff Epler  <jepler@unpythonic.dhs.org>
#    Copyright (C) 2006  Csaba Henk  <csaba.henk@creo.hu>
#
#    This program can be distributed under the terms of the GNU LGPL.
#    See the file COPYING.
#

import os, sys
import os.path
import random
from errno import *
from stat import *
import fcntl
# pull in some spaghetti to make this stuff work without fuse-py being installed
try:
    import _find_fuse_parts
except ImportError:
    pass
import fuse
from fuse import Fuse


if not hasattr(fuse, '__version__'):
    raise RuntimeError, \
        "your fuse-py doesn't know of fuse.__version__, probably it's too old."

fuse.fuse_python_api = (0, 2)

fuse.feature_assert('stateful_files', 'has_init')


def flag2mode(flags):
    md = {os.O_RDONLY: 'r', os.O_WRONLY: 'w', os.O_RDWR: 'w+'}
    m = md[flags & (os.O_RDONLY | os.O_WRONLY | os.O_RDWR)]

    if flags | os.O_APPEND:
        m = m.replace('w', 'a', 1)

    return m


class GeoGridFS(Fuse):

    def __init__(self, *args, **kw):

        Fuse.__init__(self, *args, **kw)

        # do stuff to set up your filesystem here, if you want
        #import thread
        #thread.start_new_thread(self.mythread, ())
        self.root = '/'
        
        self.mounts = {}
        self.mounts['cream'] = '/var/mount/cream'
        self.mounts['milk'] = '/var/mount/milk'
        self.mounts['jam'] = '/var/mount/jam'

#############################################################################

    def getFirstMount(self, path='/'):
    #todo!
        return self.mounts['milk']

    def getOrderedMounts(self, path='/'):
        # this mostly replicates how files are distributed amongst servers currently, so reads should find them in their ideal location most of the time. 
        if 'photos/' in path:
            if '_original' in path:
                return [self.mounts['jam'], self.mounts['cream']]
            elif 'photos/03/' in path:
                return [self.mounts['cream'], self.mounts['jam'], self.mounts['milk']]   #may as well use milk as a fallback to write if all else fails!
            elif (random.random() < 0.7):
                #because we know it has a complete copy, might as well as let jam take some strain
                return [self.mounts['jam'], self.mounts['cream']]
            else:
                return [self.mounts['cream'], self.mounts['jam']]
        else:
            return [self.mounts['milk'], self.mounts['jam']]
        
        return self.mounts.values()

#############################################################################

    def getattr(self, path):
        for mount in self.getOrderedMounts(path):
            if os.path.exists(mount + path):
                return os.lstat(mount + path)
        
        return os.lstat(mount + 'nonexistant')
        return -ENOENT

    def readlink(self, path):
        for mount in self.getOrderedMounts(path):
            if os.path.exists(mount + path):
                return os.readlink(mount + path)

    def readdir(self, path, offset):
        dedup = {}
        yield fuse.Direntry('.')   #os.listdir does NOT include these!
        yield fuse.Direntry('..')
        for mount in self.getOrderedMounts(path):
            if os.path.exists(mount + path):
                for e in os.listdir(mount + path):
                    if e not in dedup:
                        dedup[e] = True
                        yield fuse.Direntry(e)

    def unlink(self, path):
        for mount in self.getOrderedMounts(path):
            if os.path.exists(mount + path):
                os.unlink(mount + path)

    def rmdir(self, path):
        for mount in self.getOrderedMounts(path):
            if os.path.exists(mount + path):
                os.rmdir(mount + path)

    def symlink(self, path, path1):
        for mount in self.getOrderedMounts(path):
            if os.path.exists(mount + path):
                os.symlink(mount + path, mount + path1)

    def rename(self, path, path1):
        for mount in self.getOrderedMounts(path):
            if os.path.exists(mount + path):
                os.rename(mount + path, mount + path1)

    def link(self, path, path1):
        for mount in self.getOrderedMounts(path):
            if os.path.exists(mount + path):
                os.link(mount + path, mount + path1)

    def chmod(self, path, mode):
        for mount in self.getOrderedMounts(path):
            if os.path.exists(mount + path):
                os.chmod(mount + path, mode)

    def chown(self, path, user, group):
        for mount in self.getOrderedMounts(path):
            if os.path.exists(mount + path):
                os.chown(mount + path, user, group)

    def truncate(self, path, len):
        for mount in self.getOrderedMounts(path):
            if os.path.exists(mount + path):
                f = open(mount + path, "a")
                f.truncate(len)
                f.close()

    def mknod(self, path, mode, dev):
        for mount in self.getOrderedMounts(path):
            if os.path.exists(mount + path):
                os.mknod(mount + path, mode, dev)

    def mkdir(self, path, mode):
        for mount in self.getOrderedMounts(path):
            os.makedirs(mount + path, mode) #so can make dirs recurivly

    def utime(self, path, times):
        for mount in self.getOrderedMounts(path):
            if os.path.exists(mount + path):
                return os.utime(mount + path, times)

#    The following utimens method would do the same as the above utime method.
#    We can't make it better though as the Python stdlib doesn't know of
#    subsecond preciseness in acces/modify times.
#  
#    def utimens(self, path, ts_acc, ts_mod):
#      os.utime(self.getFirstMount(path) + path, (ts_acc.tv_sec, ts_mod.tv_sec))

#todo - fix this to work
    def access(self, path, mode):
        return
#        for mount in self.getOrderedMounts(path):
#            if not os.access(mount + path, mode):
#                return -EACCES

#############################################################################

    def statfs(self):
        """
        Should return an object with statvfs attributes (f_bsize, f_frsize...).
        Eg., the return value of os.statvfs() is such a thing (since py 2.2).
        If you are not reusing an existing statvfs object, start with
        fuse.StatVFS(), and define the attributes.

        To provide usable information (ie., you want sensible df(1)
        output, you are suggested to specify the following attributes:

            - f_bsize - preferred size of file blocks, in bytes
            - f_frsize - fundamental size of file blcoks, in bytes
                [if you have no idea, use the same as blocksize]
            - f_blocks - total number of blocks in the filesystem
            - f_bfree - number of free blocks
            - f_files - total number of file inodes
            - f_ffree - nunber of free file inodes
        """
        #todo total up all mounts?
        return os.statvfs(self.getFirstMount())

    def fsinit(self):
        os.chdir(self.root)

#############################################################################

    class GeoGridFSFile(object):
        direct_io = False
        keep_cache = False
        file = False
        fd = False
        
        def __init__(self, server, path, flags, *mode):
            self.file = False
            
            #first see if can find an actual file
            for mount in server.getOrderedMounts(path):
                if os.path.exists(mount + path):
                    self.file = os.fdopen(os.open(mount + path, flags, *mode), flag2mode(flags))
                    break
            
            #find a mount that has a folder we can use
            if self.file is False:  # and not (flags | os.O_RDONLY)
                for mount in server.getOrderedMounts(path):
                    if os.path.exists(os.path.dirname(mount + path)):
                        self.file = os.fdopen(os.open(mount + path, flags, *mode), flag2mode(flags))
                        break
                
                #if still not found, then just create it on the first mount
                if not self.file: 
                    for mount in server.getOrderedMounts(path):
                        if not os.path.exists(os.path.dirname(mount + path)):
                            os.makedirs(os.path.dirname(mount + path)) # use makedirs so will also create parent dirs as required
                        self.file = os.fdopen(os.open(mount + path, flags, *mode), flag2mode(flags))
                        break

            if self.file is False:
               return -EIO
            
            self.fd = self.file.fileno()

        def read(self, length, offset):
            self.file.seek(offset)
            return self.file.read(length)

        def write(self, buf, offset):
            self.file.seek(offset)
            self.file.write(buf)
            return len(buf)

        def release(self, flags):
            self.file.close()

        def _fflush(self):
            if 'w' in self.file.mode or 'a' in self.file.mode:
                self.file.flush()

        def fsync(self, isfsyncfile):
            self._fflush()
            if isfsyncfile and hasattr(os, 'fdatasync'):
                os.fdatasync(self.fd)
            else:
                os.fsync(self.fd)

        def flush(self):
            self._fflush()
            # cf. xmp_flush() in fusexmp_fh.c
            os.close(os.dup(self.fd))

        def fgetattr(self):
            return os.fstat(self.fd)

        def ftruncate(self, len):
            self.file.truncate(len)

        def lock(self, cmd, owner, **kw):

            # Convert fcntl-ish lock parameters to Python's weird
            # lockf(3)/flock(2) medley locking API...
            op = { fcntl.F_UNLCK : fcntl.LOCK_UN,
                   fcntl.F_RDLCK : fcntl.LOCK_SH,
                   fcntl.F_WRLCK : fcntl.LOCK_EX }[kw['l_type']]
            if cmd == fcntl.F_GETLK:
                return -EOPNOTSUPP
            elif cmd == fcntl.F_SETLK:
                if op != fcntl.LOCK_UN:
                    op |= fcntl.LOCK_NB
            elif cmd == fcntl.F_SETLKW:
                pass
            else:
                return -EINVAL

            fcntl.lockf(self.fd, op, kw['l_start'], kw['l_len'])

#############################################################################

    def main(self, *a, **kw):

        #see http://sourceforge.net/apps/mediawiki/fuse/index.php?title=FUSE_Python_Reference#File_Class_Methods
        class wrapped_GeoGridFSFile(self.GeoGridFSFile):
            def __init__(self2, *a, **kw):
                self.GeoGridFSFile.__init__(self2, self, *a, **kw)

        self.file_class = wrapped_GeoGridFSFile

        return Fuse.main(self, *a, **kw)


def main():

    usage = """
Unify a number of folders into one virtual folder. Designed for merging NFS shares. 

""" + Fuse.fusage

    server = GeoGridFS(version="%prog " + fuse.__version__,
                 usage=usage,
                 dash_s_do='setsingle')

    # Disable multithreading: if you want to use it, protect all method of
    # XmlFile class with locks, in order to prevent race conditions
    server.multithreaded = False

    server.parser.add_option(mountopt="root", metavar="PATH", default='/',
                             help="mirror filesystem from under PATH [default: %default]")
    server.parse(values=server, errex=1)

    try:
        if server.fuse_args.mount_expected():
            os.chdir(server.root)
    except OSError:
        print >> sys.stderr, "can't enter root of underlying filesystem"
        sys.exit(1)

    server.main()


if __name__ == '__main__':
    main()

#############################################################################

