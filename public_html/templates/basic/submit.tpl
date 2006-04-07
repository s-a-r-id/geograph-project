{assign var="page_title" value="Submit"}
{include file="_std_begin.tpl"}

{dynamic}

    <form enctype="multipart/form-data" action="{$script_name}" method="post" name="theForm">

{if $step eq 1}	

	<h2>Submit Step 1 of 4 : Choose grid square</h2>


<div style="width:180px;margin-left:10px;margin-bottom:100px;float:right;font-size:0.8em;padding:10px;background:#dddddd;position:relative">
<h3 style="margin-bottom:0;margin-top:0">Need Help?</h3>

<p>If you enter the exact location, e.g. <b>TL 246329</b> we'll figure 
out that it's in the <b>TL 2432</b> 1km square, but we'll also retain 
the more precise coordinate for accurately mapping the location of the 
photograph.</p>

<p>When you press Next, we'll find out if there are any existing photographs 
for that square</p>

<p>If you're new, you may like to check our <a href="/help/guide">guide to 
geographing</a> first.</p>

</div>


	<p>Begin by choosing the grid square you wish to submit.</p>

	{if $errormsg}
	<p style="color:#990000;font-weight:bold;">{$errormsg}</p>
	{/if}
	
	<p><b>Note:</b> this should be the location of the primary <i>subject</i> of the photo, if you wish you can specify a photographer location in the next step.</p>

	
	<p><label for="gridreference">Enter an exact grid reference 
	(<u title="e.g. TQ4364 or TQ 43 64">4</u>,
	<u title="e.g. TQ435646 or TQ 435 646">6</u>,
	<u title="e.g. TQ43526467 or TQ 4352 6467">8</u> or 
	<u title="e.g. TQ4352364673 or TQ 43523 64673">10</u> figure) for the picture subject</label><br />
	<input id="gridreference" type="text" name="gridreference" value="{$gridreference|escape:'html'}" size="14"/>
	<input type="submit" name="setpos" value="Next &gt;"/><br/>
	</p>
		
	
	<label for="gridsquare">Alternatively, you can select the 1km grid square below...</label><br/>
	<select id="gridsquare" name="gridsquare">
		{html_options options=$prefixes selected=$gridsquare}
	</select>
	<label for="eastings">E</label>
	<select id="eastings" name="eastings">
		{html_options options=$kmlist selected=$eastings}
	</select>
	<label for="northings">N</label>
	<select id="northings" name="northings">
		{html_options options=$kmlist selected=$northings}
	</select>
	
	<input type="submit" name="setpos" value="Next &gt;"/>
	
	
	<p>If you are unsure of the photo location there are a number of online 
		sources available to help:</p>
		
	<ul>
		<li><b>{getamap} provides a search by 
		Placename or Postcode.</b><br/> Once you have centred the map on the picture location, 
		return here and enter the <i>Grid reference at centre</i> value shown into the box 
		above.<br/><br/></li>
		<li>{external href="http://www.multimap.com/map/browse.cgi?lat=54.5445&lon=-6.8228&scale=1000000" text="multimap.com"} now displays 1:50,000 <b>Mapping for Northern Ireland</b>. Use our handy <a href="/latlong.php">Lat/Long Convertor</a> to get the correct Grid Square for a picture.<br/><br/></li>
		
		<li><b>If you have a WGS84 latitude &amp; longitude coordinate</b>
		(e.g. from a GPS receiver, or from multimap site), then see our 
		<a href="/latlong.php">Lat/Long to Grid Reference Convertor</a><br/><br/></li>
		<li><b>For information on {external href="http://en.wikipedia.org/wiki/Grid_reference" text="Grid References"}</b> <br/>see 
		{external title="Guide to the National Grid" text="Interactive Guide to the National Grid in Great Britain" href="http://www.ordnancesurvey.co.uk/oswebsite/gi/nationalgrid/nghelp1.html"}.
		The {external href="http://en.wikipedia.org/wiki/Irish_national_grid_reference_system" text="Irish National Grid"} is very similar, but using a single letter prefix, 
		see <a href="/mapbrowse.php">Overview Map</a> for the layout of the squares.
		</li>
	</ul>


{else}
	<input type="hidden" name="gridsquare" value="{$gridsquare|escape:'html'}">
	<input type="hidden" name="eastings" value="{$eastings|escape:'html'}">
	<input type="hidden" name="northings" value="{$northings|escape:'html'}">
	
