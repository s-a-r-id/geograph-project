</div>
</div>
<div id="nav_block" class="no_print">
 <div class="nav">
  <ul id="treemenu1" class="treeview">
    <li style="font-size:1.42em"><a accesskey="1" title="Home Page" href="/">Home</a></li>
    <li>View<ul rel="open">
     <li><a title="Find images" href="/search.php">Search</a><ul>
      <li><a title="Advanced image search" href="/search.php?form=text">Advanced</a></li>
     </ul></li>
     <li><a title="View map of all submissions" href="/mapbrowse.php">Map</a><ul>
      <li><a title="Depth Map" href="/mapbrowse.php?depth=1">Depth</a></li>
      <li><a title="Draggable Map" href="/mapper/">Draggable</a></li>
     </ul></li>
     <li><a title="Browse" href="/browse.php">Browse</a></li>
     <li><a title="Explore Images by Theme" href="/explore/">Explore</a><ul>
      <li><a href="/statistics/fully_geographed.php">Mosaics</a></li>
      <li><a href="/explore/routes.php">Routes</a></li>
      <li><a href="/explore/places/2/">Places</a></li>
      <li><a href="/explore/calendar.php">Calendar</a></li>
      <li><a href="/explore/searches.php">Featured</a></li>
     </ul></li>
     <li><a title="Content" href="/content/">Content</a></li>
     <li><a title="Activities" href="/activities/">Activities</a><ul>
      <li><a title="Play Games" href="/games/">Games</a> </li>
      <li><a title="Imagine the map in pictures" href="/help/imagine">Imagine</a></li>
     </ul></li>
    </ul></li>
    <li>Contribute<ul rel="open">
     <li><b><a title="Submit" href="/submit.php">Submit</a></b></li>
     <li><a title="Statistics" href="/numbers.php">Statistics</a><ul>
      <li><a title="More Stats" href="/statistics.php">More Stats</a></li>
      <li><a title="Credits" href="/credits/">Contributors</a></li>
     </ul></li>
     <li><a title="Leaderboard" href="/statistics/moversboard.php">Leaderboard</a></li>
     <li><a title="Content" href="/article/Content-on-Geograph">Content</a></li>
    </ul></li>
    <li>Interact<ul rel="open">
     <li><a title="Discuss" href="/discuss/">Discuss</a></li>
     {dynamic}{if $user->registered}
     <li><a title="Chat" href="/chat/">Chat</a> {if $irc_seen}<span style="color:gray">({$irc_seen} online)</span>{/if}</li>
     <li><a title="Find out about local Events" href="/events/">Events</a> <sup style="color:red">New!</sup></li>
     {/if}{/dynamic}
    </ul></li>
    <li>Export<ul>
     <li><a title="KML" href="/kml.php">Google Earth/Maps</a></li>
     <li><a title="Memory Map Exports" href="/memorymap.php">Memory Map</a></li>
     <li><a title="GPX Downloads" href="/gpx.php">GPX</a></li>
     <li style="font-size:0.9em;"><a title="API" href="/help/api">API</a></li>
    </ul></li>
    <li>Further Info<ul rel="open">
     <li><a title="FAQ" href="/faq.php">FAQ</a><ul>
      <li><a title="Geograph Documents" href="/content/?docs&amp;order=title">Documents</a></li>
     </ul></li>
     <li><a title="View More Pages" href="/help/more_pages">More Pages</a><ul>
      <li><a title="View All Pages" href="/help/sitemap">Sitemap</a></li>
     </ul></li>
     
     <li><a accesskey="9" title="Contact Us" href="/contact.php">Contact Us</a><ul>
      <li><a title="The Geograph Team" href="/admin/team.php">The Team</a></li>
      <li><a href="/help/credits" title="Who built this and how?">Credits</a></li>
     </ul></li>
    </ul></li>
  {dynamic}
  {if $is_mod || $is_admin || $is_tickmod}
    <li>Admin<ul rel="open">
     <li><a title="Admin Tools" href="/admin/">Admin Homepage</a></li>
     {if $is_mod}
     	<li><a title="Moderation new photo submissions" href="/admin/moderation.php">Moderation</a></li>
     {/if}
     {if $is_tickmod}
     	<li><a title="Trouble Tickets" href="/admin/tickets.php">Tickets</a> (<a href="/admin/tickets.php?sidebar=1" target="_search" title="Open in Sidebar, IE and Firefox Only">S</a>)</li>
     {/if}
     <li><a title="Finish Moderation for this session" href="/admin/moderation.php?abandon=1">Finish</a></li>
    </ul></li>
  {/if}
  {/dynamic}
  </ul> 
