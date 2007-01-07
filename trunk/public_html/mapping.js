/**
 * $Project: GeoGraph $
 * $Id$
 * 
 * GeoGraph geographic photo archive project
 * This file copyright (C) 2005  Barry Hunter (geo@barryhunter.co.uk)
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */
 

 var IE = document.all?true:false;

if (IE) {
	document.body.ondragstart = function() {event.returnValue = false;};
	//mozilla based do this by returning false from onmousedown
}

// These arrays hold the valid 100km references
var GBGridLetters = new Array (2);

GBGridLetters[0] = ["SV", "SQ", "SL", "SF", "SA", "NV", "NQ", "NL", "NF", "NA", "HV", "HQ", "HL", "HF", "HA"];
GBGridLetters[1] = ["SW", "SR", "SM", "SG", "SB", "NW", "NR", "NM", "NG", "NB", "HW", "HR", "HM", "HG", "HB"];
GBGridLetters[2] = ["SX", "SS", "SN", "SH", "SC", "NX", "NS", "NN", "NH", "NC", "HX", "HS", "HN", "HH", "HC"];
GBGridLetters[3] = ["SY", "ST", "SO", "SJ", "SD", "NY", "NT", "NO", "NJ", "ND", "HY", "HT", "HO", "HJ", "HD"];
GBGridLetters[4] = ["SZ", "SU", "SP", "SK", "SE", "NZ", "NU", "NP", "NK", "NE", "HZ", "HU", "HP", "HK", "HE"];
GBGridLetters[5] = ["TV", "TQ", "TL", "TF", "TA", "OV", "OQ", "OL", "OF", "OA", "JV", "JQ", "JL", "JF", "JA"];
GBGridLetters[6] = ["TW", "TR", "TM", "TG", "TB", "OW", "OR", "OM", "OG", "OB", "JW", "JR", "JM", "JG", "JB"];
GBGridLetters[7] = ["TX", "TS", "TN", "TH", "TC", "OX", "OS", "ON", "OH", "OC", "JX", "JS", "JN", "JH", "JC"];
GBGridLetters[8] = ["TY", "TT", "TO", "TJ", "TD", "OY", "OT", "OO", "OJ", "OD", "JY", "JT", "JO", "JJ", "JD"];
GBGridLetters[9] = ["TZ", "TU", "TP", "TK", "TE", "OZ", "OU", "OP", "OK", "OE", "JZ", "JU", "JP", "JK", "JE"];

//if (mapb > 100) {
//	grlen = 3;
//	mult = 100;
//} else if (mapb > 50) {
	grlen = 4;
	mult = 10;
//} else {
//	grlen = 5;
//	mult = 1;
//}

var marker1left = 14;
var marker1top = 14;

var marker2left = 9;
var marker2top = 20;


var w2 = mapw / 2;
var h2 = maph / 2;

var ratw = (mapb / w2) * 1000;
var rath = (mapb / h2) * 1000;

var currentelement = null;

var eastings1 = 0;
var northings1 = 0;
var eastings2 = 0;
var northings2 = 0;


function overlayMouseUp(e) {
	if (currentelement != null) {
		if (currentelement.id == 'marker1') {
			if (document.theForm.grid_reference.value == "") {
				currentelement.style.left = (w2-marker1left)+'px';
				currentelement.style.top = (h2-marker1top)+'px';
			}
		} else if (currentelement.id == 'marker2') {
			if (document.theForm.photographer_gridref.value == "") {
				currentelement.style.left = (15 -marker2left) +'px';
				currentelement.style.top = (maph + 15 - marker2top)+'px';
			}
		}
	}
	currentelement = null;
}

function overlayHideMarkers(e) {
	if (IE) {
		tempX = event.offsetX;
		tempY = event.offsetY;
	} else {
		tempX = e.layerX
		tempY = e.layerY
	}
	
	var m1 = document.getElementById('marker1');
	
	m1left = parseInt(m1.style.left)+marker1left;
	m1top = parseInt(m1.style.top)+marker1top;
	found = false;
	if (Math.abs(tempX - m1left) < marker1left && Math.abs(tempY - m1top) < marker1top) {
		m1.style.display = 'none';
	} else {
		m1.style.display = displayMarker1?'':'none';
	}
	
	var m2 = document.getElementById('marker2');

	m2left = parseInt(m2.style.left)+marker2left;
	m2top = parseInt(m2.style.top)+marker2top;

	if (Math.abs(tempX - m2left) < marker2left && Math.abs(tempY - m2top) < marker2top) {
		m2.style.display = 'none';
	} else {
		m2.style.display = displayMarker2?'':'none';
	}
	
	return false;
}

