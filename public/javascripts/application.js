Prototype.Browser.IE6 = function() {
  if (Prototype.Browser.IE) {
    var ua      = navigator.userAgent;
    var offset  = ua.indexOf('MSIE ');
    return parseFloat(ua.substring(offset+5, ua.indexOf(';', offset))) == 6;
  }
  return false;
};

Prototype.Browser.IE7 = function() {
  if(Prototype.Browser.IE) {
    var ua      = navigator.userAgent;
    var offset  = ua.indexOf('MSIE ');
    return parseFloat(ua.substring(offset+5, ua.indexOf(';', offset))) == 7;
  }
  return false;
};

Element.addMethods({getText:function(e){
    if(e.textContent){return e.textContent}
    if(e.outerText){return e.outerText}
    if(e.nodeValue){return e.nodeValue}
    return'';
}});

function setCookie(name, value, expires, path, domain, secure) { 
  var curCookie = name + "=" + escape(value) + ((expires) ? "; expires=" + expires.toGMTString() : "") + 
  ((path) ? "; path=" + path : "") + ((domain) ? "; domain=" + domain : "") + ((secure) ? "; secure" : ""); 
  document.cookie = curCookie;
  return document.cookie.indexOf(name) != -1;
}

function createCookie(name,value,days) {
  var expires = "";
  if (days) {
    var date = new Date();
    date.setTime(date.getTime()+(days*24*60*60*1000));
    expires = "; expires="+date.toGMTString();
  }
  document.cookie = name+"="+value+expires+"; path=/";
}

function readCookie(name) {
  var nameEQ = name + "=";
  var ca = document.cookie.split(';');
  for(var i=0;i < ca.length;i++) {
    var c = ca[i];
    while (c.charAt(0) == ' ') {c = c.substring(1,c.length); }
    if (c.indexOf(nameEQ) == 0) {return c.substring(nameEQ.length,c.length);}
  }
  return null;
}

function eraseCookie(name) {
  createCookie(name,"",-1);
}

function setLanguage(lg) {
	setCookie('lang', lg, null, '/');
	document.location.reload();
}

function loadJSFile(js_file) {
	var head = document.getElementsByTagName("head")[0];
	var script = document.createElement("script");
	script.setAttribute("type","text/javascript");
	script.setAttribute("src", js_file);
	head.appendChild(script);
}

function collapsible_toggle() {
  var o   = $(this);
  var i   = o.id;
  var div = i.endsWith('_div') ? i : i.sub('_fs', '_div');
  Effect.toggle($(div), 'blind', {duration: 0.5});
}

function add_collapsible_behaviour() {
  $$('div.collapsible').map(function(d) {
    var f = d.up('fieldset');
    var l = f ? f.down('legend') : null;
    if (l) {l.observe('click', collapsible_toggle.bind(d));}
    Effect.BlindDown(d, {duration: 0.25});
  });
}

function build_menubar(menuid){
	var ultags=$(menuid).getElementsByTagName("ul");
	for (var t=0; t<ultags.length; t++){
		if (ultags[t].parentNode.parentNode.id==menuid){ //if this is a first level submenu
		 	var newtop = ultags[t].parentNode.offsetHeight;
			if (newtop) {$(ultags[t]).setStyle({top: newtop +"px"})} //dynamically position first level submenus to be height of main menu item
			ultags[t].parentNode.getElementsByTagName("a")[0].addClassName="mainfoldericon";
		}
		else{ //else if this is a sub level menu (ul)
			parent_ul = ultags[t].parentNode.parentNode
			var newleft = parent_ul.getElementsByTagName("a")[0].offsetWidth;
			if (newleft) {$(ultags[t]).setStyle({left: newleft+"px"})} //position menu to the right of menu item that activated it
			ultags[t].parentNode.getElementsByTagName("a")[0].addClassName="subfoldericon";
		}
		ultags[t].parentNode.onmouseover=function() {
			this.getElementsByTagName("ul")[0].setStyle({visibility: "visible", zIndex:99999999});
		}
		ultags[t].parentNode.onmouseout=function(){
			this.getElementsByTagName("ul")[0].setStyle({visibility:"hidden"});
		}
    }
}

function stepper(field, mod, opts) {
    var max = opts && typeof(opts['max']) != 'undefined' && !isNaN(opts['max']) ? opts['max'] : null;
    var min = opts && typeof(opts['min']) != 'undefined' && !isNaN(opts['min']) ? opts['min'] : null;
    var val = parseFloat($F(field));

    if (field && !isNaN(val)) {
	val = val + mod;
	if ((max == null || (val <= max)) && (min == null || (val >= min))) {
		$(field).setValue(val);
	}
    }
}

