{include file="_std_begin.tpl"}
<script src="{"/sorttable.js"|revision}"></script>

{dynamic}
{if $credit_realname}
	<div class="interestBox" style="background-color:pink; color:black; border:2px solid red; padding:10px;">
	<img src="/templates/basic/img/icon_alert.gif" alt="Modify" width="50" height="44" align="left" style="margin-right:10px"/>
	The image you where viewing was contributed by the user below, but is specifically credited to <b>{$credit_realname|escape:'html'}</b>
	</div>
	<br/><br/>
{/if}
{/dynamic}

{if $overview}
  <div style="float:right; width:{$overview_width+30}px; position:relative">
  {include file="_overview.tpl"}
  </div>
{/if}

<h2><a name="top"></a>Profile for {$profile->realname|escape:'html'}</h2>

{if $profile->role}
	<div style="margin-top:0px;border-top:1px solid red; border-bottom:1px solid red; color:purple; padding: 4px;"><b>Geograph Role</b>: {$profile->role}</div>
{else}
	{if strpos($profile->rights,'admin') > 0}
		<div style="margin-top:0px;border-top:1px solid red; border-bottom:1px solid red; color:purple; padding: 4px;"><b>Geograph Role</b>: Developer</div>
	{else}
		{if strpos($profile->rights,'moderator') > 0}
			<div style="margin-top:0px;border-top:1px solid red; border-bottom:1px solid red; color:purple; padding: 4px;"><b>Geograph Role</b>: Moderator</div>
		{/if}
	{/if}
{/if}

<ul>
	<li><b>Name</b>: {$profile->realname|escape:'html'}</li>

	<li><b>Nickname</b>: 
		{if $profile->nickname}
			{$profile->nickname|escape:'html'} 
		{else}
			<i>n/a</i>
		{/if}
	</li>

	<li><b>Website</b>: 
		{if $profile->website}
			{external href=$profile->website}
		{else}
			<i>n/a</i>
		{/if}
	</li>
 
	{if $user->user_id ne $profile->user_id}
		{if $profile->public_email eq 1}
			<li><b>Email</b>: {mailto address=$profile->email encode="javascript"}</li>
		{/if}
		<li><a title="Contact {$profile->realname|escape:'html'}" href="/usermsg.php?to={$profile->user_id}">Send message to {$profile->realname|escape:'html'}</a></li>
	{else}
		<li><b>Email</b>: {mailto address=$profile->email encode="javascript"}
		{if $profile->public_email ne 1} <em>(not displayed to other users)</em>{/if}
		</li>
	{/if}

	{if $profile->grid_reference}
		<li><b>Home grid reference</b>: 
		<a href="/gridref/{$profile->grid_reference|escape:'html'}">{$profile->grid_reference|escape:'html'}</a>
	{/if}
	
	<li><b>Member since</b>: 
		{$profile->signup_date|date_format:"%B %Y"}
	</li>
</ul>

{if $profile->about_yourself && $profile->public_about}
	<div class="caption" style="background-color:#dddddd; padding:10px;">
	<h3 style="margin-top:0px;margin-bottom:0px">More about me</h3>
	{$profile->about_yourself|nl2br|GeographLinks:true}</div>
{/if}

{if $user->user_id eq $profile->user_id}
	<p><a href="/profile.php?edit=1">Edit your profile</a> if there's anything you'd like to change.</p> 	
{else}
	<br/><br/>
{/if}