{/if}
{if $step > 2}
	<input type="hidden" name="gridreference" value="{$gridreference|escape:'html'}">
{/if}

{if $step eq 2}

	<h2>Submit Step 2 of 4 : Upload photo for {$gridref}</h2>
	{if $rastermap->enabled}
		<div style="float:left;width:50%;position:relative">
	{else}
		<div>
	{/if}
		{if $imagecount gt 0}
			<p style="color:#440000">We already have 
			{if $imagecount eq 1}an image{else}{$imagecount} images{/if} {if $totalimagecount && $totalimagecount > $imagecount} ({$totalimagecount} including hidden){/if} (preview shown below)
			uploaded for <a title="View Images for {$gridref} (opens in new window)" href="/gridref/{$gridref}" target="_blank">{$gridref}</a>, but you are welcome to upload 
			another one.</p>
		{else}
			<p style="color:#004400">Fantastic! We don't yet have an image for {$gridref}! {if $totalimagecount && $totalimagecount ne $imagecount} (but you have {$totalimagecount} hidden){/if}</p>
		{/if}


		<input type="hidden" name="MAX_FILE_SIZE" value="8192000" />
		<label for="jpeg">JPEG Image File</label>
		<input id="jpeg" name="jpeg" type="file" />
		{if $error}<br /><p style="color:#990000;font-weight:bold;">{$error}</p>{/if}
		<br />
		<p>You might like to check you've selected the correct square<br/> by
		viewing the Modern {getamap gridref="document.theForm.gridreference.value" text="OS Map"}</p>

		{if $reference_index == 2} 
		{external href="http://www.multimap.com/p/browse.cgi?scale=25000&lon=`$long`&lat=`$lat`&GridE=`$long`&GridN=`$lat`" text="multimap.com" title="multimap includes 1:50,000 mapping for Northern Ireland" target="_blank"} includes 1:50,000 mapping for Northern Ireland.
		{/if}
		
		<p><b>Grid References:</b> (optional)<br/><br/><label for="gridreference">Primary Photo Subject</label> <input id="gridreference" type="text" name="gridreference" value="{$gridreference|escape:'html'}" size="14" onkeyup="updateMapMarker(this,false)"/><img src="/templates/basic/img/crosshairs.gif" alt="Marks the Subject" width="16" height="16" style="opacity: .5; filter: alpha(opacity=50);"/></p>
	
		<p><label for="viewpoint_gridreference">Photographer Position</label> <input id="viewpoint_gridreference" type="text" name="viewpoint_gridreference" value="{$viewpoint_gridreference|escape:'html'}" size="14"  onkeyup="updateMapMarker(this,false)"/><img src="/templates/basic/img/camera.gif" alt="Marks the Photographer" width="16" height="16" style="opacity: .5; filter: alpha(opacity=50);"/><br/><small>Blank assumes very close to the subject</small></p>

		{if $rastermap->enabled}
		<p><small>TIP: drag the markers on the map<br/>to update these boxes</small></p>
		{/if}
		
		<p><label for="view_direction">View Direction</label> <small>(photographer facing)</small><br/>
		<select id="view_direction" name="view_direction" style="font-family:monospace">
			{foreach from=$dirs key=key item=value}
				<option value="{$key}"{if $key%45!=0} style="color:gray"{/if}{if $key==$view_direction} selected="selected"{/if}>{$value}</option>
			{/foreach}
		</select></p>
	</div>

	{if $rastermap->enabled}
		<div class="rastermap" style="width:45%;position:relative">
		<b>{$rastermap->getTitle($gridref)}</b><br/><br/>
		{$rastermap->getImageTag()}<br/>
		<span style="color:gray"><small>{$rastermap->getFootNote()}</small></span>
		</div>
		
		{$rastermap->getScriptTag()}
		{if $viewpoint_gridreference}
			{literal}
			<script type="text/javascript">
				document.body.onload = function () {
					updateMapMarker(document.theForm.viewpoint_gridreference,false);
				}
			</script>
			{/literal}
		{/if}
	{else} 
		<script type="text/javascript" src="/mapping.js"></script>
	{/if}

	

	<br/>
	<input type="submit" name="goback" value="&lt; Back"/> <input type="submit" name="upload" value="Next &gt;" onclick="{literal}if (checkGridReferences(this.form)) {return autoDisable(this);} else {return false}{/literal}"/>
	<br style="clear:right"/>

	{if $totalimagecount gt 0}
	<br/>
	<div style="background-color:#eeeeee; padding:10px;">
		<div><b>Latest {$shownimagecount} images for this square...</b></div>

	{foreach from=$images item=image}

	  <div class="photo33" style="float:left;width:150px; background-color:white"><a title="{$image->title|escape:'html'} by {$image->realname} - click to view full size image" href="/photo/{$image->gridimage_id}" target="_blank">{$image->getThumbnail(120,120,false,true)}</a>
	  <div class="caption"><a title="view full size image" href="/photo/{$image->gridimage_id}" target="_blank">{$image->title|escape:'html'}</a></div>
	  <div class="statuscaption">status:
		{if $image->ftf}first{/if}
		{if $image->moderation_status eq "accepted"}supplemental{else}{$image->moderation_status}{/if}
	  </div>
	  </div>		

	{/foreach}
	<br style="clear:both"/>
	
	{if $imagecount gt 6 || $shownimagecount == 6}
		<div>See <a href="/gridref/{$gridref}" target="_blank">all {$imagecount} images for {$gridref}</a> (opens in new window)</div>
	{/if}&nbsp;
	</div>
	
	{/if}	
{else}
	<input type="hidden" name="viewpoint_gridreference" value="{$viewpoint_gridreference|escape:'html'}">
	<input type="hidden" name="view_direction" value="{$view_direction|escape:'html'}">

