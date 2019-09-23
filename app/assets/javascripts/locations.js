var latLng = "";
var arrayFieldsNames = [];
var arrayFieldsXY = [];
var arrayFieldsArea = [];
var shapes = [];
var selectedShape;
var strFarmName;
var strFarmXY;
var arrayFieldsNames = [];
var arrayFieldsArea = [];
var arrayFieldsXY = [];
function initialize() {
    //put lables in hidden input controls
    //document.getElementById("bntDelete").value = document.getElementById("lblDelete").value;
    //latLng = document.getElementById("latlng").value

    document.getElementById("lblZoomToState").label = document.getElementById("lblZoomState").value;
    var tableId = '0IMZAFCwR-t7jZnVzaW9udGFibGVzOjIxMDIxNw';
    var locationColumn = 'State-County';
    var lat;
    var long;
    var zoomSize;
    if (document.getElementById("hdnLat").value == "" || document.getElementById("hdnLong").value == "") { lat = 39.10960; long = -96.5; zoomSize = 5; }
    else { lat = document.getElementById("hdnLat").value; long = document.getElementById("hdnLong").value; zoomSize = 10; }

    geocoder = new google.maps.Geocoder();
    //
    map = new google.maps.Map(document.getElementById('map'), {
        zoom: zoomSize,
        center: new google.maps.LatLng(lat, long),
        mapTypeId: google.maps.MapTypeId.HYBRID,
        mapTypeControl: true,
        navigationControl: true,
        scaleControl: true,
        overviewMapControl: true,
        fullscreenControl: true,
        zoomControl: true
    });
    infoWindow = new google.maps.InfoWindow({
        maxWidth: 520,
        styles: [{ "featureType": "water",
            "stylers": [{ "visibility": "on" }, { "color": "#000000" }, { "hue": "#000000"}]
        }]
    });
    //
    var polyOptions = {
        strokeWeight: 0,
        fillOpacity: 0.3,
        editable: true
    };
    // Creates a drawing manager attached to the map that allows the user to draw
    // markers, lines, and shapes. //google.maps.drawing.OverlayType.POLYGON
    drawingManager = new google.maps.drawing.DrawingManager({
        drawingMode: null,
        drawingControl: true,
        drawingControlOptions: {
            position: google.maps.ControlPosition.TOP_CENTER,
            drawingModes: [google.maps.drawing.OverlayType.POLYGON]
        },
        markerOptions: {
            draggable: true
        },
        polylineOptions: {
            editable: true
        },
        rectangleOptions: polyOptions,
        circleOptions: polyOptions,
        polygonOptions: polyOptions,
        map: map
    });
    //strDrawnAOI = '<%= @preDrawnAOI %>';
    strDrawnAOI=document.getElementById("preDrawnAOI").value;
    //document.getElementById("savedata").value = "";
    if (strDrawnAOI.indexOf('farm') != -1 || strDrawnAOI.indexOf('field') != -1) {
        drawPreSavedAOI(strDrawnAOI);
    }
    google.maps.event.addListener(drawingManager, 'overlaycomplete', function (e) {
        if (e.type != google.maps.drawing.OverlayType.MARKER) {
            // Switch back to non-drawing mode after drawing a shape.
            drawingManager.setDrawingMode(null);
            // Add an event listener that selects the newly-drawn shape when the user
            // mouses down on it.
            var newShape = e.overlay;
            shapes.push(newShape);
            newShape.type = e.type;

            if (document.getElementById("polyTypeFarm").checked) {
                newShape.content = "farm: ";
                var person = prompt('Please enter the ' + lblFarm.innerHTML + ' name:', lblFarm.innerHTML);
                if (person != null && person != "") {
                    newShape.content += person + ", ";
                    strFarmName = person;
                }
                else {
                    alert("Your did not specify " + lblFarm.innerHTML + " name! A default value will be assigned.");
                    person = "farm";
                    newShape.content += person + ", ";
                    strFarmName = person;
                }
            } else {
                newShape.content = "field: ";
                person = prompt("Please enter the " + lblField.innerHTML + " name:", lblField.innerHTML.concat(shapes.length - 1));
                if (person != null && person != "") {
                    newShape.content += person + ", ";
                    arrayFieldsNames.push(person);
                }
                else {
                    alert("You did not specify " + lblField.innerHTML + " name! A default value will be assigned.");
                    person = "field".concat(shapes.length - 1);
                    newShape.content += person + ", ";
                    arrayFieldsNames.push(person);
                }

                var areaPoly = google.maps.geometry.spherical.computeArea(newShape.getPath());
                newShape.content += "area: " + areaPoly + ", ";
                // a brand new polygon
                arrayFieldsArea.push(areaPoly);
                // if the user modifies polygon
                google.maps.event.addListener(newShape.getPath(), 'insert_at', function () {

                    //add a new point;
                    var strTempDeletePolyInfo = newShape.content;
                    var strTempInfo = strTempDeletePolyInfo.split(',');
                    var intIndex = strTempInfo[0].indexOf(":");
                    var strTempDeletePolyName = strTempInfo[0].substring(intIndex + 1).replace(/^\s+|\s+$/g, '');
                    for (var j = 0; j < arrayFieldsNames.length; j++) {
                        if (strTempDeletePolyName == arrayFieldsNames[j].replace(/^\s+|\s+$/g, '')) {
                            var areaPolyTemp = google.maps.geometry.spherical.computeArea(newShape.getPath());
                            arrayFieldsArea[j] = areaPolyTemp;
                        }
                    }
                });
                google.maps.event.addListener(newShape.getPath(), 'set_at', function () {

                    //modify at point;
                    var strTempDeletePolyInfo = newShape.content;
                    var strTempInfo = strTempDeletePolyInfo.split(',');
                    var intIndex = strTempInfo[0].indexOf(":");
                    var strTempDeletePolyName = strTempInfo[0].substring(intIndex + 1).replace(/^\s+|\s+$/g, '');
                    for (var j = 0; j < arrayFieldsNames.length; j++) {
                        if (strTempDeletePolyName == arrayFieldsNames[j].replace(/^\s+|\s+$/g, '')) {
                            var areaPolyTemp = google.maps.geometry.spherical.computeArea(newShape.getPath());
                            arrayFieldsArea[j] = areaPolyTemp;
                        }
                    }
                });
                google.maps.event.addListener(newShape.getPath(), 'remove_at', function () {
                    //remove a point;
                    var strTempDeletePolyInfo = newShape.content;
                    var strTempInfo = strTempDeletePolyInfo.split(',');
                    var intIndex = strTempInfo[0].indexOf(":");
                    var strTempDeletePolyName = strTempInfo[0].substring(intIndex + 1).replace(/^\s+|\s+$/g, '');
                    for (var j = 0; j < arrayFieldsNames.length; j++) {
                        if (strTempDeletePolyName == arrayFieldsNames[j].replace(/^\s+|\s+$/g, '')) {
                            var areaPolyTemp = google.maps.geometry.spherical.computeArea(newShape.getPath());
                            arrayFieldsArea[j] = areaPolyTemp;
                        }
                    }
                });
                SetLable(newShape, person);
            }
            strDrawnAOI += newShape.content;

            google.maps.event.addListener(newShape, 'click', function () {
                setSelection(newShape);
            });
            setSelection(newShape);
        }

    });
    // Clear the current selection when the drawing mode is changed, or when the
    // map is clicked.
    google.maps.event.addListener(drawingManager, 'drawingmode_changed', clearSelection);
    google.maps.event.addListener(map, 'click', clearSelection);
    google.maps.event.addDomListener(document.getElementById('bntDelete1'), 'click', deleteSelectedShape);
    google.maps.event.addDomListener(document.getElementById('bntInfo'), 'click', showSelectedShapeInfo);
    //google.maps.event.addDomListener(document.getElementById('savebutton'), 'click', saveSelectedShapeInfo);
    google.maps.event.addDomListener(window, 'load', initialize);
    findAddress("United States");
    //
    var inputLatLng = document.getElementById("Textlatlng").value;
    if (inputLatLng != "") {
        codeLatLng(inputLatLng);
        document.getElementById("Textlatlng").value = "";
    }
    var inputAddress = document.getElementById("TextAddress").value
    if (inputAddress != "") {
        codeAddress(inputAddress);
        document.getElementById("TextAddress").value = "";
    }

    if (strDrawnAOI != "") {
        document.getElementById("polyTypeFarm").checked = false;
        document.getElementById("polyTypeField").checked = true;
    }
    else {
        document.getElementById("polyTypeFarm").checked = true;
        document.getElementById("polyTypeField").checked = false;
    }

    var btnFieldClick = document.getElementById('polyTypeField');
    btnFieldClick.onclick = handlerFieldClick;

    var btnFarmClick = document.getElementById('polyTypeFarm');
    btnFarmClick.onclick = handlerFarmClick;

    if (boundsPreDraw != null) {
        map.fitBounds(boundsPreDraw);
    }
    //add counties
    var layer = new google.maps.FusionTablesLayer({
        query: {
            select: locationColumn,
            from: tableId
        },
        styles: [{
            polygonOptions: {
                fillColor: '#FFFFFF',
                fillOpacity: 0.01,
                strokeColor: '#FF0000',
                strokeWeight: 1
            }
        }],
        map: map
    });

    google.maps.event.addDomListener(document.getElementById('countyselect'),
    'change', function () {
        updateMap(layer, tableId, locationColumn);
    });
}

