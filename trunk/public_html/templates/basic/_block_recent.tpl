<div id="right_block">
<div class="nav">

{if $overview}

<h3>Overview Map</h3>
<div class="map" style="margin-left:20px;border:2px solid black; height:{$overview_height}px;width:{$overview_width}px">

<div class="inner" style="position:relative;top:0px;left:0px;width:{$overview_width}px;height:{$overview_height}px;">

{foreach from=$overview key=y item=maprow}
	<div>
	{foreach from=$maprow key=x item=mapcell}
	<a href="/mapbrowse.php?o={$token}&amp;i={$x}&amp;j={$y}&amp;center="><img 
	alt="Clickable map" ismap="ismap" title="Click to zoom in" src="{$mapcell->getImageUrl()}" width="{$mapcell->image_w}" height="{$mapcell->image_h}"/></a>
	{/foreach}
	</div>
{/foreach}
</div>

</div>


{/if}	


 {if $recentcount}
  
  	<h3>Recent Photos</h3>
  	
  	{foreach from=$recent item=image}
  
  	  <div style="text-align:center;padding-bottom:1em;">
  	  <a title="{$image->title|escape:'html'} - click to view full size image" href="/view.php?id={$image->gridimage_id}">{$image->getThumbnail(120,80)}</a>
  	  
  	  <div>
  	  <a title="view full size image" href="/view.php?id={$image->gridimage_id}">{$image->title|escape:'html'}</a>
  	  by <a title="view user profile" href="/profile.php?u={$image->user_id}">{$image->realname}</a>
	  for square <a title="view page for {$image->grid_reference}" href="/gridref/{$image->grid_reference}">{$image->grid_reference}</a>
	  
	  </div>
  	  
  	  </div>
  	  
  
  	{/foreach}
  
  {/if}
  
</div> 
</div>