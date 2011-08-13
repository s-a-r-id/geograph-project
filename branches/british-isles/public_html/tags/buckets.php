<?php
/**
 * $Project: GeoGraph $
 * $Id: index.php 7069 2011-02-04 00:06:46Z barry $
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



init_session();

$smarty = new GeographPage;


$template = 'tags.tpl';
$cacheid = "bucket".md5(serialize($_GET));



if (!$smarty->is_cached($template, $cacheid))
{
	
	$db = GeographDatabaseConnection(true);
	
	$where = '';
	
	if (!empty($_GET['tag'])) {
		//TODO - this will be rewritten using sphinx... 
		
		$row= $db->getRow("SELECT * FROM tag WHERE prefix = 'bucket' AND tag=".$db->Quote($_GET['tag']));
		
		
		if (!empty($row)) {
		
			if (!empty($_GET['exclude'])) {
				$exclude= $db->getRow("SELECT * FROM tag WHERE tag=".$db->Quote($_GET['exclude']));
			}
		
			if (!empty($exclude)) {
				$sql = "select gi.*
					from gridimage_tag gt
						inner join gridimage_search gi using(gridimage_id)
					where status >0
					and gt.tag_id = {$row['tag_id']}
					and gt.gridimage_id NOT IN (SELECT gridimage_id FROM gridimage_tag gt2 WHERE gt2.tag_id = {$exclude['tag_id']})
					order by created desc 
					limit 50";
			} else {
				$sql = "select gi.*
					from gridimage_tag gt
						inner join gridimage_search gi using(gridimage_id)
					where status > 0
					and tag_id = {$row['tag_id']}
					order by created desc 
					limit 50";
			}

			$imagelist = new ImageList();

			$imagelist->_getImagesBySql($sql);

			$ids = array();
			foreach ($imagelist->images as $idx => $image) {
				$ids[$image->gridimage_id]=$idx;
				$imagelist->images[$idx]->tags = array();
			}
			$db = $imagelist->_getDB(true); //to reuse the same connection

			if ($idlist = implode(',',array_keys($ids))) {
				$sql = "SELECT gridimage_id,tag,prefix FROM tag INNER JOIN gridimage_tag gt USING (tag_id) WHERE gt.status = 2 AND gridimage_id IN ($idlist) ORDER BY tag";			

				$tags = $db->getAll($sql);
				if ($tags) {
					foreach ($tags as $row) {
						$idx = $ids[$row['gridimage_id']];
						$imagelist->images[$idx]->tags[] = $row;
					}
				}
			}

			$smarty->assign_by_ref('results', $imagelist->images);
			
			$smarty->assign('thetag', $_GET['tag']);
		}
		
	}
	
	$prev_fetch_mode = $ADODB_FETCH_MODE;
	$ADODB_FETCH_MODE = ADODB_FETCH_ASSOC;

	$tags = $db->getAll("SELECT t.tag,COUNT(*) AS images FROM tag t INNER JOIN gridimage_tag gt USING(tag_id) WHERE prefix = 'bucket' AND gt.status > 0 GROUP BY t.tag ORDER BY t.tag LIMIT 1000");
	
	$smarty->assign_by_ref('tags', $tags);
	$smarty->assign('bucket',1);
}

$smarty->display($template, $cacheid);
