{assign var="right_block" value="_block_recent.tpl"}
{include file="_std_begin.tpl"}
{literal}<style type="text/css">
.greenbar {
	position:relative; width:100%; background-color:#75FF65; border:1px solid blue; margin-bottom:10px; 
}
.redbar {
	position:relative; float:left; background-color:#FF0000; border-right:1px solid blue
}
.righttextbox {
	position:relative; float:right; text-align:right; color:#000066; padding-right: 5px; padding-top:10px; padding-bottom:10px
}
.greenbar .redbar .righttextbox {
	color: white;
}
.lefttextbox {
	position:relative; float:left; color:#000066; padding-left: 5px; padding-top:10px; padding-bottom:10px; 
}
.statsbox {
	position:relative; width:70%; float:left
}

.statsbox div {
	position:relative; width:150px; background-color:#000066; color:white; float:left; padding:10px; margin-right:20px; margin-bottom:20px; text-align:center
}
.recentbox {
	position:relative; width:25%; float:left; background-color:#dddddd; padding:10px;
}
.recentbox h4 {
	font-size:0.9em; text-align: center; margin-bottom:0px; margin-top:0px; 
}
.recentbox .halvebox {
	position:relative; width:45%; float:left; padding:3px;
}
.finalbox {
	position:relative; width:100%; background-color:#000066; color:white; float:left; text-align:center; padding-top:10px; padding-bottom:10px; line-height:1.5em; font-size:1.1em;
}
.finalbox A {
	color: red;
}
.linksbox {
	position:relative; width:100%; background-color:yellow; float:left; text-align:center; padding-top:10px; padding-bottom:10px;
}
.linksbox h3 {
	margin-top:0px; text-align: center; margin-bottom:0px;
}
</style>{/literal}

<div style="position:relative; float:right">
	&lt; <a href="/statistics.php">Old Statistics Page</a> &gt;
</div>

<h2>Geograph British Isles</h2>

<div class="greenbar">{* for 33-66% coverage *}
	<div class="righttextbox">
		Total <b class="nowrap">{$stats.total|thousends}</b> Squares<br/>
		<br/>
	</div>
	<div class="redbar" style="width:{$stats.percentage}%;">

		<div class="righttextbox">
			<b class="nowrap">{$stats.squares|thousends}</b> Squares<br/>
			<br/>
		</div>
		<br style="clear:both"/>
	</div>
	<div class="lefttextbox">
		<br/>
		<b class="nowrap">{$stats.percentage}%</b><br/>
	</div>
	<br style="clear:both"/>	
</div>
<br style="clear:both"/>
<div style="position:relative; width: 100%;">
	
	<div class="statsbox">
		<div> 
			<b class="nowrap">{$stats.users|thousends}</b><br/>
			contributors
		</div>
		<div> 
			<b class="nowrap">{$stats.images|thousends}</b><br/>
			images
		</div>
		<div> 
			<b class="nowrap">{$stats.points|thousends}</b><br/>
			points awarded
		</div>
		<div> 
			<b class="nowrap">{$stats.persquare}</b><br/>
			average images<br/>
			per square
		</div>
		<br style="clear:both"/>
	</div>

	<div class="recentbox">
		<h4>Recently completed hectads</h4>
		<div class="halvebox">
			{foreach from=$hectads key=id item=obj name="hectads"}
				<a title="View Mosaic for {$obj.hectad_ref}, completed {$obj.completed}" href="/maplarge.php?t={$obj.largemap_token}">{$obj.hectad_ref}</a><br/>
				{if $smarty.foreach.hectads.iteration eq 5}
		</div><div class="halvebox">
				{/if}
			{/foreach}
		</div>
		<br style="clear:both"/><br/>
		<h4><a href="/statistics/fully_geographed.php" title="Completed 10km x 10km squares">list all ...</a></h4>
	</div>
</div>

<br style="clear:both"/><br/>
<div style="position:relative; width:100%">
	<div class="finalbox"> 
		<b class="nowrap">{$stats.fewphotos|thousends}</b>
		 photographed squares</b> <br/> with
		 <b>fewer than 4 photos, <a href="/submit.php">add yours now!</a></b>
	</div>
</div>

<br style="clear:both;"/><br/>
<div class="linksbox">
<h3>Further Statistics</h3>
| <b><a href="/statistics.php">More Numbers...</a></b> | <a href="/statistics.php#more">More Pages...</a> | 
<a href="/statistics/pulse.php">Geograph Pulse</a> |
<a href="/statistics/estimate.php">Future Estimates</a> |
   
</div>

<br style="clear:both"/>
&nbsp;

{include file="_std_end.tpl"}
