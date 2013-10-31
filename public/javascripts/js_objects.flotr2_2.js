(function( window, undefined ) {

if(typeof(window.Control) == "undefined") {window.Control = {}}






if(typeof(window.Layout) == "undefined") {window.Layout = {}}






if(typeof(window.Storage) == "undefined") {window.Storage = {}}






if(typeof(window.AjaxTree) == "undefined") {window.AjaxTree = {}}






if(typeof(window.Report) == "undefined") {window.Report = {}}


Report.display = function(name, opts) {
var elt = opts && opts.dest ? ($('#'+opts.dest) || $('#'+name)) : $('#'+name);
if (!this.urls) {this.urls = {}; }

if (this.urls[name].match(/(\.|=)json/)) {
 elt.html('Loading...');
 $.getJSON(this.urls[name], function(rep) {
  var data = [], i, t, d,
      invert = function(elt, i) {return [i,elt]; },
      opts = {mouse:{track:true}};

  if (rep.x_axis && rep.y_axis) { // bars or lines
    for (i = 0; i < rep.elements.length; i++) {
      data.push(rep.elements[i].values.map(invert));
    }
    t = rep.elements[0].type == 'bar' ? 'bars' : rep.elements[0].type == 'bar';
    opts[t] = {show: true};
    opts.xaxis = {ticks:rep.x_axis.labels.labels.map(invert)};
    opts.xaxis.labelsAngle = 45;    opts.HtmlText = false;
    opts.yaxis = rep.y_axis;
  } else { // pie
    for (i = 0; i < rep.elements[0].values.length; i++) {
      d = rep.elements[0].values[i];
      d.data = [[0, d.value]];
      data.push(d);
    }
    opts.pie = {show: true};
  }
    elt.html('');
    graph = Flotr.draw(elt[0], data, opts);
  });
} else {
  elt.html('Loading data...');
  elt.load(this.urls[name]);
}
},

Report.json_for_flottr2 = function(rep) {
var data = [], opts = {mouse:{track:true}}, i = 0, t;
var typ = rep.elements[0].type;
var rev = function(elt, idx) {return [i,elt]; };
if (typ == 'pie') {
      data = rep.elements[0].values.map(function(elt, i) {elt.data = [[0, elt.value]]; return elt; });
      opts.HtmlText = false;
      opts.grid = {verticalLines: false, horizontalLines: false};
      opts.xaxis = { showLabels : false };
} else {
      for (i = 0; i < rep.elements.length; i++) {
        data.push(rep.elements[i].values.map(rev));
      }
}
t = typ == 'bar' ? 'bars' : typ;
opts[t] = {show: true};
if (rep.x_axis && rep.x_axis.labels && rep.x_axis.labels.labels) {
      opts.xaxis = {ticks:rep.x_axis.labels.labels.map(function(elt, i) {return [i,elt]; })};
}
opts.yaxis = rep.y_axis || {showLabels:false};
if (rep.y_axis && rep.y_axis.labels && rep.y_axis.labels.style && rep.y_axis.labels.style.match(/tickDecimals:(\d+)/)) {
  opts.yaxis.tickDecimals = rep.y_axis.labels.style.match(/tickDecimals:(\d+)/)[1];
}
opts.legend = {position : 'se'};
opts.mouse = {track:true, trackFormatter:Report.valueFormatter};
opts.colors = ['#0095D8', '#6DB122', '#6A3F8F'];
return {data:data, opts:opts};

}





if(typeof(window.Validation) == "undefined") {window.Validation = {}}






if(typeof(window.TGV2) == "undefined") {window.TGV2 = {}}






if(typeof(window.LeftRightSelector) == "undefined") {window.LeftRightSelector = {}}






if(typeof(window.Importer) == "undefined") {window.Importer = {}}






})(window);