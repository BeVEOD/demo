// inspired by https://github.com/jkarsrud/jquery-string-interpolator
;(function($) {
    $.extend($, {
        interpolate: function(t, o, s) {
            var m = (!s) ? /{([^#{}]*)}/g : s;
            if (s) m = s;
            return t.replace(m, function(a, b) {
                var r = o[b];
                return typeof r === 'string' || typeof r === 'number' ? r : a;
            });
        }
    });
})(jQuery);

jQuery.fn.outer = function() {
  return $( $('<div></div>').html(this.clone()) ).html();
}

if (typeof(Event) == "undefined") {Event = {}}
if (!Event.observe) {
 Event.observe =
  function(elt, evt, callback) {
   if (elt == window) {
    if (evt == 'load') {
      $(window).load(callback);
    } else {
      $(document).ready(callback);
    }
   } else {
    $(elt).on(evt, callback);
   }
  };
}
