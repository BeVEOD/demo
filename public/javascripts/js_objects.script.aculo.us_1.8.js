(function( window, undefined ) {









Layout.collapsible_toggle = function() {
var o = $(this);
var i = o.id;
var div = i.endsWith('_div') ? i : i.sub('_fs', '_div');
Effect.toggle($(div), 'blind', {duration: 0.5});
}



































})(window);
