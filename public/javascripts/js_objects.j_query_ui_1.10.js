(function( window, undefined ) {

if(typeof(window.Control) == "undefined") {window.Control = {}}


Control.calendar = function() {
var elt = $(this);
var opts = {};
opts.dateFormat = elt.data('dateformat');
opts.minDate = elt.data('mindate');
opts.maxDate = elt.data('maxdate');
return elt.datepicker(opts);
}




jQuery(document).ready(function($) {$("INPUT.calendar").each(Control.calendar)})


if(typeof(window.Layout) == "undefined") {window.Layout = {}}


Layout.tab_select = function() {
var labels = $(this).find('> LABEL');

var lis = $(this).find('> UL LI');

lis.each(function(ind) {
  $(this).html('<a href="#'+ labels[ind].id +'">'+$(this).text()+'</a>');
});

return $(this).tabs();
},

Layout.make_table_sortable = function(event) {
var th = $(this).find('th.no-sort');
var opts =  {headers:{}, selectorHeaders: 'THEAD TR:not(.header_filters):not(.containers) TH'};
opts.headers[th.parent().children().index(th)] = {sorter:false};
$(this).tablesorter(opts);

},

Layout.ajax_window = function(event) {
event.preventDefault();
var t = $(this);

var current_window_win;
if ( $('#' + t.data('window')).length > 0 ) {
  current_window_win = $('#' + t.data('window'));
} else {
  current_window_win = $('<div id="' + t.data('window') + '" title="'+ t.text() +'" ></div>');
}

current_window_win.load(t.attr('href'));
current_window_win.dialog();

}




jQuery(document).ready(function($) {$(".multi_field").each(Layout.tab_select)})

jQuery(document).ready(function($) {$(".sortable").each(Layout.make_table_sortable)})

jQuery(document).ready(function($) {$(document).on("click", "A[data-window]", Layout.ajax_window)})


if(typeof(window.Storage) == "undefined") {window.Storage = {}}






if(typeof(window.AjaxTree) == "undefined") {window.AjaxTree = {}}






if(typeof(window.Report) == "undefined") {window.Report = {}}






if(typeof(window.Validation) == "undefined") {window.Validation = {}}






if(typeof(window.TGV2) == "undefined") {window.TGV2 = {}}






if(typeof(window.LeftRightSelector) == "undefined") {window.LeftRightSelector = {}}






if(typeof(window.Importer) == "undefined") {window.Importer = {}}






})(window);