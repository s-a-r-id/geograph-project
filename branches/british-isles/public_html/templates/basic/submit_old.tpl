{assign var="page_title" value="Submit"}
{include file="_std_begin.tpl"}
{literal}<style type="text/css">
.tab {
	cursor:pointer;
	cursor:hand;
}

.navButtons A {
	border: 1px solid lightgrey;
	padding: 2px;
}

</style>{/literal}
{dynamic}

    <form enctype="multipart/form-data" action="{$script_name}" method="post" name="theForm" onsubmit="if (this.imageclass) this.imageclass.disabled=false;" {if $step ne 1}style="background-color:#f0f0f0;padding:5px;margin-top:0px; border:1px solid #d0d0d0;"{/if}>

{$status_message}

{if $step eq 1}
	<div class="interestBox">
		<span style="color:red">New!</span> - Have a photo to upload but unsure of the location? We have a new {external href="http://www.nearby.org.uk/geograph/speculative/" text="Speculative Upload"} area. Upload photos, and enlist the help of others to locate the photo before transferring it for real to Geograph.
	</div>


	{if $user->stats.images gt 10}
	<p align="center">&middot; <a href="/help/submit">Other submission methods</a> &middot; <b><a href="/submit2.php{if $grid_reference}#gridref={$grid_reference|escape:'url'}{/if}">Try Version 2</a></b> &middot;</p>
	{/if}

	<h2>Submit Step 1 of 4 : Choose grid square</h2>


<div style="background-color:pink; color:black; border:2px solid red; padding:20px; margin-bottom:30px;">
	<img src="http://{$static_host}/templates/basic/img/icon_alert.gif" alt="Alert" width="50" height="44" align="left" style="margin-right:10px"/>

	You are using the old Category based submission process. <br/>
	We have a new submisssion method available, <a href="/switch.php"><b>Read more</b> (and switch methods)</a>.

	<br/><br/>Otherwise please <a href="https://spreadsheets.google.com/spreadsheet/viewform?formkey=dFpiTjJsTEZRRXVwZ2pxWXdXczY2ZGc6MQ" target="_blank">tell us why</a> you haven't switched yet - Thanks!
</div>


{if $user->stats.images eq 0}
	<div style="background-color:pink; color:black; border:2px solid red; padding:10px; margin-bottom:20px"><b>First time here?</b> If so you might like to have a look at our <a href="/faq.php">FAQs</a>, or <a href="/ask.php">ask a question</a>.</div>

{/if}

{if $user->stats.images < 20}
<div style="width:180px;margin-left:10px;margin-bottom:100px;float:right;font-size:0.8em;padding:10px;background:#dddddd;position:relative; border:1px solid gray; z-index:100">
<h3 style="margin-bottom:0;margin-top:0">Need help?</h3>

<p>If you enter the exact location, e.g. <b>TL 246329</b> we'll figure
out that it's in the <b>TL 2432</b> 1km square, but we'll also retain
the more precise coordinates for accurately mapping the location of the
photograph.</p>

<p>When you press Next, we'll find out if there are any existing photographs
for that square</p>

<p>If you're new, you may like to check our <a href="/help/guide">guide to
geographing</a> first.</p>

</div>
{/if}

	{if $errormsg}
	<p style="color:#990000;font-weight:bold;">{$errormsg}</p>
	{/if}

