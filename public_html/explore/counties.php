<?php
/**
 * $Project: GeoGraph $
 * $Id$
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
require_once('geograph/mapmosaic.class.php');
require_once('geograph/gridsquare.class.php');
init_session();

$smarty = new GeographPage;

$type = (isset($_GET['type']) && preg_match('/^\w+$/' , $_GET['type']))?$_GET['type']:'center';

$template='statistics_counties.tpl';
$cacheid='statistics|counties'.$type;

$smarty->caching = 2; // lifetime is per cache
$smarty->cache_lifetime = 3600*24; //24hr cache

if (!$smarty->is_cached($template, $cacheid))
{
	$db=NewADOConnection($GLOBALS['DSN']);
	if (!$db) die('Database connection failed');  
	#$db->debug = true;

	require_once('geograph/conversions.class.php');
	$conv = new Conversions;

	if ($type == 'center') {
		$smarty->assign("page_title", "County Centre Points*");
		$smarty->assign("extra_info", "* this pages uses counties from 1995 (at a guess) and for some unknown reason Northern Ireland is just one entity. Furthermore only counties that happen to have their calculated 'centre of bounding box' on land will be included in this list (eg Cornwall doesn't, see blue triangles on this <a href=\"http://www.deformedweb.co.uk/trigs/map.cgi?w=600&amp;b=500&amp;e=400000&amp;n=400000&amp;x=d&amp;l=1&amp;hg=1\">map</a>.");
		
		$counties = $db->GetAll("select * from loc_counties where n > 0 order by reference_index,n");
		
		foreach ($counties as $i => $row) {
			list($x,$y) = $conv->national_to_internal($row['e'],$row['n'],$row['reference_index']);
			$sql="select * from gridimage_search where x=$x and y=$y ".
				" order by moderation_status+0 desc,seq_no limit 1";

			$rec=$db->GetRow($sql);
			if (count($rec))
			{
				$gridimage=new GridImage;
				$gridimage->fastInit($rec);
				
				$gridimage->county = $row['name'];
				
				$results[] = $gridimage;
			}
			else 
			{
				$sql="select grid_reference from gridsquare where x=$x and y=$y limit 1";
				
				$rec=$db->GetRow($sql);
				if (count($rec)) 
				{
					$rec['county'] = $row['name'];
					$unfilled[] = $rec;
				}
			}
		}
		
	} elseif ($type == 'capital') {
		$smarty->assign("page_title", "County Capital Towns");
		$smarty->assign("extra_info", "* at the moment we dont actully store which county each capital is in");
		$counties = $db->GetAll("SELECT * FROM `loc_towns` WHERE `s` = '2' AND `reference_index` = 2 ORDER BY n");
		
		foreach ($counties as $i => $row) {
			list($x,$y) = $conv->national_to_internal($row['e'],$row['n'],$row['reference_index']);
			$sql="select * from gridimage_search where x=$x and y=$y ".
				" order by moderation_status+0 desc,seq_no limit 1";

			$rec=$db->GetRow($sql);
			if (count($rec))
			{
				$gridimage=new GridImage;
				$gridimage->fastInit($rec);
				
				$gridimage->county = $row['name'];
				
				$results[] = $gridimage;
			}
			else 
			{
				$sql="select grid_reference from gridsquare where x=$x and y=$y limit 1";
				
				$rec=$db->GetRow($sql);
				if (count($rec)) 
				{
					$rec['county'] = $row['name'];
					$unfilled[] = $rec;
				}
			}
		}
		
	}

	$smarty->assign_by_ref("results", $results);	
	$smarty->assign_by_ref("unfilled", $unfilled);	
}


$smarty->display($template, $cacheid);

	
?>
