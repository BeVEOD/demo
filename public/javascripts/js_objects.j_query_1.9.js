(function( window, undefined ) {

if(typeof(window.Control) == "undefined") {window.Control = {}}


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
    html += '<h4>' + sec + '</h4>';
    html += '<ul class="fields">';

    $.each(val, function(fld, fval) {
      html += '<li><div class="field"><h5>' + fld + '</h5>';
      html += '<ul class="results">';
      $.each(fval, function(idx,r) {
        html += '<li class="result '+ r.tags +'"><a href="'+r.link+'">' + r.title + '</a></li>'
      })
      html += '</ul></div></li>'
    })
    html += '</ul>'
  })
  html += '</div>';
  res.append($(html));
} // else, response is obsolete
      })
    }
   })
}
},

Control.filter_forms = function(ev) {
var form = $(this);
var from_cookie = form.attr('from-cookie') || '';
var reload_to   = form.attr('reload-to') || window.location.pathname;

if (from_cookie == '') { from_cookie = 'active_filters'; }

form.find('INPUT[type=text], TEXTAREA').keypress(function(event) {
    if (event.keyCode == 13) {
     event.stopImmediatePropagation();
     Control.filter_change.bind(form)(event);
    }
});

var mpath = window.location.pathname.split('/').length > 1 ? ('/' + window.location.pathname.split('/')[1]) : window.location.pathname;
form.find('INPUT[type=reset]').click(function(event) {
  Storage.setCookie(from_cookie, '', '', mpath);
  window.location.pathname = reload_to;
});

form.find('INPUT[type=submit]').click(function(event) {
     Storage.setCookie(from_cookie, Storage.jsonify_form(elt.parent('FORM')), '', mpath);
     window.location.pathname = reload_to;
});
  
form.find('SELECT, INPUT, TEXTAREA').change(Control.filter_change);

// pre-fill forms
var active_filters = Storage.readCookie(from_cookie);
if (active_filters) {
  Storage.unjsonify_form(form, jQuery.parseJSON(unescape(active_filters)));
}

if (navigator.userAgent.match(/Mozilla/)) {
  form.find('LABEL').attr('for', '');
}
},

Control.filter_change = function(event) {
var elt = $(this); //event.findElement();
var comp = elt.parent().find('.comparator');
var default_comp = comp.find('option[value!=""]').first();
if ((comp).val() == '' || (elt.val() == '')) {
  comp.val( (elt.val() == '') ? '' : (default_comp ? default_comp.val() : '') );
}

var mpath = window.location.pathname.split('/').length > 1 ? ('/' + window.location.pathname.split('/')[1]) : window.location.pathname;
Storage.setCookie('active_filters', Storage.jsonify_form(elt.closest('FORM')), '', mpath);

if (!(elt.hasClass('comparator') && elt.next('INPUT,SELECT') &&
  elt.next('INPUT,SELECT').val().length == 0)) {
    window.location.reload();
}
},