{if $profile->stats.images gt 0}
 	<div style="background-color:#dddddd; padding:10px;">
		<div style="float:right; position:relative; margin-top:0px; font-size:0.7em">View Breakdown by <a href="/statistics/breakdown.php?by=status&u={$profile->user_id}" rel="nofollow">Classification</a>, <a href="/statistics/breakdown.php?by=takenyear&u={$profile->user_id}" rel="nofollow">Date Taken</a> or <a href="/statistics/breakdown.php?by=gridsq&u={$profile->user_id}" rel="nofollow">Myriad</a>(<a href="/help/squares" title="What is a Myriad?">?</a>).</div>
		<h3 style="margin-top:0px;margin-bottom:0px">My Statistics</h3>
		<ul>
			<li><b>{$profile->stats.points}</b> Geograph points (see <a title="Frequently Asked Questions" href="/faq.php#points">FAQ</a>)
			{if $user->user_id eq $profile->user_id && $profile->stats.points_rank > 0}
				<ul>
				<li>Overall Rank: <b>{$profile->stats.points_rank|ordinal}</b> {if $profile->stats.points_rank > 1}({$profile->stats.points_rise} more needed to reach {$profile->stats.points_rank-1|ordinal} position){/if}</li>
				</ul>
			{/if}</li>
			<li><b>{$profile->stats.geosquares}</b> Personal points (gridsquare{if $profile->stats.geosquares ne 1}s{/if} <i>geographed</i>)
			{if $user->user_id eq $profile->user_id && $profile->stats.geo_rank > 0}
				<ul>
				<li>Overall Rank: <b>{$profile->stats.geo_rank|ordinal}</b> {if $profile->stats.geo_rank > 1}({$profile->stats.geo_rise} more needed to reach {$profile->stats.geo_rank-1|ordinal} position){/if}</li>
				</ul>
			{/if}</li>
			
			
			<li><b>{$profile->stats.images}</b> photograph{if $profile->stats.images ne 1}s{/if} submitted
				{if $profile->stats.squares gt 0}<ul>
					<li><b>{$profile->stats.squares}</b> gridsquare{if $profile->stats.squares ne 1}s{/if} <i>photographed</i>,
					giving a depth score of <b>{$profile->stats.depth|string_format:"%.2f"}</b> (see <a title="Statistics - Frequently Asked Questions" href="/help/stats_faq">FAQ</a>)
					</li>
					{if $profile->stats.hectads > 1}
					<li>in <b>{$profile->stats.hectads}</b> different hectads and <b>{$profile->stats.myriads}</b> Myriads<a href="/help/squares">?</a>{if $profile->stats.days > 3}, taken on <b>{$profile->stats.days}</b> different days{/if}</li>
					{/if}
					
				</ul>{/if}
			</li>
		</ul>
		<div style="text-align:right;font-size:0.8em">Last updated: {$profile->stats.updated|date_format:"%H:%M"}</div>
	</div>
{else}
	<h3>My Statistics</h3>
	<ul>
		  <li>No photographs submitted</li>
	</ul>
{/if}