<div style="position:relative;">
	<div class="tabHolder">
		<a class="tab{if $tab == 1}Selected{/if} nowrap" id="tab1" onclick="tabClick('tab','div',1,4)">Enter Grid Reference</a>&nbsp;
		<a class="tab{if $tab == 2}Selected{/if} nowrap" id="tab2" onclick="tabClick('tab','div',2,4)">Choose Square</a>&nbsp;
		<a class="tab{if $tab == 3}Selected{/if} nowrap" id="tab3" onclick="tabClick('tab','div',3,4)">Tagged Image</a>&nbsp;
		<a class="tab{if $tab == 4}Selected{/if} nowrap" id="tab4" onclick="tabClick('tab','div',4,4); if (!document.getElementById('innerFrame4').src) document.getElementById('innerFrame4').src = '/submitmap.php?inner'"><b>Locate on Map</b>/by Placename</a>
	</div>

	<div style="position:relative;{if $tab != 1}display:none{/if}" class="interestBox" id="div1">
		<p>Begin by choosing the grid square for which you wish to submit.</p>

		<p><b>Note:</b> this should be the location of the primary <i>subject</i> of the photo; specify the photographer location in the next step.</p>

		<p><label for="grid_reference">Enter the grid reference
		(<u title="e.g. TQ4364 or TQ 43 64">4</u>,
		<u title="e.g. TQ435646 or TQ 435 646">6</u>,
		<u title="e.g. TQ43526467 or TQ 4352 6467">8</u> or
		<u title="e.g. TQ4352364673 or TQ 43523 64673">10</u> figure) for the subject grid square</label><br /><br />
		{if $grid_reference}<small><small>(<a href="javascript:void(document.getElementById('grid_reference').value = '');">clear</a>)<br/></small></small>{/if}
		<input id="grid_reference" type="text" name="grid_reference" value="{$grid_reference|escape:'html'}" size="14"/><small class="navButtons"><small><a href="javascript:doMove('grid_reference',-1,0);">W</a></small><sup><a href="javascript:doMove('grid_reference',0,1);">N</a></sup><sub><a href="javascript:doMove('grid_reference',0,-1);">S</a></sub><small><a href="javascript:doMove('grid_reference',1,0);">E</a></small></small>
		&nbsp;&nbsp;&nbsp;
		<input type="submit" name="setpos" value="Next &gt;"/> {if $picnik_api_key}<hr/><br/>or enter location above and <input type="submit" name="picnik" value="Upload via Picnik &gt;"/>
		</p>

		<p><small>Clicking the <i>Upload via Picnik</i> button above allows submission via an online image manipulation service that allows tweaking of the image prior to automatically transferring it to Geograph.</small>
		{/if}</p>
	</div>

	<div style="position:relative;{if $tab != 2}display:none{/if}" class="interestBox" id="div2">
		<p>Begin by choosing the grid square for which you wish to submit.</p>

		<p><b>Note:</b> this should be the location of the primary <i>subject</i> of the photo; if you wish you can specify a photographer location in the next step.</p>

		<p><label for="gridsquare">Select the 1km grid square below...</label><br/><br/>
		<select id="gridsquare" name="gridsquare">
			{html_options options=$prefixes selected=$gridsquare}
		</select>&nbsp;&nbsp;
		<label for="eastings">E</label>
		<select id="eastings" name="eastings">
			{html_options options=$kmlist selected=$eastings}
		</select>
		<small><small><a href="javascript:doMove2(-1,0);">W</a></small><small><a href="javascript:doMove2(1,0);">E</a></small></small>&nbsp;&nbsp;
		<label for="northings">N</label>
		<select id="northings" name="northings">
			{html_options options=$kmlist selected=$northings}
		</select>
		<small><sup><a href="javascript:doMove2(0,1);">N</a></sup><sub><a href="javascript:doMove2(0,-1);">S</a></sub></small>
		&nbsp;&nbsp;&nbsp;
		<input type="submit" name="setpos2" value="Next &gt;"/> {if $picnik_api_key}<hr/><br/>or select location above and <input type="submit" name="picnik" value="Upload via Picnik &gt;"/>
		</p>

		<p><small>Clicking the <i>Upload via Picnik</i> button above allows submission via an online image manipulation service that allows tweaking of the image prior to automatically transferring it to Geograph.</small>{/if}
		</p>
	</div>

	<div style="position:relative;{if $tab != 3}display:none{/if}" class="interestBox" id="div3">
		<p><label for="jpeg_exif"><b>Upload an image with locational information attached</b></label> <br/>

		<input id="jpeg_exif" name="jpeg_exif" type="file" size="60"/>
		<input type="hidden" name="MAX_FILE_SIZE" value="8192000" />

		<input type="submit" name="setpos" value="Next &gt;"/> <br/>

		 - (upload photos larger than 640px - upto 8Mb filesize <a href="/article/Larger-Uploads-Information" class="about" target="_blank">About</a>)<br/>

		<div>Currently understands: <a href="/article/Uploading-Tagged-Images" class="about">About</a><ul>
		<li>GPS-EXIF tags based on WGS84 Lat/Long</li>
		<li>Subject grid-reference from the name of the file (eg "<tt>photo-<b style="padding:1px">TQ435646</b>A.jpg</tt>")</li>
		<li>Subject grid-reference in EXIF Comment tag</li>
		</ul></div>

		<p><sup style=color:red>New!</sup> the <a href="/submit-multi.php">Multi-Submit</a>, now understands tagged images like this upload box does.</p>
	</div>

	<div style="position:relative;{if $tab != 4}display:none{/if}" class="interestBox" id="div4">
		<iframe {if $tab == 4}src="/submitmap.php?inner"{/if} id="innerFrame4" width="613" height="660" frameborder="0"><a href="/submitmap.php">Click here to open a Draggable Interactive Google Map</a></iframe>
	</div>

</div>
	{if !$user->use_autocomplete && $user->stats.images gt 10}
	(<input type="checkbox" name="use_autocomplete" {if $user->use_autocomplete} checked{/if} id="use_autocomplete"/> <label for="use_autocomplete">Tick this box, to try a new auto-complete text entry for image category selection, rather than dropdown. Change permanently on your <a href="/profile.php?edit=1">profile settings page</a></label>)
	{/if}

	<br/><br/><br/>
	<p>If you are unsure of the photo location there are a number of online
		sources available to help:</p>

	<ul>
		<li><b>{external href="http://www.getamap.ordnancesurveyleisure.co.uk/" text="OS getamap"} provides a search by
		Placename or Postcode.</b><br/> Once you have centred the map on the picture location,
		return here and enter the <i>Grid reference at centre</i> value shown into the box
		above.<br/><br/></li>
		<li>{external href="http://www.multimap.com/map/browse.cgi?lat=54.5445&lon=-6.8228&scale=1000000" text="multimap.com"} now displays 1:50,000 <b>Mapping for Northern Ireland</b>. Use our handy <a href="/latlong.php">Lat/Long Convertor</a> to get the correct Grid Square for a picture.<br/><br/>

		Furthermore {external href="http://www.osni.gov.uk/mapstore" text="OSNI"} and {external href="http://www.osi.ie/" text="OSI"} now offer online mapping from their own websites. Coordinate conversion may not be easy - its probably best to rely on visual estimation using the national grid projected on the map.
		<br/><br/></li>

		<li><b>If you have a WGS84 latitude &amp; longitude coordinate</b>
		(e.g. from a GPS receiver, or from multimap site), then see our
		<a href="/latlong.php">Lat/Long to Grid Reference Convertor</a><br/><br/></li>
		<li><b>For information on {external href="http://en.wikipedia.org/wiki/Grid_reference" text="Grid References"}</b> <br/>see
		{external title="Guide to the National Grid" text="Interactive Guide to the National Grid in Great Britain" href="http://www.ordnancesurvey.co.uk/oswebsite/gi/nationalgrid/nghelp1.html"}.
		The {external href="http://en.wikipedia.org/wiki/Irish_national_grid_reference_system" text="Irish National Grid"} is very similar, but using a single letter prefix,
		see <a href="/mapbrowse.php">Overview Map</a> for the layout of the squares.
		</li>
	</ul>

	<script type="text/javascript" src="{"/mapping1.js"|revision}"></script>
	<script type="text/javascript" src="{"/mapper/geotools2.js"|revision}"></script>
{else}
	<input type="hidden" name="gridsquare" value="{$gridsquare|escape:'html'}">
	<input type="hidden" name="eastings" value="{$eastings|escape:'html'}">
	<input type="hidden" name="northings" value="{$northings|escape:'html'}">
{/if}
{if $step > 2}
	<input type="hidden" name="grid_reference" value="{$grid_reference|escape:'html'}">
{/if}

