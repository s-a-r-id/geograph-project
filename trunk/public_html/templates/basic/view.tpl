{include file="_std_begin.tpl"}

{if $image}

 <h2><a title="Grid Reference {$image->grid_reference}{if $square_count gt 1} :: {$square_count} total images{/if}" href="/gridref/{$image->grid_reference}">{$image->grid_reference}</a> : {$image->title}</h2>
 {if $place.distance}
 <h3>{if $place.distance > 3}{$place.distance} km from{else}near to{/if} <b>{$place.full_name}</b><small><i>{if $place.adm1_name && $place.adm1_name != $place.reference_name}, {$place.adm1_name}{/if}, {$place.reference_name}</i></small></h3>
 {/if}

{if $image->moderation_status eq 'rejected'}
<h3>Rejected</h3>
<p>This photograph has been rejected by the site moderators, and is only viewable by you.
Possible reasons for rejection include:
</p>
<ul>
<li>Doesn't offer much geographical context - closeups tend to fall into this category.
Shots don't have to be sweeping landscapes, but must provide a reasonable idea of
typical geography.</li>
<li>Family snap - while people can be in the photo, they must not <i>be</i> the photo</li>
<li>Inappropriate content - any image containing material inappropriate for minors</li>
</ul>
<p>We keep rejected submissions on file for a short period, so if you think your
image has been incorrectly rejected (and mistakes do happen!) please <a title="Contact us" href="contact.php">contact us</a>
referring to <b>image {$image->gridimage_id}</b>
</p>

{/if}

<div class="{if $image->isLandscape()}photolandscape{else}photoportrait{/if}">
  <div class="img-shadow">{$image->getFull()}</div>
  <div class="caption"><b>{$image->title|escape:'html'}</b></div>

  {if $image->comment}
  <div class="caption">{$image->comment|escape:'html'|geographlinks}</div>
  {/if}

 
  
  {if $ismoderator}
	  <form method="post">
	  <script type="text/javascript" src="/admin/moderation.js"></script>
	  <b>Moderation</b>
	  <input class="accept" type="button" id="geograph" value="Geograph!" onclick="moderateImage({$image->gridimage_id}, 'geograph')"/>
	  <input class="accept" type="button" id="accept" value="Accept" onclick="moderateImage({$image->gridimage_id}, 'accepted')"/>
	  <input class="reject" type="button" id="reject" value="Reject" onclick="moderateImage({$image->gridimage_id}, 'rejected')"/>
	  <div class="caption" id="modinfo{$image->gridimage_id}">&nbsp;</div>
	  </form>
  {/if}

</div>




<div style="background:#bbbbbb;color:black;">

<table width="100%"><tr>

<td width="50"><a href="/discuss/index.php?gridref={$image->grid_reference}"><img align="left" src="/templates/basic/img/icon_discuss.gif"/></a></td>
<td valign="middle" style="font-size:0.7em;">
{if $discuss}
	There {if $totalcomments == 1}is 1 post{else}are {$totalcomments} posts{/if} in a
	<a href="/discuss/index.php?gridref={$image->grid_reference}">discussion<br/>on {$image->grid_reference}</a> (preview on the left)

{else}
	<a href="/discuss/index.php?gridref={$image->grid_reference}#newtopic">Start a discussion on {$image->grid_reference}</a>
{/if}
</td>

<td width="50"><a href="/editimage.php?id={$image->gridimage_id}"><img align="left" src="/templates/basic/img/icon_alert.gif"/></a></td>
<td valign="middle" style="font-size:0.7em;">
  
  {if ($user->user_id eq $image->user_id) or ($ismoderator)}
  	<a title="Edit title and comments" href="/editimage.php?id={$image->gridimage_id}">Edit picture information</a>
  {else}
  	<a href="/editimage.php?id={$image->gridimage_id}">Report a problem with this picture</a>
  {/if}
</td>

