
{include file="_search_begin.tpl"}

{if $engine->resultCount}
	<script type="text/javascript" src="http://www.nearby.org.uk/geograph/mootools/mootools-1.2-core.js"></script>
	<script type="text/javascript" src="http://www.nearby.org.uk/geograph/mootools/mootools-1.2-more.js"></script>
	<link rel="stylesheet" type="text/css" href="http://www.nearby.org.uk/geograph/mootools/MooFlow.css" />
	<script type="text/javascript" src="http://www.nearby.org.uk/geograph/mootools/MooFlow.js"></script>

	<br/>( Page {$engine->pagesString()}) {if $engine->criteria->searchclass != 'Special'}[<a href="/search.php?i={$i}&amp;form=advanced">refine search</a>]{/if}
	</p>
	{if $nofirstmatch}
	<p style="font-size:0.8em">[We have no images for {$engine->criteria->searchq|escape:"html"}, <a href="/submit.php?gridreference={$engine->criteria->searchq|escape:"html"}">Submit Yours Now</a>]</p>
	{/if}
	{if $singlesquares}
	<p style="font-size:0.8em">[<a href="/squares.php?p={math equation="900*(y-1)+900-(x+1)" x=$engine->criteria->x y=$engine->criteria->y}&amp;distance={$singlesquare_radius}">{$singlesquares} squares within {$singlesquare_radius}km have no or only one photo</a> - can you <a href="/submit.php">add more</a>?]</p>
	{/if}
	
	
	<div id="MooFlow">
	{foreach from=$engine->results item=image}

	  <a href="/photo/{$image->gridimage_id}">{$image->getThumbnail(213,160,false,true)|replace:' alt=':' title='}</a>
	
	{foreachelse}
		{if $engine->resultCount}
			<p style="background:#dddddd;padding:20px;"><a href="/search.php?i={$i}{if $engine->temp_displayclass}&amp;displayclass={$engine->temp_displayclass}{/if}"><b>continue to results</b> &gt; &gt;</a></p>
		{/if}
	{/foreach}
	</div>
	<p>&middot; Double click center image to view full size</p>
	{literal}
	<script>
	window.addEvent('domready', function(){

		var mf = new MooFlow($('MooFlow'), {
			startIndex: 0,
			heightRatio: 0.5,
			factor: 82,
			useSlider: true,
			useAutoPlay: true,
			useCaption: true,
			useResize: true,
			useWindowResize: true,
			useMouseWheel: true,
			useKeyInput: true,
			'onClickView': function(mixedObject){
				window.open(mixedObject.href);
			}
		});

	});
	</script>
	{/literal}
	{if $engine->results}
	<p style="clear:both">Search took {$querytime|string_format:"%.2f"} secs, ( Page {$engine->pagesString()})
	{/if}
{else}
	{include file="_search_noresults.tpl"}
{/if}

{include file="_search_end.tpl"}
