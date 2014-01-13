<?php
/**
 * $Project: GeoGraph $
 * $Id: tags.json.php 7383 2011-08-20 17:49:45Z barry $
 * 
 * GeoGraph geographic photo archive project
 * This file copyright (C) 2011 Barry Hunter (geo@barryhunter.co.uk)
 * 
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */

require_once('geograph/global.inc.php');


if (!empty($_GET['callback'])) {
	header('Content-type: text/javascript');
} else {
	header('Content-type: application/json');
}

customExpiresHeader(3600);


$db = GeographDatabaseConnection(true);

$sql = array();

$sql['columns'] = "tag_id, prefix, tag, canonical, count(*) as images, count(distinct user_id) as users";

$sql['tables'] = array();
$sql['tables']['t'] = 'tag_public';

$sql['wheres'] = array();

$bits = explode(':',$_GET['q']);
if (count($bits) > 1) {
	$sql['wheres'][] = "`prefix` LIKE ".$db->Quote(trim($bits[0]));
	$_GET['q'] = $bits[1];
} else { #if (empty($_GET['expand'])) {
	$sql['wheres'][] = "`prefix` = ''";
}

$sql['wheres'][] = "`tag` LIKE ".$db->Quote(trim($_GET['q']));


$sql['group'] = 'tag_id';

$sql['order'] = 'null';

$sql['limit'] = 2;




$query = sqlBitsToSelect($sql);

$ADODB_FETCH_MODE = ADODB_FETCH_ASSOC;
$data = $db->getAll($query);

if (!empty($data)) {
	if (count($data) > 1) {
		$data = array("error"=>'multiple results');
	} else {
		$data = $data[0];
	}
}


if (!empty($_GET['callback'])) {
        $callback = preg_replace('/[^\w\.-]+/','',$_GET['callback']);
        echo "{$callback}(";
}

require_once '3rdparty/JSON.php';
$json = new Services_JSON();
print $json->encode($data);

if (!empty($_GET['callback'])) {
        echo ");";
}


