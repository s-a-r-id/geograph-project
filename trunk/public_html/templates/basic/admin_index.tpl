{include file="_std_begin.tpl"}


<h2>Administrative Tools</h2>
<ul>
<li><a href="/admin/moderation.php">Moderate</a> new photo submissions</li>


<li><a title="Map Maker" href="/admin/mapmaker.php">Map Maker</a> is a simple tool for checking
the internal land/sea map</li>
  <li><a title="Server Stats" href="http://www.geograph.co.uk/logs/">Server Stats</a> - 
   check the server activity logs</li>
      
     
</ul>

{dynamic}
<h2>Basic Stats</h2>
<ul>
<li>Total registered users: {$users_total} ({$users_thisweek} new users in past 7 days)</li>
<li>{$users_pending} registrations awaiting email address confirmation</li>
<li>Total images: {$images_total} ({$images_thisweek} new image in past 7 days)</li>
<li>{$images_pending} images awaiting <a href="moderation.php">moderation</a></li>
</ul>
{/dynamic}    
    
{include file="_std_end.tpl"}