function drawPreSavedAOI(strDrawnAOI) {
    // parse the information when ready creating a table of information
    x = strDrawnAOI.split('field:');
    // extract the coordinates and store them in the array countyCoordinates
    for (i = 0; i < x.length; i++) {
        var arrayIfXY = x[i].split(', ');
        var newShape;
        var countyCoordinates = [];
        var points = [];
        var a;
        var n;
        var strTempName = "";
        if (arrayIfXY[0].indexOf('farm:') != -1) {
            //farm
            strFarmName = arrayIfXY[0].slice(6, arrayIfXY[0].length);
            strFarmXY = arrayIfXY[1];
            a = arrayIfXY[1].split(' ');
            for (var j = 0; j < a.length - 1; j++) {
                if (a[j] != "") {
                    var strCoor = a[j].split(',');
                    var Latit = parseFloat(strCoor[1]);
                    var Longit = parseFloat(strCoor[0]);
                    var ll = new google.maps.LatLng(Latit, Longit);
                    points.push(ll);
                }
            }
            newShape = new google.maps.Polygon({
                paths: points,
                strokeColor: '#FF0000',
                strokeOpacity: 0.8,
                strokeWeight: 1,
                fillColor: '#1E90FF',
                fillOpacity: 0.3
            });
            newShape.content = arrayIfXY[0] + ", ";
            boundsPreDraw = getBoundsForPoly(newShape);
            var polyCenter = strFarmXY.split(' ');
            inputStr = polyCenter[0];
            codeLatLngState(function (addr) {
                document.getElementById("StateAbbr").value = addr;
            });

            codeLatLngCountry(function (addr) {
                document.getElementById("CountryName").value = addr;
            });

            codeLatLngStateLong(function (addr) {
                document.getElementById("StateName").value = addr;
            });

            codeLatLngCounty(function (addr) {
                document.getElementById("CountyName").value = addr;
            });
        }
        else {
            //field
            arrayFieldsNames.push(arrayIfXY[0].slice(1, arrayIfXY[0].length));
            arrayFieldsXY.push(arrayIfXY[2]);
            a = arrayIfXY[2].trim().split(' ');
            for (var jfield = 0; jfield < a.length - 1; jfield++) {
                if (a[jfield] != "") {
                    var strCoorfield = a[jfield].split(',');
                    var fieldLatit = parseFloat(strCoorfield[1]);
                    var fieldLongit = parseFloat(strCoorfield[0]);
                    var fieldll = new google.maps.LatLng(fieldLatit, fieldLongit);
                    points.push(fieldll);
                }
            }
            newShape = new google.maps.Polygon({
                paths: points,
                strokeColor: '#FF0000',
                strokeOpacity: 0.8,
                strokeWeight: 1,
                fillColor: '#FF1493',
                fillOpacity: 0.3
            });
            var areaPolyTemp = google.maps.geometry.spherical.computeArea(newShape.getPath().getArray());
            arrayFieldsArea.push(areaPolyTemp);
            newShape.content = "field: ";
            newShape.content += arrayIfXY[0] + ", " + arrayIfXY[1] + ", ";
            SetLable(newShape, arrayIfXY[0].slice(1, arrayIfXY[0].length));
            //added to just have the field part of the map
            shapes.push(newShape);
            newShape.setMap(map);

            google.maps.event.addListener(newShape, 'click', function () {
                this.setEditable(true);
                setSelection(this);
            });
        }
    }
}

