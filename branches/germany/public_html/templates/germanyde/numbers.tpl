{assign var="page_title" value="Aktueller Stand"}
{assign var="meta_description" value="Kurz�bersicht �ber den aktuellen Stand beim Fotografieren jedes Quadratkilometers Deutschlands."}
{assign var="right_block" value="_block_recent.tpl"}
{include file="_std_begin.tpl"}

<div style="position:relative; float:right">
	&lt; <a href="/statistics.php">Mehr Statistik</a> | <a href="/statistics/moversboard.php">Rangliste</a> &gt;
</div>

<h2>Geograph Deutschland</h2>

<div class="greenbar">{* for 33-66% coverage *}
	<div class="righttextbox">
		<b class="nowrap">{$stats.total|thousends}</b><br/>
		<br/>
	</div>
	<div class="redbar" style="width:{$stats.percentage}%;">
		<div class="righttextbox">
		{if $stats.percentage >= 50 }
			<b class="nowrap">{$stats.squares|thousends}</b> fotografierte Planquadrate<br/>
		{else}
			<br/>
		{/if}
			<br/>
		</div>
		<br style="clear:both"/>
	</div>
	<div class="lefttextbox">
		{if $stats.percentage >= 50 }
		<div class="innerlefttextbox">
		<br/>
		<b class="nowrap">{$stats.percentage}%</b>
		</div>
		<br/>
		<b class="nowrap">{$stats.percentage}%</b><br/>
		{else}
		<div class="innerlefttextbox">
		<b class="nowrap">{$stats.squares|thousends}</b> fotografierte Planquadrate<br/>
		<b class="nowrap">{$stats.percentage}%</b><br/>
		</div>
		<b class="nowrap">{$stats.squares|thousends}</b> fotografierte Planquadrate<br/>
		<b class="nowrap">{$stats.percentage}%</b><br/>
		{/if}
	</div>
	<br style="clear:both"/>
</div>
<br style="clear:both"/>
<div style="position:relative; width: 100%;">
	
	<div class="statsbox">
		<div> 
			<b class="nowrap">{$stats.users|thousends}</b><br/>
			Teilnehmer
		</div>
		<div> 
			<b class="nowrap">{$stats.points|thousends}</b><br/>
			vergebene Punkte
		</div>
		<div> 
			<b class="nowrap">{$stats.images|thousends}</b><br/>
			Bilder insgesamt
		</div>
		<div> 
			<b class="nowrap">{$stats.persquare}</b><br/>
			Bilder<br/>
			je Quadrat
		</div>
		<br style="clear:both"/>
	</div>

	<div class="recentbox">
		<h4>Zuletzt vervollst�ndigte<br/> 10km-Quadrate (<a href="/statistics/fully_geographed.php" title="Vollst�ndige 10km-Quadrate">alle anzeigen ...</a>)</h4>
		<div class="halvebox">
			{foreach from=$hectads key=id item=obj name="hectads"}
				<a title="Mosaik f�r {$obj.hectad_ref}, seit {$obj.completed}" href="/maplarge.php?t={$obj.largemap_token}">{$obj.hectad_ref}</a><br/>
				{if $smarty.foreach.hectads.iteration eq 5}
		</div><div class="halvebox">
				{/if}
			{/foreach}
		</div>
		<br style="clear:both"/>
	</div>
</div>

<small><br style="clear:both"/><br/></small>
<div class="finalboxframe">
	<div class="finalbox" style="width:{$stats.fewpercentage}%;">
		{if $stats.fewpercentage >= 50 }
		<b class="nowrap">{$stats.fewphotos|thousends}</b>
		 fotografierte<br/> Quadrate... <br/> 
		{else}
		<br/><br/>
		{/if}
	</div>
	<!--div class="finalbox2" style="width:{$stats.negfewpercentage}%;"-->
	<div class="finalbox2">
		{if $stats.fewpercentage >= 50 }
		... mit <b>weniger als 4 Fotos,<br/>
		<a href="/submit.php">wir freuen uns auf mehr!</a></b>
		{else}
		<b class="nowrap">{$stats.fewphotos|thousends}</b>
		 fotografierte Quadrate... <br/> 
		... mit <b>weniger als 4 Fotos,
		<a href="/submit.php">wir freuen uns auf mehr!</a></b>
		{/if}
	</div>
	<!--br style="clear:both"/-->
</div>

<small><br style="clear:both"/><br/></small>
<div class="linksbox">
<h3>Mehr Statistik</h3>
| <b><a href="/statistics.php">Mehr Zahlen...</a></b> | <a href="/statistics.php#more">Weitere Seiten...</a> | 
<a href="/statistics/moversboard.php">Rangliste</a> |
<a href="/statistics/pulse.php">Geograph-Puls</a> |
<a href="/statistics/estimate.php">Prognosen</a> |
   
</div>

<br style="clear:both"/>
&nbsp;

{include file="_std_end.tpl"}