Control.miniColors = function(o, data) {
var create = function(input, o, data) {
	//
	// Creates a new instance of the miniColors selector
	//
	
	// Determine initial color (defaults to white)
	var color = expandHex(input.val());
  if( !color ) {color = 'ffffff';}
	var hsb = hex2hsb(color);
	
	// Create trigger
	var trigger = $('<a class="miniColors-trigger" style="background-color: #' + color + '" href="#"></a>');
	trigger.insertAfter(input);
	
	// Set input data and update attributes
	input
		.addClass('miniColors')
		.data('original-maxlength', input.attr('maxlength') || null)
		.data('original-autocomplete', input.attr('autocomplete') || null)
		.data('letterCase', 'uppercase')
		.data('trigger', trigger)
		.data('hsb', hsb)
		.data('change', o.change)
		.attr('maxlength', 7)
		.attr('autocomplete', 'off')
		.val('#' + convertCase(color, o.letterCase));
	
	// Handle options
  if( o.readonly ) {input.prop('readonly', true);}
  if( o.disabled ) {disable(input);}
	
	// Show selector when trigger is clicked
	trigger.bind('click.miniColors', function(event) {
		event.preventDefault();
		//if( input.val() === '' ) input.val('#');
		show(input);

	});
	
	// Show selector when input receives focus
	input.bind('focus.miniColors', function(event) {
		//if( input.val() === '' ) input.val('#');
		show(input);
	});
	
	// Hide on blur
	input.bind('blur.miniColors', function(event) {
		var hex = expandHex(input.val());
		input.val( hex ? convertCase(hex, input.data('letterCase')) : '' );
	});
	
	// Hide when tabbing out of the input
	input.bind('keydown.miniColors', function(event) {
      if( event.keyCode === 9 ) {hide(input);}
	});
	
	// Update when color is typed in
	input.bind('keyup.miniColors', function(event) {
		setColorFromInput(input);
	});
	
	// Handle pasting
	input.bind('paste.miniColors', function(event) {
		// Short pause to wait for paste to complete
		setTimeout( function() {
			setColorFromInput(input);
		}, 5);
	});
	
};

var destroy = function(input) {
	//
	// Destroys an active instance of the miniColors selector
	//
	
	hide();
	input = $(input);
	
	// Restore to original state
	input.data('trigger').remove();
	input
		.attr('autocomplete', input.data('original-autocomplete'))
		.attr('maxlength', input.data('original-maxlength'))
		.removeData()
		.removeClass('miniColors')
		.unbind('.miniColors');
	$(document).unbind('.miniColors');
};

var enable = function(input) {
	//
	// Enables the input control and the selector
	//
	input
		.prop('disabled', false)
		.data('trigger')
		.css('opacity', 1);
};

var disable = function(input) {
	//
	// Disables the input control and the selector
	//
	hide(input);
	input
		.prop('disabled', true)
		.data('trigger')
		.css('opacity', 0.5);
};

var show = function(input) {
	//
	// Shows the miniColors selector
	//
  if( input.prop('disabled') ) {return false;}
	
	// Hide all other instances 
	hide();				
	
	// Generate the selector
	var selector = $('<div class="miniColors-selector"></div>');
	selector
		.append('<div class="miniColors-colors" style="background-color: #FFF;"><div class="miniColors-colorPicker"></div></div>')
		.append('<div class="miniColors-hues"><div class="miniColors-huePicker"></div></div>')
		.css({
			top: input.is(':visible') ? input.offset().top + input.outerHeight() : input.data('trigger').offset().top + input.data('trigger').outerHeight(),
			left: input.is(':visible') ? input.offset().left : input.data('trigger').offset().left,
			display: 'none'
		})
		.addClass( input.attr('class') );
	
	// Set background for colors
	var hsb = input.data('hsb');
	selector
		.find('.miniColors-colors')
		.css('backgroundColor', '#' + hsb2hex({ h: hsb.h, s: 100, b: 100 })); // OK
	
	// Set colorPicker position
	var colorPosition = input.data('colorPosition');
  if( !colorPosition ) {colorPosition = getColorPositionFromHSB(hsb);}
	selector.find('.miniColors-colorPicker')
		.css('top', colorPosition.y + 'px')
		.css('left', colorPosition.x + 'px');
	
	// Set huePicker position
	var huePosition = input.data('huePosition');
  if( !huePosition ) {huePosition = getHuePositionFromHSB(hsb);}
	selector.find('.miniColors-huePicker').css('top', huePosition.y + 'px');
	
	// Set input data
	input
		.data('selector', selector)
		.data('huePicker', selector.find('.miniColors-huePicker'))
		.data('colorPicker', selector.find('.miniColors-colorPicker'))
		.data('mousebutton', 0);
		
	$('BODY').append(selector);
	selector.fadeIn(100);
	
	// Prevent text selection in IE
	selector.bind('selectstart', function() { return false; });
	
	$(document).bind('mousedown.miniColors touchstart.miniColors', function(event) {
		
		input.data('mousebutton', 1);
		
		if( $(event.target).parents().andSelf().hasClass('miniColors-colors') ) {
			event.preventDefault();
			input.data('moving', 'colors');
			moveColor(input, event);
		}
		
		if( $(event.target).parents().andSelf().hasClass('miniColors-hues') ) {
			event.preventDefault();
			input.data('moving', 'hues');
			moveHue(input, event);
		}
		
		if( $(event.target).parents().andSelf().hasClass('miniColors-selector') ) {
			event.preventDefault();
			return;
		}
		
      if( $(event.target).parents().andSelf().hasClass('miniColors') ) {return;}
		
		hide(input);
	});
	
	$(document)
		.bind('mouseup.miniColors touchend.miniColors', function(event) {
			event.preventDefault();
			input.data('mousebutton', 0).removeData('moving');
		})
		.bind('mousemove.miniColors touchmove.miniColors', function(event) {
			event.preventDefault();
			if( input.data('mousebutton') === 1 ) {
              if( input.data('moving') === 'colors' ) {moveColor(input, event);}
              if( input.data('moving') === 'hues' ) {moveHue(input, event);}
			}
		});
	
};

var hide = function(input) {
	
	//
	// Hides one or more miniColors selectors
	//
	
	// Hide all other instances if input isn't specified
  if( !input ) {input = '.miniColors';}
	
	$(input).each( function() {
		var selector = $(this).data('selector');
		$(this).removeData('selector');
		$(selector).fadeOut(100, function() {
			$(this).remove();
		});
	});
	
	$(document).unbind('.miniColors');
	
};

var moveColor = function(input, event) {

	var colorPicker = input.data('colorPicker');
	
	colorPicker.hide();
	
	var position = {
		x: event.pageX,
		y: event.pageY
	};
	
	// Touch support
	if( event.originalEvent.changedTouches ) {
		position.x = event.originalEvent.changedTouches[0].pageX;
		position.y = event.originalEvent.changedTouches[0].pageY;
	}
	position.x = position.x - input.data('selector').find('.miniColors-colors').offset().left - 5;
	position.y = position.y - input.data('selector').find('.miniColors-colors').offset().top - 5;
  if( position.x <= -5 ) {position.x = -5;}
  if( position.x >= 144 ) {position.x = 144;}
  if( position.y <= -5 ) {position.y = -5;}
  if( position.y >= 144 ) {position.y = 144;}
	
	input.data('colorPosition', position);
	colorPicker.css('left', position.x).css('top', position.y).show();
	
	// Calculate saturation
	var s = Math.round((position.x + 5) * 0.67);
  if( s < 0 ) {s = 0;}
  if( s > 100 ) {s = 100;}
	
	// Calculate brightness
	var b = 100 - Math.round((position.y + 5) * 0.67);
  if( b < 0 ) {b = 0;}
  if( b > 100 ) {b = 100;}
	
	// Update HSB values
	var hsb = input.data('hsb');
	hsb.s = s;
	hsb.b = b;
	
	// Set color
	setColor(input, hsb, true);
};

var moveHue = function(input, event) {
	
	var huePicker = input.data('huePicker');
	
	huePicker.hide();
	
	var position = {
		y: event.pageY
	};
	
	// Touch support
	if( event.originalEvent.changedTouches ) {
		position.y = event.originalEvent.changedTouches[0].pageY;
	}
	
	position.y = position.y - input.data('selector').find('.miniColors-colors').offset().top - 1;
  if( position.y <= -1 ) {position.y = -1;}
  if( position.y >= 149 ) {position.y = 149;}
	input.data('huePosition', position);
	huePicker.css('top', position.y).show();
	
	// Calculate hue
	var h = Math.round((150 - position.y - 1) * 2.4);
  if( h < 0 ) {h = 0;}
  if( h > 360 ) {h = 360;}
	
	// Update HSB values
	var hsb = input.data('hsb');
	hsb.h = h;
	
	// Set color
	setColor(input, hsb, true);
	
};

var setColor = function(input, hsb, updateInput) {
	input.data('hsb', hsb);
	var hex = hsb2hex(hsb);	
  if( updateInput ) {input.val( convertCase(hex, input.data('letterCase')) );}
	input.data('trigger').css('backgroundColor', '#' + hex);
  if( input.data('selector') ) {input.data('selector').find('.miniColors-colors').css('backgroundColor', '#' + hsb2hex({ h: hsb.h, s: 100, b: 100 }));}
	
	// Fire change callback
	if( input.data('change') ) {
      if( hex === input.data('lastChange') ) {return;}
		input.data('change').call(input, hex, hsb2rgb(hsb));
		input.data('lastChange', hex);
	}
	
};

var setColorFromInput = function(input) {
	
	input.val(cleanHex(input.val()));
	var hex = expandHex(input.val());
  if( !hex ) {return false;}
	
	// Get HSB equivalent
	var hsb = hex2hsb(hex);
	
	// If color is the same, no change required
	var currentHSB = input.data('hsb');
  if( hsb.h === currentHSB.h && hsb.s === currentHSB.s && hsb.b === currentHSB.b ) {return true;}
	
	// Set colorPicker position
	var colorPosition = getColorPositionFromHSB(hsb);
	var colorPicker = $(input.data('colorPicker'));
	colorPicker.css('top', colorPosition.y + 'px').css('left', colorPosition.x + 'px');
	input.data('colorPosition', colorPosition);
	
	// Set huePosition position
	var huePosition = getHuePositionFromHSB(hsb);
	var huePicker = $(input.data('huePicker'));
	huePicker.css('top', huePosition.y + 'px');
	input.data('huePosition', huePosition);
	
	setColor(input, hsb);
	
	return true;
	
};

var convertCase = function(string, letterCase) {
  if( letterCase === 'lowercase' ) {return string.toLowerCase();}
  if( letterCase === 'uppercase' ) {return string.toUpperCase();}
	return string;
};

var getColorPositionFromHSB = function(hsb) {				
	var x = Math.ceil(hsb.s / 0.67);
  if( x < 0 ) {x = 0;}
  if( x > 150 ) {x = 150;}
	var y = 150 - Math.ceil(hsb.b / 0.67);
  if( y < 0 ) {y = 0;}
  if( y > 150 ) {y = 150;}
	return { x: x - 5, y: y - 5 };
};

var getHuePositionFromHSB = function(hsb) {
	var y = 150 - (hsb.h / 2.4);
  if( y < 0 ) {h = 0;}
  if( y > 150 ) {h = 150;}				
	return { y: y - 1 };
};

var cleanHex = function(hex) {
	return hex.replace(/[^A-F0-9]/ig, '');
};

var expandHex = function(hex) {
	hex = cleanHex(hex);
  if( !hex ) {return null;}
  if( hex.length === 3 ) {hex = hex[0] + hex[0] + hex[1] + hex[1] + hex[2] + hex[2];}
	return hex.length === 6 ? hex : null;
};			

var hsb2rgb = function(hsb) {
	var rgb = {};
	var h = Math.round(hsb.h);
	var s = Math.round(hsb.s*255/100);
	var v = Math.round(hsb.b*255/100);
	if(s === 0) {
		rgb.r = rgb.g = rgb.b = v;
	} else {
		var t1 = v;
		var t2 = (255 - s) * v / 255;
		var t3 = (t1 - t2) * (h % 60) / 60;
      if( h === 360 ) {h = 0;}
		if( h < 60 ) { rgb.r = t1; rgb.b = t2; rgb.g = t2 + t3; }
		else if( h < 120 ) {rgb.g = t1; rgb.b = t2; rgb.r = t1 - t3; }
		else if( h < 180 ) {rgb.g = t1; rgb.r = t2; rgb.b = t2 + t3; }
		else if( h < 240 ) {rgb.b = t1; rgb.r = t2; rgb.g = t1 - t3; }
		else if( h < 300 ) {rgb.b = t1; rgb.g = t2; rgb.r = t2 + t3; }
		else if( h < 360 ) {rgb.r = t1; rgb.g = t2; rgb.b = t1 - t3; }
		else { rgb.r = 0; rgb.g = 0; rgb.b = 0; }
	}
	return {
		r: Math.round(rgb.r),
		g: Math.round(rgb.g),
		b: Math.round(rgb.b)
	};
};

var rgb2hex = function(rgb) {
	var hex = [
		rgb.r.toString(16),
		rgb.g.toString(16),
		rgb.b.toString(16)
	];
	$.each(hex, function(nr, val) {
      if (val.length === 1) {hex[nr] = '0' + val;}
	});
	return hex.join('');
};

var hex2rgb = function(hex) {
	hex = parseInt(((hex.indexOf('#') > -1) ? hex.substring(1) : hex), 16);
	
	return {
		r: hex >> 16,
		g: (hex & 0x00FF00) >> 8,
		b: (hex & 0x0000FF)
	};
};

var rgb2hsb = function(rgb) {
	var hsb = { h: 0, s: 0, b: 0 };
	var min = Math.min(rgb.r, rgb.g, rgb.b);
	var max = Math.max(rgb.r, rgb.g, rgb.b);
	var delta = max - min;
	hsb.b = max;
	hsb.s = max !== 0 ? 255 * delta / max : 0;
	if( hsb.s !== 0 ) {
		if( rgb.r === max ) {
			hsb.h = (rgb.g - rgb.b) / delta;
		} else if( rgb.g === max ) {
			hsb.h = 2 + (rgb.b - rgb.r) / delta;
		} else {
			hsb.h = 4 + (rgb.r - rgb.g) / delta;
		}
	} else {
		hsb.h = -1;
	}
	hsb.h *= 60;
	if( hsb.h < 0 ) {
		hsb.h += 360;
	}
	hsb.s *= 100/255;
	hsb.b *= 100/255;
	return hsb;
};			

var hex2hsb = function(hex) {
	var hsb = rgb2hsb(hex2rgb(hex));
	// Zero out hue marker for black, white, and grays (saturation === 0)
  if( hsb.s === 0 ) {hsb.h = 360;}
	return hsb;
};

var hsb2hex = function(hsb) {
	return rgb2hex(hsb2rgb(hsb));
};


// Handle calls to $([selector]).miniColors()
switch(o) {

	case 'readonly':
		
		$(this).each( function() {
          if( !$(this).hasClass('miniColors') ) {return;}
			$(this).prop('readonly', data);
		});
		
		return $(this);
	
	case 'disabled':
		
		$(this).each( function() {
          if( !$(this).hasClass('miniColors') ) {return;}
			if( data ) {
				disable($(this));
			} else {
				enable($(this));
			}
		});
							
		return $(this);

	case 'value':
		
		// Getter
		if( data === undefined ) {
          if( !$(this).hasClass('miniColors') ) {return;}
			var input = $(this),
				hex = expandHex(input.val());
			return hex ? convertCase(hex, input.data('letterCase')) : null;
		}
		
		// Setter
		$(this).each( function() {
          if( !$(this).hasClass('miniColors') ) {return;}
			$(this).val(data);
			setColorFromInput($(this));
		});
		
		return $(this);
		
	case 'destroy':
		
		$(this).each( function() {
          if( !$(this).hasClass('miniColors') ) {return;}
			destroy($(this));
		});
    return $(this);
	
	default:
		
    if( !o ) {o = {};}
		
		$(this).each( function() {
			
			// Must be called on an input element
          if( $(this)[0].tagName.toLowerCase() !== 'input' ) {return;}
			
			// If a trigger is present, the control was already created
          if( $(this).data('trigger') ) {return;}
			
			// Create the control
			create($(this), o, data);
			
		});
		
		return $(this);
		
}
},

