{assign var="page_title" value="Geograph Contributors"}
{include file="_std_begin.tpl"}

{if $where}
<div style="float:right">Switch to <a href="/credits.php?cloud&amp;where={$where}{if $whenname}&amp;when={$when}/{/if}">cloud version</a></div>
{else}
<div style="float:right">Switch to <a href="/credits.php?cloud{if $whenname}&amp;when={$when}{/if}">cloud version</a> or <a href="/statistics/breakdown.php?by=user{if $whenname}&amp;when={$when}{/if}">statistics version</a>.</div>
{/if}

<h2>Geograph British Isles Photographers <small>[{$user_count}]</small></h2>
{if $whenname}
	<h3>Submitting images March 2005 though {$whenname}</h3>
{/if}
{if $where}
	<h3>Submitting in {$where} Myriad</h3>
{/if}

<p class="wordnet" style="font-size:0.8em;line-height:1.4em" align="center"> 
{foreach from=$users key=user_id item=obj}
&nbsp;<a title="{$obj.nickname}, {$obj.images} images" {if $obj.images > 100} style="font-weight:bold"{/if} href="/profile/{$user_id}">{$obj.realname|replace:' ':'&middot;'}</a><small>&nbsp;[{$obj.images}]</small> &nbsp;
{/foreach} 
</p>
 		
{include file="_std_end.tpl"}
