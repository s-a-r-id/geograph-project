<?php
/**
 * $Project: GeoGraph $
 * $Id$
 * 
 * GeoGraph geographic photo archive project
 * This file copyright (C) 2011 Rudi Winter (http://www.geograph.org.uk/profile/2520)
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
 

if ($_SERVER['SERVER_ADDR']=='127.0.0.1') {
	require_once('./geograph_snub.inc.php');
} else {
	require_once('geograph/global.inc.php');
}
init_session();

$smarty = new GeographPage;

//you must be logged in to request changes
$USER->mustHavePerm("basic");

include('./geotrip_func.php');


$db = GeographDatabaseConnection(false);
// can now use mysql_query($sql); directly, or mysql_query($sql,$db->_connectionID);





$smarty->assign('page_title', 'Geo-Trip creation :: Geo-Trips');


$smarty->display('_std_begin.tpl','trip_submit');
print '<link rel="stylesheet" type="text/css" href="/geotrips/geotrips.css" />';

    if (!isset($_POST['submit2'])) {
?>
      <div class="panel maxi">
        <h3>Geo-Trip submission form</h3>
        <form name="trip" method="post" action="<?php echo $_SERVER['PHP_SELF'];?>" enctype="multipart/form-data">
          <hr style="color:#992233">
          <p>
            <b>Location</b> <span class="hlt">(required)</span><br />
            <input type="text" name="loc" size="72" /><br />
            (e.g. <em>Cadair Idris</em>)
          </p>
          <hr style="color:#992233">
          <p>
            <b>Starting point</b> <span class="hlt">(required)</span><br />
            <input type="text" name="start" size="72" /><br />
            (e.g. <em>Dolgellau</em>)
          </p>
          <hr style="color:#992233">
          <p>
            <b>Type of trip</b> <span class="hlt">(required)</span><br />
            <select name="type">
              <option value="" selected="selected">choose one</option>
              <option value="walk">walk</option>
              <option value="bike">cycle ride</option>
              <option value="road">road trip</option>
              <option value="rail">train journey</option>
              <option value="boat">boat trip</option>
              <option value="bus">scheduled public transport</option>
            </select>
          </p>
          <ul>
            <li>Choose whichever option matches closest the nature of your trip.</li>
          </ul>
          <hr style="color:#992233">
          <p>
            <b>Geograph search id</b> <span class="hlt">(required)</span><br />
            <input type="text" name="search" size="72" /><br />
            (e.g. <em>12345678</em> or <em>http://www.geograph.org.uk/search.php?i=12345678</em>)
          </p>
          <ul>
            <li>
The search defines which images will be shown on the map on your trip page.
            </li>
            <li>
The search id is the number at the end of the web address (URL) of the page that shows the search
results.  You can either copy and paste the whole address line or just the id number.
            </li>
            <li>
The <a href="http://www.geograph.org.uk/search.php?form=advanced">search</a> should include only
images <b>taken by yourself on the same day</b>, in date-submitted order (assuming you've submitted
in the order they were taken).
            </li>
            <li>
Here is a list of <a target="_blank" href="http://www.geograph.org.uk/stuff/latestdays.php">
your ten most recent days out</a> (opens in a new window),
with pre-defined searches.  Click one of the links in the list, and paste the URL of the
search results page that you get.
            </li>
            <li>
To show on the map, images must have at least a six-figure <em>camera</em> position, and either
a view direction must be set or subject and camera position must be different.
            </li>
            <li>
By agreement with the Hamsters' Trade Union (HTU), search results are limited to the first 250
images.
            </li>
            <li>
You can create the search before your images have been moderated, but they won't show on the map
until they go live on Geograph.
            </li>
          </ul>
          <hr style="color:#992233">
          <p>
            <b>Title</b> (optional)<br />
            <input type="text" name="title" size="72" /><br />
            (e.g. <em>The Foxes' Path up Cadair Idris</em>)
          </p>
          <ul>
            <li>
By default the title will be <em>Location</em> from <em>starting point</em>.  Choose a different
title if you'd like something more inspired.
            </li>
          </ul> 
          <hr style="color:#992233">
          <p>
            <b>Upload a GPS track</b> in GPX format (optional)<br />
            <input type="file" name="gpxfile" size="40">
          </p>
          <ul>
            <li>
If you <b>have a GPS unit</b>, set it to record your track and download the track to your computer
in GPX format.
            </li>
            <li>
Please remember to clear your GPS receiver's memory before starting your
trip and stop recording data at the end - the track should only show the trip you're
describing, not your drive home as well...
            </li>
            <li>
Note that uploading a track will reveal your precise whereabouts during your trip - only
upload if you're comfortable with that.  However, all time stamps will be discarded.
            </li>
            <li>
If you can remove spurious data points, please do so.  Don't worry if you can't.<br />
Programs that may be useful for this are <i>e.g.</i> <a href="http:www.gpsu.co.uk">GPS Utility</a>
(for Microsoft Windows) or <a href="http://activityworkshop.net/software/prune/download.html">
GPS Prune</a> (for Linux).
            </li>
            <li>
If you <b>don't have a GPS unit</b>, you can still upload a track by creating a GPX file on
<a href="http://wtp2.appspot.com/wheresthepath.htm">Wheresthepath</a>.  Click the route
button bottom left, draw a route on the map or satellite image, then export the gpx to
file using the import/export button (bottom centre), delivering your very own GPX file
to your computer.
            </li>
          </ul>
          <hr style="color:#992233">
          <p>
            <b>Geograph image id</b> (optional)<br />
            <input type="text" name="img" size="72" /><br />
            (e.g. <em>1234567</em> or <em>http://www.geograph.org.uk/photo/1234567</em>)
          </p>
          <ul>
            <li>
Choose your favourite picture from the trip, which will be used in the index and on the
overview map.  If left blank, the first image from the search will be used.  All the other
images shown on the trip page will be determined from the search specified above.
            </li>
            <li>
The image id is the number at the end of the web address (URL) of the page that shows the full
image.  You can either copy and paste the whole address line or just the id number.
            </li>
          </ul>
          <hr style="color:#992233">
          <p>
            <b>Description</b> (optional)<br />
            <textarea rows="8" cols="80" name="descr"></textarea>
          </p>
          <ul>
            <li>
Please describe briefly what is special about this trip - things to see and learn, why
you particularly enjoyed it (or why not!), any difficulties encountered etc.
            </li>
            <li>
The descriptions of the individual images will be shown in the map pop-ups, so there is
no need to repeat them here.
            </li>
          </ul>
          <hr style="color:#992233">
          <p>
            <b>Continuation from previous trip</b> (optional)<br />
            <input type="text" name="contfrom" size="72" /><br />
            (e.g. <em>123</em> or <em>http://www.geograph.org.uk/geotrips/geotrip_show.php?trip=123</em>)
          </p>
          <ul>
            <li>
If this trip is a continuation of one you've uploaded earlier, specify its Geo-Trips id or full
URL here.  This will create links in both directions.
            </li>
          </ul>
          <div style="text-align:center;background-color:green">
            <input type="submit" name="submit2" value="Ok" style="margin:10px" />
          </div>
        </form>
      </div>
<?php
    } else {
      // sanity check
      if ($_POST['loc']&&$_POST['start']&&$_POST['type']&&$_POST['search']&&$_POST['search']!=$_POST['img']) {
        // fetch Geograph data
        $search=explode('=',$_POST['search']);
        $search=intval($search[sizeof($search)-1]);
        @$csvf=fopen(fetch_url("http://www.geograph.org.uk/export.csv.php?key=7u3131n73r&i=$search&count=250&taken=1&en=1&thumb=1&desc=1&dir=1&ppos=1&big=1"),'r') or die('Geograph seems to be down at the moment.  Please don\'t navigate away from this page and press F5 in a few minutes.');
        fgets($csvf);  // discard header
        while ($line=fgetcsv($csvf,4092,',','"')) {
          if (
            $line[10]                                                  // camera position defined
            && $line[3]==$USER->realname                               // taken by submitter
            && $line[12]>4                                             // camera position at least six figures
            && ($line[14]||$line[7]!=$line[10]||$line[8]!=$line[11])   // view direction given, or camera and subject different
          ) {
            $geograph[]=$line;
          }
        }
        fclose($csvf);
        $len=count($geograph);                                         // taken on the same day
        for ($i=1;$i<$len;$i++) if ($geograph[$i][13]!=$geograph[0][13]) $geograph=0;
        if (count($geograph)<3) {   // we need three different images for the thumbnails at the top
?>
          <div class="panel maxi">
            <h3 class="hlt">Upload failed</h3>
            <p>
It seems your search contained no suitable images.  Images need to:-
            </p>
            <ul>
              <li>be taken by yourself</li>
              <li>be taken during the same trip (<i>i.e.</i> on the same day)</li>
              <li>have a six-figure or better camera position</li>
              <li>have either a view direction, or subject and camera position must be different</li>
            </ul>
            <p>
and there need to be at least three images matching these criteria in your search.  Only the first 250 images per trip will be shown.
            </p>
          </div>
<?php
          die('No suitable images in search.');
        }
        // extract coordinates from GPX file
        $trk='';
        if (file_exists($_FILES['gpxfile']['tmp_name'])) {
          $gpxf=fopen($_FILES['gpxfile']['tmp_name'],'r');
          $xml_data=fread($gpxf,999999);
          fclose($gpxf);
          $xml_parser=xml_parser_create();
          xml_set_element_handler($xml_parser,'xml_startTag',null);
          xml_parse($xml_parser,$xml_data);
          xml_parser_free($xml_parser);
          foreach ($trkpt as $point) {
            if (isset($point['LAT'])) {
              $bng=wgs2bng($point['LAT'],$point['LON']);
              $ee[]=$bng[0];
              $nn[]=$bng[1];
              $trk=$trk.$bng[0].' '.$bng[1].' ';
            }
          }
        } else {
          $len=count($geograph);
          for ($i=0;$i<$len;$i++) {
            $ee[$i]=$geograph[$i][10];
            $nn[$i]=$geograph[$i][11];
          }
        }
        $ee=array_filter($ee);  // remove zero eastings/northings (camera position missing)
        $nn=array_filter($nn);
        $bbox=min($ee).' '.min($nn).' '.max($ee).' '.max($nn);
        // database update
        if ($_POST['img']) {
          $img=explode('/',$_POST['img']);
          $img=intval($img[sizeof($img)-1]);
        } else $img=$geograph[0][0];
        if ($_POST['contfrom']) {
          $contfrom=explode('=',$_POST['contfrom']);
          $contfrom=intval($contfrom[sizeof($contfrom)-1]);
        } else $contfrom=0;
        
        $query='insert into geotrips values(null,';
        $query=$query.intval($USER->user_id).',';
        $query=$query."'".mysql_real_escape_string($USER->realname)."',";
        $query=$query."'".mysql_real_escape_string($_POST['type'])."',";
        $query=$query."'".mysql_real_escape_string($_POST['loc'])."',";
        $query=$query."'".mysql_real_escape_string($_POST['start'])."',";
        $query=$query."'".mysql_real_escape_string($_POST['title'])."',";
        $query=$query."'".$geograph[0][13]."',";
        $query=$query."'".$bbox."',";
        $query=$query."'".$trk."',";
        $query=$query.$search.",";
        $query=$query.$img.",";
        $query=$query."'".mysql_real_escape_string($_POST['descr'])."',";
        $query=$query.date('U').",";
        $query=$query.$contfrom.')';
        
        $db->Execute($query);
        $newid=$db->Insert_ID();
   
        // success
?>
        <div class="panel maxi">
          <h3>Thanks for adding your trip.</h3>
          <p>
If all has gone well, your <a href="geotrip_show.php?trip=<?php print($newid); ?>">new trip</a>
should show on the <a href="./">map</a> now.  Please
<a href="http://www.geograph.org.uk/usermsg.php?to=2520">let me know</a> if anything doesn't
work as expected.
          </p>
        </div>
        <div class="panel maxi">
          <h3>Add a blog post for your Geo-trip</h3>
          <p>
Two for the price of one!  If you'd like to add a post to the
<a href="http://www.geograph.org.uk/blog/">Geograph blog</a> to highlight your trip, please
press the submit button below.  This will take you to the blog edit page prefilled with the
information you've submitted to Geo-trips, so you can tweak the blog post before it goes live.
          </p>
<?php
          if ($_POST['title']) $title=$_POST['title'];
          else $title=$_POST['loc'].' from '.$_POST['start'];
          $gr=bbox2gr($bbox);
          $tags='Geo-trip, '.whichtype($_POST['type']);
          $pub=explode('-',date('d-m-Y-H-i-s'));
          $descr=$_POST['descr'].'  You can see this trip plotted on a map on the Geo-trips page http://www.geograph.org.uk/geotrips/geotrip_show.php?trip='.$newid.' .';
          $imgid=explode('/',$_POST['img']);
          $imgid=intval($img[sizeof($img)-1]);
?>
          <form name="blog" method="post" action="http://www.geograph.org.uk/blog/edit.php">
            <input type="hidden" name="id" value="new" />
            <input type="hidden" name="initial" value="true" />
            <input type="hidden" name="title" value="<?php print(htmlentities($title)); ?>" />
            <input type="hidden" name="publishedDay" value="<?php print($pub[0]); ?>" />
            <input type="hidden" name="publishedMonth" value="<?php print($pub[1]); ?>" />
            <input type="hidden" name="publishedYear" value="<?php print($pub[2]); ?>" />
            <input type="hidden" name="publishedHour" value="<?php print($pub[3]); ?>" />
            <input type="hidden" name="publishedMinute" value="<?php print($pub[4]); ?>" />
            <input type="hidden" name="publishedSecond" value="<?php print($pub[5]); ?>" />
            <input type="hidden" name="grid_reference" value="<?php print($gr); ?>" />
            <input type="hidden" name="gridimage_id" value="<?php print($imgid); ?>" />
            <input type="hidden" name="content" value="<?php print(htmlentities($descr)); ?>" />
            <input type="hidden" name="tags" value="<?php print($tags); ?>" />
            <div style="text-align:center;background-color:green">
              <input type="submit" name="submit" value="Submit to Geograph blog" style="margin:10px" />
            </div>
          </form>
        </div>
<?php
      } else {
?>
        <div class="panel maxi">
          <p>
Location, starting point, type of trip and a Geograph search id are required to plot your
trip on the map.  Please fill in at least these fields.
          </p>
          <p>
Press Back button, or <a href="geotrip_submit.php">Try again.</a>
          </p>
        </div>
<?php
      }
    }


$smarty->display('_std_end.tpl');