function getBoundsForPoly(poly) {
    var bounds = new google.maps.LatLngBounds;
    poly.getPath().forEach(function (latLng) {
        bounds.extend(latLng);
    });
    return bounds;
}

    function codeLatLngState(callback) {
    var latlngStr = inputStr.split(',', 2);
    var lat = parseFloat(latlngStr[1]);
    var lng = parseFloat(latlngStr[0]);
    var latlng = new google.maps.LatLng(lat, lng);
    if (geocoder) {
        geocoder.geocode({ 'latLng': latlng }, function (results, status) {
            if (status == google.maps.GeocoderStatus.OK) {
                if (results[0]) {
                    //break down the three dimensional array into simpler arrays
                    for (i = 0; i < results.length; ++i) {
                        var super_var1 = results[i].address_components;
                        for (j = 0; j < super_var1.length; ++j) {
                            var super_var2 = super_var1[j].types;
                            var strTempStateCounty = "";
                            for (k = 0; k < super_var2.length; ++k) {
                                //find State
                                if (results[0].formatted_address.indexOf("Puerto Rico") != -1) {
                                    if (super_var2[k] == "country") {
                                        //put the state abbreviation in the form
                                        callback(super_var1[j].short_name);
                                    }
                                }
                                else {
                                    if (super_var2[k] == "administrative_area_level_1") {
                                        //put the state abbreviation in the form
                                        callback(super_var1[j].short_name);
                                    }
                                }
                            }
                        }
                    }
                } else {
                    alert("No results found");
                }
            } else {
                alert("Geocoder failed due to: " + status);
            }
        });
    }
}

