
{include file="_std_begin.tpl"}

<h2>Search Results</h2>
{dynamic}
<p>Your search for images<i>{$engine->criteria->searchdesc}</i>, returns 
{if $engine->islimited}
<b>{$engine->resultCount}</b> images
{else}
the following
{/if}:
{if $engine->resultCount}
	<br/>( Page {$engine->pagesString()}) [<a href="search.php?i={$i}&amp;form=advanced">refine search</a>]
	</p>

	{foreach from=$engine->results item=image}
	  <div style="clear:both">
		<div style="float:left; position: relative">
		<a title="{$image->title|escape:'html'} - click to view full size image" href="/photo/{$image->gridimage_id}">{$image->getThumbnail(120,120)}</a>
		</div>
	  <a title="view full size image" href="/photo/{$image->gridimage_id}">{$image->title|escape:'html'}</a>
	  by <a title="view user profile" href="/profile.php?u={$image->user_id}">{$image->realname}</a> <br/>
	  for square <a title="view page for {$image->grid_reference}" href="/gridref/{$image->grid_reference}">{$image->grid_reference}</a>

	  <i>{$image->dist_string}</i><br/><br/>
	  
	  {if $image->imageclass}<small>Category: {$image->imageclass}</small>{/if}
	</div>


	{/foreach}

	<p style="clear:both">( Page {$engine->pagesString()})
{/if}
[<a href="search.php?i={$i}&amp;form=advanced">refine search</a>]</p>
{/dynamic}		
{include file="_std_end.tpl"}
