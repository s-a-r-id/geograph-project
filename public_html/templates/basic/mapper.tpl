{assign var="page_title" value="Great Britain Map"}
{include file="_std_begin.tpl"}

<table>
	<tbody>
		<tr>
			<td>
<iframe src="/mapper/?inner&amp;t={$token}{if $extra}&amp;{$extra}{/if}" width="700" height="900" frameborder="0"></iframe>
			</td>
			<td>
<iframe src="/mapper/blank.html?" width="210" height="900" frameborder="1" name="browseframe"></iframe>
			</td>
		</tr>
	</tbody>
</table>

<hr/>
<p><b>Centisquare Depth Key</b>: <img src="/img/depthkey.png" width="400" height="20"/> (click <img src="/mapper/img/layer-switcher-maximize.png" width="18" height="18"/> to enable Centisquare Layer)<br/>
<small>NOTE: The centisquare coverage layer only includes photos plotted with 6figure grid-references or above, and only include Geograph Images.</small></p>



{include file="_std_end.tpl"}