{if $step eq 2}

	<h2>Submit Step 2 of 4 : Upload photo for {$gridref}</h2>

	{if !$user->stats.images || $user->stats.images < 100 || !$last_imagetaken}
	<div style="color:black; background-color:yellow; font-size:0.7em; padding:3px; border: 1px solid orange">Please avoid submitting images with overlaid text or borders; they should be cropped before submission. Thank you for your attention to this matter.<br/><br/>
	You should only submit photos you have taken yourself, or those for which you have been licensed to act by the original author.</div><br/>
	{/if}

	{if $rastermap->enabled}
		<div style="float:left;width:50%;position:relative">
	{else}
		<div>
	{/if}
		{if $imagecount gt 0}
			<div style="color:#440000">We currently have
			{if $imagecount eq 1}an image{else}{$imagecount} images{/if} {if $totalimagecount && $totalimagecount > $imagecount} ({$totalimagecount} including hidden){/if}
			uploaded for {newwin title="View images for `$gridref`" href="/gridref/`$gridref`" text=`$gridref`}, add yours now!</div>
		{else}
			<p style="color:#004400">Fantastic! We don't yet have an image for {$gridref}! {if $totalimagecount && $totalimagecount ne $imagecount} (but you have {$totalimagecount} hidden){/if}</p>
		{/if}
		<hr/>
		{if $transfer_id}
		<img src="{$preview_url}" width="{$preview_width*0.2|string_format:"%d"}" height="{$preview_height*0.2|string_format:"%d"}" alt="low resolution reminder image"/>
		<input name="transfer_id" type="hidden" value="{$transfer_id|escape:"html"}"/>
		{elseif $jpeg_url}
		<label for="jpeg_url"><b>JPEG Image URL</b></label>
		<input id="jpeg_url" name="jpeg_url" type="text" size="40" value="{$jpeg_url|escape:"html"}"/>
		{else}
		<input type="hidden" name="MAX_FILE_SIZE" value="8192000" />
		<label for="jpeg"><b>JPEG Image File</b></label>
		<input id="jpeg" name="jpeg" type="file" />

		<div>(upload photos larger than 640px - upto 8Mb filesize <a href="/article/Larger-Uploads-Information" class="about" target="_blank">About</a>)</div>
		{/if}
		{if $error}<br /><p style="color:#990000;font-weight:bold;">{$error}</p>{/if}
		<hr/>

		{if $reference_index == 2}
		{external href="http://www.multimap.com/maps/?zoom=15&countryCode=GB&lat=`$lat`&lon=`$long`&dp=904|#map=`$lat`,`$long`|15|4&dp=925&bd=useful_information||United%20Kingdom" text="multimap.com" title="multimap includes 1:50,000 mapping for Northern Ireland" target="_blank"} includes 1:50,000 mapping for Northern Ireland.
		{/if}

		{if $last_grid_reference || $last_photographer_gridref}
			<div style="font-size:0.8em">
			<a href="javascript:{if $last_photographer_gridref}void(document.theForm.photographer_gridref.value = '{$last_photographer_gridref}');void(updateMapMarker(document.theForm.photographer_gridref,false));{/if}{if $last_grid_reference}void(document.theForm.grid_reference.value = '{$last_grid_reference}');void(updateMapMarker(document.theForm.grid_reference,false));{/if}">Copy from Last Submission</a></div>
		{else}

		{/if}

		<p><label for="grid_reference"><b style="color:#0018F8">Primary Photo Subject</b></label> <input id="grid_reference" type="text" name="grid_reference" value="{if $square->natspecified}{$grid_reference|escape:'html'}{/if}" size="14" onkeyup="updateMapMarker(this,false)" onpaste="updateMapMarker(this,false)" onmouseup="updateMapMarker(this,false)" oninput="updateMapMarker(this,false)"/>{if $rastermap->reference_index == 1}<img src="http://{$static_host}/img/icons/circle.png" alt="Marks the Subject" width="29" height="29" align="middle"/>{else}<img src="http://www.google.com/intl/en_ALL/mapfiles/marker.png" alt="Marks the Subject" width="20" height="34" align="middle"/>{/if}</p>



		<p><label for="photographer_gridref"><b style="color:#002E73">Photographer Position</b></label> <input id="photographer_gridref" type="text" name="photographer_gridref" value="{$photographer_gridref|escape:'html'}" size="14" onkeyup="updateMapMarker(this,false)" onpaste="updateMapMarker(this,false)" onmouseup="updateMapMarker(this,false)" oninput="updateMapMarker(this,false)"/>{if $rastermap->reference_index == 1}<img src="http://{$static_host}/img/icons/viewc--1.png" alt="Marks the Photographer" width="29" height="29" align="middle"/>{else}<img src="http://{$static_host}/img/icons/camicon.png" alt="Marks the Photographer" width="12" height="20" align="middle"/>{/if}

		<span style="font-size:0.8em"><br/><a href="javascript:void(document.theForm.photographer_gridref.value=(document.theForm.grid_reference.value.length>3)?document.theForm.grid_reference.value:document.theForm.photographer_gridref.value);void(updateMapMarker(document.theForm.photographer_gridref,false));" style="font-size:0.8em">Copy from Subject</a> <span id="dist_message" style="padding-left:20px"></span>
		</span>

		{if $rastermap->enabled}
			<br/><br/><input type="checkbox" name="use6fig" id="use6fig" {if $use6fig} checked{/if} value="1"/> <label for="use6fig">Only display 6 figure grid reference</label> <a href="/help/map_precision" title="Explanation" class="about" target="_blank" style="font-size:0.6em">About</a>
		{/if}
		</p>

		<hr/>

		<p><label for="view_direction"><b>View Direction</b></label> <small>(photographer facing)</small><br/>
		<select id="view_direction" name="view_direction" style="font-family:monospace" onchange="updateCamIcon(this);">
			{foreach from=$dirs key=key item=value}
				<option value="{$key}"{if $key%45!=0} style="color:gray"{/if}{if $key==$view_direction} selected="selected"{/if}>{$value}</option>
			{/foreach}
		</select></p>

		<hr/>
	</div>

	{if $rastermap->enabled}
		<div class="rastermap" style="width:45%;position:relative">
		<b>{$rastermap->getTitle($gridref)}</b><br/><br/>
		{$rastermap->getImageTag()}<br/>
		<span style="color:gray"><small>{$rastermap->getFootNote()}</small></span>

		</div>

		{$rastermap->getScriptTag()}
			{literal}
			<script type="text/javascript">
				function updateMapMarkers() {
					updateMapMarker(document.theForm.grid_reference,false,true);
					updateMapMarker(document.theForm.photographer_gridref,false,true);
					{/literal}{if $view_direction == -1}
						updateViewDirection();
					{/if}{literal}
				}
				AttachEvent(window,'load',updateMapMarkers,false);
			</script>
			{/literal}

	{else}
		<script type="text/javascript" src="{"/mapping.js"|revision}"></script>
	{/if}

	<br/>
	<input type="submit" name="goback" value="&lt; Back"/> <input type="submit" name="upload" value="Next &gt;" onclick="if (checkFormSubmission(this.form,{if $rastermap->enabled}true{else}false{/if}{literal})) {return autoDisable(this);} else {return false}{/literal}"/>
	<br style="clear:both"/>

	{if $totalimagecount gt 0}
	<br/>
	<div class="interestBox">
		<div><b>Latest {$shownimagecount} images for this square...</b></div>

	{foreach from=$images item=image}

	  <div class="photo33" style="float:left;width:150px; height:170px; background-color:white">{newwin title="`$image->title` by `$image->realname` - click to view full size image"|escape:'html' href="/photo/`$image->gridimage_id`" text=$image->getThumbnail(120,120,false,true)}
	  <div class="caption"><a title="view full size image" href="/photo/{$image->gridimage_id}" target="_blank">{$image->title|escape:'html'}</a></div>
	  </div>

	{/foreach}
	<br style="clear:both"/>

	{if $imagecount gt 6 || $shownimagecount == 6}
		<div>{newwin href="/gridref/`$gridref`" text="View browse page for `$gridref`"}, {newwin href="/search.php?gridref=`$gridref`&amp;distance=1&amp;orderby=submitted&amp;reverse_order_ind=1&amp;do=1" text="View images page by page"}</div>
	{/if}&nbsp;
	</div>
	{else}
		<br style="clear:both"/>
	{/if}
	{if $rastermap->enabled}
		{$rastermap->getFooterTag()}
	{/if}
{else}
	<input type="hidden" name="photographer_gridref" value="{$photographer_gridref|escape:'html'}">
	<input type="hidden" name="view_direction" value="{$view_direction|escape:'html'}">
	<input type="hidden" name="use6fig" value="{$use6fig|escape:'html'}">