<td width="50"><a href="/usermsg.php?to={$image->user_id}&amp;image={$image->gridimage_id}"><img align="left" src="/templates/basic/img/icon_email.gif"/></a></td>
<td valign="middle" style="font-size:0.7em;">
  
  <a href="/usermsg.php?to={$image->user_id}&amp;image={$image->gridimage_id}">Contact the photographer</a>
</td>

</tr>
</table>

</div>




<div class="picinfo">

{if $overview}
  <div style="float:left; width:{$overview_width+30}px; position:relative">
  {include file="_overview.tpl"}
  <div style="text-align:center"><br/>
  <a title="Open in Google Earth" href="/kml.php?id={$image->gridimage_id}" class="xml-kml">KML</a></div>
  </div>
{/if}


<table class="infotable">
<tr><td><a rel="license" href="http://creativecommons.org/licenses/by-sa/2.0/"><img alt="Creative Commons License" src="http://creativecommons.org/images/public/somerights20.gif" /></a></td><td>

&copy; Copyright <a title="View profile" href="/profile.php?u={$image->user_id}">{$image->realname|escape:'html'}</a> and  
licenced for reuse under this <a rel="license" href="http://creativecommons.org/licenses/by-sa/2.0/" class="nowrap">Creative Commons Licence</a>.
(find <a title="pictures near {$image->grid_reference} by {$image->realname|escape:'html'}" href="/search.php?gridref={$image->grid_reference}&amp;u={$image->user_id}" class="nowrap">nearby pictures by {$image->realname|escape:'html'}</a>) 


</td>

</tr>

<tr><td>Image status</td><td>
{if $image->ftf}
	First geograph for this square!
{else}
	{if $image->moderation_status eq "rejected"}
	Rejected
	{/if}

	{if $image->moderation_status eq "pending"}
	Awaiting moderation
	{/if}

	{if $image->moderation_status eq "geograph"}
	Geograph
	{/if}

	{if $image->moderation_status eq "accepted"}
	Supplemental image
	{/if}
{/if}
</td></tr>


{if $image_taken}
<tr><td>Date Taken</td><td colspan="2">{$image_taken}
 (submitted {$image->submitted|date_format:"%A, %e %B, %Y"})</td></tr>
{else}
<tr><td>Submitted</td><td colspan="2">{$image->submitted|date_format:"%A, %e %B, %Y"}</td></tr>
{/if}

<tr><td>Category</td><td>

{if $image->imageclass}
	{$image->imageclass}

	(<a title="pictures near {$image->grid_reference} of {$image->imageclass|escape:html}" href="/search.php?gridref={$image->grid_reference}&amp;imageclass={$image->imageclass|escape:url}">find more nearby</a>)
{else}
	<i>n/a</i>
{/if}

</td></tr>

<tr><td>Maps</td><td>

<a href="/mapbrowse.php?t={$map_token}">Geograph Map</a>,

{getamap gridref=$image->grid_reference text="OS Get-a-Map"},

{if $image->grid_square->reference_index eq 1}
	{external href="http://www.streetmap.co.uk/streetmap.dll?Grid2Map?X=`$image->grid_square->nateastings`&amp;Y=`$image->grid_square->natnorthings`&amp;title=[`$image->title`]+from+geograph.co.uk&amp;back=Return+to+Geograph&amp;url=http://$http_host/photo/`$image->gridimage_id`&amp;nolocal=X&amp;bimage=background%3dhttp://$http_host/templates/basic/img/background.gif" text="streetmap.co.uk"}
	&amp; 
	{external href="http://www.multimap.com/map/browse.cgi?GridE=`$image->grid_square->nateastings`&amp;GridN=`$image->grid_square->natnorthings`&amp;scale=25000&amp;title=[`$image->title`]+on+geograph.co.uk" text="multimap.com"}
{else}
	&amp;
	{external href="http://www.multimap.com/p/browse.cgi?scale=25000&amp;lon=`$long`&amp;lat=`$lat`&amp;GridE=`$long`&amp;GridN=`$lat`" text="multimap.com" title="multimap includes 1:50,000 mapping for Northern Ireland"}
{/if}