{/if}

{if $step eq 3}

<h2>Submit Step 3 of 4 : Check photo</h2>

{if $errormsg}
<p style="color:#990000;font-weight:bold;">{$errormsg}</p>
{/if}

<p>
Below is a full-size preview of the image we will store for grid reference 
{$gridref}.<br/><br/>

<img src="{$preview_url}" width="{$preview_width}" height="{$preview_height}"/>
<br/><br/>

<div style="position:relative; background-color:#dddddd; padding-left:10px;padding-top:1px;padding-bottom:1px;">
<h3>Is the image a &quot;geograph&quot;?</h3>

<p><label for="user_status">Actually just make this image a supplemental:</label> <input type="checkbox" name="user_status" id="user_status" value="accepted" {if $user_status == "accepted"}checked="checked"{/if}/> (tick to apply)</p>

<p>If you're the first to submit a proper &quot;geograph&quot; for {$gridref}
you'll get a geograph point added to your profile and the warm glow that comes
with it. So what makes an image a genuine geograph?</p>
<ul>
<li>The image subject must be within grid square {getamap gridref=$gridref}, and ideally the photographer should be too.</li>
<li>You must clearly show at close range one of the main geographical features within the square</li>
<li>You should include a short description relating the image to the map square</li>
</ul>

<p>Good quality, visually appealing and historically relevant pictures (eg wide area views
covering many square kilometers) may also be accepted as supplemental images 
for {$gridref} provided they are accurately located, but may not qualify as geographs.</p>
</div>

<div style="float:right;position:relative;">
<img src="{$preview_url}" width="{$preview_width*0.5|string_format:"%d"}" height="{$preview_height*0.5|string_format:"%d"}" alt="low resolution reminder image"/>	
</div>

<p>If you like, you can provide more images or extra information (which
can be edited at any time) but to activate a square you need to be first to meet the
criteria above!</p>


<h3>Title and Comments</h3>
<p>Please provide a short title for the image, and any other comments about where
it was taken or other interesting geographical information. (<a href="/help/style" target="_blank">Open Style Guide</a>)</p>

<p><label for="title">Title</label> {if $error.title}
	<br/><span class="formerror">{$error.title}</span>
	{/if}<br/>
<input size="50" id="title" name="title" value="{$title|escape:'html'}" /></p>
 {if $place.distance}
 <p style="font-size:0.7em">Gazetteer info as will appear:<br/> <span style="color:silver;">{if $place.distance > 3}{$place.distance} km from{else}near to{/if} <b>{$place.full_name}</b><small><i>{if $place.adm1_name && $place.adm1_name != $place.reference_name}, {$place.adm1_name}{/if}, {$place.reference_name}</i></small></span></p>
 {/if}