{/if}

{if $step eq 3}

<h2>Submit Step 3 of 4 : Check photo</h2>

{if $errormsg}
<p style="color:#990000;font-weight:bold;">{$errormsg}</p>
{/if}

  {if $smallimage}
	<div style="background-color:red; color:white; border:1px solid pink; padding:10px;">We notice the image is quite small, you can continue, but we would welcome a bigger image. Note, small images are usually rejected unless there is something unique about the image.</div>
  {/if}

<p>
Below is a full-size preview of the image we will store for grid reference
{$gridref}.<br/><br/>

<img src="{$preview_url}" width="{$preview_width}" height="{$preview_height}"/>
<br/><br/>

<div style="position:relative; background-color:#dddddd; padding-left:10px;padding-top:1px;padding-bottom:1px;">
<h3><a name="geograph"></a>Is the image a &quot;geograph&quot;?</h3>

<p>If you're the first to submit a proper &quot;geograph&quot; for {$gridref}
you'll get a geograph point added to your profile and the warm glow that comes
with it.</p>
<p>So what makes an image a genuine geograph?</p>
<ul>
<li>The image subject and the photographer must both be within the grid square {$gridref}.</li>
<li>You must clearly show at close range one of the main geographical features within the square.</li>
<li>You should include a short description relating the image to the map square.</li>
<li>The image should be a natural image as a human would see it, please avoid digitally altering the image to add dates, texts etc, or creating montages, similarly turn off date stamping performed by a camera. A little tweaking of brightness/contrast and/or cropping is fine and encouraged. </li>
</ul>

