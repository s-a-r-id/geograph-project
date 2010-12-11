<?php
/**
 * $Project: GeoGraph $
 * $Id: conversion.php 5502 2009-05-13 14:18:23Z barry $
 * 
 * GeoGraph geographic photo archive project
 * This file copyright (C) 2005 BArry Hunter (geo@barryhunter.co.uk)
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

if (!empty($_GET['hectad']) && !empty($_GET['canonical'])) {
	$db = GeographDatabaseConnection(true);
	$q = $_GET['hectad'];
	
	$q .= " @imageclass (\"{$_GET['canonical']}\"";
	
	$list = $db->getCol("SELECT imageclass FROM category_canonical WHERE canonical = ".$db->Quote($_GET['canonical'])." GROUP BY imageclass LIMIT 10");
	foreach ($list as $c) {
		if (strpos($c,' ') !== FALSE) {
			$q .= "| \"$c\"";
		} else {
			$q .= "| $c";
		}
	}
	$q .= ")";
	
	$q= urlencode($q);
	header("Location: /search.php?q=$q");
	exit;
}

init_session();

$USER->mustHavePerm("basic");


$smarty = new GeographPage;

$template='stuff_canonical.tpl';
$cacheid='';

if (!empty($_GET['stats'])) {
	$template='stuff_canonical_stats.tpl';

	if (!$smarty->is_cached($template, $cacheid)) {
		$db = GeographDatabaseConnection(true);
		
		$data = $db->getRow("SELECT COUNT(*) AS normal FROM category_stat");
		$smarty->assign($data);
		$data = $db->getRow("SELECT COUNT(*) AS suggestions,COUNT(DISTINCT imageclass) AS cats,COUNT(DISTINCT canonical) AS canons,COUNT(DISTINCT user_id) AS users FROM category_canonical_log");
		$smarty->assign($data);
		$data = $db->getRow("SELECT COUNT(DISTINCT imageclass) AS final,COUNT(DISTINCT canonical) AS canons_final FROM category_canonical");
		$smarty->assign($data);

	}
	
} elseif (!empty($_GET['renameloops'])) {
	
	$smarty->display('_std_begin.tpl');
	
	$db = GeographDatabaseConnection(true);

	$ADODB_FETCH_MODE = ADODB_FETCH_ASSOC;
	$list = $db->getAll("SELECT one.canonical_old, one.canonical_new, 
	SUM( one.type IN ('agree',  'initial') ) AS forthis, SUM( two.type IN ('agree',  'initial') ) AS forother,
	SUM( one.type IN ('disagree') ) AS againthis, SUM( two.type IN ('disagree') ) AS againother
	FROM  `category_canonical_rename_log` one
	INNER JOIN  `category_canonical_rename_log` two ON ( one.`canonical_new` = two.`canonical_old` AND one.`canonical_old` = two.`canonical_new` ) 
	WHERE 1 
	GROUP BY one.`canonical_old` , one.`canonical_new` ");

	print "<pre>";
	print_r($list);
	
	$smarty->display('_std_end.tpl');
	exit;

} elseif (!empty($_GET['renametree'])) {
	
	$smarty->display('_std_begin.tpl');
	
	$db = GeographDatabaseConnection(true);
	
	$table = empty($_GET['preview'])?'category_canonical_rename':'category_canonical_rename_log';
	
	$list = $db->getAll("SELECT canonical_old,canonical_new FROM $table GROUP BY canonical_old,canonical_new ORDER BY canonical_new,canonical_old");
	
	$t = array();
	foreach ($list as $row) {
		$t[$row['canonical_old']]['to'][] = $row['canonical_new'];
		$t[$row['canonical_new']]['from'][] = $row['canonical_old'];
	}
	
	$done = array();
	
	
	function dumplist($a,$from) {
		global $done,$t;
		
		print "<ul>";
		foreach ($a as $two) {
			print "<li> -&gt; <b>".htmlentities($two)."</b> <a href=\"?mode=rename&old=".urlencode($from)."&new=".urlencode($two)."\">...</a>";
			
			$row2 = $t[$two];
			
			if (!empty($row2['to'])) {
				if (!empty($done[$two])) {
					print " <i>(Looping)</i>";
				} else {
					$done[$two] = 1;

					dumplist($row2['to'],$two);
				}
			}
			
			print "</li>";
		}
		print "</ul>";
	}
	
	print "<ul>";
	foreach ($t as $one => $row1) {
		$done = array();
		#if (empty($row1['from'])) {
		if (!empty($row1['to'])) {
			print "<li>".htmlentities($one);

			if (!empty($row1['to'])) {
				$done[$one] = 1;
				dumplist($row1['to'],$one);
			}

			print "</li>";
		}
	}
	print "</ul>";
	
	$smarty->display('_std_end.tpl');
	exit;
	
} elseif (!empty($_GET['preview'])) {
	$template='stuff_canonical_tree.tpl';
	$cacheid='preview'.preg_replace('/[^\w]+/','',$_GET['alpha']);
	if (!$smarty->is_cached($template, $cacheid)) {
		
		$db = GeographDatabaseConnection(true);
		
		$letters = $db->getAll("SELECT canonical,COUNT(DISTINCT imageclass) AS classes FROM category_canonical_log WHERE canonical != '-bad-' GROUP BY LOWER(SUBSTRING(canonical,1,1))");
		
		$a = 'A';
		$str = "";
		foreach ($letters as $row) {
			$al = strtoupper(substr($row['canonical'],0,1));
			$size = max(1,log1p($row['classes'])*0.4);
			if ($al == $_GET['alpha']) {
				$str .= "<b style=\"font-size:{$size}em\">$al</b> ";
				$a = $al;
			} else {
				$str .= "<a href=\"?preview=1&amp;alpha=$al\" style=\"font-size:{$size}em\">$al</a> ";
			}
		}
		
		$smarty->assign('intro',"<b>NOTE</b>: This is only the result of the first pass over the data. It will be slightly messy as it combines results from multiple users, <u>without any processing</u>.<p>First letter: $str</p>");
		
		$list = $db->getAll("SELECT imageclass,canonical FROM category_canonical_log WHERE canonical LIKE '$a%' GROUP BY imageclass ORDER BY LOWER(canonical)");
		$smarty->assign_by_ref('list',$list);
	}

} elseif (!empty($_GET['final'])) {
	$template='stuff_canonical_tree.tpl';
	$cacheid='final';
	if (!$smarty->is_cached($template, $cacheid)) {
		$smarty->assign('intro',"This is preliminary results of the mapping - showing canonical categories confirmed by at least 3 people in stage 1. Also takes into account confirmed renames as per stage 2.");
	
		$db = GeographDatabaseConnection(true);
		
		$list = $db->getAll("SELECT imageclass,canonical FROM category_canonical WHERE canonical != '-bad-' GROUP BY imageclass ORDER BY LOWER(canonical),LOWER(imageclass) LIMIT 1000");
		$smarty->assign_by_ref('list',$list);
	}
	
} elseif (!empty($_GET['canonical'])) {
	$template='stuff_canonical_canonical.tpl';
	$cacheid='preview';
	if (!$smarty->is_cached($template, $cacheid)) {
		$smarty->assign('intro',"This is the current list of canonical categories. Categories suggested by few people are shown in gray.");
	
		$db = GeographDatabaseConnection(true);
		
		$list = $db->getAll("SELECT canonical,COUNT(DISTINCT imageclass) AS cats,COUNT(DISTINCT cm.user_id) AS users,canonical_old FROM category_canonical_log cm LEFT JOIN category_canonical_rename_log ON (canonical=canonical_old) WHERE canonical != '-bad-' GROUP BY LOWER(canonical)");
		$smarty->assign_by_ref('list',$list);
	}
	
} elseif (!empty($_GET['sample'])) {
	if (!empty($_GET['tree'])) {
		$template='stuff_canonical_tree.tpl';
		$order = "canonical,imageclass";
	} else {
		$template='stuff_canonical_list.tpl';
		$order = "imageclass";
	}
	$cacheid='sample';
	
	if (!$smarty->is_cached($template, $cacheid)) {
		$smarty->assign('intro',"This is a small sample of mappings for demonstration purposes.");
	
		$db = GeographDatabaseConnection(true);
		
		$list = $db->getAll("SELECT imageclass,canonical FROM category_canonical_log WHERE user_id = 3 AND (canonical LIKE '%path%' OR canonical LIKE '%road%' OR canonical LIKE '%water%') ORDER BY $order LIMIT 100");
		$smarty->assign_by_ref('list',$list);
	}
	
} elseif (!empty($_GET['mode']) && $_GET['mode'] == 'rename') {
	$template='stuff_canonical_moderename.tpl';


	if (!empty($_POST) && $_POST['submit'] && !empty($_POST['canonical_old']) && !empty($_POST['canonical_new'])) {
		$db = GeographDatabaseConnection(false);
	
		$updates = array();
		$updates['canonical_old'] = $_POST['canonical_old'];
		$updates['canonical_new'] = $_POST['canonical_new'];
		$updates['type'] = strtolower($_POST['submit']);
		$updates['user_id'] = $USER->user_id;

		$db->Execute('INSERT INTO category_canonical_rename_log SET `'.implode('` = ?,`',array_keys($updates)).'` = ?',array_values($updates));
	} else {
		$db = GeographDatabaseConnection(true);
	}
	
	if (!empty($_GET['old']) && !empty($_GET['new'])) {
		$row = array('canonical_old'=>$_GET['old'],'canonical_new'=>$_GET['new']);
	} else {
		$row = $db->GetRow("
			SELECT cr.* 
			FROM category_canonical_rename_log cr 
			LEFT JOIN category_canonical_rename_log cr2 
				ON (cr.canonical_new = cr2.canonical_new AND cr.canonical_old = cr2.canonical_old AND cr2.user_id = {$USER->user_id})
			WHERE cr2.rename_id IS NULL AND cr.type='initial' AND cr.type!={$USER->user_id}
			LIMIT 1");
	}
	
	$smarty->assign($row);
	$smarty->assign('mode',$_GET['mode']);

	$others = $db->getAll("SELECT canonical_old FROM category_canonical_rename_log WHERE canonical_new = ".$db->Quote($row['canonical_new'])." GROUP BY canonical_old");
	$smarty->assign_by_ref('others',$others);

} elseif (!empty($_GET['rename']) && $_GET['rename'] == 2 ) {
	$template='stuff_canonical_rename.tpl';
	$smarty->assign("suggestion",1);
	
	if (!empty($_POST) && $_POST['submit'] && !empty($_POST['new'])) {
		$db = GeographDatabaseConnection(false);

		foreach ($_POST['new'] as $old => $new) {
			if ($old != $new) {
				$sql = "INSERT INTO category_canonical_rename_log SET canonical_new = ".$db->Quote(trim($new)).", type='initial', user_id = {$USER->user_id}, canonical_old = ".$db->Quote($old);
				$db->Execute($sql);
			}
		}
		header("Location: /stuff/canonical.php");
		exit;
	}
	
	if (!empty($_POST['list'])) {
		$db = GeographDatabaseConnection(true);

		$names = implode(',',array_map(array($db, 'Quote'),$_POST['list']));

		$list = $db->getAll("SELECT canonical,count(*) AS count FROM category_canonical_log WHERE canonical IN ($names) GROUP BY canonical");
		$smarty->assign('list',$list);
	}
	
} elseif (!empty($_GET['rename']) && $_GET['rename'] == 1) {
	$template='stuff_canonical_rename.tpl';
	
	if (!empty($_POST) && $_POST['submit'] && !empty($_POST['new'])) {
		$db = GeographDatabaseConnection(false);
	
		foreach ($_POST['new'] as $old => $new) {
			if ($old != $new) {
				$sql = "UPDATE category_canonical_log SET canonical = ".$db->Quote(trim($new))." WHERE user_id = {$USER->user_id} AND canonical = ".$db->Quote($old);
				$db->Execute($sql);
			}
		}
		header("Location: /stuff/canonical.php");
		exit;
	}
	
	$db = GeographDatabaseConnection(true);
	
	$list = $db->getAll("SELECT canonical,count(*) AS count FROM category_canonical_log WHERE user_id = {$USER->user_id} GROUP BY canonical ORDER BY category_map_id DESC LIMIT 100");
	$smarty->assign('list',$list);
	
	
} elseif (!empty($_GET['review'])) {
	$template='stuff_canonical_review.tpl';
	
	$db = GeographDatabaseConnection(true);
	
	$list = $db->getAll("SELECT imageclass,canonical FROM category_canonical_log WHERE user_id = {$USER->user_id} ORDER BY category_map_id DESC LIMIT 100");
	$smarty->assign_by_ref('list',$list);
	
	
} elseif (!empty($_GET['mode'])) {
	
	if (!empty($_POST) && $_POST['submit'] && !empty($_POST['imageclass']) && !empty($_POST['canonical'])) {
		$db = GeographDatabaseConnection(false);
	
		switch ($_POST['canonical']) {
		
			case 'asis':
				$canonical = $_POST['imageclass'];
				break;
			case 'other': 
				$canonical = $_POST['other'];
				break;
			case 'prev': 
				$canonical = $_POST['prev'];
				break;
			case 'new': 
				$canonical = $_POST['new'];
				break;
			case 'bad': 
				$canonical = '-bad-';
				break;
		}
		if (!empty($canonical)) {
			$updates = array();
			$updates['imageclass'] = $_POST['imageclass'];
			$updates['canonical'] = $canonical;
			$updates['user_id'] = $USER->user_id;
			
			$db->Execute('REPLACE INTO category_canonical_log SET `'.implode('` = ?,`',array_keys($updates)).'` = ?',array_values($updates));
	
		} else {
			//try again!
			$imageclass = $_POST['imageclass'];
		}
	} else {
		$db = GeographDatabaseConnection(true);
		
		if (!empty($_GET['category'])) {
			$imageclass = $_GET['category'];
		}
	}
	
	if (!empty($imageclass)) {
		$row = array('imageclass'=>$imageclass);
	} else {
		switch ($_GET['mode']) {

			case 'alpha':
				$row = $db->GetRow("
					SELECT cs.* 
					FROM category_stat cs 
					LEFT JOIN category_canonical_log cm 
						ON (cs.imageclass=cm.imageclass AND user_id = {$USER->user_id})
					LEFT JOIN category_canonical cc
						ON (cs.imageclass=cc.imageclass)
					WHERE cm.category_map_id IS NULL
						AND cc.imageclass IS NULL
					ORDER BY cs.imageclass
					LIMIT 1");

				break;
			case 'random':
				$orders = array('category_id','cs.imageclass desc','category_id desc','reverse(category_id)','c desc');
				$order = $orders[date('G')%(count($orders)-1)];
				$row = $db->GetRow("
					SELECT cs.* 
					FROM category_stat cs 
					LEFT JOIN category_canonical_log cm 
						ON (cs.imageclass=cm.imageclass AND user_id = {$USER->user_id})
					LEFT JOIN category_canonical cc
						ON (cs.imageclass=cc.imageclass)
					WHERE cm.category_map_id IS NULL
						AND cc.imageclass IS NULL
					ORDER BY $order
					LIMIT 1");

				break;
			case 'unmapped':
				if (date('G')%2 == 0) {
					//in category_canonical_log, but not shown to this user, but not in final
					$row = $db->GetRow("
						SELECT cs.* 
						FROM category_stat cs 
						INNER JOIN category_canonical_log cm 
							ON (cs.imageclass=cm.imageclass)
						LEFT JOIN category_canonical_log cm2 
							ON (cs.imageclass=cm2.imageclass AND cm2.user_id = {$USER->user_id})
						LEFT JOIN category_canonical cc
							ON (cs.imageclass=cc.imageclass)
						WHERE cm2.category_map_id IS NULL
							AND cc.imageclass IS NULL
						ORDER BY cs.category_id
						LIMIT 1");
				} else {
					//not in category_canonical_log
					//TODO - this should use the final 'approved' list.
					$row = $db->GetRow("
						SELECT cs.* 
						FROM category_stat cs 
						LEFT JOIN category_canonical_log cm 
							ON (cs.imageclass=cm.imageclass)
						WHERE cm.category_map_id IS NULL
						ORDER BY cs.category_id
						LIMIT 1");
				}
				break;
			default:
				$q=trim($_GET['mode']);
				
				$sphinx = new sphinxwrapper($q);
			
				$sphinx->pageSize = $pgsize = 100; 
			
				$pg = 1;
					
				$offset = (($pg -1)* $sphinx->pageSize)+1;
	
				if ($offset < (1000-$pgsize) ) { 
					$sphinx->processQuery();
			
					$sphinx->q = "\"^{$sphinx->q}$\" | ($sphinx->q)";
			
					$ids = $sphinx->returnIds($pg,'category');
					
					if (!empty($ids) && count($ids)) {
			
						$where = "category_id IN(".join(",",$ids).")";
						$row = $db->GetRow("
							SELECT cs.* 
							FROM category_stat cs 
							LEFT JOIN category_canonical_log cm 
								ON (cs.imageclass=cm.imageclass AND user_id = {$USER->user_id})
							LEFT JOIN category_canonical cc
								ON (cs.imageclass=cc.imageclass)
							WHERE cm.category_map_id IS NULL
								AND cc.imageclass IS NULL
								AND $where
							ORDER BY cs.imageclass
							LIMIT 1");
					}
				}
				
				break;
		}
	}
	
	if ($row) {
		if (empty($row['imageclass']) && !empty($row[1])) {
			//work around adodb bug. if label consists solely of hyphens its ignored
			$row['imageclass'] = $row[1];
		}
		
		
		$smarty->assign($row);
		$smarty->assign('mode',$_GET['mode']);
		
		$prev = $db->getAll("SELECT canonical FROM category_canonical_log WHERE imageclass = ".$db->Quote($row['imageclass'])." GROUP BY canonical");
		$smarty->assign_by_ref('prev',$prev);
		
		//todo - use this from the confirmed one?
		$list = $db->getAll("SELECT canonical,count(*) AS count FROM category_canonical_log WHERE canonical != '-bad-' GROUP BY canonical");
		$smarty->assign_by_ref('list',$list);
		
	} else {
	
		$smarty->assign('done',1);
	}
}


$smarty->display($template, $cacheid);