function codeLatLngCountry(callback) {
    var latlngStr = inputStr.split(',', 2);
    var lat = parseFloat(latlngStr[1]);
    var lng = parseFloat(latlngStr[0]);
    var latlng = new google.maps.LatLng(lat, lng);
    if (geocoder) {
        geocoder.geocode({ 'latLng': latlng }, function (results, status) {
            if (status == google.maps.GeocoderStatus.OK) {
                if (results[0]) {
                    //break down the three dimensional array into simpler arrays
                    for (i = 0; i < results.length; ++i) {
                        var super_var1 = results[i].address_components;
                        for (j = 0; j < super_var1.length; ++j) {
                            var super_var2 = super_var1[j].types;
                            var strTempStateCounty = "";
                            for (k = 0; k < super_var2.length; ++k) {
                                //find State
                                    if (super_var2[k] == "country") {
                                        //put the state abbreviation in the form
                                        callback(super_var1[j].long_name);
                                    }
                            }
                        }
                    }
                } else {
                    alert("No results found");
                }
            } else {
                alert("Geocoder failed due to: " + status);
            }
        });
    }
}

function codeLatLngStateLong(callback) {
    var latlngStr = inputStr.split(',', 2);
    var lat = parseFloat(latlngStr[1]);
    var lng = parseFloat(latlngStr[0]);
    var latlng = new google.maps.LatLng(lat, lng);
    if (geocoder) {
        geocoder.geocode({ 'latLng': latlng }, function (results, status) {
            if (status == google.maps.GeocoderStatus.OK) {
                if (results[0]) {
                    //break down the three dimensional array into simpler arrays
                    for (i = 0; i < results.length; ++i) {
                        var super_var1 = results[i].address_components;
                        for (j = 0; j < super_var1.length; ++j) {
                            var super_var2 = super_var1[j].types;
                            var strTempStateCounty = "";
                            for (k = 0; k < super_var2.length; ++k) {
                                //find State
                                if (results[0].formatted_address.indexOf("Puerto Rico") != -1) {
                                    if (super_var2[k] == "country") {
                                        //put the state abbreviation in the form
                                        callback(super_var1[j].long_name);
                                    }
                                }
                                else {
                                    if (super_var2[k] == "administrative_area_level_1") {
                                        //put the state abbreviation in the form
                                        callback(super_var1[j].long_name);
                                    }
                                }
                            }
                        }
                    }
                } else {
                    alert("No results found");
                }
            } else {
                alert("Geocoder failed due to: " + status);
            }
        });
    }
}

