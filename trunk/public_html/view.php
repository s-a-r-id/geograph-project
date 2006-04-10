<?php
/**
 * $Project: GeoGraph $
 * $Id$
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

init_session();

$smarty = new GeographPage;

$template='view.tpl';

$cacheid=0;

$smarty->caching = 2; // lifetime is per cache
$smarty->cache_lifetime = 3600*3; //3hour cache

$image=new GridImage;

if (isset($_GET['id']))
{
	$image->loadFromId($_GET['id']);
	$isowner=($image->user_id==$USER->user_id)?1:0;
	$ismoderator=$USER->hasPerm('moderator')?1:0;

	$cacheid="img{$_GET['id']}|{$isowner}_{$ismoderator}";

	//is the image rejected? - only the owner and administrator should see it
	if ($image->moderation_status=='rejected')
	{
		if ($isowner||$ismoderator)
		{
			//ok, we'll let it lie...
		}
		else
		{
			//clear the image
			$image=new GridImage;
			$cacheid=0;
		}
	}
}

//do we have a valid image?
if ($image->isValid())
{
	$taken=$image->getFormattedTakenDate();

	//get the photographer position
	$image->getPhotographerGridref();
	$image->getSubjectGridref();


	//what style should we use?
	$style='white';
	$valid_style=array('white', 'black');
	if (isset($_GET['style']) && in_array($_GET['style'], $valid_style))
	{
		$style=$_GET['style'];
		$_SESSION['style']=$style;

		//ToDo - if logged in user, save this in profile
	}
	elseif (false) //if logged in user
	{
			//get setting from profile
	}
	elseif (isset($_SESSION['style']))
	{
		$style=$_SESSION['style'];

	}
	$cacheid.=$style;

	if (!$smarty->is_cached($template, $cacheid))
	{

		$smarty->assign('maincontentclass', 'content_photo'.$style);


		//remove grid reference from title
		$untitled="Untitled photograph for {$image->grid_reference}";
		if ($image->title!=$untitled)
			$image->title=trim(str_replace($image->grid_reference, '', $image->title));

		$smarty->assign('page_title', $image->title.":: OS grid {$image->grid_reference}");
		$smarty->assign('meta_description', $image->comment);
		$smarty->assign('image_taken', $taken);
		$smarty->assign('ismoderator', $ismoderator);
		$smarty->assign_by_ref('image', $image);

		//get a token to show a suroudding geograph map
		$mosaic=new GeographMapMosaic;
		$smarty->assign('map_token', $mosaic->getGridSquareToken($image->grid_square));



		//find a possible place within 25km
		$smarty->assign('place', $image->grid_square->findNearestPlace(75000));

		//let's find posts in the gridref discussion forum
		$image->grid_square->assignDiscussionToSmarty($smarty);
		
		//count the number of photos in this square
		$smarty->assign('square_count', $image->grid_square->imagecount);

		//lets add an overview map too
		$overview=new GeographMapMosaic('overview');
		$overview->assignToSmarty($smarty, 'overview');
		$smarty->assign('marker', $overview->getSquarePoint($image->grid_square));


		require_once('geograph/conversions.class.php');
		$conv = new Conversions;

		list($lat,$long) = $conv->gridsquare_to_wgs84($image->grid_square);
		$smarty->assign('lat', $lat);
		$smarty->assign('long', $long);

		list($latdm,$longdm) = $conv->wgs84_to_friendly($lat,$long);
		$smarty->assign('latdm', $latdm);
		$smarty->assign('longdm', $longdm);

		$smarty->assign('x', $image->grid_square->x);
		$smarty->assign('y', $image->grid_square->y);
		
		if ($image->view_direction > -1) {
			require_once('geograph/searchengine.class.php');
			$search = new SearchEngine('');
			$smarty->assign('view_direction', ($image->view_direction%90==0)?strtoupper($search->heading_string($image->view_direction)):ucwords($search->heading_string($image->view_direction)) );
		}
	}
}



$smarty->display($template, $cacheid);


?>