<p style="clear:both"><label for="comment">Comment</label><br/>
<textarea id="comment" name="comment" rows="4" cols="80">{$comment|escape:'html'}</textarea></p>
<div style="font-size:0.7em">TIP: use <span style="color:blue">[[TQ7506]]</span> or <span style="color:blue">[[5463]]</span> to link 
to a Grid Square or another Image.<br/>For a weblink just enter directly like: <span style="color:blue">http://www.example.com</span></div>


<h3>Further Information</h3>

<script type="text/javascript" src="/categories.js.php"></script>
{literal}
<script type="text/javascript">
<!--
//rest loaded in geograph.js

function prePopulateImageclass() {
	setTimeout('populateImageclass()',500);
}

window.onload = prePopulateImageclass;
//-->
</script>
{/literal}

<p><label for="imageclass">Primary geographical category</label> {if $error.imageclass}
	<br/><span class="formerror">{$error.imageclass}</span>
	{/if}<br />	
	<select id="imageclass" name="imageclass" onchange="onChangeImageclass()">
		<option value="">--please select feature--</option>
		{if $imageclass}
			<option value="{$imageclass}" selected="selected">{$imageclass}</option>
		{/if}
		<option value="Other">Other...</option>
	</select>

<span id="otherblock">
	<label for="imageclassother">Please specify </label> 
	<input size="32" id="imageclassother" name="imageclassother" value="{$imageclassother|escape:'html'}" maxlength="32"/>
	</span></p>
	
	
	
	
<p><label>Date photo taken</label> {if $error.imagetaken}
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
	
	<br/><br/><span style="font-size:0.7em">(please provide as much detail as possible, if you only know the year or month then that's fine)</span></p>


<p>
<input type="hidden" name="upload_id" value="{$upload_id}"/>
<input type="hidden" name="savedata" value="1"/>
<input type="submit" name="goback" value="&lt; Back"/>
<input type="submit" name="next" value="Next &gt;"/></p>
{/if}

{if $step eq 4}
	<input type="hidden" name="upload_id" value="{$upload_id}"/>
	<input type="hidden" name="title" value="{$title|escape:'html'}"/>
	<input type="hidden" name="comment" value="{$comment|escape:'html'}"/>
	<input type="hidden" name="imageclass" value="{$imageclass|escape:'html'}"/>
	<input type="hidden" name="imagetaken" value="{$imagetaken|escape:'html'}"/>
	<input type="hidden" name="user_status" value="{$user_status|escape:'html'}"/>
	
	<h2>Submit Step 4 of 4 : Confirm image rights</h2>
		
	<p>
	Because we are an open project we want to ensure our content is licenced
	as openly as possible and so we ask that you adopt a {external title="Learn more about Creative Commons" href="http://creativecommons.org" text="Creative Commons"  target="_blank"}
	licence for your image.</p>
	
	<p>With a Creative Commons licence, you <b>keep your copyright</b> but allow 
	people to copy and distribute your work provided they <b>give you credit</b></p>
	
	<p>Since we want to ensure we can use your image to fund the running costs of
	this site, and allow us to create montages of grid images, we ask that you
	allow the following</p>
	
	<ul>
	<li>The right to use the image commercially</li>
	<li>The right to modify the image to create derivative works</li>
	</ul>
	
	<p>{external title="View licence" href="http://creativecommons.org/licenses/by-sa/2.0/" text="Here is the Commons Deed outlining the licence terms" target="_blank"}</p>
	
	
	<p>If you do
	not agree with these terms, click "I do not agree" and your upload will
	be abandoned.<br />
	<input style="width:200px" type="submit" name="abandon" value="I DO NOT AGREE"/>
	
	</p>


	<p>If you agree with these terms, click "I agree" and your image will be
	stored in grid square {$gridref}.<br />
	<input type="submit" name="goback3" value="&lt; Back"/>
	<input style="width:200px" type="submit" name="finalise" value="I AGREE &gt;" onclick="autoDisable(this)"/>
	</p>
	


{/if}

{if $step eq 5}
<h2>Submission Complete!</h2>
<p>Thank you very much - your photo has now been added to grid square 
<a title="Grid Reference {$gridref}" href="/gridref/{$gridref}">{$gridref}</a></p>
<p><a title="submit another photo" href="submit.php">Click here to submit a new photo...</a></p>
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

{/dynamic}
{include file="_std_end.tpl"}
