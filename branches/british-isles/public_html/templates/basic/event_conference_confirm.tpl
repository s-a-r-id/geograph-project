{assign var="page_title" value="Geograph Conference"}
{include file="_std_begin.tpl"}


{dynamic}

<h2>Geograph Conference - 17th Feb 2010 in Southampton</h2>

{if $get}
<h3>Welcome {$Name|escape:'html'},</h3>
{/if}

{if $cancelled > 0}
	<p>Your registration has been cancelled. Please <a href="/contact.php">Contact Us</a> if you have any updates.</p>

	<p>If you would like to submit a testimony - please {external href="http://spreadsheets.google.com/viewform?formkey=dGVEQVZkaEZUNXE3cERkZXk3Y2RYQ3c6MA" text="do so here"}.</p>

{elseif $confirmed > 0}

	{if $Parking == 'Unknown'}
		
		<p>Please let us know if you are bringing a car, and need a parking space at the venue</p>
		
	{else}
		<h3>Your place at the conference has been confirmed - thank you!</h3>
	
		<p>We look forward to seeing you there! We will contact all confirmed registrants with more details shortly.</p>

		<p>Please bookmark this page (or save the initial email) - so can return to this page should circumstances change.</p>
	
		<div class="interestBox">
			&middot; <b><a href="http://www.geograph.org.uk/article/First-Geograph-Conference-17th-Feb-2010-in-Southampton">Article about the conference</a></b> (more to be added, but includes start/end time)
		</div>
	
	{/if}
	
	<br/><br/>
	<hr/>
	<blockquote><p><i>Details for your Conference Badge: (let us know via comments if want to change)</i><br/><br/>
		 <b>Full Name:</b> <tt>{$Name|escape:'html'} {$Last|escape:'html'}</tt><br/>
		 <b>Nickname:</b> <tt>{$Nickname|escape:'html'|default:'n/a'}</tt></p></blockquote>

	<hr/>
	<br/><br/>
	
	<form action="{$script_name}?action=confirm&amp;ident={$ident|escape:'html'}" method="post" class="interestBox">
		<input type="hidden" name="ident" value="{$ident|escape:'html'}"/>
	
		Optional Comments: <br/>
		<textarea name="comments" rows="5" cols="80"></textarea><br/><br/>
		
	
	{if $Parking == 'Unknown'}
		<b>Do you need parking?</b><br/>
		<input type="radio" name="Parking" value="Yes"/> Yes, I am driving and request a free parking space<br/>
		<input type="radio" name="Parking" value="No"/> No, I don't need a parking space<br/><br/><br/>
	{/if}
		
		
		<input type="submit" name="" value="Please update my registration" style="background-color:lightgreen"/>
		
		
		<br/><br/><br/><br/>
		<hr/>
		<br/><br/>
	
		<input type="submit" name="cancel" value="Please CANCEL my registration" style="background-color:pink"/> - click this if you are no longer able to attend (include a comment above)
	</form>
	
{else}
	<p>Please use this page to confirm your place at the conference. We will be using this list to reallocate places as required. </p>

	<blockquote><p><i>Details for your Conference Badge: (let us know via comments if want to change)</i><br/>
		 <b>Full Name:</b> <tt>{$Name|escape:'html'} {$Last|escape:'html'}</tt><br/>
		 <b>Nickname:</b> <tt>{$Nickname|escape:'html'|default:'n/a'}</tt></p></blockquote>

	<form action="{$script_name}?action=confirm&amp;ident={$ident|escape:'html'}" method="post" class="interestBox">
		<input type="hidden" name="ident" value="{$ident|escape:'html'}"/>
		
		{if $Speaking == 'Yes'}
			<input type="checkbox" name="Speaking" value="Yes" checked="checked"/> <b>Yes</b>, I am still interested in giving a short talk at the conference <small>(we will contact you seperately)</small><br/><hr/><br/>
		{/if}
		
		Additional Comments, if any: <br/>
		<textarea name="comments" rows="5" cols="80"></textarea><br/><br/>
		<input type="submit" name="confirm" value="Please CONFIRM my registration" style="background-color:lightgreen"/>
	
	<br/><br/><br/><br/>
	<hr/>
	<br/><br/>
	
		<input type="submit" name="cancel" value="Please CANCEL my registration" style="background-color:pink"/> - click this if you are no longer able to attend
	</form>

{/if}


{/dynamic}


{include file="_std_end.tpl"}