function codeLatLngCounty(callback) {
    var latlngStr = inputStr.split(',', 2);
    var lat = parseFloat(latlngStr[1]);
    var lng = parseFloat(latlngStr[0]);
    var latlng = new google.maps.LatLng(lat, lng);
    if (geocoder) {
        geocoder.geocode({ 'latLng': latlng }, function (results, status) {
            if (status == google.maps.GeocoderStatus.OK) {
                if (results[0]) {
                    //break down the three dimensional array into simpler arrays
                    for (i = 0; i < results.length; ++i) {
                        var super_var1 = results[i].address_components;
                        for (j = 0; j < super_var1.length; ++j) {
                            var super_var2 = super_var1[j].types;
                            var strTempStateCounty = "";
                            for (k = 0; k < super_var2.length; ++k) {
                                //find county
                                if (results[0].formatted_address.indexOf("Puerto Rico") != -1) {
                                    if (super_var2[k] == "administrative_area_level_1") {
                                        //put the state abbreviation in the form
                                        callback(super_var1[j].long_name);
                                    }
                                }
                                else {
                                    if (super_var2[k] == "administrative_area_level_2") {
                                        //put the county name in the form
                                        callback(super_var1[j].long_name);
                                    }
                                }
                            }
                        }
                    }
                } else {
                    alert("No results found");
                }
            } else {
                alert("Geocoder failed due to: " + status);
            }
        });
    }
}

function SetLable(shape, lable) {
    var regionsOptions;
    var regionLabel;
    var bounds = new google.maps.LatLngBounds();
    var i;
    var coordinates = shape.getPath().getArray();
    var totalLat = 0;
    var totalLong = 0;

    for (i = 0; i < coordinates.length; i++) {
        totalLat = totalLat + coordinates[i].lat();
        totalLong = totalLong + coordinates[i].lng();
    }
    totalLat = totalLat / coordinates.length;
    totalLong = totalLong / coordinates.length;
    var latLng = new google.maps.LatLng(totalLat, totalLong);

    regionsOptions = {
        content: lable,
        boxStyle: { textAlign: "left",
            fontSize: "14px",
            whiteSpace: "nowrap",
            lineHeight: "16px",
            fontWeight: "bold",
            fontFamily: "Tahoma",
            color: "white"
        },
        disableAutoPan: true,
        position: latLng,
        closeBoxURL: "",
        isHidden: false,
        pane: "floatPane",
        enableEventPropagation: true,
        boxClass: "regionLabel"
    };
    regionLabel = new InfoBox(regionsOptions);
    if (lable == "DeleteLabel") {
        regionsOptions = { content: "" };
        regionLabel.open(map)
    }   //regionLabel.setMap(null) }   //regionLabel.close(map);
    else { regionLabel.open(map); }
}

function clearSelection() {
    if (document.getElementById("polyTypeFarm").checked == false && document.getElementById("polyTypeField").checked == false && drawingManager.drawingMode != null) {
        alert('Please specify the Area of Interest type: ' + lblFarm.innerHTML + " or " + lblFiled.innerHTML + '?');
        document.getElementById("polyTypeFarm").checked = true;
    }
    if (strFarmName != null && document.getElementById("polyTypeFarm").checked == true && drawingManager.drawingMode != null) {
        if (strFarmName != "") {
            alert('Only one ' + lblFarm.innerHTML + ' can be selected.');
            document.getElementById("polyTypeField").checked = true;
        }
    }
    if (selectedShape) {
        selectedShape.setEditable(false);
        selectedShape = null;
    }
}