<div style="text-align:center; padding-top:15px; border-top: 2px solid black; margin-top: 15px;">sponsored by <br/> <br/>
<a title="Geograph sponsored by Ordnance Survey" href="http://www.ordnancesurvey.co.uk/oswebsite/education/"><img src="http://{$static_host}/templates/basic/img/sponsor_small.gif" width="125" height="31" alt="Ordnance Survey" style="padding:4px;"/></a></div>
{if $image && $image->collections}
	<h3 class="newstitle" style="padding-top:15px; border-top: 2px solid black; margin-top: 15px;">Collections: <sup style="color:red">new!</sup></h3>
	{assign var="lasttype" value="0"}
	{foreach from=$image->collections item=item}
		{if $lasttype != $item.type}
			<div class="newsheader">{$item.type|regex_replace:"/y$/":'ie'}s</div>
		{/if}
		<div class="newsbody">&middot; <a href="{$item.url}" title="{$item.type|escape:'html'}">{$item.title|escape:'html'}</a></div>
	{/foreach}
{/if}
{if $discuss}
	{foreach from=$discuss item=newsitem}
		<h3 class="newstitle" style="padding-top:15px; border-top: 2px solid black; margin-top: 15px;">{$newsitem.topic_title}</h3>
		<div class="newsbody">{$newsitem.post_text}</div>
		<div class="newsfooter">
		Posted by <a href="/profile/{$newsitem.user_id}">{$newsitem.realname}</a> on {$newsitem.topic_time|date_format:"%a, %e %b"}
		<a href="/discuss/index.php?action=vthread&amp;topic={$newsitem.topic_id}">({$newsitem.comments} {if $newsitem.comments eq 1}comment{else}comments{/if})</a>
		</div>
	{/foreach}
{/if}
{if $news}
	{foreach from=$news item=newsitem}
		<h3 class="newstitle" style="padding-top:15px; border-top: 2px solid black; margin-top: 15px;">{$newsitem.topic_title}</h3>
		<div class="newsbody">{$newsitem.post_text}</div>
		<div class="newsfooter">
		Posted by <a href="/profile/{$newsitem.user_id}">{$newsitem.realname}</a> on {$newsitem.topic_time|date_format:"%a, %e %b"}
		<a href="/discuss/index.php?action=vthread&amp;topic={$newsitem.topic_id}">({$newsitem.comments} {if $newsitem.comments eq 1}comment{else}comments{/if})</a>
		</div>
	{/foreach}
	{if $rss_url}
		<div style="padding-top:15px; border-top: 2px solid black; margin-top: 15px;">
		<a rel="alternate" type="application/rss+xml" title="RSS Feed" href="{$rss_url}" class="xml-rss">News RSS Feed</a>
		</div>
	{/if}
{/if}
  </div>
</div>
<div id="search_block" class="no_print">
  <div id="search">
    <div id="searchform">
    <form method="get" action="/search.php">
    <div id="searchfield"><label for="searchterm">Search</label> 
    <input type="hidden" name="form" value="simple"/>
    {dynamic}<input id="searchterm" type="text" name="q" value="{$searchq|escape:'html'}" size="10" title="Enter a Postcode, Grid Reference, Placename or a text search"/>{/dynamic}
    <input id="searchbutton" type="submit" name="go" value="Find"/></div>
    </form>
    </div>
  </div>
  <div id="login">
  {dynamic}
  {if $user->registered}
  	  Logged in as {$user->realname|escape:'html'}
  	  <span class="sep">|</span>
  	  <a title="Profile" href="/profile/{$user->user_id}">profile</a>
  	  <span class="sep">|</span>
  	  <a title="Log out" href="/logout.php">logout</a>
  {else}
	  You are not logged in
	  <a title="Already registered? Login in here" href="/login.php">login</a>
		<span class="sep">|</span>
	  <a title="Register to upload photos" href="/register.php">register</a>
  {/if}
  {/dynamic}
  </div>
</div>
{if $right_block}
	{include file=$right_block}
	<div class="content3" id="footer_block">
{else}
	<div class="content2" id="footer_block">
{/if}
  <div id="footer" class="no_print">
     <p style="color:#AAAABB;float:left">Page updated at {$smarty.now|date_format:"%H:%M"}</p>
   <p><a href="/help/sitemap" title="Listing of site pages">Sitemap</a>
       <span class="sep">|</span>
       <a href="/help/credits" title="Who built this and how?">Credits</a>
       <span class="sep">|</span>
       <a href="/help/terms" title="Terms and Conditions">Terms of use</a>
       <span class="sep">|</span>
       <a href="http://validator.w3.org/check/referer" title="check our xhtml standards compliance">XHTML</a>
       <span class="sep">|</span>
       <a href="http://jigsaw.w3.org/css-validator/validator?uri=http://{$static_host}/templates/basic/css/basic.css" title="check our css standards compliance">CSS</a>
    </p>
    <p style="color:#777788;">Hosting supported by 
    {external title="click to visit the Fubra website" href="http://www.fubra.com/" text="Fubra"}
    </p>
  </div>
</div>
</body>
</html>
