{if $inner}
{assign var="page_title" value="Grid Ref Finder"}

{include file="_basic_begin.tpl"}
{else}

{assign var="page_title" value="Grid Ref Finder"}
{include file="_std_begin.tpl"}
{/if}

<script type="text/javascript" src="http://s0.{$http_host}/mapper/geotools2.js"></script>
<script type="text/javascript" src="http://s0.{$http_host}/mappingG.v{$javascript_version}.js"></script>
{literal}
	<script type="text/javascript">
	//<![CDATA[
		var issubmit = 1;
		var themarker;
		
		//the google map object
		var map;

		//the geocoder object
		var geocoder;
		var running = false;

		function showAddress(address) {
			if (!geocoder) {
				 geocoder = new GClientGeocoder();
			}
			if (geocoder) {
				geocoder.getLatLng(address,function(point) {
					if (!point) {
						alert("Your entry '" + address + "' could not be geocoded, please try again");
					} else {
						if (themarker) {
							themarker.setPoint(point);
							GEvent.trigger(themarker,'drag');

						} else {
							themarker = createMarker(point,null);
							map.addOverlay(themarker);

							GEvent.trigger(themarker,'drag');
						}
						map.setCenter(point, 12);
					}
				 });
			}
		}

		function loadmap() {
			if (GBrowserIsCompatible()) {
				map = new GMap2(document.getElementById("map"));

				G_NORMAL_MAP.getMinimumResolution = function () { return 5 };
				G_SATELLITE_MAP.getMinimumResolution = function () { return 5 };
				G_HYBRID_MAP.getMinimumResolution = function () { return 5 };

				map.addControl(new GLargeMapControl());
				map.addControl(new GMapTypeControl(true));
				
				var point = new GLatLng(54.55,-3.88);
				map.setCenter(point, 5);

				map.enableDoubleClickZoom(); 
				map.enableContinuousZoom();
				map.enableScrollWheelZoom();
		
				GEvent.addListener(map, "click", function(marker, point) {
					if (marker) {
					} else if (themarker) {
						themarker.setPoint(point);
						GEvent.trigger(themarker,'drag');
					
					} else {
						themarker = createMarker(point,null);
						map.addOverlay(themarker);
						
						GEvent.trigger(themarker,'drag');
					}
				});


				AttachEvent(window,'unload',GUnload,false);

				// Add a move listener to restrict the bounds range
				GEvent.addListener(map, "move", function() {
					checkBounds();
				});

				// The allowed region which the whole map must be within
				var allowedBounds = new GLatLngBounds(new GLatLng(49.4,-11.8), new GLatLng(61.8,4.1));

				// If the map position is out of range, move it back
				function checkBounds() {
					// Perform the check and return if OK
					if (allowedBounds.contains(map.getCenter())) {
					  return;
					}
					// It`s not OK, so find the nearest allowed point and move there
					var C = map.getCenter();
					var X = C.lng();
					var Y = C.lat();

					var AmaxX = allowedBounds.getNorthEast().lng();
					var AmaxY = allowedBounds.getNorthEast().lat();
					var AminX = allowedBounds.getSouthWest().lng();
					var AminY = allowedBounds.getSouthWest().lat();

					if (X < AminX) {X = AminX;}
					if (X > AmaxX) {X = AmaxX;}
					if (Y < AminY) {Y = AminY;}
					if (Y > AmaxY) {Y = AmaxY;}

					map.setCenter(new GLatLng(Y,X));

					// This Javascript Function is based on code provided by the
					// Blackpool Community Church Javascript Team
					// http://www.commchurch.freeserve.co.uk/   
					// http://econym.googlepages.com/index.htm
				}
			}
		}

		AttachEvent(window,'load',loadmap,false);

		function updateMapMarkers() {
			updateMapMarker(document.theForm.grid_reference,false,true);
		}
		AttachEvent(window,'load',updateMapMarkers,false);
	</script>
{/literal}

<p>Click on the map to create a point, pick it up and drag to move to better location...</p>

<form action="/submit.php" name="theForm" method="post" {if $inner} target="_top"{/if} style="background-color:#f0f0f0;padding:5px;margin-top:0px; border:1px solid #d0d0d0;">


<div style="width:600px; text-align:center;"><label for="grid_reference"><b style="color:#0018F8">Selected Grid Reference</b></label> <input id="grid_reference" type="text" name="grid_reference" value="{if $grid_reference}{$grid_reference|escape:'html'}{/if}" size="14" onkeyup="updateMapMarker(this,false)"/>

<input type="submit" value="Step 2 &gt; &gt;"/></div>

<div id="map" style="width:600px; height:500px;border:1px solid blue">Loading map...</div><br/>			

<div style="width:600px; text-align:right;"><label for="addressInput">Enter Address or Postcode: 
	<input type="text" size="50" id="addressInput" name="address" value="" />
	<input type="button" value="Find" onclick="showAddress(this.form.address.value)"/><small><small><br/>
	(Powered by the Google Maps API Geocoder)</small></small>
</div>

<input type="hidden" name="gridsquare" value=""/>
<input type="hidden" name="setpos" value=""/>

</form>

<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key={$google_maps_api_key}" type="text/javascript"></script>
			
{if $inner}
</body>
</html>
{else}
{include file="_std_end.tpl"}
{/if}