function print_element_id(elt, title) {
  var text = $(elt).innerHTML;
  var winId = window.open('','newwin');
  with (winId.document) {
    write('<html><head><title>'+title+'<\/title><link href="/stylesheets/print.css" media="all" rel="Stylesheet" type="text/css" /><\/head><body onload="window.focus();window.print()">'+text+'<\/body><\/html>');
    close();
  }
}

function rails_date_selects_to_string(lab) {
 var res = ""
 if ($(lab).hasClassName('input_date') || $(lab).hasClassName('input_datetime')) {
   res += $(lab).down("SELECT[id$=_1i]").getValue() + "-" + $(lab).down("SELECT[id$=_2i]").getValue() + "-" + $(lab).down("SELECT[id$=_3i]").getValue()
 }
 if ($(lab).hasClassName('input_time') || $(lab).hasClassName('input_datetime')) {
   if ($(lab).hasClassName('input_datetime')) { res += " "}
   res += $(lab).down("SELECT[id$=_4i]").getValue() + ":" + $(lab).down("SELECT[id$=_5i]").getValue()
 }
 return res;
}

function disp_lang(elt) { /* elt == 'model_mf_lg_id'*/
	if (typeof($(elt)) == 'undefined') {
		var t = elt.split('_');
		var id = t.pop();
		t[t.length-1] = id;
		if ($(t.join('_'))) {disp_lang(t.join('_'));}
	} else {
		var sib = $(elt).siblings();
		var sib_c = sib[0].getElementsByTagName("li"); /* ul */
		/* for (var c=0; c<sib_c.length; c++) {sib_c[c].className = '';} */
		for (var s=1; s<sib.length; s++) {sib[s].hide();}
		$(elt).show();
	}
}

// deprecated
function tab_select(title_id) {
    var title = $(title_id);
    var index = title.up().immediateDescendants().indexOf(title) || 0;
    var divs = title.up(".container_tabs").immediateDescendants();
    divs.shift();
    divs.each(function(div) { div.hide(); })
    title.siblings().each(function(tab) { tab.removeClassName("current"); })
    title.addClassName("current");
    divs[index].show();
}

Ajax.Responders.register({
  onCreate: function() { if (Ajax.activeRequestCount > 0) {$('indicator').show(); }},
  onComplete: function() { if (Ajax.activeRequestCount == 0){$('indicator').hide(); }}
});

function isQTInstalled() {
	var qtInstalled = false;
	qtObj = false;
	if(navigator.plugins && navigator.plugins.length) {
		for(var i=0; i < navigator.plugins.length; i++ ) {
         var plugin = navigator.plugins[i];
         if(plugin.name.indexOf("QuickTime") > -1) { qtInstalled = true; }
        }
	} else {
		execScript('on error resume next: qtObj = IsObject(CreateObject("QuickTimeCheckObject.QuickTimeCheck.1"))','VBScript');
		qtInstalled = qtObj;
	}
	return qtInstalled;
}

function getFirstFormElements(fs, opts) {
	var elts = []
	fs.getElementsBySelector('LABEL').each(function(elt) {
		if (($(elt.parentNode).getStyle('float') == '' || $(elt.parentNode).getStyle('float') == 'none') && !elt.hasClassName('not-aligned') && !elt.up('FIELDSET.not-aligned') && elt.visible() && elt.getStyle('display') == 'block') {
			cand = elt.getElementsBySelector('INPUT[type!=hidden]', 'SELECT', 'TEXTAREA', '.aligned').select(function(e) {
				return e.getStyle('display') != 'none' && e.className != 'mceSelectList' && e.className != 'x-font-select' && !e.hasClassName('not-aligned')
			})
			if (cand.length > 0) { elts.push(cand.first()) }
		}
	})
	return elts.uniq()
}