Control.ColorPicker = function(id, opts) {
$.proxy(Control.miniColors, $("#" + id), opts);
},

Control.position_moves = function(event) {
event.preventDefault();
var t = $(this);
if (t.data('update')) {
  $.ajax({url:t.attr('href'), method:t.data('method'), success:function(resp){$('#'+ t.data('update')).html(resp);}});
} else {
  $.ajax(t.attr('href'), {method:t.data('method')});
}
},

Control.disable_submit_during_sending = function() {
if (window.hiddenCommit) {
  window.hiddenCommit.setAttribute('value', this.value);
} else {
  hiddenCommit = document.createElement('input');
  hiddenCommit.type = 'hidden';
  hiddenCommit.value = this.value;
  hiddenCommit.name = this.name;
  this.form.appendChild(hiddenCommit);
}
this.setAttribute('originalValue', this.value);
this.disabled = true;this.value='Processing...';
result = (this.form.onsubmit ? (this.form.onsubmit() ? this.form.submit() : false) : this.form.submit());
if (result == false) {
  this.value = this.getAttribute('originalValue');
  this.disabled = false;
}
return result;
},

Control.ajax_editor = function(evt,url) {
var elt = $(evt.target);
var nam = elt.attr('name');

var bgc = elt.css('background-color');
var data = nam + "=" + elt.val();

elt.css('background-color', 'silver');

$.ajax({
  type: 'PUT',
  url: url,
  data: data,
  complete: function() { elt.css('background-color', bgc); },
  dataType: 'json'
});

}