function deleteSelectedShape() {
    if (selectedShape) {
        selectedShape.setMap(null);
        // Find and remove item from an array
        var i = shapes.indexOf(selectedShape);
        if (i != -1) {
            shapes.splice(i, 1);
        }

        // Delete polygon's content
        var strTempDeletePolyInfo = selectedShape.content;
        var strTempInfo = strTempDeletePolyInfo.split(',');
        var intIndex = strTempInfo[0].indexOf(":");
        var strTempDeletePolyName = strTempInfo[0].substring(intIndex + 1).replace(/^\s+|\s+$/g, '');
        if (strTempDeletePolyName == strFarmName.replace(/^\s+|\s+$/g, '')) {
            strFarmName = "";
            strFarmXY = "";
            alert('You just deleted a ' + lblFarm.innerHTML);
        }
        else {
            for (var j = 0; j < arrayFieldsNames.length; j++) {
                if (strTempDeletePolyName == arrayFieldsNames[j].replace(/^\s+|\s+$/g, '')) {
                    arrayFieldsNames.splice(j, 1);
                    arrayFieldsArea.splice(j, 1);
                    arrayFieldsXY.splice(j, 1);
                    alert('You just deleted a ' + lblField.innerHTML);
                }
            }

        }

        if (shapes.length == 0) {
            document.getElementById("polyTypeFarm").checked = true;
        }

    }
}

function showSelectedShapeInfo() {
    if (selectedShape) {
        var strTempInfo = selectedShape.content.split(':');
        var intIndex = strTempInfo[1].indexOf(",");
        var strFiledName = strTempInfo[1].slice(1, intIndex);
        var bounds = new google.maps.LatLngBounds();
        var polyCenter = bounds.getCenter();
        inputStr = polyCenter.lat() + "," + polyCenter.lng();
        var myLatlng = new google.maps.LatLng(inputStr);

        var marker = new google.maps.Marker({
            position: myLatlng,
            labelContent: strFiledName,
            labelAnchor: new google.maps.Point(95, 20),
            labelClass: "labels",
            labelStyle: { opacity: 0.75 },
            zIndex: 999999,
            map: map
        })

        google.maps.event.addListener(selectedShape, 'click', function (e) {
            var content = "<div class='infowindow'>";
            content += lblField.innerHTML + "'s Name: " + strFiledName + "<br/>";
            content += "Current location's latitude is: " + e.latLng.lat() + ", ";
            content += "longitude is: " + e.latLng.lng() + "</div>";

            HandleInfoWindow(e.latLng, content);
        });
    }
}

function findAddress(address) {

    var addressStr = document.getElementById("stateselect")[document.getElementById("stateselect").selectedIndex].text;
    var stateAbr = document.getElementById("stateselect")[document.getElementById("stateselect").selectedIndex].value;
    var countiesAll = document.getElementById("countyselect");
    var state;
    var countiSelect = document.getElementById("countyselect");
    var i = 0;
    countiSelect.length = 0;
    for (var n = 0; n < countiesAll.length - 1; n++) {
        state = countiesAll[n].value.substring(0, 2);
        if (stateAbr == state || n == 0) {
            if (n == 0) { countiSelect.options[i] = new Option(document.getElementById("lblZoomCounty").value, ""); }
            else { countiSelect.options[i] = new Option(countiesAll[n].text, countiesAll[n].value); }
            i++;
            //                    countyselect.add(countiesAll[n]);
        }
    }
    if (countiSelect.length == 0) { return; }
    if (!address && (addressStr != ''))
        address = "State of " + addressStr;
    else
        address = addressStr;
    if ((address != '') && geocoder) {
        geocoder.geocode({ 'address': address }, function (results, status) {
            if (status == google.maps.GeocoderStatus.OK) {
                if (status != google.maps.GeocoderStatus.ZERO_RESULTS) {
                    if (results && results[0]
      && results[0].geometry && results[0].geometry.viewport)
                        map.fitBounds(results[0].geometry.viewport);
                } else {
                    alert("No results found");
                }
            } else {
                alert("Geocode was not successful for the following reason: " + status);
            }
        });
    }
}