function alignValues(fs, opts) {
	var fs = $(fs);
	var float_val = fs.getStyle('float')
	if (float_val == 'right' || float_val == 'left') { fs.setStyle('float:none') }
	var elts = []
	if (opts) {
	  elts = opts.only ? fs.getElementsBySelector(opts.only) : getFirstFormElements(fs, opts)
	} else {
	  elts = getFirstFormElements(fs)
	}
	if (elts.length > 1) {
	  var max = 0
	  var dir = document.getElementsByTagName('HTML')[0].dir
	  elts.each(function(elt) {
		var l = 0;
		elt.setStyle({marginLeft : '0px'})
		if (dir == 'rtl') {
			l = $(elt.parentNode).getWidth() - Position.positionedOffset(elt)[0] - elt.getWidth()
		} else {
		  if (elt.tagName == 'SPAN' && elt.innerHTML == '') {
		    elt.insert('&nbsp;')
		  }
			l = Position.positionedOffset(elt)[0]
		}
		if (l > max) { max = l }
	  })
	  elts.each(function(elt) {
		if (dir == 'rtl') {
			elt.parentNode.style.marginRight = (max - ($(elt.parentNode).getWidth() - Position.positionedOffset(elt)[0] - elt.getWidth()))+ 'px'
		} else {
			elt.up('label').setStyle({marginLeft : ((max - Position.positionedOffset(elt)[0]) + 'px')})
		}
	  })
	}
	if (float_val == 'right' || float_val == 'left') { fs.setStyle('float:'+ float_val) }
}

function getOuterHTML(object) {
	if (!object) return null;
	var element = document.createElement("div");
	element.appendChild(object.cloneNode(true));
	return element.innerHTML;
}

function setOptionTo(sel, id, set) {
  if (set) { //add
    if ($(sel).immediateDescendants().find(function(elt) {return elt.value == id})) {
      $(sel).immediateDescendants().find(function(elt) {return elt.value == id}).selected = true
    } else {
      new Insertion.Bottom(sel, '<option value=\"' + id + '\" selected=\"selected\" >'+id+'</option>')
    }
  } else { // remove
    if ($(sel).getValue().include(id)) { 
       $(sel).immediateDescendants().find(function(elt) {return elt.value == id}).selected = false
    }
  }
}
function setLinksTo(div, id, link, set) {
  if (set) { //add
	if ($(div.replace('_links', '')).multiple) {
		$(div).insert(link)
	} else {
		$(div).update(link)
	}
  } else { // remove
	$(div+id).remove()
  }
  if ($(div).immediateDescendants().any()) {
	$(div).innerHTML = $(div).immediateDescendants().collect(function(elt){ return getOuterHTML(elt)}).join()
  } else {
	$(div).update('None')
  }
}

function tree_children_toggle(elt, ctrl) {
	var elt = $(elt)
	var img = elt.down('IMG.collapser')
	if (elt.hasClassName('children_loaded')) {
		elt.select('DIV.tree_element').each(function(e) {e.toggle()})
	} else {
		if (img.src.match('minus.gif')) {
			elt.select('DIV.tree_element').each(function(e) {e.toggle()})
		} else {
			new Ajax.Updater(elt.id, '/'+ctrl+'/tree_list/'+elt.id.gsub(/[^\d]/, ''),
				{insertion: Insertion.Bottom,asynchronous:true, evalScripts:true,
				onSuccess:function() { elt.addClassName('children_loaded') },
				onLoading:function() { img.src="/images/std/indicator.gif"},
				onComplete:function() {img.src="/images/std/minus.gif"}
				})
		}
	}
	img.src = img.src.match('minus.gif') ? "/images/std/plus.gif" : "/images/std/minus.gif"
};


function syntaxHighlight(editable) {
  var opts = $H({start_highlight:true, allow_toggle:false})
  if (editable) {
	opts.update({plugins:"charmap", charmap_default:"arrows", toolbar:"search, |, charmap, go_to_line, fullscreen, |, undo, redo, |, select_font,|, change_smooth_selection, highlight, reset_highlight, word_wrap"})
  } else {
	opts.set('is_editable',false)
  }
  $$('TEXTAREA.ruby, TEXTAREA.js, TEXTAREA.css, TEXTAREA.html, TEXTAREA.xml').each(function(elt){
    if ((editAreas[elt.id] == undefined) && elt.visible()) {
      var e_opts = opts.merge({id:elt.id, syntax:elt.className})
      if (elt.className == 'html' || elt.className == 'xml') { e_opts.set('plugins', 'charmap,zencoding') }
      editAreaLoader.init(e_opts.toObject())
    }
  })
}

function restrict_to_numbers(event, opts) {
 var ok_codes = [8, 9, 109]
 if (opts && opts.float) {
   ok_codes.push(188)
   ok_codes.push(190)
 }
 var kc = event.keyCode
 if (!((kc > 45 && kc < 58) || (kc > 36 && kc < 41) || ok_codes.include(kc) || (kc > 96 && kc < 107))) {
   event.stop()
 }
};

