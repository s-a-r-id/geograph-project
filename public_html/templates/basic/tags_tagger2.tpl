{assign var="page_title" value="Tagging Box"}
{include file="_basic_begin.tpl"}
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
<link href="/js/select2-3.3.2/select2.css" rel="stylesheet"/>
<script src="/js/select2-3.3.2/select2.js"></script>
<div style="position:fixed;top:200px;left:10px;border:1px solid red"></div>
<div style="padding:6px">
<style>{literal}
.tagPublic span,.tagPublic a.taglink {
	background-color:lightgreen !important;
}

.tagPrivate span,.tagPrivate a.taglink {
	background-color:pink !important;
}
.tagGeneral span,.tagGeneral a.taglink {
	background-color:yellow !important;
}
.interestBox .tag {
	margin-left:5px;
	white-space:nowrap;
}

{/literal}</style>


<form method="post" action="{$script_name}?gr={$gr|escape:'url'}&amp;upload_id={$upload_id|escape:'url'}&amp;gridimage_id={$gridimage_id}" style="background-color:#f0f0f0;" name="theForm">
	<div id="savebutton" style="float:right;display:none">
		<input type="submit" name="save" value="Save Changes" style="font-size:1.2em"/>
		<div id="autoSave" style="font-size:0.7em"></div>
	</div>

	{if $gridimage_id}<input type="hidden" name="gridimage_id" value="{$gridimage_id}" />{/if}
	{if $ids}<input type="hidden" name="ids" value="{$ids|escape:'html'}" />{/if}
	{if $gr}<input type="hidden" name="gr" value="{$gr|escape:'html'}" />{/if}

	<div style="float:right;"><a href="/article/Tags" title="Article about Tags" class="about" target="_blank">More about Tags</a></div>

	<div style="float:left;position:relative;width:610px;">
{dynamic}
		{if $topicstring}<input type="hidden" name="topicstring" value="{$topicstring|escape:'html'}" />{/if}
		<input type=hidden name="__newtag" id="__newtag" value="{$usedtext|escape:html}" size="50" style="width:600px"/>
{/dynamic}

		<div style="font-size:0.8em;padding-right:20px;padding-top:20px">

			&middot; To start a new tag, just type a comma or semicolon.<br/><br/>
			&middot; Tags are simple free-form keywords/short phrases used to describe the image.<br/><br/>
			&middot; Please add as many Tags as you need. Tags will help other people find your photo.<br/><br/>
			&middot; Tags should be singular, ie an image of a church should have the tag "church", not "churches"<br/> <small>&nbsp;&nbsp;(however if a photo is of multiple say fence posts, then the tag "fence post<b>s</b>" should be used).</small><br/><br/>
			&middot; To add a placename as a Tag, please prefix with "place:", eg "place:Croydon" - similarly could use "near:Tring".
		</div>

	</div>

	<div style="float:left;position:relative;font-size:0.9em;z-index:10000">
		<input type="radio" name="selector" value="alpha" id="sel_alpha"/> <label for="sel_alpha">All Tags - Alphabetical</label><br/>
		<input type="radio" name="selector" value="ranked" id="sel_ranked" checked/> <label for="sel_ranked">All Tags - Ranked</label><br/>
		<input type="radio" name="selector" value="selfrecent" id="sel_selfrecent"/> <label for="sel_selfrecent">Your Tags - Recently Used</label><br/>
		<input type="radio" name="selector" value="selfalpha" id="sel_selfalpha"/> <label for="sel_selfalpha">Your Tags - Alphabetical</label><br/>
		{dynamic}
		{if $topicstring}
			<input type="radio" name="selector" value="suggestions" id="sel_suggestions" checked/> <label for="sel_suggestions">Automatic suggestions</label><br/>
		{/if}{/dynamic}
		<input type="radio" name="selector" value="subject" id="sel_subject"/> <label for="sel_subject">Subject List</label><br/>
		<input type="radio" name="selector" value="top" id="sel_top"/> <label for="sel_top">Context List</label><br/>
		<input type="radio" name="selector" value="bucket" id="sel_bucket"/> <label for="sel_bucket">Bucket List</label><br/>
		<input type="radio" name="selector" value="categories" id="sel_categories"/> <label for="sel_categories">Your Category list</label><br/>

	</div>

</form>





<br style="clear:both"/>


{literal}

<script type="text/javascript">

$(function() {
	$('#__newtag').select2({
		multiple: true,
		separator: ';',
		placeholder: 'enter tags here',
		closeOnSelect: false,
		tokenSeparators: [',',';'],
		ajax: {
			quietMillis: 200,
			url: "/tags/tags.json.php",
			cache: true,
			jsonpCallback: 'tagsFunc',
			dataType: 'jsonp',
			data: function (term, page) {
				var mode =$("input[name=selector]:checked").val()
				if (mode == 'suggestions' && $("input[name=topicstring]").val().length > 0) {
					return {
						mode: mode,
						term: '', //send a empty string to help with caching
						string: $("input[name=topicstring]").val()
					};
				}
				if (mode == 'selfrecent') { //tofix temp patch, because CANT search selfrecent yet?
					return {
						mode: mode,
						term: ''
					};
				}
				return {
					mode: mode,
					term: term, // search term
					page: page
				};
			},
			results: function (data, page) { // parse the results into the format expected by Select2.
				var more = (data.length == 60 && (page*60) < 1000);
				var results = [];
				$.each(data, function(){
					results.push({id: this, text: this });
				});
				return {results: results, more: more};
			}
		},
		createSearchChoice: function (term) {
			var mode =$("input[name=selector]:checked").val()
			if (mode == 'subject' || mode == 'top' || mode == 'bucket' || mode == 'categories')
				return false;
			return {id: term, text: term};
		},
		initSelection: function (element, callback) {
			var data = [];
			$(element.val().split(/;/)).each(function () {
				data.push({id: this, text: this});
			});
			callback(data);
		}
	}).on('change', function (e) {
		console.log(e.val,e.added,e.removed);
		if (e.added) {
			submitTag(e.added.text, 2);
		} else if (e.removed) {
			submitTag(e.removed.text, 0);
		}
	});


	$("input[name=selector]").click(function() {
		$('#__newtag').select2('close');
		$('#__newtag').select2('open');
	});

});


	function submitTag(tag,status) {
		var data = new Object;
		data['tag'] = tag;
		data['status'] = status;

		var form= document.forms['theForm'];
		if (form.gridimage_id)
			data['gridimage_id'] = form.gridimage_id.value;
		if (form.ids)
			data['ids'] = form.ids.value;

		$.ajax({
			url: "/tags/tagger.json.php",
			data: data
		});
	}

</script>
{/literal}

</div>
</body>
</html>