function overlayMouseDown(e) {
	if (currentelement != null) {
		//huh why we here?
		return;
	}
	
	if (IE) {
		tempX = event.offsetX;
		tempY = event.offsetY;
	} else {
		tempX = e.layerX
		tempY = e.layerY
	}
	
	var m1 = document.getElementById('marker1');
	
	m1left = parseInt(m1.style.left)+marker1left;
	m1top = parseInt(m1.style.top)+marker1top;
	
	if (Math.abs(tempX - m1left) < marker1left && Math.abs(tempY - m1top) < marker1top) {
		currentelement = m1;
	} else {
		var m2 = document.getElementById('marker2');

		m2left = parseInt(m2.style.left)+marker2left;
		m2top = parseInt(m2.style.top)+marker2top;

		if (Math.abs(tempX - m2left) < marker2left && Math.abs(tempY - m2top) < marker2top) {
			currentelement = m2;
		}
	}
	
	return false;
}

function overlayMouseMove(e) {
	if (IE) {
		tempX = event.offsetX;
		tempY = event.offsetY;
	} else {
		tempX = e.layerX
		tempY = e.layerY
	}
	if (currentelement != null) {
		if (document.getElementById) {
			if (currentelement.id == 'marker1') {
				currentelement.style.left = (tempX - marker1left)+'px';
				currentelement.style.top = (tempY - marker1top)+'px';
			} else {
				currentelement.style.left = (tempX - marker2left)+'px';
				currentelement.style.top = (tempY - marker2top)+'px';
			}
		}
	}

	if (tempY > maph) {
		if (currentelement != null) {
			if (currentelement.id == 'marker1') {
				if (document.theForm.grid_reference)
					document.theForm.grid_reference.value = "";
			} else if (currentelement.id == 'marker2') {
				if (document.theForm.photographer_gridref)
					document.theForm.photographer_gridref.value = "";
			}
		}
		document.images['map'].alt = "";
		return;
	}

	tempX = tempX - w2;
	tempY = tempY - h2;
	
	var easting = cene + Math.round(tempX * ratw);
	var northing = cenn - Math.round(tempY * rath);

	var cenXhun = "00000" + (easting % 100000);
	var cenYhun = "00000" + (northing % 100000);
	cenXhun = cenXhun.substr(cenXhun.length - 5, grlen);
	cenYhun = cenYhun.substr(cenYhun.length - 5, grlen);

	var cenXblock = Math.floor(easting / 100000);
	var cenYblock = Math.floor(northing / 100000);

	if(cenXblock < 0 || cenYblock < 0 || cenXblock > 9 || cenYblock > 15) {
		if (currentelement != null) {
			if (currentelement.id == 'marker1') {
				eastings1 = 0;
				northings1 = 0;
				document.theForm.grid_reference.value = "-Invalid-";
			} else if (currentelement.id == 'marker2') {
				eastings2 = 0;
				northings2 = 0;
				document.theForm.photographer_gridref.value = "-Invalid-";
			}
		}
		document.images['map'].alt = "-Invalid Grid Ref-"
	} else {
		grstr = GBGridLetters[cenXblock][cenYblock] + cenXhun + cenYhun;
		if (currentelement != null) {
			if (currentelement.id == 'marker1') {
				eastings1 = easting;
				northings1 = northing;
				document.theForm.grid_reference.value = grstr;
			} else if (currentelement.id == 'marker2') {
				eastings2 = easting;
				northings2 = northing;
				document.theForm.photographer_gridref.value = grstr;
			} 
		}
		document.images['map'].alt = grstr;
	}
	if (currentelement != null) {
		updateViewDirection();
	}
}

function checkGridReferences(that_form) {
	if (!checkGridReference(that_form.grid_reference,true)) 
		return false;
	if (!checkGridReference(that_form.photographer_gridref,true)) 
		return false;
	return true;

} 

function checkGridReference(that,showmessage) {
	GridRef = /\b([a-zA-Z]{1,2}) ?(\d{2,5})[ \.]?(\d{2,5})\b/;
	ok = true;
	if (that.value.length > 0) {
		myArray = GridRef.exec(that.value); 
		if (myArray && myArray.length > 0) {
			numbers = myArray[2]+myArray[3];
			if (numbers.length == 0 || numbers.length % 2 != 0) {
				ok = false;
			}
		} else {
			ok = false;
		}
	}
	if (ok == false && showmessage) {
		if (that.name == 'grid_reference') {
			alert("please enter a valid subject grid reference");
		} else {
			alert("please enter a valid photographer grid reference");
		}
		that.focus();
	}
	return ok;
}