jQuery(document).ready(Control.setup_global_search)

jQuery(document).ready(function($) {$("FORM.filter_bar").each(Control.filter_forms)})

jQuery(document).ready(function($) {$(document).on("click", "A.position_move[data-ajax]", Control.position_moves)})

jQuery(document).ready(function($) {$(document).on("re", "INPUT[type=submit]", Control.disable_submit_during_sending)})


if(typeof(window.Layout) == "undefined") {window.Layout = {}}


Layout.alignValues = function(sel, opts) {
var fss = (typeof(sel) == 'string' || typeof(sel) == 'object') ? $(sel) : $(this);
if (!fss.length) {return; }

$.each(fss, function(idx,fs) {
var float_val = $(fs).css('float'), elts = [];
if (float_val == 'right' || float_val == 'left') { $(fs).css('float', 'none') ; }
if (opts && typeof(opts) == 'object') {
	elts = opts.only ? fs.getElementsBySelector(opts.only) : Layout.getFirstFormElements($(fs), opts);
} else {
	elts = Layout.getFirstFormElements($(fs));
}
if (elts.length > 1) {
  var max = 0, dir = document.getElementsByTagName('HTML')[0].dir;
  $(elts).each(function(idx, elt_) {
	        var elt = $(elt_), l = 0;
		elt.css('margin-left', '0px');
		if (dir == 'rtl') {
			l = elt.parent().width() - elt.position().left - elt.width();
		} else {
		  if (elt.tagName == 'SPAN' && elt.innerHTML == '') {
		    elt.html('&nbsp;');
		  }
			l = elt.position().left;
		}
		if (l > max) { max = l; }
	  })
  $(elts).each(function(idx, elt_) {
    var elt = $(elt_);
		if (dir == 'rtl') {
			elt.parent().css('margin-right', (max - (elt.parent().width() - elt.position().left - elt.width()))+ 'px');
		} else {
			elt.parent('label').css('margin-left', ((max - elt.position().left) + 'px'));
		}
	  })
	}
 if (float_val == 'right' || float_val == 'left') { $(fs).css('float', float_val); }
})
},

