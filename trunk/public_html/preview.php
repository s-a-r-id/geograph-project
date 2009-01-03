<?php
/**
 * $Project: GeoGraph $
 * $Id: view.php 5080 2008-12-09 23:11:41Z barry $
 *
 * GeoGraph geographic photo archive project
 * This file copyright (C) 2005 Paul Dixon (paul@elphin.com)
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


require_once('geograph/gridimage.class.php');
require_once('geograph/gridsquare.class.php');
require_once('geograph/mapmosaic.class.php');
require_once('geograph/rastermap.class.php');

init_session();

customGZipHandlerStart();

$smarty = new GeographPage;

$template='view.tpl';
$cacheid=0;

$smarty->caching = 0; 



//do we have a valid image?
if (!empty($_POST))
{
	$image=new GridImage;
	
	$image->gridimage_id = 0;
	$image->moderation_status = 'pending';
	$image->submitted = time();
	$image->user_id = $USER->user_id;
	$image->realname = $USER->realname;
	$image->profile_link = "/profile/{$image->user_id}";

	$image->title = strip_tags(trim(stripslashes($_POST['title'])));
	$image->comment = strip_tags(trim(stripslashes($_POST['comment'])));
	
	$image->imageclass=strip_tags(trim(stripslashes($_POST['imageclass'])));
	
	if ($image->imageclass=="Other") {
		$image->imageclass = strip_tags(trim(stripslashes($_POST['imageclassother'])));
	}
	
	if (isset($_POST['imagetakenYear'])) {
		$image->imagetaken=sprintf("%04d-%02d-%02d",$_POST['imagetakenYear'],$_POST['imagetakenMonth'],$_POST['imagetakenDay']);
	}	
	$image->use6fig = !empty($_POST['use6fig']);
	
	if (!empty($_POST['grid_reference'])) {
		$image->grid_square = new GridSquare();
		$image->grid_square->setByFullGridRef($_POST['grid_reference']);
		
		$image->grid_reference=$image->grid_square->grid_reference;
		$image->natgrlen=$image->grid_square->natgrlen;
		$image->nateastings=$image->grid_square->nateastings;
		$image->natnorthings=$image->grid_square->natnorthings;
	}
	
	if (!empty($_POST['photographer_gridref'])) {
		$viewpoint = new GridSquare;
		$ok= $viewpoint->setByFullGridRef($_POST['photographer_gridref'],true);
		
		$image->viewpoint_eastings = $viewpoint->nateastings;
		$image->viewpoint_northings = $viewpoint->natnorthings;
		$image->viewpoint_grlen = $viewpoint->natgrlen;
	}
	
	$image->view_direction = intval(strip_tags(trim(stripslashes($_POST['view_direction']))));
	
	
	$image->fullpath = "/submit.php?preview=".strip_tags(trim(stripslashes($_POST['upload_id'])));


if (!empty($_POST['spelling'])) {
	
	include("3rdparty/spellchecker.class.php");
	?>
	<style>
		body { font-family:Georgia, Verdana, Arial, serif; }
		u { color:red }
		u span { color:black } 
		p { background-color:#eeeeee; border:1px solid gray; padding:10px }
	</style>
	<?
	$query = "{$image->title} {$image->comment} {$image->imageclass}"; 

	$xml = new SimpleXMLElement(SpellChecker::GetSuggestions( $query )); 

	$sugges = $replacement = array(); 
	foreach($xml->c as $correction) { 
		$suggestions = explode("\t", (string)$correction); 
		$offset = $correction['o']; 
		$length = $correction['l']; 

		$replacement[mb_substr($query, $offset, $length)] = $suggestions[0]; 
		$sugges[mb_substr($query, $offset, $length)] = implode("\n",$suggestions);
	} 

	print "<form>";
	foreach (array('title'=>'Title','comment'=>'Description/Comment','imageclass'=>'Category') as $key => $name) {
		print "<h3>$name</h3><blockquote>";
		$result = $original = htmlentities2($image->$key);
		if (!empty($original)) {
			foreach($replacement as $old => $new) { 
				$old2 = preg_quote($old); 
				$original = preg_replace("/$old2/is", "<u title=\"{$sugges[$old]}\"><span>$old</span></u>", $original, 1); 
				$result = preg_replace("/$old2/is", "$new", $result, 1); 
			}
			print "<h4>Original</h4>";
			print "<p>$original</p>";
			print "<small><i>hover over underlined words to see suggestions</i></small>";
			print "<h4>Suggestion</h4>";
			if ($original != $result) {
				if ($key == 'comment') {
					print "<p><textarea name=\"$key\" rows=\"7\" cols=\"80\" spellcheck=\"true\">$result</textarea>";
				} else {
					print "<p><input name=\"$key\" spellcheck=\"true\" value=\"$result\" size=60 readonly/>";
				}
				if ($key != 'imageclass') {
					print "<input type=button value=\"copy to submission\" onclick=\"window.opener.document.forms.theForm.$key.value= this.form.$key.value\" />";
				}
				print "</p>";
			} else {
				print "<i>no suggestions</i>";
			}
		} else {
			print "<i>empty</i>";
		}
		print "</blockquote><hr/>";
	}
	print "</form>";
	print "<div>Powered by Google Toolbar</div>";
	exit;
}


	//what style should we use?
	$style = $USER->getStyle();

	if (!$smarty->is_cached($template, $cacheid))
	{
		function smarty_function_hidekeywords($input) {
			return preg_replace('/(^|[\n\r\s]+)(Keywords?[\s:][^\n\r>]+)$/','<span class="keywords">$2</span>',$input);
		}
		$smarty->register_modifier("hidekeywords", "smarty_function_hidekeywords");

		$smarty->assign('maincontentclass', 'content_photo'.$style);
	
		$image->assignToSmarty($smarty);
	}
} else {
	header("HTTP/1.0 404 Not Found");
	header("Status: 404 Not Found");
	$template='static_404.tpl';
}



$smarty->display($template, $cacheid);


?>