{if $profile->stats.images gt 0}
	<div style="float:right; position:relative; margin-top:0px; font-size:0.7em"><a href="/search.php?u={$profile->user_id}&amp;orderby=submitted&amp;reverse_order_ind=1">Find images by {$profile->realname|escape:'html'}</a> (<a href="/search.php?u={$profile->user_id}&amp;orderby=submitted&amp;reverse_order_ind=1&amp;displayclass=thumbs">Thumbnail Only</a>, <a href="/search.php?u={$profile->user_id}&amp;orderby=submitted&amp;reverse_order_ind=1&amp;displayclass=slide">Slide Show Mode</a>)</div>
	<h3 style="margin-bottom:0px">Photographs</h3>
	
	<p style="font-size:0.7em">Click column headers to sort in a different order</p>
	
	{if $limit}
		<p>Showing the latest {$limit} images, see <a href="/search.php?u={$profile->user_id}&amp;orderby=submitted&amp;reverse_order_ind=1&amp;displayclass=text&amp;resultsperpage=100">More</a></p>
	{/if}
	
	<table class="report sortable" id="photolist" style="font-size:8pt;">
	<thead><tr>
		<td><img title="Any grid square discussions?" src="/templates/basic/img/discuss.gif" width="10" height="10"> ?</td>
		<td>Grid Ref</td>
		<td>Title</td>
		<td sorted="desc">Submitted</td>
		<td>Classification</td>
	</tr></thead>
	<tbody>
	{foreach from=$userimages item=image}
		<tr>
		<td sortvalue="{$image->last_post}">{if $image->topic_id}<a title="View discussion - last updated {$image->last_post|date_format:"%a, %e %b %Y at %H:%M"}" href="/discuss/index.php?action=vthread&amp;forum={$image->forum_id}&amp;topic={$image->topic_id}" ><img src="/templates/basic/img/discuss.gif" width="10" height="10" alt="discussion indicator"></a>{/if}</td>
		<td sortvalue="{$image->grid_reference}"><a title="view full size image" href="/photo/{$image->gridimage_id}">{$image->grid_reference}</a></td>
		<td>{$image->title}</td>
		<td sortvalue="{$image->gridimage_id}" class="nowrap">{$image->submitted|date_format:"%a, %e %b %Y"}</td>
		<td class="nowrap">{if $image->moderation_status eq "accepted"}supplemental{else}{$image->moderation_status}{/if} {if $image->ftf}(first){/if}</td>
		</tr>
	{/foreach}
	</tbody></table>

	{if $limit}
		<p>Showing the latest {$limit} images, see <a href="/search.php?u={$profile->user_id}&amp;orderby=submitted&amp;reverse_order_ind=1&amp;displayclass=text&amp;resultsperpage=100">More</a></p>
	{/if}
	{if $profile->stats.images gt 100 && $limit == 100}
		{dynamic}
		{if $user->user_id eq $profile->user_id}
			<form method="get" action="/profile/{$profile->user_id}/more"><input type="submit" value="Show Longer Profile Page"/></form>
		{/if}
		{/dynamic}
	{/if}
	<h3 style="margin-bottom:0px">Explore My Images</h3>

	<ul>
		
		<li><b>Maps</b>: {if $profile->stats.images gt 10}<a href="/profile/{$profile->user_id}/map">Personalised Geograph Map</a> or {/if} Recent Photos on <a href="http://maps.google.co.uk/maps?q=http://{$http_host}/profile/{$profile->user_id}/feed/recent.kml&ie=UTF8&om=1">Google Maps</a></li>

		<li><b>Recent Images</b>: <a title="View images by {$profile->realname} in Google Earth" href="/search.php?u={$profile->user_id}&amp;orderby=submitted&amp;reverse_order_ind=1&amp;kml">as KML</a> or <a title="RSS Feed for images by {$profile->realname}" href="/profile/{$profile->user_id}/feed/recent.georss" class="xml-rss">RSS</a> or <a title="GPX file for images by {$profile->realname}" href="/profile/{$profile->user_id}/feed/recent.gpx" class="xml-gpx">GPX</a></li>
		{if $profile->stats.images gt 10}
			{dynamic}{if $user->registered}
				<li><b>Download</b>: 
					<a title="Comma Seperated Values - file for images by {$profile->realname}" href="/export.csv.php?u={$profile->user_id}&amp;supp=1{if $user->user_id eq $profile->user_id}&amp;taken=1{/if}">CSV</a>
					{if $user->user_id eq $profile->user_id},
						<a title="Excel 2003 XML - file for images by {$profile->realname}" href="/export.excel.xml.php?u={$profile->user_id}&amp;supp=1{if $user->user_id eq $profile->user_id}&amp;taken=1{/if}">XML<small> for Excel <b>2003</b></small></a>
					{/if} of all images</li>
			{/if}{/dynamic}
		{/if}
		{if $user->user_id eq $profile->user_id}
			<li><b>Change Requests</b>: <a href="/tickets.php">View Recent Tickets</a></li>
		{/if}
	</ul>
{/if}


<div align="right"><a href="#top">Back to Top</a></div>

{include file="_std_end.tpl"}