Layout.getFirstFormElements = function(fs, opts) {
var elts = [];

var labels = $(fs).find('LABEL:not(.not-aligned)').filter(":visible").filter(function(idx) {
  return $(this).parent().css('float') == 'none' && !$(this).parents('.not-aligned, TABLE.table_container').length && $(this).css('display') == 'block';
});

$(labels).each(function(idx,lab){
  var cand = $(lab).find('INPUT[type!=hidden], SELECT, TEXTAREA, .aligned').filter(function(idx) {
    return !($(this).css('display') == 'none' || $(this).hasClass('mceSelectList') || $(this).hasClass('x-font-select') || $(this).hasClass('not-aligned'));
  });
  if (cand.length > 0) { elts.push(cand[0]); }
});

return $.unique(elts);
},

Layout.collapsibleFieldset = function(event) {
$(this).parent('FIELDSET').toggleClass('collapsed');
},

Layout.build_menubar = function(ev) {
var menuid = this.id;
var ultags = this.getElementsByTagName("ul");
var t = 0;
var omover = function() { $(this.getElementsByTagName("ul")[0]).css('visibility', "visible").css('zIndex', 99999999); };
var omout = function(){ $(this.getElementsByTagName("ul")[0]).css('visibility',"hidden");};
for (t=0; t<ultags.length; t++) {
	if (ultags[t].parentNode.parentNode.id == menuid){ //if this is a first level submenu
		var newtop = ultags[t].parentNode.offsetHeight;
		if (newtop) {$(ultags[t]).css('top',newtop +"px");} //dynamically position first level submenus to be height of main menu item
		ultags[t].parentNode.getElementsByTagName("a")[0].className="mainfoldericon";
	}
	else{ //else if this is a sub level menu (ul)
		var parent_ul = ultags[t].parentNode.parentNode;
		var newleft = parent_ul.getElementsByTagName("a")[0].offsetWidth;
		if (newleft) {$(ultags[t]).css('left', newleft+"px");} //position menu to the right of menu item that activated it
		ultags[t].parentNode.getElementsByTagName("a")[0].className="subfoldericon";
	}
	ultags[t].parentNode.onmouseover = omover;
	ultags[t].parentNode.onmouseout = omout;
}
},