function serialize_not_empty(form_id) {
  var my_form = $(form_id);
  if (!my_form) {return $H({})}
  return $H(my_form.serialize(true)).select(function(x) {return x[0] && x[1] != ''}).map(function(x) {return x[0] + '=' + x[1]}).join('&')
};


if (typeof(Control) == "undefined") {Control = {}; }
if (!Control.GlobalSearch) {Control.GlobalSearch = {last_request: 0, last_result: 0}; }

function setup_global_search() {
 var fld = $('global_search_field');
 var res = $('global_search_results');
 var gsi = $('global_search_indicator');

 if (fld && res) {
  new Form.Element.Observer(fld, 0.5,
   function(element, value) {
    if (value == '') {
     res.hide();
    } else if (value.length > 2) {
     Control.GlobalSearch.last_request = Math.max(Control.GlobalSearch.last_request, (new Date()).valueOf());
     new Ajax.Request('/smart_queries/global_search/' + escape(value) + '.json',
      { asynchronous:true, evalScripts:true,
        parameters:'timestamp=' + (new Date()).valueOf(),
        onComplete:function(request){if (gsi) {gsi.hide()}},
        onLoading:function(request){if (gsi) {gsi.show()}},
        onSuccess:function(resp){
now = resp.responseJSON.timestamp || (new Date()).valueOf();
if (now > Control.GlobalSearch.last_result) {
  var jsn = resp.responseJSON; 
  res.update('');
  if (jsn.msg) {res.insert(new Element('div', {'class': 'notice'}).update(jsn.msg))}
  if (jsn.total > 0) {res.insert(new Element('div', {'class': 'total'}).update(jsn.total_msg || jsn.total))}
  res.show();

  $H(jsn.sections).map(function(sec) {
    var modl = sec[0]; var fldz = sec[1];
    var mdiv = new Element('div', {'class': 'model'}).update(new Element('h4').update(modl));
    var mlst = new Element('ul', {'class': 'fields'});

    $H(fldz).map(function(fld) {
      var fname = fld[0]; results = fld[1];
      var fdiv = new Element('div', {'class': 'field'}).update(new Element('h5').update(fname));
      var flst = new Element('ul', {'class': 'results'});

      $A(results).map(function(r) {
        flst.insert(new Element('li', {'class': 'result ' + r.tags}).update(
          new Element('a', {href: r.link}).update(r.title)))
      })
      fdiv.insert(flst);
      mlst.insert(new Element('li').update(fdiv));
    })
    mdiv.insert(mlst);
    res.insert(mdiv);
  })

} // else, response is obsolete
        }
      })
    }
   })
 }
}

Reports = {
    urls: {}, // name:url
    data: {}, // name:data

    get_data: function(name) {
        new Ajax.Request(this.urls[name], {method: 'get', asynchronous: false, onSuccess: function(resp) { Reports.data[name] = resp.responseJSON;}});
        return this.data[name];
    },

    display: function(name, opts) {
        var elt = opts ? ($(opts['dest']) || $(name)) : $(name)
        if (this.urls[name].match(/\.json/)) {
            if (elt.hasClassName('ofc')) {
                var w = elt.attributes.width ? elt.attributes.width.value : 800;
                var h = elt.attributes.height ? elt.attributes.height.value : 500;
                //              swfobject.embedSWF("/open-flash-chart.swf", name, w, h, "9.0.0", "expressInstall.swf", {"get-data":"Reports.get_data", "id":name}, {wmode:'transparent'});
                swfobject.embedSWF("/open-flash-chart.swf", elt.id, w, h, "9.0.0", "expressInstall.swf", {"data-file":this.urls[name]}, {wmode:'transparent'});
            } else { 
                // protojs
            }
        } else {
            if (typeof(elt) == 'function') {
                elt.replace('<div id="' + name + '"></div>');
            }
            elt.update('Loading data...');
            new Ajax.Updater(elt.id, this.urls[name], {method:'get'});
        }
    },
    
    display_all: function(opts) {
        $H(this.urls).each(function(pair) { this.display(pair.key, opts) }, this)
    }

}


function check_rtl() {
 if ($$('html').first().dir == 'rtl') {
  document.dir = 'rtl';
  if ($('content')) {
    $('content').setStyle('left:0;text-align:right;right:auto');
  }
  if ($('menu')) {
    $('menu').setStyle('right:0;text-align:right;left:auto');
  }
 }
}
Event.observe(window, 'load', check_rtl); 