</td></tr>

<tr><td>What's nearby?</td><td>
<a title="More pictures near {$image->grid_reference}" href="/search.php?q={$image->grid_reference}">Geograph Images</a>, 
{if $image->grid_square->reference_index eq 1}
	{external title="Geocaches from geocaching.com, search by geocacheuk.com" href="http://stats.guk2.com/caches/search_parse.php?osgbe=`$image->grid_square->nateastings`&amp;osgbn=`$image->grid_square->natnorthings`" text="Geocaches"},
	{external title="Trigpoints from trigpointinguk.com" href="http://www.trigpointinguk.com/trigtools/find.php?t=`$image->grid_reference`" text="Trigpoints"},
	{external href="http://geourl.org/near?lat=`$lat`&amp;long=`$long`" text="geourl.org" title="search for webpages near this location"} &amp;
 	{external title="find local features and maps with nearby.org.uk" href="http://www.nearby.org.uk/coord.cgi?p=`$image->grid_square->nateastings`+`$image->grid_square->natnorthings`" text="more..."}
{else}
	{external href="http://www.geocaching.com/seek/nearest.aspx?lat=`$lat`&amp;lon=`$long`" text="geocaches" title="Geocaches from geocaching.com"},
 	{external href="http://geourl.org/near?lat=`$lat`&amp;long=`$long`" text="geourl.org" title="search for webpages near this location"}  &amp;
 	{external title="find local features and maps with nearby.org.uk" href="http://www.nearby.org.uk/coord.cgi?p=`$image->grid_square->nateastings`+`$image->grid_square->natnorthings`+OSI" text="more from nearby.org.uk"}
{/if}

</td></tr>


<tr><td>Subject Location</td>
<td style="font-family:verdana, arial, sans serif; font-size:0.8em">
{if $image->grid_square->reference_index eq 1}OSGB36{else}Irish{/if}: {$smallgr} [Accurate to ~{$accucacy}m]<br/>
WGS84: {$latdm} {$longdm}
[{$lat|string_format:"%.5f"},{$long|string_format:"%.5f"}]</td></tr>

{if $posgr}
<tr><td>Photographer Location</td>

<td style="font-family:verdana, arial, sans serif; font-size:0.8em">
{if $image->grid_square->reference_index eq 1}OSGB36{else}Irish{/if}: {$posgr}</td></tr>
{/if}

</table>


<br style="clear:both"/>


<p align="center">
{if $maincontentclass eq "content_photowhite"}
	<a href="/photo/{$image->gridimage_id}?style=black">Prefer a black background for photo viewing?</a>
{else}
	<a href="/photo/{$image->gridimage_id}?style=white">Prefer a white background for photo viewing?</a>
{/if}
</p>

<!--

<rdf:RDF xmlns="http://web.resource.org/cc/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<Work rdf:about="">
     <dc:date>{$image->submitted}</dc:date>
     <dc:format>image/jpeg</dc:format>
     <dc:title>{$image->title|escape:'html'}</dc:title>
     <license rdf:resource="http://creativecommons.org/licenses/by-sa/2.0/" />
</Work>

<License rdf:about="http://creativecommons.org/licenses/by-sa/2.0/">
   <permits rdf:resource="http://web.resource.org/cc/Reproduction" />
   <permits rdf:resource="http://web.resource.org/cc/Distribution" />
   <requires rdf:resource="http://web.resource.org/cc/Notice" />
   <requires rdf:resource="http://web.resource.org/cc/Attribution" />
   <permits rdf:resource="http://web.resource.org/cc/DerivativeWorks" />
   <requires rdf:resource="http://web.resource.org/cc/ShareAlike" />
</License>

</rdf:RDF>

-->

<!--info block-->
</div>



{else}
<h2>Sorry, image not available</h2>
<p>The image you requested is not available. This maybe due to software error, or possibly because
the image was rejected after submission - please <a title="Contact Us" href="/contact.php">contact us</a>
if you have queries</p>
{/if}

{include file="_std_end.tpl"}
