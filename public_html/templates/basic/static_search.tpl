{assign var="page_title" value="Searching by Text"}
{include file="_std_begin.tpl"}


<h2>Text <a href="/search.php">Search</a> Options</h2>

<ul>
 	<li><h3><i>Default</i></h3>
	<p>By default the geograph search just searches for the exact text you enter anywhere in the title, matching part words.</p></li>
</ul>

<p>Use any of the following features to refine your search:</p>

<ul>
	<li><h3>^Whole Word Matching</h3>
	<p>Enter a single word prefixed by caret: ^ to find images with that exact word in the title, example:</p>
	<tt style="border:1px solid gray;padding:10px">^bridge</tt>
	<p>would not match against Bridgewater. (can't be combined with boolean searches below)</p></li>

    
	<li><h3>Searching the Title, Description and Category+</h3>
	<p>End your search word with a plus: + to search all three fields, example:</p>
	<tt style="border:1px solid gray;padding:10px">bridge+</tt>
	<p>would match images with bridge in the title, in the comments, <b>or</b> in the 'Road Bridge' category (for example).</p></li>

    
	<li><h3>Advanced Boolean Searches</h3>
	<p>Can use the commands <tt>AND</tt>, <tt>OR</tt>, <tt>NOT</tt> (case is important, brackets optional), probably easiest to demonstrate with a few examples:</p>
	<ul>
    	<li style="padding:10px;"><tt style="border:1px solid gray;padding:10px">bridge AND river</tt></li>
    	<li style="padding:10px;"><tt style="border:1px solid gray;padding:10px">river OR stream</tt></li>
    	<li style="padding:10px;"><tt style="border:1px solid gray;padding:10px">road AND NOT bridge</tt>
    	<li style="padding:10px;"><tt style="border:1px solid gray;padding:10px">road OR motorway OR carriageway</tt></li>
    	<li style="padding:10px;"><tt style="border:1px solid gray;padding:10px">NOT bridge</tt></li>
    	<li style="padding:10px;"><tt style="border:1px solid gray;padding:10px">^train AND ^bridge+</tt></li>
    	<li style="padding:10px;"><tt style="border:1px solid gray;padding:10px">road OR motorway+</tt></li>
    	<li style="padding:10px;"><tt style="border:1px solid gray;padding:10px">road+ AND <span style="color:lightgrey">(</span>a OR motorway+<span style="color:lightgrey">)</span></tt> - brackets optional</li>
    	<li style="padding:10px;"><tt style="border:1px solid gray;padding:10px">(river AND crossing) OR bridge</tt> - brackets required</li>
    	</ul>
    	<br/>
    	* each term can be combined with either or both ^ and + symbols for very flexible searching!
   	</li>
</ul> 

    
<a name="question"></a>
<h3>I have a question, what should I do?</h3>
    <p>Please <a title="Contact Us" href="contact.php">Contact Us</a></p>
    
    
{include file="_std_end.tpl"}
