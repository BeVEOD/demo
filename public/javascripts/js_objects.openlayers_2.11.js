(function( window, undefined ) {



Control.openLayers_geolocalisation = function(id, model_sid, field_sid, areas_tab, opts) {
var id		= params.id;
var model_sid	= params.model_sid;
var field_sid	= params.field_sid;
var areas_tab	= params.areas;
var lon 	= params.lng;
var lat 	= params.lat;
var opts	= params.opts || options;

var select_layers = [];

/* Layers */
var layers_tab = [];
var wms_layer = new OpenLayers.Layer.WMS("OpenLayers WMS", "http://vmap0.tiles.osgeo.org/wms/vmap0?",
                                                 {layers: 'basic'});
layers_tab.push(wms_layer);

layers_tab.push(new OpenLayers.Layer.OSM("OpenLayers OSM"));

var points_layer = new OpenLayers.Layer.Vector("Display points", {
    styleMap: new OpenLayers.StyleMap({
        "default": new OpenLayers.Style(OpenLayers.Util.applyDefaults({
           // externalGraphic: "/images/OpenLayers/img_js/marker-green.png",
           // graphicOpacity: 1,
            //pointRadius: 10
        }, OpenLayers.Feature.Vector.style["default"])),
        "select": new OpenLayers.Style({
            pointRadius: 12
            //externalGraphic: "/images/OpenLayers/img_js/marker-blue.png"
        })
    })
});
layers_tab.push(points_layer);
var polygons_layer = new OpenLayers.Layer.Vector("Display polygons", {
  styleMap: new OpenLayers.StyleMap({
      "default": new OpenLayers.Style(OpenLayers.Util.applyDefaults({
          fillColor: "red",
          strokeColor: "gray",
          graphicName: "square",
          rotation: 45,
          pointRadius: 15
      }, OpenLayers.Feature.Vector.style["default"])),
      "select": new OpenLayers.Style(OpenLayers.Util.applyDefaults({
          graphicName: "square",
          rotation: 45,
          pointRadius: 15
      }, OpenLayers.Feature.Vector.style["select"]))
  })
});
layers_tab.push(polygons_layer);
select_layers.push(polygons_layer);
var markers_layer = new OpenLayers.Layer.Markers("Display markers");
layers_tab.push(markers_layer);

/* Creation of all areas */
Control.features = {};
for (var i = 0; i < areas_tab.length ; i ++) {
  var area = areas_tab[i];
  var rule = new OpenLayers.Rule({
      symbolizer: {
          fillColor:   area["fillColor"],
          strokeColor: area["fillColor"],
          fillOpacity: "0.5"
      }    
  });
  
  var layer = new OpenLayers.Layer.Vector(area["name"],
    { styleMap: new OpenLayers.StyleMap({"default": new OpenLayers.Style(null, {rules: [rule]}) }) });
  
  Control.features[area["name"]] = layer;
  select_layers.push(layer);
                                                
  layers_tab.push(Control.features[area["name"]]);
}


/* Init MAP options */
var my_opts = {
  div:    field_sid,
  layers: layers_tab,
  center: new OpenLayers.LonLat(opts.lon, opts.lat),
  zoom:   opts.zoom
}

if (opts.zoom_bar) {
  my_opts["controls"]      = [new OpenLayers.Control.PanZoomBar(), new OpenLayers.Control.Navigation()];
  my_opts["numZoomLevels"] = opts.zoom_bar_level;
}


/* Init variable that will containt map and markers */
// --> Control.maps = { field_sid : { "map" : map1, "markers" : marker1 }, field_sid2 { "map" : map2, "markers" : marker2 }}
if (typeof(Control.maps) == "undefined") {
  Control.maps = {}; 
}
        
/* Create MAP */
Control.maps[field_sid] = {};
Control.maps[field_sid]["map"] = new OpenLayers.Map(my_opts);


// Place the marker of "adress" input
if ((opts.disp_marker) && ((lon != 0) || (lat != 0))) { 
  
  feature = new OpenLayers.Feature(layers_tab, new OpenLayers.LonLat(lon, lat));
  Control.maps[field_sid]["markers"] = feature.createMarker();          
  markers_layer.addMarker(Control.maps[field_sid]["markers"]);

  Control.maps[field_sid]["markers"].events.register("mousedown", Control.maps[field_sid]["markers"], Control.maps["display_marker_information"]);
  
  // Control.maps[field_sid]["markers"] = new OpenLayers.Marker(new OpenLayers.LonLat(opts.lon, opts.lat));
  //Control.maps[field_sid]["markers"] = (new OpenLayers.Feature(markers_layer, new OpenLayers.LonLat(opts.lon, opts.lat))).createMarker();
  
  //markers_layer.addMarker(Control.maps[field_sid]["markers"]);
  //var draw_point new OpenLayers.Control.DrawFeature(vectors, OpenLayers.Handler.Point)
    
  //new OpenLayers.Geometry.Point(new OpenLayers.LonLat(opts.lon, opts.lat));

  //control.events.register("display marker information", Control.maps[field_sid]["markers"], Control.maps["display_marker_information"]); 
}

/* LOCATE ME */
var pulsate = function(feature) {
    var point  = feature.geometry.getCentroid(),
        bounds = feature.geometry.getBounds(),
        radius = Math.abs((bounds.right - bounds.left)/2),
        count  = 0,
        grow   = 'up';

    var resize = function(){
        if (count>16) {
            clearInterval(window.resizeInterval);
        }
        var interval = radius * 0.03;
        var ratio = interval/radius;
        switch(count) {
            case 4:
            case 12:
                grow = 'down'; break;
            case 8:
                grow = 'up'; break;
        }
        if (grow!=='up') {
            ratio = - Math.abs(ratio);
        }
        feature.geometry.resize(1+ratio, point);
        vector.drawFeature(feature);
        count++;
    };
    window.resizeInterval = window.setInterval(resize, 50, point, radius);
};

var geolocate = new OpenLayers.Control.Geolocate({
    bind: false,
    geolocationOptions: {
        enableHighAccuracy: false,
        maximumAge: 0,
        timeout: 7000
    }
});
Control.maps[field_sid]["map"].addControl(geolocate);

var firstGeolocation = true;
geolocate.events.register("locationupdated",geolocate,function(e) {
    vector.removeAllFeatures();
    var circle = new OpenLayers.Feature.Vector(
        OpenLayers.Geometry.Polygon.createRegularPolygon(
            new OpenLayers.Geometry.Point(e.point.x, e.point.y),
            e.position.coords.accuracy/2,
            40,
            0
        ),
        {}
    );
    vector.addFeatures([
        new OpenLayers.Feature.Vector(
            e.point,
            {},
            {
                graphicName: 'cross',
                strokeColor: '#f00',
                strokeWidth: 2,
                fillOpacity: 0,
                pointRadius: 10
            }
        ),
        circle
    ]);
    if (firstGeolocation) {
        Control.maps[field_sid]["map"].zoomToExtent(vector.getDataExtent());
        pulsate(circle);
        firstGeolocation = false;
        this.bind = true;
    }
});
geolocate.events.register("locationfailed",this,function() {
    OpenLayers.Console.log('Location detection failed');
});
$('#locate').click(function() {
    vector.removeAllFeatures();
    geolocate.deactivate();
    geolocate.watch = false;
    firstGeolocation = true;
    geolocate.activate();
});
//-- end : LOCATE ME


/* CONTROL */
// Let choose a kind of map
Control.maps[field_sid]["map"].addControl(new OpenLayers.Control.LayerSwitcher());

// Add position in bottom-right corner : coord_in_bottom
if (opts.coord_in_bottom) { Control.maps[field_sid]["map"].addControl(new OpenLayers.Control.MousePosition()); }

// Add a map in bottom-right corner : overview_map
if (opts.overview_map) { Control.maps[field_sid]["map"].addControl(new OpenLayers.Control.OverviewMap()) }

// Add distance in bottom-left : distance
if (opts.distance) { Control.maps[field_sid]["map"].addControl(new OpenLayers.Control.ScaleLine()) }


// Draw POLYGON and MARKUP
// initialisation var for draw polygon and draw markup
var draw_polygon;
var draw_point;
    
// Ability to draw POLYGON
if (opts.ability_add_polygon) { 
  draw_polygon = new OpenLayers.Control.DrawFeature(polygons_layer, OpenLayers.Handler.Polygon);
  Control.maps[field_sid]["map"].addControl(draw_polygon);
}

// Ability to draw MARKUP (POINT)
if (opts.ability_add_point) {
  draw_point = new OpenLayers.Control.DrawFeature(points_layer, OpenLayers.Handler.Point)
  Control.maps[field_sid]["map"].addControl(draw_point);
}

// Ability to draw MARKUP
/*
  
if (opts.ability_add_markup) {
  OpenLayers.Control.Click = OpenLayers.Class(OpenLayers.Control, {                
    defaultHandlerOptions: {
        'single': true,
        'double': false,
        'pixelTolerance': 0,
        'stopSingle': false,
        'stopDouble': false
    },
    
    initialize: function (options) {
        this.handlerOptions = OpenLayers.Util.extend({}, this.defaultHandlerOptions);
        OpenLayers.Control.prototype.initialize.apply(this, arguments);
        this.handler = new OpenLayers.Handler.Click(this, { 'click': this.trigger }, this.handlerOptions);
    },
    
    trigger: function (e) {  
      var lonlat  = Control.maps[field_sid]["map"].getLonLatFromViewPortPx(e.xy);
      var feature = new OpenLayers.Feature(osm_layer, new OpenLayers.LonLat(lonlat.lon, lonlat.lat));
      var marker  = feature.createMarker();       
      markers_layer.addMarker(marker);
  
      //marker.events.register("mousedown", marker, mousedown);
                                                               
       // // Set markup at the good position (with the bottom of the markup just under the mouse) 
       // e.xy.y = e.xy.y - 10;
       // var lonlat = map.getLonLatFromViewPortPx(e.xy);
       // var point  = new OpenLayers.Feature.Vector(new OpenLayers.Geometry.Point(lonlat.lon, lonlat.lat), { type: $('#select_color').val() });
       // //var point = new OpenLayers.Feature(new OpenLayers.Geometry.Point(lonlat.lon, lonlat.lat), {cls: "two"})
      
       // vector.addFeatures(point);
  
    }
  }); 
  draw_markup = new OpenLayers.Control.Click();
  Control.maps[field_sid]["map"].addControl(draw_markup);
}
*/

// Radio button event
$('#draw_none').change(function() {
  if ($('#draw_none').attr("checked") == "checked") {
    draw_polygon.deactivate();
    draw_point.deactivate();
  }
})
$('#draw_polygon').change(function() {
  if ($('#draw_polygon').attr("checked") == "checked") {
    draw_polygon.activate();
    draw_point.deactivate();
  }
})
/*
$('#draw_point').change(function() {
  if ($('#draw_point').attr("checked") == "checked") {
    draw_point.activate();
    draw_polygon.deactivate();
  }
})
*/
//-- end : Draw POLYGON and MARKUP

  
// Select a point or a polygon
var select = new OpenLayers.Control.SelectFeature(
  select_layers,
  {
    clickout:    true, 
    toggle:      false,                 
    multiple:    false, 
    hover:       false,
    multiple:    false                 
    //toggleKey:   "ctrlKey", // ctrl key removes from selection                      
    //multipleKey: "shiftKey" // shift key adds to selection
  }
);
Control.maps[field_sid]["map"].addControl(select);
select.activate();

var cur_feature = null;
var popup = null;
$.each(select_layers, function(index, value) {
  value.events.on({
    "featureselected": function(e) {
      cur_feature = e;
      popup = new OpenLayers.Popup.FramedCloud("chicken", 
                  e.feature.geometry.getBounds().getCenterLonLat(),
                  null,
                  "<div style=''>Direction générale : " + e.feature.attributes["AREA_DR_NAME"] +"<br>" +
                     "Directeur général : " + e.feature.attributes["AREA_DIRECTEUR_REGIONAL"] + "<br></div>",
                  null, true, function(evt) {
                      /*select.unselect(cur_feature);*/
                  });
      e.popup = popup;
      Control.maps[field_sid]["map"].addPopup(popup);
      $('#' + model_sid + '_0_nom').val(e.feature.id);
    },
    "featureunselected": function(e) {
      cur_feature = null;
      Control.maps[field_sid]["map"].removePopup(popup);
      //e.popup.destroy();
      e.popup = null;
      $('#' + model_sid + '_0_nom').val("");
    }
  });}
)
//-- end : Select a point or a polygon

// Save a point or a polygon

$('form').submit(function(){ //listen for submit event
        if (cur_feature != null) {
	        var bounds = {};
		$.each(cur_feature.feature.geometry.components[0].components, function(index, value) {
		    bounds[value.id] = { "x" : value.x, "y" : value.y };
		}); 
	        $('<input />').attr('type', 'hidden').attr('name', "bounds").attr('value', JSON.stringify(bounds)).appendTo('form');
	}
});


OpenLayers.Event.observe(document, "keydown", function(evt) {
    var handled = false;
    switch (evt.keyCode) {
        case 90: // z
            if (evt.metaKey || evt.ctrlKey) {
                draw_polygon.undo();
                handled = true;
            }
            break;
        case 89: // y
            if (evt.metaKey || evt.ctrlKey) {
                draw_polygon.redo();
                handled = true;
            }
            break;
        case 27: // esc
            draw_polygon.cancel();
            handled = true;
            break;
    }
    if (handled) {
        OpenLayers.Event.stop(evt);
    }
});


/*
$("form").submit( function () {
  	var bounds = {};
	$.each(cur_feature.feature.geometry.components[0].components, function(index, value) {
	    bounds[value.id] = { "x" : value.x, "y" : value.y };
	}); 
	$(this).bounds = bounds;
} );
*/


/*
$('#' + model_sid + '_0_record_button').click(function() {
  var bounds = {};
  $.each(cur_feature.feature.geometry.components[0].components, function(index, value) {
    bounds[value.id] = { "x" : value.x, "y" : value.y };
  }); 
  var area = { "area" : { "id" : cur_feature.feature.id, 
            "name" : $('#' + model_sid + '_0_nom').val(),
            "bounds" : bounds }};
  $.ajax({
    type: "PUT",
    data: area,
    url: "/regions/new_region/" + id
  })
}); 
*/



//-- end : Save a point or a polygon
  
/*
// Permiss scroll with mouse : scroll_navigation

if (opts.scroll_navigation) { map.addControl(new OpenLayers.Control.Navigation()) }
else { map }


//map.addControl(new OpenLayers.Control.KeyboardDefaults())
*/

},

Control.openLayers_create_popup = function(layer, elt) {
if (popup == null) {
  popup = new OpenLayers.Popup(elt.id + '_popup',
               new OpenLayers.LonLat(elt.lon, elt.lat),
               new OpenLayers.Size(100, 50),
               elt.informations,
               true);

  layer.map.addPopup(popup);
} else {
  popup.toggle();
}
OpenLayers.Event.stop(evt);


},

Control.map_init = function(id, options) {
if (!Control.maps) {
  Control.maps = {};
}
if (!Control.layers) {
  Control.layers = {};
}
var projWGS84 = new OpenLayers.Projection("EPSG:4326"); 
var opts = options || {};

// Controls
controls_tab = [new OpenLayers.Control.Navigation()];
if (opts.controls) {
  if (opts.controls.indexOf('mouse_position') >= 0) {
    controls_tab.push(new OpenLayers.Control.MousePosition({ displayProjection : new OpenLayers.Projection("EPSG:4326") }));
  }
  if (opts.controls.indexOf('layer_switcher') >= 0) {
    controls_tab.push(new OpenLayers.Control.LayerSwitcher());
  }
  if (opts.controls.indexOf('zoom_bar') >= 0) {
    controls_tab.push(new OpenLayers.Control.PanZoomBar());
  }
  if (opts.controls.indexOf('overview_map') >= 0) {
    controls_tab.push(new OpenLayers.Control.OverviewMap());
  }
  if (opts.controls.indexOf('scale_line') >= 0) { 
	controls_tab.push(new OpenLayers.Control.ScaleLine());
  }
}

var map_options = { controls: controls_tab };

if (opts.extent && opts.extent.length == 4) {
  var extent = new OpenLayers.Bounds();
  extent.bottom = opts.extent[0];
  extent.left   = opts.extent[1];
  extent.right  = opts.extent[2];
  extent.top    = opts.extent[3];
  map_options["restrictedExtent"] = extent;
  //map_options["maxExtent"] = extent;
}

var map = Control.maps[id] = new OpenLayers.Map(id, map_options);

var layer = new OpenLayers.Layer.OSM("OpenStreetMap");
map.addLayer(layer);

var style = {'default': {
   fillColor:   "${fillColor}", 
   strokeColor: "${strokeColor}",
   label: "${label}", 
   align: "cm",
   graphicName: "${graphicName}",
   labelXOffset: 50,
   labelYOffset: 15,
   strokeWidth:  1,
   fillOpacity:  0.4,
   pointRadius:  "${radius}",
   pointerEvents: "visiblePainted"
}}

style.hidden = {fillOpacity: 0,	strokeOpacity: 0, label:''}

var point_layer = Control.layers['point'] = new OpenLayers.Layer.Vector("Point", { styleMap: new OpenLayers.StyleMap(style) });
window.point = point_layer;

var multipoint_layer = Control.layers['multipoint'] = new OpenLayers.Layer.Vector("MultiPoint", { styleMap: new OpenLayers.StyleMap(style) });
window.multipoint = multipoint_layer;

map.addLayer(multipoint_layer);
map.addLayer(point_layer);

if (opts.center) {
  var lonLat = new OpenLayers.LonLat(opts.center[0] || 0, opts.center[1] || 45);
  if (map.getProjectionObject().projCode != 'EPSG:4326') { // not WGS 1984
    lonLat.transform(projWGS84, map.getProjectionObject())
  }
  map.setCenter(lonLat, opts.center[2] || 6);
}

select_layers = [point_layer];
select = new OpenLayers.Control.SelectFeature(select_layers, {clickout:true, toggle:false, multiple:false, hover:false, multiple:false});
point_layer.events.on({
	featureselected: function(evt) {
		var feature = evt.feature;
		if (!feature.data.infos_url) { return };
		var popup = new OpenLayers.Popup.FramedCloud("popup_infos", 
		          feature.geometry.getBounds().getCenterLonLat(),
		          null,
		          'Chargement...',
		          null, true, function(evt) { 
		             map.removePopup(this);
			   //  this.destroy();
		          });
		popup.handler = function(r) {
			this.setContentHTML(r.responseText);
			eval($(this.contentDiv).find('script').text());
			this.updateSize();
		}
		popup.request = OpenLayers.Request.GET({
				url: feature.data.infos_url, params:{ajax:1},
				callback: popup.handler, scope: popup});
		feature.popup = popup;
		map.addPopup(popup);
	},
	featureunselected: function(evt) {
		var feature = evt.feature;
		if (feature.popup) {
			map.removePopup(feature.popup);
			feature.popup.destroy();
			delete feature.popup;
		}
	}
});
map.addControl(select);
select.activate();


return map;
},

Control.add_layer = function(map_id, options) {
var map  = Control.maps[map_id];
var opts = options || {};
var projWGS84 = new OpenLayers.Projection("EPSG:4326"); 

if (!opts.style) {
  opts.style = {
                   fillColor:   "${fillColor}", 
                   strokeColor: "${strokeColor}",
                   label: "${label}", 
                   align: "cm",
		   graphicName: 'circle',
                   labelXOffset: 50,
                   labelYOffset: 15,
                   strokeWidth:  1,
                   fillOpacity:  0.4,
                   pointRadius:  "${radius}",
                   pointerEvents: "visiblePainted",
                   rendererOptions: {zIndexing: true},
                   graphicZIndex: 150
                }  
}


var vectorLayer = new OpenLayers.Layer.Vector(opts.layer_name || 'Layer', {
                styleMap: new OpenLayers.StyleMap({'default':opts.style, rendererOptions: {zIndexing: true}}),
                format: OpenLayers.Format.GeoJSON
 //               projection: projWGS84
});

map.addLayer(vectorLayer);


if (opts.features) {
  var parser = new OpenLayers.Format.GeoJSON({externalProjection:projWGS84, internalProjection:map.getProjectionObject()});
  
  vectorLayer.addFeatures(parser.read(opts.features));
  
  var tab_layers_select = [];
  var pos_contol_select = -1;
  for (var i = 0; i < map.controls.length; i++) {
  	if (map.controls[i].CLASS_NAME == "OpenLayers.Control.SelectFeature") {
  		pos_contol_select = i;
  	}
  }
  
  if (pos_contol_select > -1) {
  	tab_layers_select = map.controls[pos_contol_select].layers;
  }
  
  tab_layers_select.push(vectorLayer);
  select = new OpenLayers.Control.SelectFeature(tab_layers_select, {clickout:true, toggle:false, multiple:false, hover:false, multiple:false});

  vectorLayer.events.on({
  featureselected: function(evt) {
    var feature = evt.feature;
    if (!feature.data.infos_url) { return };
    var popup = new OpenLayers.Popup.FramedCloud("popup_infos", 
                  feature.geometry.getBounds().getCenterLonLat(),
                  null,
                  'Chargement...',
                  null, true, function(evt) { 
                     map.removePopup(this);
		   //  this.destroy();
                  });
      popup.handler = function(r) {
        this.setContentHTML(r.responseText);
	eval($(this.contentDiv).find('script').text());
        this.updateSize();
      }
      popup.request = OpenLayers.Request.GET({
    			url: feature.data.infos_url, params:{ajax:1},
			callback: popup.handler, scope: popup});
      feature.popup = popup;
      map.addPopup(popup);
  },
  featureunselected: function(evt) {
    var feature = evt.feature;
    if (feature.popup) {
      map.removePopup(feature.popup);
      feature.popup.destroy();
      delete feature.popup;
    }
  }
 });
 map.addControl(select);
 select.activate();
}

return vectorLayer;
},

Control.add_feature = function(map_id, layer_type, feature) {
var map    = Control.maps[map_id];
var layer  = Control.layers[layer_type];
var projWGS84 = new OpenLayers.Projection("EPSG:4326"); 

feature.style = {
   pointRadius: 15
}

var parser = new OpenLayers.Format.GeoJSON({externalProjection:projWGS84, internalProjection:map.getProjectionObject()});

layer.addFeatures(parser.read(feature));

var tab_layers_select = [];
var pos_contol_select = -1;
for (var i = 0; i < map.controls.length; i++) {
	if (map.controls[i].CLASS_NAME == "OpenLayers.Control.SelectFeature") {
		pos_contol_select = i;
	}
}



},

Control.add_features = function(map_id, features) {
var map = Control.maps[map_id];

if (features.type == 'Feature') {
  var layer ;
  if (features.geometry.type == 'Point') {
    layer = map.layers.filter(function(f) { return f.name == 'Point'})[0];
  } else {
    layer = map.layers.filter(function(f) { return f.name == 'MultiPoint'})[0];
  }

  var projWGS84 = new OpenLayers.Projection("EPSG:4326"); 

  features.style = {pointRadius: 15}

  var parser = new OpenLayers.Format.GeoJSON({externalProjection:projWGS84, internalProjection:map.getProjectionObject()});
  layer.addFeatures(parser.read(features));

  var tab_layers_select = [];
  var pos_contol_select = -1;
  for (var i = 0; i < map.controls.length; i++) {
	if (map.controls[i].CLASS_NAME == "OpenLayers.Control.SelectFeature") {
		pos_contol_select = i;
	}
  }
} else {
  for (var i = 0; i < features.features.length; i++) {
    Control.add_features(map_id, features.features[i]);
  }
}

},

Control.render_features = function(map_id, feat_ids, intent) {
var map = Control.maps[map_id];
var layers = map.layers.filter(function(f) { return (f.name == 'Point' || f.name == 'MultiPoint')});

for (var l = 0; l < layers.length; l++) {
  var layer = layers[l];
  for (var i = 0; i < feat_ids.length; i++) {
    var f = layer.features.filter(function(f) {return f.fid == feat_ids[i]})[0];
    if (f) {
      f.renderIntent = intent;
    }
  }
  layer.redraw()
}
},

Control.locate_me = function(map, layer) {
var pulsate = function(feature) {
    var point  = feature.geometry.getCentroid(),
        bounds = feature.geometry.getBounds(),
        radius = Math.abs((bounds.right - bounds.left)/2),
        count  = 0,
        grow   = 'up';

    var resize = function(){
        if (count>16) {
            clearInterval(window.resizeInterval);
        }
        var interval = radius * 0.03;
        var ratio = interval/radius;
        switch(count) {
            case 4:
            case 12:
                grow = 'down'; break;
            case 8:
                grow = 'up'; break;
        }
        if (grow!=='up') {
            ratio = - Math.abs(ratio);
        }
        feature.geometry.resize(1+ratio, point);
        layer.drawFeature(feature);
        count++;
    };
    window.resizeInterval = window.setInterval(resize, 50, point, radius);
};

var geolocate = new OpenLayers.Control.Geolocate({
    bind: false,
    geolocationOptions: {
        enableHighAccuracy: false,
        maximumAge: 0,
        timeout: 7000
    }
});
map.addControl(geolocate);

var firstGeolocation = true;
geolocate.events.register("locationupdated", geolocate, function(e) {
    layer.removeAllFeatures();
    var circle = new OpenLayers.Feature.Vector(
        OpenLayers.Geometry.Polygon.createRegularPolygon(
            new OpenLayers.Geometry.Point(e.point.x, e.point.y),
            e.position.coords.accuracy/2,
            40,
            0
        ),
        {}
    );
    layer.addFeatures([
        new OpenLayers.Feature.Vector(
            e.point,
            {},
            {
                graphicName: 'cross',
                strokeColor: '#f00',
                strokeWidth: 2,
                fillOpacity: 0,
                pointRadius: 10
            }
        ),
        circle
    ]);
    if (firstGeolocation) {
        map.zoomToExtent(layer.getDataExtent());
        pulsate(circle);
        firstGeolocation = false;
        this.bind = true;
    }
});
geolocate.events.register("locationfailed", this, function() {
    OpenLayers.Console.log('Location detection failed');
});
$('#locate').click(function() {
    layer.removeAllFeatures();
    geolocate.deactivate();
    geolocate.watch = false;
    firstGeolocation = true;
    geolocate.activate();
});
},

Control.remove_features = function(map_id, fid) {
var map     = Control.maps[map_id];
var feature = null;

// TRY with Point Layer 
var layer = map.layers.filter(function(f) { return f.name == 'Point'})[0];
for (i = 0; i < layer.features.length; i++) {
  if (layer.features[i].fid == fid) { feature = layer.features[i] }
}

// TRY with MultiPoint Layer 
if (feature == null) {
  layer = map.layers.filter(function(f) { return f.name == 'MultiPoint'})[0];
  for (i = 0; i < layer.features.length; i++) {
    if (layer.features[i].fid == fid) { feature = layer.features[i] }
  }
}

// Remove feature and reaffect selection to others features
if (feature != null) {
  layer.removeFeatures(feature);

  var tab_layers_select = [];
  var pos_contol_select = -1;
  for (var i = 0; i < map.controls.length; i++) {
    if (map.controls[i].CLASS_NAME == "OpenLayers.Control.SelectFeature") { pos_contol_select = i; }
  }
}

}















































})(window);