Layout.toggle_display = function(id) {
$('#'+id).toggle();
},

Layout.check_rtl = function(event) {
if ($('html')[0].dir == 'rtl' && $(this).css('right') != 'auto') {
  document.dir = 'rtl';
  $(this).css('left',0).css('text-align', 'right').css('right', 'auto');
  if ($('#menu').length > 0) {
    $('#menu').css('left','auto').css('text-align', 'right').css('right', 0);
  }
}
},

Layout.print_element_id = function(elt, title) {
var eid = $(elt).id ;
var txt = $('#' + eid).html();
var winId = window.open('','newwin');

winId.write('<html><head><title>'+title+'<\/title><link href="/stylesheets/print.css" media="all" rel="Stylesheet" type="text/css" /><\/head><body onload="window.focus();window.print()">'+text+'<\/body><\/html>');
winId.close();

},

Layout.list_rows_default_actions = function(event) {
var action, ctrl = this.id.match(/(.*)_(\d+)/)[1];
var id = this.id.match(/(.*)_(\d+)/)[2];
if (ctrl && id) {
  action = event.altKey ? 'edit' : 'show';
  window.location = ('/' + ctrl + '/' + action + '/' + id);
}
}




jQuery(document).ready(function($) {$(".align_fields").each(Layout.alignValues)})

jQuery(document).ready(function($) {$(document).on("click", "#content FIELDSET LEGEND", Layout.collapsibleFieldset)})