<p>Good quality, visually appealing and historically relevant pictures (eg wide area views
covering many square kilometres) may also be accepted as supplemental images
for {$gridref} provided they are accurately located, but may not qualify as geographs.</p>

<ul>
<li>We welcome many Geograph or Supplemental images per square, so even if you don't get the point, you are still making a valuable contribution to the project.</li>
</ul>

</div>

<p>If you like, you can provide more images or extra information (which
can be edited at any time) but to activate a square you need to be first to meet the
criteria above!</p>

<div class="interestBox" style="width:30em;z-index:0"><a href="/submit_popup.php?t={$reopenmaptoken|escape:'html'}" target="gmappreview" onclick="window.open(this.href,this.target,'width=650,height=500,scrollbars=yes'); return false;">Reopen Map in a popup</a> (and view list of placenames)<br/>
{newwin href="/gridref/`$gridref`" text="Open `$gridref` Page"}</div>

<h3>Title and Comments</h3>
<p>Please provide a short title for the image, and any other comments about where
it was taken or other interesting geographical information. <span id="styleguidelink">({newwin href="/help/style" text="Open Style Guide"})</span></p>

<p><label for="title"><b>Title</b></label> {if $error.title}
	<br/><span class="formerror">{$error.title}</span>
	{/if}<br/>
<input size="50" maxlength="128" id="title" name="title" value="{$title|escape:'html'}" spellcheck="true" onblur="checkstyle(this,'title',true);" onkeyup="checkstyle(this,'title',false);"/> <span class="formerror" style="display:none" id="titlestyle">Possible style issue. See Guide above. <span id="titlestylet" style="font-size:0.9em"></span></span></p>
 {if $place.distance}
 <p style="font-size:0.7em">Gazetteer info as will appear:<br/> <span style="color:silver;">{place place=$place}</span></p>
 {/if}

<p style="clear:both"><label for="comment"><b>Description/Comment</b></label> <span class="formerror" style="display:none" id="commentstyle">Possible style issue. See Guide above. <span id="commentstylet"></span></span><br/>
<textarea id="comment" name="comment" rows="7" cols="80" spellcheck="true" onblur="checkstyle(this,'comment',true);" onkeyup="checkstyle(this,'comment',false);">{$comment|escape:'html'}</textarea></p>

<div style="font-size:0.7em">TIP: use <span style="color:blue">[[TQ7506]]</span> to link to a Grid Square or <span style="color:blue">[[54631]]</span> to link to another Image.<br/>
For a weblink just enter directly like: <span style="color:blue">http://www.example.com</span></div>

<h3 style="margin-bottom:3px">Further Information</h3>

<div style="font-size:0.7em;margin-top:0;margin-bottom:4px">Please add at least one Tag or Context item. Note: <b>Can use the old Category list to create a Tag</b>, click the Tags tab.</div>

<div class="tabHolder" style="font-size:1em">
	<a class="tab nowrap" id="tab2" style="font-size:0.9em" onclick="tabClick('tab','div',2,4);show_tagging(document.forms['theForm'])">Tags</a>&nbsp;
	<a class="tabSelected nowrap" id="tab1" style="font-size:0.9em" onclick="tabClick('tab','div',1,4)">Geographical Context</a>&nbsp;
	<a class="tab nowrap" id="tab3" style="font-size:0.9em" onclick="tabClick('tab','div',3,4); document.getElementById('shareframe').src='/submit_snippet.php?upload_id={$upload_id}&gr={$grid_reference|escape:'html'}';">Shared Descriptions <small>(Optional)</small></a>