function updateMapMarker(that,showmessage,dontcalcdirection) {
	if (!checkGridReference(that,showmessage)) {
		return false;
	}
	if (!document.images['map']) {
		//we have no map! so we only wanted to check the GR
		return;
	}

	if (document.getElementById) {
		if (that.name == 'photographer_gridref') {
			currentelement = document.getElementById('marker2');
		} else {
			currentelement = document.getElementById('marker1');
		}
		gr = that.value;

		GridRef = /\b([a-zA-Z]{2}) ?(\d{2,5})[ \.]?(\d{2,5})\b/;

		if (gr.length > 5) {
			myArray = GridRef.exec(gr);
			letters = myArray[1];
			numbers = myArray[2]+myArray[3];
			if (numbers.length % 2 == 0) {
				halve = numbers.length /2;
				easting = numbers.substr(0, halve);
				northing = numbers.substr(halve, halve);

				var cenXhun = easting + "00000";
				var cenYhun = northing + "00000";
				cenXhun = cenXhun.substr(0, 5);
				cenYhun = cenYhun.substr(0, 5);

				var cenXblock = 0;
				letters = letters.toUpperCase();
				for(x=0;x<10;x++)
					for(y=0;y<15;y++)
						if (GBGridLetters[x][y] == letters) {
							cenXblock = x*100000;
							cenYblock = y*100000;
						}

				if (cenXblock > 0) {
					//we use parseFloat to avoid issues with 0 prefixed numbers!
					easting = parseInt(cenXblock) + parseFloat(cenXhun);
					northing = parseInt(cenYblock) + parseFloat(cenYhun);
					
					if (halve == 3) {
					//	easting = easting + 50;
					//	northing = northing + 50;
					}
					
					
					tempX = (easting - cene) / ratw;
					tempY = (cenn - northing) / rath;

					tempX = tempX + w2;
					tempY = tempY + h2;
					if (currentelement.id == 'marker2' && ( (tempX < 0) || (tempX > mapw) || (tempY < 0) || (tempY > maph) ) ) {
						currentelement.style.left = 5+'px';
						currentelement.style.top = (maph + 5)+'px';
						eastings2 = easting;
						northings2 = northing;
					} else {
						if (currentelement.id == 'marker1') {
							if (numbers.length == 4 && easting%1000 == 0 && northing%1000 == 0) {
								tempX = tempX + (mapw /4);
								tempY = tempY - (maph /4);
								eastings1 = easting + 500;
								northings1 = northing + 500;
							} else if (numbers.length == 6 && easting%100 == 0 && northing%100 == 0) {
								tempX = tempX + (mapw /40);
								tempY = tempY - (maph /40);
								eastings1 = easting + 50;
								northings1 = northing + 50;
							} else {
								eastings1 = easting;
								northings1 = northing;
							}
							currentelement.style.left = (tempX - marker1left)+'px';
							currentelement.style.top = (tempY - marker1top)+'px';
						} else if (currentelement.id == 'marker2') {
							if (numbers.length == 6 && easting%100 == 0 && northing%100 == 0) {
								tempX = tempX + (mapw /40);
								tempY = tempY - (maph /40);
								eastings2 = easting + 50;
								northings2 = northing + 50;
							} else {
								eastings2 = easting;
								northings2 = northing;
							}
							currentelement.style.left = (tempX - marker2left)+'px';
							currentelement.style.top = (tempY - marker2top)+'px';
						} 
					}
				}
			}
		}
	}
	currentelement = null;
	if (!dontcalcdirection)
		updateViewDirection();
}


function updateViewDirection() {
	if (eastings1 > 0 && eastings2 > 0) {
		
		distance = Math.sqrt( Math.pow(eastings1 - eastings2,2) + Math.pow(northings1 - northings2,2) );
	
		if (distance > 0) {
			realangle = Math.atan2( eastings1 - eastings2, northings1 - northings2 ) / (Math.PI/180);

			if (realangle < 0)
				realangle = realangle + 360.0;

			jump = 360.0/16.0;

			newangle = Math.floor(Math.round(realangle/jump)*jump);
			if (newangle == 360)
				newangle = 0;

			var ele = document.theForm.view_direction;
			for(q=0;q<ele.options.length;q++)
				if (ele.options[q].value == newangle)
					ele.selectedIndex = q;

			document.images['camicon'].src = "/templates/basic/img/camicon-"+newangle+".png";

		}
	}
}

function updateCamIcon() {
	if (!document.images['map']) {
		//we have no map!
		return;
	}
	ele = document.theForm.view_direction;
	realangle = ele.options[ele.selectedIndex].value;
	if (realangle == -1) {
		document.images['camicon'].src = "/templates/basic/img/camicon--1.png";
	} else {
		jump = 360.0/16.0;
		newangle = Math.floor(Math.round(realangle/jump)*jump);
		if (newangle == 360)
			newangle = 0;
		document.images['camicon'].src = "/templates/basic/img/camicon-"+newangle+".png";
	}
}