jQuery(document).ready(function($) {$("#main-menubar").each(Layout.build_menubar)})

jQuery(document).ready(function($) {$("#content").each(Layout.check_rtl)})

jQuery(document).ready(function($) {$(document).on("dblclick", "#content TABLE TBODY TR", Layout.list_rows_default_actions)})


if(typeof(window.Storage) == "undefined") {window.Storage = {}}


Storage.jsonify_form = function(f) {
var hf = {};
$(f).find('SELECT[id^=comp_].comparator').each(function(idx,delt) {
  var elt = $(delt);
  var label = elt.closest('LABEL');
  var sid = label.attr('data-field');
  var val = (elt.next() ? (elt.next('INPUT, SELECT, TEXTAREA')).val() : '');
  if (sid && sid != '') {
   if (elt.val() != '' && ((elt.val().match(/NULL/) != null) || (elt.next().multiple ? (val.length > 0) : val != ''))) {
    var t = hf[sid] || {};
    if (label.find('SELECT:not(.comparator)') && (label.hasClass('input_date') || label.hasClass('input_datetime') || label.hasClass('input_time'))) {
	  t[elt.val()] = Storage.rails_date_selects_to_string(label);
    } else {
	  t[elt.val()] = val;
    }
    hf[sid] = $.extend(hf[sid] || {}, t);
   }
  }
});
$(f).find('LABEL.input_scope').each(function(idx,lbl) {
  var label = $(lbl);
  var sid = label.attr('data-scope');
  var val = label.children().val();
  if (val) {
    t = hf['_scopes'] || [];
    t.push(val);
  }
  hf['_scopes'] = t;
});
return JSON.stringify(hf);
},

Storage.unjsonify_form = function(f, hf) {
var openable = $('.full_filters').length > 0;
var sid  = null;
var op   = null;
var myop = null;
var comp = null;
var lbl  = null;
var val  = null;
var fld  = null; 
var d    = null;
var fr_date = null;
var dateformat = null;

for (sid in hf) {
  for (op in hf[sid]) {

    myop =  $(f).find('[data-field="' + sid + '"] OPTION[value="' + op + '"]');
    comp = myop ? myop.parent() : null;
    lbl  = comp.parent('LABEL, UL');
    val  = hf[sid][op];

    if (comp && op && val) {
      fld = comp.next('INPUT, SELECT, TEXTAREA');

      if (fld) { // && (op != comp.val() || val != fld.val())) {

	comp.val(op);
	fld.val(val);
	if (comp.hasClass('date')) {
	  d = val.match(new RegExp("([0-9]{4})([0-9]{2})([0-9]{2})", "i"));
	  fr_date = (d == null) ? '' : new Date(d[1], d[2]-1, d[3]).toFormattedString();

	  fld.val(fr_date);
	} else {
          if (fld.hasClass('calendar')) {
	    dateformat = fld.datepicker("option", "dateFormat");
            fld.datepicker("option", "dateFormat", 'yy-mm-dd');

	    fld.datepicker("option", "dateFormat", dateformat);
            fld.datepicker().val(val);

          } else {
	    fld.val(val);
          }
	}

        if (lbl && openable && lbl.parent('.full_filters:hidden')) {
          lbl.parent('.full_filters').show();
        }
      }
    }
  }
}

},

Storage.rails_date_selects_to_string = function(lab) {
var res = "";

if ($(lab).closest('filter_bar') && ($(lab).hasClass('input_date') || $(lab).hasClass('input_datetime'))) {
	res_manip = {};
	regexp = new RegExp(/[0-9]{2}-[0-9]{2}-[0-9]{2}/);
	res_manip = $(lab).find("INPUT.calendar").val().split("/");
    if (res_manip[0].match(regexp)){
      res = res_manip[0];
    }  
  else {
      res_manip = res_manip[2] + "-" + res_manip[0] + "-" + res_manip[1];
      res = res_manip.toString();
  }
}
else 
{
	if ($(lab).hasClass('input_date') || $(lab).hasClass('input_datetime')) {
      res += $(lab).find("SELECT[id$=_1i]").val() + "-" + $(lab).find("SELECT[id$=_2i]").val() + "-" + $(lab).find("SELECT[id$=_3i]").val();
    }
  else {
    res = $(lab).find("SELECT").val();
  }
  if ($(lab).hasClass('input_time') || $(lab).hasClass('input_datetime')) {
    if ($(lab).hasClass('input_datetime')) { res += " ";}
    if ($(lab).find("SELECT[id$=_4i]") && $(lab).find("SELECT[id$=_5i]")) {
      res += $(lab).find("SELECT[id$=_4i]").val() + ":" + $(lab).find("SELECT[id$=_5i]").val();
    }
    else {
      res = $(lab).find("SELECT").val();
    }  
    
   }
}
return res;
}