</div>



		<div id="div3" class="interestBox" style="display:none">
			<iframe src="about:blank" height="400" width="100%" id="shareframe" style="border:0">
			</iframe>
		</div>

		<div id="div1" class="interestBox">
			<div style="float:right"><a href="/article/Transitioning-Categories-to-Tags" text="Article about new tags and categories" class="about" target="_blank">About Context/Tags</a></div>
			<div style="font-size:0.8em;padding-bottom:5px;">
			&middot; Tick as many Geogaphical Contexts as required.<br/>
			&middot; Hover over name for a description, see also <a href="/tags/primary.php" text="More examples" target="_blank">further details and examples</a><br/>
			&middot; If in doubt about the exact context, simply pick the best match from Natural Environment or Human Habitat.<br/>
			&middot; As we have been adding Context to the previous categories, you could also try <a href="/finder/categories.php" target="_blank">searching by the old category name here</a>.<br/>
			</div>

			{foreach from=$tops key=key item=item}
				<div class="plist">
					<div style="color:black">{$key}</div>
					{foreach from=$item item=row}{assign var="tagtop" value=$row.top}
						<label for="c-{$row.top|escape:'url'}" title="{$row.description|escape:'html'}" id="l-{$row.top|escape:'url'}">
							<input type="checkbox" name="tags[]" value="top:{$row.top|escape:'html'}" id="c-{$row.top|escape:'url'}" onclick="rehighlight(this,true)" {if $tagarray.$tagtop} checked{/if}/>
							{$row.top|escape:'html'}
						</label>
					{/foreach}
					<br/>
				</div>
			{/foreach}
			<br style="clear:both"/>

		</div>

		<div id="div2" class="interestBox" style="display:none">
			<div style="float:right"><a href="/article/Tags" title="Article about Tags" class="about" target="_blank">More about Tags</a></div>
			<div style="font-size:0.8em;padding-bottom:5px;">
			&middot; Tags are simple free-form keywords/short phrases used to describe the image.<br/>
			&middot; Please add as many Tags as you need. Tags will help other people find your photo.<br/>
			&middot; Tags should be singular, ie an image of a church should have the tag "church", not "churches"<br/> <small>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(however if a photo is of multiple say fence posts, then the tag "fence post<b>s</b>" should be used).</small><br/>
			&middot; To add a placename as a Tag, please prefix with "place:", eg "place:Croydon" - similarly could use "near:Tring".
			</div>

			<iframe src="about:blank" height="200" width="100%" id="tagframe" style="border:0">
			</iframe>

			{if $use_autocomplete}

			<p><label for="imageclass"><b>Primary geographical category</b></label> {if $error.imageclass}
				<br/><span class="formerror">{$error.imageclass} or select some Geographical Context</span>
				{/if}<br />
				<input size="32" id="imageclass" name="imageclass" value="{$imageclass|escape:'html'}" maxlength="32" spellcheck="true"/>
				</p>
			{literal}
			<script type="text/javascript">
			<!--

			AttachEvent(window,'load', function() {
			 	var inputWord = $('imageclass');

			    new Autocompleter.Request.JSON(inputWord, '/finder/categories.json.php', {
			        'postVar': 'q',
			        'minLength': 2,
			        maxChoices: 60
			    });

			},false);

			//-->
			</script>
			{/literal}

			{else}

			{literal}
			<script type="text/javascript">
			<!--
			//rest loaded in geograph.js
			function mouseOverImageClass() {
				if (!hasloaded) {
					setTimeout("prePopulateImageclass2()",100);
				}
				hasloaded = true;
			}

			function prePopulateImageclass2() {
				var sel=document.getElementById('imageclass');
				sel.disabled = false;
				var oldText = sel.options[0].text;
				sel.options[0].text = "please wait...";

				populateImageclass();

				hasloaded = true;
				sel.options[0].text = oldText;
				if (document.getElementById('imageclass_enable_button'))
					document.getElementById('imageclass_enable_button').disabled = true;
			}
			AttachEvent(window,'load',onChangeImageclass,false);
			//-->
			</script>
			{/literal}

			Alternatively add a Tag by selecting from the (old) Category list:<br/>
				<select id="imageclass" name="imageclass" onchange="onChangeImageclass()" onfocus="prePopulateImageclass()" onmouseover="mouseOverImageClass()" style="width:300px">
					<option value="">--please select feature--</option>
					{if $imageclass}
						<option value="{$imageclass}" selected="selected">{$imageclass}</option>
					{/if}
					<option value="Other">Other...</option>
				</select>

				<span id="otherblock">
				<label for="imageclassother">Please specify </label>
				<input size="32" id="imageclassother" name="imageclassother" value="{$imageclassother|escape:'html'}" maxlength="32" spellcheck="true"/>
				</span>


				<input type=button value="Add" onclick="addCategoryTag(this.form)"/></p>

			{/if}



		</div>

{literal}
<script type="text/javascript">

function addCategoryTag(form) {
	var catother = form.elements['imageclassother'].value;

	var ele = form.elements['imageclass'];
	var value = ele.options[ele.selectedIndex].value;
	if (value == 'Other' && catother.length > 0) {
		value = catother;
	}

	var loader = new Image();
	loader.src = "/tags/tagger.json.php?upload_id={/literal}{$upload_id}{literal}&status=2&tag="+encodeURIComponent("category:"+value);

	document.getElementById('tagframe').src='about:blank';

	setTimeout(function(){ show_tagging(form); }, 250);
}

function show_tagging(form) {
	var query = 'upload_id={/literal}{$upload_id}&gr={$grid_reference|escape:'html'}{literal}&v=3';
	if (form.elements['title'].value.length> 0 )
		query=query+'&title='+encodeURIComponent(form.elements['title'].value);
	for(q=0;q<form.elements['tags[]'].length;q++)
		if (form.elements['tags[]'][q].checked)
			query=query+'&tags[]='+encodeURIComponent(form.elements['tags[]'][q].value);
	if (form.elements['comment'].value.length> 0 )
		query=query+'&comment='+encodeURIComponent(form.elements['comment'].value.substr(0,1500).replace(/[\n\r]/,' '));
	document.getElementById('tagframe').src='/tags/tagger.php?'+query;
}
function rehighlight(that,check) {
	if (check) {
		var name=that.name;
		var ele = that.form.elements[name];
		count=-1; //the current one will already be checked
		for(q=0;q<ele.length;q++)
			if (ele[q].checked)
				count++;
		if (count > 5) {
			if (!confirm("Are you sure you wish to enable '"+that.value.replace(/top:/,'')+"'?\n\n You already have "+count+" ticked items, which is probably plenty!")) {
				that.checked = false;
			}
		}

	}
	var id = that.id.replace(/c-/,'l-');
	document.getElementById(id).style.fontWeight=that.checked?'bold':'normal';
	document.getElementById(id).style.backgroundColor=that.checked?'white':'';
}
{/literal}

