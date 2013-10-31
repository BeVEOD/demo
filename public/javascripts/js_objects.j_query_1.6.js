(function( window, undefined ) {



Control.setup_global_search = function() {
var fld = $('#global_search_field')
var res = $('#global_search_results')
var gsi = $('#global_search_indicator')

Control.gs_last_request = 0;
Control.gs_last_result = 0;

if (gsi.length) {
gsi.ajaxStart(function(){
   $(this).show();
 });
gsi.ajaxStop(function(){
   $(this).hide();
 }); 
}

if (fld && res) {
  fld.keyup(function(event) {
    if (this.value.length < 2) {
      res.hide();
    } else {
     Control.gs_last_request = Math.max(Control.gs_last_request, (new Date()).valueOf());
     $.getJSON('/smart_queries/global_search.json',
     		{timestamp: (new Date()).valueOf(), value:this.value},
       		function(resp){
var now = resp.timestamp || (new Date()).valueOf();
if (now > Control.gs_last_result) {
  var jsn = resp;
  res.empty();
  if (jsn.msg) {res.append($('<div class="notice">'+jsn.msg+'</div>'))}
  if (jsn.total > 0) {res.append($('<div class="total">'+ (jsn.total_msg || jsn.total)+ '</div>'))}
  res.show();
  var html = '<div class="model">';
  
  $.each(jsn.sections, function(sec, val) {
    html += '<h4>' + sec + '</h4>'
    html += '<ul class="fields">'

    $.each(val, function(fld, fval) {
      html += '<li><div class="field"><h5>' + fld + '</h5>'
      html += '<ul class="results">'
      $.each(fval, function(idx,r) {
        html += '<li class="result '+ r.tags +'"><a href="'+r.link+'">' + r.title + '</a></li>'
      })
      html += '</ul></div></li>'
    })
    html += '</ul>'
  })
  html += '</div>'
  res.append($(html));
} // else, response is obsolete
      })
    }
   })
}
}




jQuery(document).ready(Control.setup_global_search)




Layout.alignValues = function(sel, opts) {
var fss = (typeof(sel) == 'string' || typeof(sel) == 'object') ? $(sel) : $(this)
if (!fss.length) {return }

$.each(fss, function(idx,fs) {
var float_val = $(fs).css('float')
if (float_val == 'right' || float_val == 'left') { $(fs).css('float', 'none') }
var elts = []
if (opts && typeof(opts) == 'object') {
	elts = opts.only ? fs.getElementsBySelector(opts.only) : Layout.getFirstFormElements($(fs), opts)
} else {
	elts = Layout.getFirstFormElements($(fs))
}
if (elts.length > 1) {
	var max = 0
	var dir = document.getElementsByTagName('HTML')[0].dir
	$(elts).each(function(idx, elt_) {
	        var elt = $(elt_)
		var l = 0;
		elt.css('margin-left', '0px')
		if (dir == 'rtl') {
			l = elt.parent().width() - elt.position().left - elt.width()
		} else {
		  if (elt.tagName == 'SPAN' && elt.innerHTML == '') {
		    elt.html('&nbsp;')
		  }
			l = elt.position().left
		}
		if (l > max) { max = l }
	  })
	  $(elts).each(function(idx, elt) {
		if (dir == 'rtl') {
			elt.parentNode.style.marginRight = (max - (elt.parent().width() - elt.position().left - elt.width()))+ 'px'
		} else {
			$(elt).parent('label').css('margin-left', ((max - $(elt).position().left) + 'px'))
		}
	  })
	}
if (float_val == 'right' || float_val == 'left') { $(fs).css('float', float_val) }
})
},

Layout.getFirstFormElements = function(fs, opts) {
var elts = []

var labels = $(fs).find('LABEL:not(.not-aligned)').filter(function(idx) {
  return $(this).parent().css('float') == 'none' || $(this).parent('FIELDSET.not-aligned') || !$(this).css('display') == 'block'
})

$(labels).each(function(idx,lab){
  var cand = $(lab).find('INPUT[type!=hidden], SELECT, TEXTAREA, .aligned').filter(function(idx) {
    return !($(this).css('display') == 'none' || $(this).hasClass('mceSelectList') || $(this).hasClass('x-font-select') || $(this).hasClass('not-aligned'))
  })
  if (cand.length > 0) { elts.push(cand[0]) }
})

return $.unique(elts)
},

Layout.collapsible_fieldset = function() {
$(this).parent('FIELDSET').toggleClass('collapsed')
}




jQuery(document).ready(function($) {$(".align_fields").each(Layout.alignValues)})

jQuery(document).ready(function($) {$("#content FIELDSET LEGEND").on("click", Layout.collapsible_fieldset)})
































})(window);