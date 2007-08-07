<?

$p = $_SERVER['REQUEST_URI'];

#http://s1.www.geograph.org.uk/photos/50/64/506453_c5b9915b_120x120.jpg
if (preg_match('/^\/photos\/(\d{2})\/(\d{2})\/\d{6}_\w+\.jpg$/',$p,$m)) {

#	#give them something quick 
#	header("HTTP/1.1 302 Found");
#	header("Location: http://www.geograph.org.uk$p");
#	#but lets cache it for next time.


	$base=$_SERVER['DOCUMENT_ROOT'].'/photos';
	if (!is_dir("$base/{$m[1]}"))
		mkdir("$base/{$m[1]}");
	if (!is_dir("$base/{$m[1]}/{$m[2]}"))
		mkdir("$base/{$m[1]}/{$m[2]}");


	#the -p is important to maintain the mod date
	system("cp -p /var/www/geograph_live/public_html$p .$p");


	$t=filemtime('.'.$p);
	$type="image/jpeg";
	$size=filesize('.'.$p);
	$e=time()+3600*24*180;


	header("HTTP/1.1 200 OK");
	#header("Status: 200 OK");

	$lastmod=strftime("%a, %d %b %Y %H:%M:%S GMT", $t);	
	header("Last-Modified: $lastmod");

	#no etag cos we dont exactly know apaches system
	#header ("Etag: \"$hash\""); 

	header("Content-Type: $type");
	#header("Content-Size: $size");
	header("Content-Length: $size");
	
	$expires=strftime("%a, %d %b %Y %H:%M:%S GMT", $e);
	header("Expires: $expires");

	readfile('.'.$p);
	exit;

} elseif (preg_match('/\.(css|js|png|gif|jpg)$/',$p)) {
	header("HTTP/1.0 404 Not Found");
	header("Status: 404 Not Found");
	print 'Not Found : <a href="http://www.geograph.org.uk/">Visit our homepage</a>';
	exit;
} else {
	header("HTTP/1.0 301 Moved Permanently");
	header("Status: 301 Moved Permanently");
	header("Location: http://www.geograph.org.uk$p");
	print "<a href=\"http://www.geograph.org.uk$p\">Moved Here</a>";
	exit;
}
?>
