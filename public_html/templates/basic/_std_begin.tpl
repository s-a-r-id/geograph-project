<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
 "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"{if $rastermap->service == 'Google'} xmlns:v="urn:schemas-microsoft-com:vml"{/if} xml:lang="en" id="geograph">
<head>
{if $page_title}<title>{$page_title|escape:'html'} :: Geograph British Isles - photograph every grid square!</title>
{else}<title>Geograph British Isles - photograph every grid square!</title>{/if}
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
{if $meta_description}<meta name="description" content="{$meta_description|escape:'html'|truncate:240:"... more"}" />
{else}<meta name="description" content="Geograph British Isles is a web based project to collect and reference geographically representative images of every square kilometre of the British Isles."/>{/if}
{if $lat && $long}<meta name="ICBM" content="{$lat}, {$long}"/>{/if}
<meta name="DC.title" content="Geograph{if $page_title}:: {$page_title|escape:'html'}{/if}"/>
{$extra_meta}
<link rel="stylesheet" type="text/css" title="Monitor" href="/templates/basic/css/basic.v{$javascript_version}.css" media="screen" />
<link rel="shortcut icon" type="image/x-icon" href="/favicon.ico"/>
{if $image && $image->gridimage_id && $image->moderation_status ne 'rejected'}
<link rel="alternate" type="application/vnd.google-earth.kml+xml" href="/photo/{$image->gridimage_id}.kml"/>
{elseif $profile && $profile->user_id}
<link rel="alternate" type="application/rss+xml" title="Geograph RSS for {$profile->realname}" href="/feed/userid/{$profile->user_id}.rss"/>
<link rel="alternate" type="application/vnd.google-earth.kml+xml" href="/feed/userid/{$profile->user_id}.kml"/>
{elseif $engine && $engine->resultCount}
<link rel="alternate" type="application/rss+xml" title="Geograph RSS" href="/feed/results/{$i}{if $engine->currentPage > 1}/{$engine->currentPage}{/if}.rss"/>
<link rel="alternate" type="application/vnd.google-earth.kml+xml" href="/feed/results/{$i}{if $engine->currentPage > 1}/{$engine->currentPage}{/if}.kml"/>
{else}
<link rel="alternate" type="application/rss+xml" title="Geograph RSS" href="/feed/recent.rss"/>
{/if}
<link rel="search" type="application/opensearchdescription+xml" 
title="Geograph British Isles search" href="/stuff/osd.xml" />
<script type="text/javascript" src="/geograph.v{$javascript_version}.js"></script>
</head>

<body>

<div id="header_block">
  <div id="header">
    <h1 onclick="document.location='/';"><a title="Geograph home page" href="/">GeoGraph - photograph every grid square</a></h1>
  </div>
</div>

{if $right_block}
<div {if $maincontentclass}class="{$maincontentclass}"{else}class="content3"{/if} id="maincontent_block">
{else}
<div {if $maincontentclass}class="{$maincontentclass}"{else}class="content2"{/if} id="maincontent_block">
{/if}

<div id="maincontent">
