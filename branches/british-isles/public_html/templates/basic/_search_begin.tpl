{include file="_std_begin.tpl"}

<div style="padding:10px;" class="searchresults">
{if $engine->resultCount}

<div style="float:right;position:relative; font-size:0.9em">
<form action="/search.php" method="get" style="display:inline">
<div>
Display: 
<input type="hidden" name="i" value="{$i}"/>
{if $engine->currentPage > 1}<input type="hidden" name="page" value="{$engine->currentPage}"/>{/if}
<select name="displayclass" size="1" onchange="this.form.submit()" style="font-size:0.9em"> 
	{html_options options=$displayclasses selected=$engine->criteria->displayclass}
</select>
{if $legacy}<input type="hidden" name="legacy" value="1"/>{/if}
<noscript>
<input type="submit" value="Update"/>
</noscript></div>
</form>

</div>
{/if}

{if $suggestions} 
	<div><b>Alternative suggestions:</b>
	<ul>
	{foreach from=$suggestions item=row}
		<li><b><a href="{if $row.link}{$row.link}{else}/search.php?i={$i}&amp;text={$row.query|escape:'url'}&amp;gridref={$row.gr}&amp;redo=1{/if}">{$row.query}{if $row.name} <i>near</i> {$row.name}{/if}</a></b>? {if $row.localities}<small style="font-size:0.7em">({$row.localities})</small>{/if}</li>
	{/foreach}
	</ul></div>
	<hr/>
{/if}

<h2>Search Results</h2>


<p>Your search{if !$engine->criteria->groupby} for images{/if}<i>{$engine->criteria->searchdesc|escape:"html"}</i>, returns 
{if $engine->pageOneOnly && $engine->resultCount == $engine->numberofimages}
	<acronym title="to keep server load under control, we delay calculating the total">many</acronym> {if $engine->criteria->groupby}groups{else}images{/if}
{elseif $engine->islimited}
	<b>{$engine->resultCount|number_format}</b> {if $engine->criteria->groupby}groups{else}images{/if}
{else}
	the following
{/if}:

{if $engine->error}
	<div style="padding:2px;border:1px solid red; text-align:center; background-color:pink;color:black;">
		Unfortunatly it doesn't appear the search was processed,<br/>
		this is most likly a invalid combination of search terms,<br/>
		but could also be a temporarlly issue so you could try again in a little while.<br/>
	</div>

{elseif $engine->fullText && $engine->nextLink}
	<div class="interestBox" style="border:1px solid pink;">
		You have reached the last page of results, this is due to the fact that the new search engine will only return at most {$engine->maxResults|number_format} results. However as your search is in a predictable sort order, you can <b><a href="{$engine->nextLink|escape:'html'}">Generate a new Search</a></b> that continues from this approximatly this page forward.
	</div>
	
{elseif $engine->fullText && $engine->numberOfPages eq $engine->currentPage && $engine->criteria->sphinx.compatible && $engine->criteria->sphinx.compatible_order && $engine->resultCount > $engine->maxResults}
	<div class="interestBox" style="border:1px solid pink;">
		You have reached the last page of results, this is due to the fact that the new search engine will only return at most {$engine->maxResults|number_format} results. However your search seems to be compatible with the legacy engine. You can <a href="/search.php?i={$i}&amp;legacy=true&amp;page={$engine->currentPage+1}">view the next page in Legacy Mode</a> to continue. <b>Note, searches will be slower.</b>
	</div>
	
{elseif $engine->fullText && (!$engine->criteria->sphinx.compatible || $engine->criteria->sphinx.no_legacy)}


{elseif strlen($engine->criteria->searchtext) && $engine->criteria->sphinx.impossible}
	<div style="padding:2px;border:1px solid gray; font-size:0.7em;text-align:center">You have dropped back into <a href="/help/search_new">legacy search mode</a>, the search options you have selected are not supported in the new search,<br/> you can try simplifing the choosen options to change mode.
	
	{if $engine->criteria->sphinx.no_legacy}
	<br/><br/>
		<b>However legacy is not able to support this query</b> - please <a href="/contact.php">let us know</a>.
	{elseif strpos($engine->criteria->searchtext,' ')}
	<br/><br/>
		Note: <b>The <a href="/help/search_new">text matching method</a> is different</b>. So the results might not be what you expect.
	{/if}
	</div>
{elseif $legacy && $engine->criteria->sphinx.no_legacy}
	<div style="padding:2px;border:1px solid red; text-align:center">
		This query is not supported in Legacy Mode, try in the <a href="/search.php?i={$i}"> new interface</a>
	</div>
{/if}

{if $engine->resultCount}
	<br/>( Page {$engine->pagesString()}) {if $engine->criteria->searchclass != 'Special'}[<a href="/search.php?i={$i}&amp;form=advanced">refine search</a>]{/if}
{/if}

	{if $engine->fullText && $engine->criteria->searchclass != 'Special'}
		[<a href="javascript:void(show_tree(101));" id="hide101">quick refine</a>]</p>
		<div class="interestBox" style="border:1px solid pink;display:none; " id="show101">
			<form action="{$script_name}" method="get">
				<div><label for="fq">New Keywords</label>: <input type="text" name="text" id="fq" size="30"{if $engine->criteria->searchtext} value="{$engine->criteria->searchtext|escape:'html'}"{/if}/>
				<input type="submit" value="Search"/>
				<input type="hidden" name="i" value="{$i}"/>
				<input type="hidden" name="redo" value="1"/>
				({newwin href="/article/Word-Searching-on-Geograph" text="Tips"}) - all other fields unchanged
				
				| <a href="javascript:void(hide_tree(101));">close</a></div>
			</form>
		</div>
	{else}
	</p>
	{/if}
	{if $nofirstmatch}
	<p style="font-size:0.8em">[We have no images for <a href="/gridref/{$engine->criteria->searchq|escape:"html"}">{$engine->criteria->searchq|escape:"html"}</a>, <a href="/submit.php?gridreference={$engine->criteria->searchq|escape:"url"}">Submit Yours Now</a>!]</p>
	{/if}
	{if $singlesquares}
	<p style="font-size:0.8em">[<a href="/squares.php?p={math equation="900*(y-1)+900-(x+1)" x=$engine->criteria->x y=$engine->criteria->y}&amp;distance={$singlesquare_radius}">{$singlesquares} squares within {$singlesquare_radius}km have no or only one photo</a> - can you <a href="/submit.php">add more</a>?]</p>
	{/if}