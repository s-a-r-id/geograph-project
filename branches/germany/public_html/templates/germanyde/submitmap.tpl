{if $inner}
{assign var="page_title" value="Planquadrat-Suche"}

{include file="_basic_begin.tpl"}
{else}

{assign var="page_title" value="Planquadrat-Suche"}
{include file="_std_begin.tpl"}
{/if}

<script type="text/javascript" src="{"/mapper/geotools2.js"|revision}"></script>
<script type="text/javascript" src="{"/mappingG.js"|revision}"></script>
{literal}
	<script type="text/javascript">
	//<![CDATA[
		var issubmit = 1;
		var ri = -1;
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
						alert("Die Eingabe '" + address + "' konnte nicht bearbeitet werden, bitte nochmals versuchen");
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
				map.addMapType(G_PHYSICAL_MAP);

				G_PHYSICAL_MAP.getMinimumResolution = function () { return 5 };
				G_NORMAL_MAP.getMinimumResolution = function () { return 5 };
				G_SATELLITE_MAP.getMinimumResolution = function () { return 5 };
				G_HYBRID_MAP.getMinimumResolution = function () { return 5 };

				map.addControl(new GLargeMapControl());
				map.addControl(new GMapTypeControl(true));
				
				var point = new GLatLng(51, 10); //(54.55,-3.88);
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
				var allowedBounds = new GLatLngBounds(new GLatLng(45,2), new GLatLng(57,18));//(new GLatLng(49.4,-11.8), new GLatLng(61.8,4.1));

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

<p>Bitte Karte anklicken um einen verschiebbaren Marker zu erzeugen...</p>

<form {if $picasa}action="/puploader.php?inner"{else}action="/submit.php" {if $inner} target="_top"{/if}{/if}name="theForm" method="post" style="background-color:#f0f0f0;padding:5px;margin-top:0px; border:1px solid #d0d0d0;">


<div style="width:600px; text-align:center;"><label for="grid_reference"><b style="color:#0018F8">Aktuelle Koordinate</b></label> <input id="grid_reference" type="text" name="grid_reference" value="{if $grid_reference}{$grid_reference|escape:'html'}{/if}" size="14" onkeyup="updateMapMarker(this,false)"/>

<input type="submit" value="Schritt 2 &gt; &gt;"/></div>

<div id="map" style="width:600px; height:500px;border:1px solid blue">Karte wird geladen... (JavaScript n�tig)</div><br/>

<div style="width:600px; text-align:right;"><label for="addressInput">Adresse eingeben:
	<input type="text" size="50" id="addressInput" name="address" value="" />
	<input type="button" value="Suchen" onclick="showAddress(this.form.address.value)"/><small><small><br/>
	(�ber Google Maps API Geocoder)</small></small>
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