{if $tagarray}
	{foreach from=$tagarray key=key item=row}
		rehighlight(document.getElementById("c-{$key|escape:'url'}"));
	{/foreach}
{/if}

</script>


<p><label><b>Date photo taken</b></label> {if $error.imagetaken}
	<br/><span class="formerror">{$error.imagetaken}</span>
	{/if}<br/>
	{html_select_date prefix="imagetaken" time=$imagetaken start_year="-200" reverse_years=true day_empty="" month_empty="" year_empty="" field_order="DMY"}
	{if $imagetakenmessage}
	    {$imagetakenmessage}
	{/if}

	[ Use
	<input type="button" value="Today's" onclick="setdate('imagetaken','{$today_imagetaken}',this.form);" class="accept"/>
	{if $last_imagetaken}
		<input type="button" value="Last Submitted" onclick="setdate('imagetaken','{$last_imagetaken}',this.form);" class="accept"/>
	{/if}
	{if $imagetaken != '--' && $imagetaken != '0000-00-00'}
		<input type="button" value="Current" onclick="setdate('imagetaken','{$imagetaken}',this.form);" class="accept"/>
	{/if}
	Date ]

	<br/><br/><span style="font-size:0.7em">(please provide as much detail as possible, if you only know the year or month that's fine)</span></p>


	<p align="center"><input type="button" value="Preview submission in a new window"  onclick="document.getElementById('previewButton').click();"/>

<div style="position:relative; background-color:#dddddd; border: 1px solid red; padding-left:10px;padding-top:1px;padding-bottom:1px;">
<h3>Image Classification</h3>

<p><label for="user_status">I wish to suggest supplemental classification:</label> <input type="checkbox" name="user_status" id="user_status" value="accepted" {if $user_status == "accepted"}checked="checked"{/if}/> (tick to apply)</p>

<p>Tick this box only if you believe your photograph is not a 'geograph'. The moderator will just use the box as a suggestion, so if you are not sure, leave it unticked. Note: there can be many geograph images per square.</p>

<p>Remembering the points <a href="#geograph">above</a> about what makes a 'geograph', <span class="nowrap">more information can be found in this {newwin href="/article/Geograph-or-supplemental" text="article on how images are moderated"}.</span></p>
</div>

<p>
<input type="hidden" name="upload_id" value="{$upload_id}"/>
<input type="hidden" name="savedata" value="1"/>
<input type="submit" name="goback" value="&lt; Back" onclick="return confirm('Please confirm. All details entered on this page - will be lost.');"/>
<input type="submit" name="next" value="Next &gt;"/></p>

{if $use_autocomplete}
	<link rel="stylesheet" type="text/css" href="{"/js/Autocompleter.css"|revision}" />

	<script type="text/javascript" src="{"/js/mootools-1.2-core.js"|revision}"></script>
	<script type="text/javascript" src="{"/js/Observer.js"|revision}"></script>
	<script type="text/javascript" src="{"/js/Autocompleter.js"|revision}"></script>
	<script type="text/javascript" src="{"/js/Autocompleter.Request.js"|revision}"></script>
{else}
<script type="text/javascript" src="/categories.js.php"></script>
<script type="text/javascript" src="/categories.js.php?full=1&amp;u={$user->user_id}"></script>
{/if}

{else}
	<input type="hidden" name="title" value="{$title|escape:'html'}"/>
	<input type="hidden" name="comment" value="{$comment|escape:'html'}"/>
	<input type="hidden" name="tags" value="{$tags|escape:'html'}"/>
	<input type="hidden" name="imageclass" value="{$imageclass|escape:'html'}"/>
	<input type="hidden" name="imagetaken" value="{$imagetaken|escape:'html'}"/>
	<input type="hidden" name="user_status" value="{$user_status|escape:'html'}"/>
{/if}

{if $step eq 4}
	<input type="hidden" name="upload_id" value="{$upload_id}"/>
	<input type="hidden" name="title" value="{$title|escape:'html'}"/>
	<input type="hidden" name="comment" value="{$comment|escape:'html'}"/>
	<input type="hidden" name="tags" value="{$tags|escape:'html'}"/>
	<input type="hidden" name="imageclass" value="{$imageclass|escape:'html'}"/>
	<input type="hidden" name="imagetaken" value="{$imagetaken|escape:'html'}"/>
	<input type="hidden" name="user_status" value="{$user_status|escape:'html'}"/>

	{if $original_width}

		<h2>Submit Step 4 of 4: Confirm image size and rights</h2>

		{include file="_submit_sizes.tpl"}

		<hr/>
	{else}
		<h2>Submit Step 4 of 4 : Confirm image rights</h2>
	{/if}


	{if $user->stats.images && $user->stats.images > 100 && $last_imagetaken}

	<div style="border:1px solid gray; padding:10px">I've read this already, <input style="background-color:lightgreen; width:200px" type="submit" name="finalise" value="I AGREE &gt;" onclick="autoDisable(this);autoDisable(this.form.finalise[1]);"/><br/> (saves scrolling to the bottom)</div>
	{/if}

	<p>
	Because we are an open project we want to ensure our content is licensed
	as openly as possible and so we ask that all images are released under a {external title="Learn more about Creative Commons" href="http://creativecommons.org" text="Creative Commons" target="_blank"}
	licence, including accompanying metadata.</p>

	<p>With a Creative Commons licence, the photographer <b>keeps the copyright</b> but allows
	people to copy and distribute the work provided they <b>give credit</b>.</p>

	<p>Since we want to ensure we can use your work to fund the running costs of
	this site, and allow us to create montages of grid images, we ask that you
	allow the following</p>

	<ul>
	<li>The right to use the work commercially</li>
	<li>The right to modify the work to create derivative works</li>
	</ul>

	<p>{external title="View licence" href="http://creativecommons.org/licenses/by-sa/2.0/" text="Here is the Commons Deed outlining the licence terms" target="_blank"}</p>

	{assign var="credit" value=$user->credit_realname}
	{assign var="credit_default" value=0}
	{include file="_submit_licence.tpl"}

	<p>If you do
	not agree with these terms, click "I do not agree" and your upload will
	be abandoned.<br />
	<input style="background-color:pink; width:200px" type="submit" name="abandon" value="I DO NOT AGREE" onclick="return confirm('Are you sure? The current upload will be discarded!');"/>

	</p>


	<p>If you agree with these terms, click "I agree" and your image will be
	stored in grid square {$gridref}.<br />
	<input type="submit" name="goback3" value="&lt; Back"/>
	<input style="background-color:lightgreen; width:200px" type="submit" name="finalise" value="I AGREE &gt;" onclick="autoDisable(this);{if $user->stats.images && $user->stats.images > 100 && $last_imagetaken}autoDisable(this.form.finalise[0]);{/if}"/>
	</p>



{/if}

{if $step eq 5}
<h2>Submission Complete!</h2>
<p>Thank you very much - your photo has now been added to grid square
<a title="Grid Reference {$gridref}" href="/gridref/{$gridref}">{$gridref}</a>.</p>
<p>Your photo has identification number [<a href="/photo/{$gridimage_id}">{$gridimage_id}</a>]</p>


<p><a title="submit another photo" href="/submit.php">Submit another photo...</a></p>

<ul>
<li><a href="/submissions.php" rel="nofollow">Edit My Recent Submissions</a></li>
</ul>

{/if}

{if $step eq 6}
<h2>Submission Abandoned</h2>
<p>Your upload has been aborted - if you have any
concerns or feedback regarding our licence terms,
please <a title="contact us" href="/contact.php">contact us</a></p>
{/if}


{if $step eq 7}
<h2>Submission Problem</h2>
<p>{$errormsg}</p>
<p>Please <a title="submit a photo" href="/submit.php">try again</a>, and
<a title="contact us" href="/contact.php">contact us</a> if you continue to
have problems
</p>
{/if}


	</form>

{if $step eq 3}

	<script type="text/javascript">{literal}
	function previewImage() {
		window.open('','_preview');//forces a new window rather than tab?
		var f1 = document.forms['theForm'];
		var f2 = document.forms['previewForm'];
		for (q=0;q<f2.elements.length;q++) {
			if (f2.elements[q].name && f1.elements[f2.elements[q].name]) {
				f2.elements[q].value = f1.elements[f2.elements[q].name].value;
			}
		}
		return true;
	}
	{/literal}</script>
	<form action="/preview.php" method="post" name="previewForm" target="_preview" style="padding:10px; text-align:center">
	<input type="hidden" name="grid_reference"/>
	<input type="hidden" name="photographer_gridref"/>
	<input type="hidden" name="view_direction"/>
	<input type="hidden" name="use6fig"/>
	<input type="hidden" name="title"/>
	<textarea name="comment" style="display:none"/></textarea>
	<input type="hidden" name="imageclass"/>
	<input type="hidden" name="imageclassother"/>
	<input type="hidden" name="imagetakenDay"/>
	<input type="hidden" name="imagetakenMonth"/>
	<input type="hidden" name="imagetakenYear"/>
	<input type="hidden" name="upload_id"/>
	<input type="submit" value="Preview Submission in a new window" onclick="previewImage()" id="previewButton"/>

	<input type="checkbox" name="spelling"/>Check Spelling
	<sup style="color:red">Experimental!</sup>
	</form>
{/if}

{if $preview_url}
{if !$enable_forums}
	<div style="position:fixed;right:10px;bottom:10px;display:none;background-color:silver;padding:2px;font-size:0.8em;width:148px" id="hidePreview">
{else}
	<div style="position:fixed;left:1px;bottom:10px;display:none;background-color:silver;padding:2px;font-size:0.8em;width:138px" id="hidePreview">
{/if}
	<div id="previewInner"></div></div>

<script type="text/javascript">
{literal}
function showPreview(url,width,height,filename) {
	height2=Math.round((138 * height)/width);
	document.getElementById('previewInner').innerHTML = '<img src="'+url+'" width="138" height="'+height2+'" id="imgPreview" onmouseover="this.height='+height+';this.width='+width+'" onmouseout="this.height='+height2+';this.width=138" /><br/>'+filename;
	document.getElementById('hidePreview').style.display='';
}
 AttachEvent(window,'load',function () {showPreview({/literal}'{$preview_url}',{$preview_width},{$preview_height},'{$filename|escape:'javascript'}'{literal}) },false);

{/literal}
</script>

{/if}


{/dynamic}
{include file="_std_end.tpl"}