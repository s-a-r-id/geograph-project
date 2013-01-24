<?php
/**
 * $Project: GeoGraph $
 * $Id: xmas.php 6235 2009-12-24 12:33:07Z barry $
 * 
 * GeoGraph geographic photo archive project
 * This file copyright (C) 2005 Barry Hunter (geo@barryhunter.co.uk)
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
require_once('geograph/map.class.php');
require_once('geograph/mapmosaic.class.php');
init_session();

$smarty = new GeographPage;


$i = !empty($_GET['i'])?intval($_GET['i']):822;

	require_once('geograph/searchcriteria.class.php');
	require_once('geograph/searchengine.class.php');

	$engine = new SearchEngine($i);
	if (empty($engine->criteria)) {
		print "Invalid search";
		exit;
	}
	$engine->criteria->getSQLParts();
	if (!empty($engine->criteria->sphinx['no_legacy']) || empty($engine->criteria->sphinx['compatible'])) {
		print "Unable to run this search (no sphinx)";
		exit;
	}
	extract($engine->criteria->sql,EXTR_PREFIX_ALL^EXTR_REFS,'sql');
	if (preg_match("/group by ([\w\,\(\) ]+)/i",$sql_where)) {
		print "Unable to run on this search (special search)";
		exit;
	}

	if (!empty($sql_where)) {

	} else {
		print "Unable to run on this search (no filter)";
		exit;
	}
	
	$engine->criteria->searchdesc = preg_replace("/, in [\w ]* order/",'',$engine->criteria->searchdesc);
	$title = "<i>".htmlentities2($engine->criteria->searchdesc)."</i>";

$map=new GeographMap;
//standard 1px national map
$map->setOrigin(0,-10);
$map->setImageSize(900,1300);
$map->setScale(1);

$map->type_or_user = -10;

$blankurl=$map->getImageUrl();



$map->transparent = true;
$map->searchId = $i;
$map->setPalette(3);
$map->type_or_user = -12;



if (!empty($_GET['refresh']) && $USER->hasPerm("admin")) {
	$target=$_SERVER['DOCUMENT_ROOT'].$map->getImageFilename();
	unlink($target);
	$map->_renderMap();
}


$overlayurl=$map->getImageUrl();


$smarty->display('_std_begin.tpl');

print "<h2>Coverage map for Search";
if (!empty($title))
	print "<small><a href=\"/search.php?i=$i\">$title</a></small>";
print "</h2>";

?>
<div style="position:relative; height:1300px;width:900px">
	<div style="position:absolute;top:0;left:0"> 
		<img src="<? echo $blankurl; ?>"/>
	</div>
	<div style="position:absolute;top:0;left:0"> 
		<img src="<? echo $overlayurl; ?>"/>
	</div>
</div>

<?


$smarty->display('_std_end.tpl');

