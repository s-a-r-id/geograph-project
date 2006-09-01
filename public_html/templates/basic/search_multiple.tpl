
{include file="_std_begin.tpl"}

<h2>Please refine your Search</h2>
{dynamic}
<p>In your search for images<i>{$searchdesc}</i>.</p>

<p>We have found the following possible match{if count($criteria->matches) > 1}es{/if} for '{$criteria->searchq}':</p>

<form action="{$script_name}" method="post">

{foreach key=name item=value from=$post}
	{if $value && $name != 'placename' && $name != 'go'}
		<input type="hidden" name="{$name}" value="{$value|escape:'html'}">
	{/if}		
{/foreach}
<input type="hidden" name="old-{$multipleon}" value="{$criteria->searchq|escape:'html'}">
	
{foreach from=$criteria->matches item=match}
	<input type="radio" name="{$multipleon}" value="{$match.id}" id="match{$match.id}">
	<span style="width:75px;position:absolute;">{$match.gridref}</span>
	<label style="padding-left: 75px;" for="match{$match.id}"><b>{$match.full_name}</b><small><i>{if $match.adm1_name}, {$match.adm1_name}{/if}, {$references[$match.reference_index]}</i>
	<small>[{$match.dsg_name}]</small></small></label> <br/>
{/foreach}

{if $pos_realname}
<br/>
<input type="radio" name="{$multipleon}" value="user:{$pos_user_id}" id="douser">
<label for="douser"><i>Perform a search for pictures taken by '<a href="/profile.php?u={$pos_user_id}" title="profile for {$pos_realname}">{$pos_realname}</a>'</i></label> <br/>		
{/if}

<br/>
<input type="radio" name="{$multipleon}" value="text:{$criteria->searchq}" id="dotext">
<label for="dotext"><i>Perform a title search for '{$criteria->searchq}'</i></label> <br/>	
{if !preg_match('/\+$/',$criteria->searchq)}
<input type="radio" name="{$multipleon}" value="text:{$criteria->searchq}+" id="dotext2">
<label for="dotext2"><i>Perform a text search for '{$criteria->searchq}' in title and description</i></label> <br/>		
{/if}
{/dynamic}
<p><input type="submit" name="refine" value="Refine"> <input type="submit" value="Find &gt;"></p>

</form>	
{include file="_std_end.tpl"}
