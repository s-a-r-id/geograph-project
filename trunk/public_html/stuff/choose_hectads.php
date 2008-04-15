<?php
/**
 * $Project: GeoGraph $
 * $Id: view_direction_filler.php 2978 2007-01-17 21:49:56Z barry $
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
init_session();


$smarty = new GeographPage;

$USER->mustHavePerm("basic");

$template='stuff_choose_hectads.tpl';

$cacheid='';

$db = NewADOConnection($GLOBALS['DSN']);


if (isset($_POST['submit']) && !empty($_POST['hectads'])) {
	$hectads = $db->getAssoc("
	SELECT hectad,hectad_assignment_id
	FROM hectad_assignment
	WHERE user_id = {$USER->user_id}
	ORDER BY sort_order");


	$list = explode("\n",str_replace("\r",'',$_POST['hectads']));
	$sort_order = 1;
	foreach ($list as $hectad) {
		$hectad = strtoupper(preg_replace('/[^\w]/','',$hectad));
		if ($hectad) {
			if (isset($hectads[$hectad]) && $id = $hectads[$hectad]) {
				$updates = array();
				$updates['status'] = 'new';
				$updates['sort_order'] = $sort_order;
				
				$db->Execute('UPDATE hectad_assignment SET `'.implode('` = ?,`',array_keys($updates)).'` = ? WHERE hectad_assignment_id = '.$id,array_values($updates));

				unset($hectads[$hectad]);
			} else {
				
				$updates = array();
				$updates['user_id'] = $USER->user_id;
				$updates['hectad'] = $hectad;
				$updates['sort_order'] = $sort_order;

				$db->Execute('INSERT INTO hectad_assignment SET created = NOW(),`'.implode('` = ?,`',array_keys($updates)).'` = ?',array_values($updates));

			}
			$sort_order++;
		}
	}
	
	if (count($hectads)) {
		//'remove' any that are left.
		$db->Execute("UPDATE hectad_assignment SET status = 'deleted' WHERE hectad_assignment_id IN (".implode(',',array_values($hectads)).')');
	}
	$smarty->assign('saved',$sort_order-1);
}

$ADODB_FETCH_MODE = ADODB_FETCH_ASSOC;
$hectads = $db->getAll("
SELECT *
FROM hectad_assignment
WHERE user_id = {$USER->user_id} AND status = 'new'
ORDER BY sort_order");
$smarty->assign_by_ref('hectads',$hectads);


$smarty->display($template,$cacheid);

?>
