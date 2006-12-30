<?php
/**
 * $Project: GeoGraph $
 * $Id: faq.php 15 2005-02-16 12:23:35Z lordelph $
 * 
 * GeoGraph geographic photo archive project
 * This file copyright (C) 2006 Barry Hunter (geo@barryhunter.co.uk)
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

$USER->mustHavePerm('basic');
$isadmin=$USER->hasPerm('moderator')?1:0;

if (empty($_REQUEST['article_id']) && (empty($_REQUEST['page']) || preg_match('/[^\w-\.]/',$_REQUEST['page']))) {
	$smarty->display('static_404.tpl');
	exit;
}


$template = 'article_edit.tpl';




	$db=NewADOConnection($GLOBALS['DSN']);
	if ($_REQUEST['page'] == 'new' || $_REQUEST['article_id'] == 'new') {
		$smarty->assign('article_id', "new");
		$smarty->assign('title', "New Article");
		$smarty->assign('realname', $USER->realname);
		$smarty->assign('user_id', $USER->user_id);
	} else {
		if (!empty($_REQUEST['article_id'])) {
			$sql_where = " article_id = ".$db->Quote($_REQUEST['article_id']);
		} else {
			$sql_where = " url = ".$db->Quote($_REQUEST['page']);
		}
		$prev_fetch_mode = $ADODB_FETCH_MODE;
		$ADODB_FETCH_MODE = ADODB_FETCH_ASSOC;	
		$page = $db->getRow("
		select article.*,realname
		from article 
			left join user using (user_id)
		where $sql_where
		limit 1");
		$ADODB_FETCH_MODE = $prev_fetch_mode;
		
		if (count($page) && ($page['user_id'] == $USER->user_id || $USER->hasPerm('moderator'))) {
			foreach ($page as $key => $value) {
				$smarty->assign($key, $value);
			}
		} else {
			$template = 'static_404.tpl';
		}
	}


if ($template != 'static_404.tpl' && isset($_POST) && isset($_POST['submit'])) {
	$error = 0;
	

	$_POST['publish_date']=sprintf("%04d-%02d-%02d",$_POST['publish_dateYear'],$_POST['publish_dateMonth'],$_POST['publish_dateDay']);
	$_POST['title'] = preg_replace('/[^\w-\. ]+/','',trim($_POST['title']));
	if (empty($_POST['url']) && !empty($_POST['title'])) {
		$_POST['url'] = $_POST['title'];
	}
	$_POST['url'] = preg_replace('/ /','-',trim($_POST['url']));
	$_POST['url'] = preg_replace('/[^\w-\.]+/','',$_POST['url']);
	
	if ($_POST['title'] == "New Article") {
		$smarty->assign('error', "Please give a meaningful title");
		$error =1;
	}
	
	//the most basic protection
	$_POST['content'] = strip_tags($_POST['content']);
	
	$_POST['content'] = preg_replace('/[��]/','',$_POST['content']);
	
	$updates = array();
	foreach (array('url','title','licence','content','publish_date') as $key) {
		if ($page[$key] != $_POST[$key]) {
			$updates[] = "`$key` = ".$db->Quote($_POST[$key]); 
			$smarty->assign($key, $_POST[$key]);
			if ($key == 'url' || $key = 'title') {
				$sql = "select count(*) from article where `$key` = ".$db->Quote($_POST[$key]);
				if (!empty($_REQUEST['article_id'])) {
					$sql .=  " and article_id != ".$db->Quote($_REQUEST['article_id']);
				}
				if ($db->getOne($sql)) {
					$smarty->assign('error', "$key (".$db->Quote($_POST[$key]).') is already in use');
					$error =1;
				}
			}
		} elseif (empty($_POST[$key])) {
			$smarty->assign('error', "$key is missing");
			$error =1;
		}
	}
	if (!count($updates)) {
		$smarty->assign('error', "No Changes to Save");
		$error =1;
	}
	if ($_REQUEST['page'] == 'new' || $_REQUEST['article_id'] == 'new') {
	
		//todo check has title/url and that its unique!
		
		$updates[] = "`user_id` = {$USER->user_id}";
		$updates[] = "`create_time` = NOW()";
		$sql = "INSERT INTO article SET ".implode(',',$updates);
	} else {
		//todo check has url and that its unique!
		foreach (array('title','url') as $key) { 
			if ($page[$key] != $_POST[$key]) {
				
			}
		}
	
		$sql = "UPDATE article SET ".implode(',',$updates)." WHERE article_id = ".$db->Quote($_REQUEST['article_id']);
	}
	if (!$error && count($updates)) {
		
		$db->Execute($sql);
		if ($_REQUEST['page'] == 'new' || $_REQUEST['article_id'] == 'new') {
			$_REQUEST['article_id'] = $db->Insert_ID();
		}
		//and back it up
		$sql = "INSERT INTO article_revisions SELECT *,NULL FROM article WHERE article_id = ".$db->Quote($_REQUEST['article_id']);
		$db->Execute($sql);

		$smarty->clear_cache('article_article.tpl', $_POST['url']);
		$smarty->clear_cache('article.tpl');

		header("Location: /article/");
		exit;
	}
} 

	$smarty->assign('licences', array('none' => '(Temporally) Not Published','pd' => 'Public Domain','cc-by-sa/2.0' => 'Creative Commons BY-SA/2.0' ,'copyright' => 'Copyright'));



$smarty->display($template, $cacheid);

	
?>
