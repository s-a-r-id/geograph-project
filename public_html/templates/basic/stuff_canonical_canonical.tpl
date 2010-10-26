{assign var="page_title" value="Canonical Categories"}
{include file="_std_begin.tpl"}
<script src="{"/sorttable.js"|revision}"></script>

<h2><a href="?">Canonical Category Mapping</a> :: List</h2>

<form method="post" action="{$script_name}?rename=2">
	<p>{$intro}</p>
	
	<p>Click a column header to resort the table</p>
	
	<table class="report sortable" id="events">
	<thead><tr>
		<td>&nbsp;</td>
		<td>Canonical Category</td>
		<td>Categories</td>
		<td>Suggestors</td>
	</tr></thead>
	<tbody>

	{if $list}
	{foreach from=$list item=item}
		<tr{if $item.users < 3} style="color:gray"{/if}>
			<td>{if !$item.canonical_old}<input type="checkbox" name="list[]" value="{$item.canonical|escape:"html"}"/>{/if}</td>
			<td>{$item.canonical|escape:"html"}</td>
			<td align="right">{$item.cats|thousends}</td>
			<td align="right">{$item.users|thousends}</td>
		</tr>
	{/foreach}
	{else}
		<tr><td colspan="2">- nothing to show -</td></tr>
	{/if}

	</tbody>

	</table>
	<br/><br/>
	<hr/>
	<p>Tick canonical category/ies you think could be renamed above, and click <input type="submit" name="submit" value="Continue with rename suggestion"/> <br/>
	(Items without a tickbox already have an active suggestion)</p>
</form>


<br/><br/>

<a href="?">Go Back</a>

<br/><br/>

{include file="_std_end.tpl"}
