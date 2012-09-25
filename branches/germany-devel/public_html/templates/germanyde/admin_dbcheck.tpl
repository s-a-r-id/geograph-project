{assign var="page_title" value="database check"}
{include file="_std_begin.tpl"}
{dynamic}

<h2><a title="Admin home page" href="/admin/index.php">Admin</a> :Database Check</h2>
<p>This tool will analyse the database tables for corruption at the
db server level, and also perform some application level sanity checks</p>

<form method="post" action="dbcheck.php">
	<input type="checkbox" checked="checked" name="dbtables" value="1" id="dbtables"/>
	<label for="dbtables">Check Database tables</label><br/>
	<input type="checkbox"                   name="anatables" value="1" id="anatables"/>
	<label for="anatables">Analyse Database tables</label><br/>
	<input type="checkbox"                   name="opttables" value="1" id="opttables"/>
	<label for="opttables">Optimise Database tables</label><br/>

	<input type="checkbox" checked="checked" name="gridsquares" value="1" id="gridsquares"/>
	<label for="gridsquares">Gridsquare Integrity Check</label><br/>
	<input type="checkbox" checked="checked" name="gridsquareperm" value="1" id="gridsquareperm"/>
	<label for="gridsquareperm">Check if permissions to submit photographs or geographs are correct</label><br/>
	<input type="checkbox"                   name="gridsquareperc" value="1" id="gridsquareperc"/>
	<label for="gridsquareperc">Check if land percentages are correct</label><br/>
	<input type="checkbox" checked="checked" name="fix" value="1" id="fix"/>
	<label for="fix">Fix problems if possible</label><br/>

	<input type="checkbox" checked="checked" name="geographs" value="1" id="geographs"/>
	<label for="geographs">check 1 geograph per square</label><br/>
	Table: <input type="radio" checked="checked" name="table" value="gridimage_search" id="table_gis"/>
	<label for="table_gis">gridimage_search</label> /<input type="radio" name="table" value="gridimage" id="table_gi"/>
	<label for="table_gi">gridimage</label><br/>

	<input type="submit" name="check" value="Perform Database Check"/>
</form>

{/dynamic}    
{include file="_std_end.tpl"}