if(typeof(window.AjaxTree) == "undefined") {window.AjaxTree = {}}






if(typeof(window.Report) == "undefined") {window.Report = {}}






if(typeof(window.Validation) == "undefined") {window.Validation = {}}






if(typeof(window.TGV2) == "undefined") {window.TGV2 = {}}






if(typeof(window.LeftRightSelector) == "undefined") {window.LeftRightSelector = {}}


LeftRightSelector.all_in = function(lid, lval, keep_in_list) {
var rg  = /_(\d+)$/;
var values = null;
var _values = null;

$('#' + lid + ' .selector_out LI').each(function(i, li){
  if (keep_in_list) {
    $(li).clone().appendTo($('#' + lid + ' UL.selector_in'));
    values  = $('#' + lval).val() || '';
    _values = values.split(',');
    if (values == '') { _values.shift(); }
    _values.push($(li).attr('id').match(rg)[1]);
    values = _values.join(',');
  } else {
     $('#' + lid + ' UL.selector_in').append(li);
     values = $('#' + lval).val() || [];
     values.push($(li).attr('id').match(rg)[1]); 
  }
  $('#' + lval).val(values);
});

LeftRightSelector.left_right_selector_maj_nb('#' + lid);

},

LeftRightSelector.all_out = function(lid, lval, keep_in_list) {
$('#' + lid + ' .selector_in LI').each(function(i, li){
  if (keep_in_list) { 
     $(li).remove(); 
  } else {
     $('#' + lid + ' UL.selector_out').append(li);
     $('#' + lval).val([]);
  }
  $('#' + lval).val([]);
});
LeftRightSelector.left_right_selector_maj_nb('#' + lid);
},

LeftRightSelector.one_in = function(lid, lval, keep_in_list) {
var rg = /_(\d+)$/;

$('#' + lid + ' .selector_out LI.selected').each(function(i, li) {
  var values;
  if (keep_in_list) {     
     $(li).clone().appendTo($('#' + lid + ' UL.selector_in'));
     values = $('#' + lval).val() || '';
     var _values = values.split(',');
     if (values == '') { _values.shift(); }
     _values.push($(li).attr('id').match(rg)[1]);
     values = _values.join(',');
  } else {   
     $('#' + lid + ' UL.selector_in').append(li);
     values = $('#' + lval).val() || [];
     values.push($(li).attr('id').match(rg)[1]);
  }
  $('#' + lval).val(values);
});
LeftRightSelector.left_right_selector_maj_nb('#' + lid);
},

LeftRightSelector.one_out = function(lid, lval, keep_in_list) {
var rg = /_(\d+)$/;
var values,idx;

$('#' + lid + ' .selector_in LI.selected').each(function(i, li){
  if (keep_in_list) {
      if ( $('#' + lid + ' UL.selector_out').find(li).length) { $(li).remove(); }
      else { $('#' + lid + ' UL.selector_out').append(li); }
       values = $('#' + lval).val() || '';
       idx = values.indexOf($(li).attr('id').match(rg)[1]);
      var _values = values.split(',');
      if (values == '') { _values.shift() ;}
      _values.splice(idx, 1);
      values = _values.join(',');
  } else {
      $('#' + lid + ' UL.selector_out').append(li);
       values = $('#' + lval).val() || [];
       idx = values.indexOf($(li).attr('id').match(rg)[1]);
      values.splice(idx, 1);
  }
  $('#' + lval).val(values);
});
},

LeftRightSelector.filter = function(lid) {
$('#' + lid + ' .selector_out li').each(function(index) {
  if (($(this).text() == "") || ($(this).text().toLowerCase().match($('#' + lid + ' .filter').val().toLowerCase()))) {
    $(this).css('display', 'block');
  } else {
    $(this).css('display', 'none');
    $(this).removeClass('selected');
  }
}); 
}





if(typeof(window.Importer) == "undefined") {window.Importer = {}}


Importer.darken = function() {
$('.command_button').map(function (x) {x.disable();}); $('#importer_loading').show(); $('#darken').show();

},

Importer.setup = function() {
$('#import_result_div').css('width', $(document).width() - 16 + 'px');

}




jQuery(window).load(function() {$("#import_result_div").each(Importer.setup)})


})(window);