function codeLatLng(inputLatLng) {
    var input;
    if (document.getElementById('latlng').value != "") {
        input = document.getElementById('latlng').value
    }
    else {
        input = inputLatLng;
    }
    document.getElementById("Textlatlng").value = input;
    var latlngStr = input.split(',', 2);
    var lat = parseFloat(latlngStr[0]);
    var lng = parseFloat(latlngStr[1]);
    var latlng = new google.maps.LatLng(lat, lng);
    geocoder.geocode({ 'latLng': latlng }, function (results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
            if (results[1]) {
                map.setCenter(results[1].geometry.location);
                map.setZoom(20);
                marker = new google.maps.Marker({
                    position: latlng,
                    map: map
                });
                infowindow.setContent(results[1].formatted_address);
                infowindow.open(map, marker);
            } else {
                alert('No results found');
            }
        } else {
            alert('Geocoder failed due to: ' + status);
        }
    });
}

function handlerFieldClick() {
    var btnFarmClick = document.getElementById('polyTypeFarm').style.display;
    if (strDrawnAOI == "" && btnFarmClick != 'none') {
        if (strFarmName == null) {
            alert('Please select a ' + lblFarm.innerHTML + ' first, then select the ' + lblField.innerHTML + 's.');
            document.getElementById("polyTypeFarm").checked = true;
        }
    }
    else {
        if (strFarmName == "" && btnFarmClick != 'none') {
            alert('Please select a ' + lblFarm.innerHTML + ' first, then select the ' + lblField.innerHTML + 's.');
            document.getElementById("polyTypeFarm").checked = true;
        }
    }
}

function handlerFarmClick() {
    if (strDrawnAOI != "") {
        if (strFarmName != "") {
            alert('Only one ' + lblFarm.innerHTML + ' is allowed.');
            document.getElementById("polyTypeField").checked = true;
        }
    }
}

function codeAddress(inputAddress) {
    var address;
    if (document.getElementById('address').value != "") {
        address = document.getElementById('address').value
    }
    else {
        address = inputAddress;
    }
    document.getElementById("TextAddress").value = address;
    geocoder.geocode({ 'address': address }, function (results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
            map.setCenter(results[0].geometry.location);
            map.setZoom(20);
            var marker = new google.maps.Marker({
                map: map,
                position: results[0].geometry.location
            });
        } else {
            alert('Geocode was not successful for the following reason: ' + status);
        }
    });
}

function setSelection(shape) {
    clearSelection();
    selectedShape = shape;
    shape.setEditable(true);
    if (shape.content.indexOf('farm:') == -1) {
        showSelectedShapeInfo();
    }

    if (document.getElementById("polyTypeField").checked) {
        google.maps.event.addListener(shape.getPath(), 'insert_at', function () {

            var strTempDeletePolyInfo = shape.content;
            var strTempInfo = strTempDeletePolyInfo.split(',');
            var intIndex = strTempInfo[0].indexOf(":");
            var strTempDeletePolyName = strTempInfo[0].substring(intIndex + 1).replace(/^\s+|\s+$/g, '');
            for (var j = 0; j < arrayFieldsNames.length; j++) {
                if (strTempDeletePolyName == arrayFieldsNames[j].replace(/^\s+|\s+$/g, '')) {
                    var areaPolyTemp = google.maps.geometry.spherical.computeArea(shape.getPath());
                    arrayFieldsArea[j] = areaPolyTemp;
                }
            }
        });
        google.maps.event.addListener(shape.getPath(), 'set_at', function () {

            var strTempDeletePolyInfo = shape.content;
            var strTempInfo = strTempDeletePolyInfo.split(',');
            var intIndex = strTempInfo[0].indexOf(":");
            var strTempDeletePolyName = strTempInfo[0].substring(intIndex + 1).replace(/^\s+|\s+$/g, '');
            for (var j = 0; j < arrayFieldsNames.length; j++) {
                if (strTempDeletePolyName == arrayFieldsNames[j].replace(/^\s+|\s+$/g, '')) {
                    var areaPolyTemp = google.maps.geometry.spherical.computeArea(shape.getPath());
                    arrayFieldsArea[j] = areaPolyTemp;
                }
            }
        });
        google.maps.event.addListener(shape.getPath(), 'remove_at', function () {
            var strTempDeletePolyInfo = shape.content;
            var strTempInfo = strTempDeletePolyInfo.split(',');
            var intIndex = strTempInfo[0].indexOf(":");
            var strTempDeletePolyName = strTempInfo[0].substring(intIndex + 1).replace(/^\s+|\s+$/g, '');
            for (var j = 0; j < arrayFieldsNames.length; j++) {
                if (strTempDeletePolyName == arrayFieldsNames[j].replace(/^\s+|\s+$/g, '')) {
                    var areaPolyTemp = google.maps.geometry.spherical.computeArea(shape.getPath());
                    arrayFieldsArea[j] = areaPolyTemp;
                }
            }
        });

    }
    if (shape.content.indexOf('farm') != -1) {
        var vertices = shape.getPath();
        inputStr = vertices.getAt(0).lng() + "," + vertices.getAt(0).lat();
        codeLatLngCountry(function (addr) {
            document.getElementById("CountryName").value = addr;
        });

        codeLatLngStateLong(function (addr) {
            document.getElementById("StateName").value = addr;
        });


        codeLatLngState(function (addr) {
            document.getElementById("StateAbbr").value = addr;
        });

        codeLatLngCounty(function (addr) {
            document.getElementById("CountyName").value = addr;
        });
        selectedShape.set('fillColor', '#1E90FF');
    } else {
        selectedShape.set('fillColor', '#FF1493');
    }
}

function HandleInfoWindow(latLng, content) {
    infoWindow.setContent(content);
    infoWindow.setPosition(latLng);
    infoWindow.open(map);
}

function submitSelection(type) {
    turnOffControls();
    arrayFieldsXY.length = 0;
    for (var n = 0; n < shapes.length; n++) {
        var shapesOne = shapes[n];
        if (shapesOne) {
            var vertices = shapesOne.getPath();
            var bounds = new google.maps.LatLngBounds();
            var polyCenter = bounds.getCenter();
            var strTempXY = "";
            document.getElementById("savedata").value += shapesOne.content;
            for (var i = 0; i < vertices.length; i++) {
                var xy = vertices.getAt(i);
                bounds.extend(xy);
                if (i == (vertices.length - 1)) {
                    document.getElementById("savedata").value +=
        xy.lng().toFixed(6) + "," + xy.lat().toFixed(6) + " ";
                    strTempXY += xy.lng().toFixed(6) + "," + xy.lat().toFixed(6) + " ";
                }
                else {
                    document.getElementById("savedata").value +=
        xy.lng().toFixed(6) + "," + xy.lat().toFixed(6) + " ";
                    strTempXY += xy.lng().toFixed(6) + "," + xy.lat().toFixed(6) + " ";
                }
            }
            if (shapesOne.content.indexOf("farm:") != -1) {

                strFarmXY = strTempXY;
            }
            else {
                if (arrayFieldsXY.indexOf(strTempXY) == -1) {
                    arrayFieldsXY.push(strTempXY);
                }
            }
        }
        document.getElementById("FarmName").value = strFarmName;
        document.getElementById("FarmXY").value = strFarmXY;
        document.getElementById("FieldsName").value = arrayFieldsNames;
        document.getElementById("FieldsXY").value = arrayFieldsXY;
        document.getElementById("FieldsArea").value = arrayFieldsArea;
    }
    if (strFarmName != '' && arrayFieldsNames.length > 0) {
        return true;
    }
    else {
        if (type == "CopyFarm") { return true; }
        if (strFarmXY != '' && arrayFieldsXY.length > 0) {
            alert('Please make sure the names of the ' + lblFarm.innerHTML + ' and ' + lblField.innerHTML + '(s) are already assigned.');
        }
        else {
            alert('Please select only one ' + lblFarm.innerHTML + ' and at least one' + lblField.innerHTML + '!');
        }
        return false;
    }
}

function turnOffControls() {
    document.getElementById("dvForm").style.display = "none";
    document.getElementById("map").style.display = "none";
    document.getElementById("dvWait").style.display = "";
}