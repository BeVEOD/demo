(function( window, undefined ) {

if(typeof(window.Control) == "undefined") {window.Control = {}}


Control.setup_global_search = function() {
var fld = $('global_search_field')
var res = $('global_search_results')
var gsi = $('global_search_indicator')

Control.gs_last_request = 0;
Control.gs_last_result = 0;

if (fld && res) {
  new Form.Element.Observer(fld, 0.5,
   function(element, value) {
    if (value == '') {
      res.hide();
    } else if (value.length > 2) {
     Control.gs_last_request = Math.max(Control.gs_last_request, (new Date()).valueOf());
     new Ajax.Request('/smart_queries/global_search.json',
      { asynchronous:true, evalScripts:true,
        parameters:{timestamp: (new Date()).valueOf(), value:value},
        onComplete:function(request){if (gsi) {gsi.hide()}},
        onLoading:function(request){if (gsi) {gsi.show()}},
        onSuccess:function(resp){
var now = resp.responseJSON.timestamp || (new Date()).valueOf();
if (now > Control.gs_last_result) {
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
},

Control.stepper = function(field, mod, opts) {
var max = opts && opts['max'] != 'undefined' && !isNaN(opts['max']) ? opts['max'] : null;
var min = opts && opts['min'] != 'undefined' && !isNaN(opts['min']) ? opts['min'] : null;
var val = parseFloat($F(field));

if (field && !isNaN(val)) {
	val = val + mod;
	if ((max == null || (val <= max)) && (min == null || (val >= min))) {
		$(field).setValue(val);
	}
}
},

Control.restrict_to_numbers = function(event, opts) {
var ok_codes = [8, 9, 109];
if (opts && opts.float) {
   ok_codes.push(188);
   ok_codes.push(190);
}
var kc = event.keyCode;
if (!((kc > 45 && kc < 58) || (kc > 36 && kc < 41) || ok_codes.include(kc) || (kc > 96 && kc < 107))) {
   event.stop();
}
},

Control.ajax_editor = function(evt, url) {
var h = {};
var elt = $(evt.target);
var bgc = elt.getStyle('background-color');
var jax = null;

h[elt.name] = elt.getValue();

jax = new Ajax.Request(url,
 {method:'put',
  parameters:h,
  onLoading:function() { elt.setStyle('background-color:gray'); },
  onComplete:function() { elt.setStyle('background-color:'+ bgc); }
 }
);

},

Control.calendar = function(ev) {
var elt = this;
var filter_change = $(this).up('.filter_bar') ? 'after_close:function(param) { Control.filter_change.bind($(this))() }, ' : '';
var img = '<img alt="Calendar" onclick="new CalendarDateSelect($(this).previous(), {'+filter_change+'time: false, year_range: 10})" src="/images/std/calendar.gif" style="margin-left:3px;border:0px none;cursor:pointer;">';
loadJSFile('/javascripts/calendar_date_select.js');
loadJSFile('/javascripts/calendar_date_select_format_hyphen_ampm.js');
elt.insert({after:img});
},

Control.filter_change = function(event) {
var elt = $(this);

var from_cookie = elt.form.readAttribute('from-cookie') || '';
var reload_to   = elt.form.readAttribute('reload-to') || window.location.pathname;
var mpath	= window.location.pathname.split('/').length > 1 ?
  ('/' + window.location.pathname.split('/')[1]) :
  window.location.pathname;

if (from_cookie.split(':').length > 1) {
  mpath		= from_cookie.split(':')[0];
  from_cookie	= from_cookie.split(':')[1];
} else if (from_cookie.blank()) {
  from_cookie	= 'active_filters';
}

var comp = elt.up().down('.comparator');
var default_comp = null;
if (comp) {
    default_comp = comp.down('option[value!=""]');
    if ($F(comp) == '' || ($F(elt) == '')) {
	comp.setValue( ($F(elt) == '') ? '' : (default_comp ? default_comp.value : '') );
    }
}

Storage.setCookie(from_cookie, Storage.jsonify_form(elt.up('FORM')), '', mpath);
if (!(elt.hasClassName('comparator') && elt.next('INPUT,SELECT') && elt.next('INPUT,SELECT').getValue().blank())) {

  var frm = elt.up('form');
  if (frm && (!frm.down('input[type=submit], input.submit') || (event && event.keyCode == 13) )) {
    var act = frm.readAttribute('reload-to');
    if (act && !act.blank()) { window.location.pathname = act; }
    else { window.location.reload(); }
  }
}
},

Control.filter_forms = function(ev) {
var form = this;
var from_cookie = form.readAttribute('from-cookie') || '';
var reload_to   = form.readAttribute('reload-to') || window.location.pathname;
var mpath	= window.location.pathname.split('/').length > 1 ?
  ('/' + window.location.pathname.split('/')[1]) :
  window.location.pathname;

if (from_cookie.split(':').length > 1) {
  mpath		= from_cookie.split(':')[0];
  from_cookie	= from_cookie.split(':')[1];
} else if (from_cookie.blank()) {
  from_cookie	= 'active_filters';
}

form.select('INPUT[type=text], TEXTAREA').each(function(elt) {
  elt.observe('keypress', function(event) {
    if (event.keyCode == 13) {
     event.stop();
     Control.filter_change.bind(elt)(event);
    }
  });
});

if (form.down('INPUT[type=reset]')) {
  form.select('INPUT[type=reset]').each(function(elt) {
    elt.observe('click', function(event) {
      Storage.setCookie(from_cookie, '', '', mpath);
      window.location.pathname = reload_to;
    });
  });
}

if (form.down('INPUT[type=submit]')) {
  form.select('INPUT[type=submit]').each(function(elt) {
    elt.observe('click', function(event) {
     Storage.setCookie(from_cookie, Storage.jsonify_form(elt.up('FORM')), '', mpath);
     window.location.pathname = reload_to;
    });
  });
}

form.select('SELECT, INPUT, TEXTAREA').each(function(elt) {
  elt.observe('change', Control.filter_change);
});

// pre-fill forms
var active_filters = Storage.readCookie(from_cookie);
if (active_filters) {
  var h = $H(unescape(active_filters).evalJSON(true));
  Storage.unjsonify_form(form, h);
}

if (Prototype.Browser.Gecko) {
  form.select('LABEL').each(function(l) {l.setAttribute('for', '');});
}
},

Control.position_moves = function(event) {
event.stop();
var t = $(this);
if (t.readAttribute('data-update')) {
  new Ajax.Updater(t.readAttribute('data-update'), t.readAttribute('href'), {
    method:t.readAttribute('data-ajax-method'),
    onComplete:function() {
      $(t.readAttribute('data-update')).select('A.position_move[data-ajax]').each(function(elt) {
        elt.observe("click", Control.position_moves)
      })
    }
  })
} else {
  new Ajax.Request(t.readAttribute('href'), {method:t.readAttribute('data-ajax-method')})
}
}




Event.observe(window, "load", Control.setup_global_search)

document.observe('dom:loaded', function(ev) { $$("INPUT.calendar").each(function(elt) { Control.calendar.bind(elt)(ev) }) })

document.observe('dom:loaded', function(ev) { $$("FORM.filter_bar").each(function(elt) { Control.filter_forms.bind(elt)(ev) }) })

document.observe('dom:loaded', function() { $$("A.position_move[data-ajax]").each(function(elt) { elt.observe("click", Control.position_moves) })})


if(typeof(window.Layout) == "undefined") {window.Layout = {}}


Layout.build_menubar = function(ev) {
var menuid = this.id,
    t = 0,
    ultags = $(menuid).getElementsByTagName("ul"),
    newtop, parent_ul, newleft,
    omov = function() { this.getElementsByTagName("ul")[0].setStyle({visibility: "visible", zIndex:99999999}); },
    omou = function(){ this.getElementsByTagName("ul")[0].setStyle({visibility:"hidden"}); } ;
for (t ; t < ultags.length; t++) {
	if (ultags[t].parentNode.parentNode.id == menuid) { //if this is a first level submenu
		newtop = ultags[t].parentNode.offsetHeight;
		if (newtop) { $(ultags[t]).setStyle({top: newtop +"px"}); } //dynamically position first level submenus to be height of main menu item
		ultags[t].parentNode.getElementsByTagName("a")[0].className="mainfoldericon";
	}
	else{ //else if this is a sub level menu (ul)
		parent_ul = ultags[t].parentNode.parentNode;
		newleft = parent_ul.getElementsByTagName("a")[0].offsetWidth;
		if (newleft) {$(ultags[t]).setStyle({left: newleft+"px"}); } //position menu to the right of menu item that activated it
		ultags[t].parentNode.getElementsByTagName("a")[0].className="subfoldericon";
	}
	ultags[t].parentNode.onmouseover = omov;
	ultags[t].parentNode.onmouseout = omou;
}
},

Layout.getFirstFormElements = function(fs, opts) {
var elts = [];
fs.getElementsBySelector('LABEL').each(function(elt) {
	if (($(elt.parentNode).getStyle('float') == '' || $(elt.parentNode).getStyle('float') == 'none') && !elt.hasClassName('not-aligned') && !elt.up('FIELDSET.not-aligned') && !elt.up('TABLE.table_container') && elt.visible() && elt.getStyle('display') == 'block') {
		cand = elt.getElementsBySelector('INPUT[type!=hidden]', 'SELECT', 'TEXTAREA', '.aligned').select(function(e) {
			return e.getStyle('display') != 'none' && e.className != 'mceSelectList' && e.className != 'x-font-select' && !e.hasClassName('not-aligned');
		});
		if (cand.length > 0) { elts.push(cand.first()); }
	}
});
return elts.uniq();
},

Layout.alignValues = function(sel, opts) {
var fss = (typeof(sel) == 'string') ? $$(sel) : $A([$(this)]);
var max = null;
var dir = null;
var float_val = null;
var elts = null;
var l = null;
if (!fss) {return;}

fss.each(function(fs) {
float_val = fs.getStyle('float');
if (float_val == 'right' || float_val == 'left') { fs.setStyle('float:none'); }
elts = [];
if (opts) {
	elts = opts.only ? fs.getElementsBySelector(opts.only) : Layout.getFirstFormElements(fs, opts);
} 
else {
	elts = Layout.getFirstFormElements(fs);
}
if (elts.length > 1) {
	max = 0;
	dir = document.getElementsByTagName('HTML')[0].dir;
	elts.each(function(elt) {
		l = 0;
		elt.setStyle({marginLeft : '0px'});
		if (dir == 'rtl') {
			l = $(elt.parentNode).getWidth() - Position.positionedOffset(elt)[0] - elt.getWidth();
		} 
		else {
		  if (elt.tagName == 'SPAN' && elt.innerHTML == '') { elt.insert('&nbsp;'); }
		     l = Position.positionedOffset(elt)[0];
		}
		if (l > max) { max = l; }
	 });
	 elts.each(function(elt) {
		if (dir == 'rtl') {
			elt.parentNode.style.marginRight = (max - ($(elt.parentNode).getWidth() - Position.positionedOffset(elt)[0] - elt.getWidth()))+ 'px';
		} 
		else {
			elt.up('label').setStyle({marginLeft : ((max - Position.positionedOffset(elt)[0]) + 'px')});
		}
	  });
}
if (float_val == 'right' || float_val == 'left') { fs.setStyle('float:'+ float_val); }
});
},

Layout.check_rtl = function() {
if ($$('html').first().dir == 'rtl') {
  document.dir = 'rtl';
  if ($('content')) {
    $('content').setStyle('left:0;text-align:right;right:auto');
  }
  if ($('menu')) {
    $('menu').setStyle('right:0;text-align:right;left:auto');
  }
}
},

Layout.print_element_id = function(elt, title) {
var text = $(elt).innerHTML;
var winId = window.open('','newwin');

winId.document.write('<html><head><title>'+title+'<\/title><link href="/stylesheets/print.css" media="all" rel="Stylesheet" type="text/css" /><\/head><body onload="window.focus();window.print()">'+text+'<\/body><\/html>');
winId.document.close();

},

Layout.disp_lang = function(elt) {
var s;
if ($(elt) === 'undefined') {
		var t = elt.split('_');
		var id = t.pop();
		t[t.length-1] = id;
		if ($(t.join('_'))) {disp_lang(t.join('_'));}
	} else {
		var sib = $(elt).siblings();
		var sib_c = sib[0].getElementsByTagName("li"); /* ul */
		/* for (var c=0; c<sib_c.length; c++) {sib_c[c].className = '';} */
		for (s=1; s<sib.length; s++) {sib[s].hide();}
		$(elt).show();
	}
},

Layout.tab_select = function(event) {
var div = $(this);
div.select('LABEL').each(Element.hide);

display_selected = function(ev) {
  var index = $(this).up().immediateDescendants().indexOf($(this));
  if (!index){ index = 0; }
  div.select('LABEL').each(Element.hide);
  $(this).siblings().each(function(tab) { tab.removeClassName("current"); });
  $(this).addClassName("current");
  div.select('LABEL')[index].show();
};

div.down('UL.tabs').select('LI').each(function(li) {
  li.on('click', display_selected);
});

display_selected.bind(div.down('LI.current') || div.down('LI:first-child'))();
},

Layout.collapsible_fieldset = function() {
if ($(this)) { $(this).up('FIELDSET').toggleClass('collapsed'); }

},

Layout.toggle_display = function(id) {
$(id).toggle();
},

Layout.ajax_window = function(event) {
event.stop();
var t = $(this);

var current_window_win = new Window(t.readAttribute('data-window'), {
	destroyOnClose: true, title: t.innerHTML, zIndex: 1100, center: true, width: 400}
);
current_window_win.showCenter();
current_window_win.setAjaxContent(t.readAttribute('href'), {method:(t.readAttribute('data-ajax-method') || 'get')});
},

Layout.list_rows_default_actions = function(event) {
var t = $(this), action;
var ctrl = t.id.match(/(.*)_(\d+)/)[1];
var id = t.id.match(/(.*)_(\d+)/)[2];
if (ctrl && id) {
  action = event.altKey ? 'edit' : 'show';
  window.location = ('/' + ctrl + '/' + action + '/' + id);
}
}




document.observe('dom:loaded', function(ev) { $$("#main-menubar").each(function(elt) { Layout.build_menubar.bind(elt)(ev) }) })

document.observe('dom:loaded', function(ev) { $$(".align_fields").each(function(elt) { Layout.alignValues.bind(elt)(ev) }) })

Event.observe(window, "load", Layout.check_rtl)

document.observe('dom:loaded', function(ev) { $$(".multi_field").each(function(elt) { Layout.tab_select.bind(elt)(ev) }) })

document.observe('dom:loaded', function() { $$("#content FIELDSET LEGEND").each(function(elt) { elt.observe("click", Layout.collapsible_fieldset) })})

document.observe('dom:loaded', function() { $$("A[data-window]").each(function(elt) { elt.observe("click", Layout.ajax_window) })})

document.observe('dom:loaded', function() { $$("#content TABLE TBODY TR").each(function(elt) { elt.observe("dblclick", Layout.list_rows_default_actions) })})


if(typeof(window.Storage) == "undefined") {window.Storage = {}}


Storage.jsonify_form = function(f) {
var hf = new Hash();
$(f).select('SELECT[id^=comp_].comparator').each(function(elt) {
  var label = elt.up('LABEL');
  var sid = label.readAttribute('data-field') || elt.up('LABEL').readAttribute('for');
  var val = (elt.next() ? $F(elt.next('INPUT, SELECT, TEXTAREA')) : '');
  if (!$F(elt).blank() && (($F(elt).match(/NULL/) != null) || (elt.next().multiple ? (val.length > 0) : !val.blank()))) {
    var t = hf.get(sid) || new Hash();

    if (elt.hasClassName('date')) {
	var fdate = Date.parseFormattedString(val);
	var db_date =	fdate.getFullYear().toString() +
			Date.padded2(fdate.getMonth()+1) +
			Date.padded2(fdate.getDate());
	t.set($F(elt), db_date);
    }
    else if (label.down('SELECT:not(.comparator)') && (label.hasClassName('input_date') || label.hasClassName('input_datetime') || label.hasClassName('input_time'))) {
	t.set($F(elt), Storage.rails_date_selects_to_string(label));
    } else {
	t.set($F(elt), val);
    }
    hf.set(sid, t);
  }
});
$(f).select('UL.mselect INPUT:checked').each(function(i) {
  var sid = i.up('ul.mselect').readAttribute('data-field');
  var t = hf.get(sid) || new Hash();
  var val = t.get('IN') || [];
  val.push(i.getValue());
  t.set('IN', val);
  hf.set(sid, t);
});

return Object.toJSON(hf.toObject());

},

Storage.unjsonify_form = function(frm, hf) {
var openable = $$('.full_filters').length > 0;
hf.each(function(pair) {
   var sid = pair.key;

   $H(pair.value).each(function(cp) {
    var op  = cp.key;
    var val = cp.value;

    var myop =  $(frm).down('[data-field="' + sid + '"] OPTION[value="' + op + '"]');
    var comp = myop ? myop.up() : null;
    var lbl  = comp.up('LABEL, UL');

    if (comp && op && val) {
      var fld = comp.next('INPUT, SELECT, TEXTAREA');

      if (fld && (op != comp.getValue() || val != fld.getValue())) {
	comp.setValue(op);
	fld.setValue(val);
	if (comp.hasClassName('date')) {
	  var d = val.match(new RegExp("([0-9]{4})([0-9]{2})([0-9]{2})", "i"));
	  var fr_date = (d == null) ? '' : new Date(d[1], d[2]-1, d[3]).toFormattedString();
	  fld.setValue(fr_date);
	} else {
	  fld.setValue(val);
	}
      }
     }

     if (lbl && openable && lbl.up('.full_filters')) {
       var full = lbl.up('.full_filters');
       if (!full.visible()) {full.show();}
     }
     if (lbl && !comp) {
       lbl.select('LI INPUT:checked').each(function(i) {
         i.checked = $A(val).include(i.getValue());
       });
     }
    });
});

},

Storage.rails_date_selects_to_string = function(lab) {
var res = "";
if ($(lab).hasClassName('input_date') || $(lab).hasClassName('input_datetime')) {
   res += $(lab).down("SELECT[id$=_1i]").getValue() + "-" + $(lab).down("SELECT[id$=_2i]").getValue() + "-" + $(lab).down("SELECT[id$=_3i]").getValue();
}
if ($(lab).hasClassName('input_time') || $(lab).hasClassName('input_datetime')) {
   if ($(lab).hasClassName('input_datetime')) { res += " ";}
   res += $(lab).down("SELECT[id$=_4i]").getValue() + ":" + $(lab).down("SELECT[id$=_5i]").getValue();
}
return res;
}





if(typeof(window.AjaxTree) == "undefined") {window.AjaxTree = {}}


AjaxTree.tree_children_toggle = function(e, ctrl) {

var elt=$(e);var img=elt.down('IMG.collapser');var jax=null;if(elt.hasClassName('children_loaded')){elt.select('DIV.tree_element').each(function(e){e.toggle();});}else{if(img.src.match('minus.gif')){elt.select('DIV.tree_element').each(function(e){e.toggle();});}else{jax=new Ajax.Updater(elt.id,'/'+ctrl+'/tree_list/'+elt.id.gsub(/[^\d]/,''),{insertion:Insertion.Bottom,asynchronous:true,evalScripts:true,onSuccess:function(){elt.addClassName('children_loaded');},onLoading:function(){img.src="/images/std/indicator.gif";},onComplete:function(){img.src="/images/std/minus.gif";}});}}
img.src=img.src.match('minus.gif')?"/images/std/plus.gif":"/images/std/minus.gif";
}





if(typeof(window.Report) == "undefined") {window.Report = {}}


Report.display = function(name, opts) {
var elt = opts ? ($(opts['dest']) || $(name)) : $(name);
var upd = null;

if (!this.urls) {this.urls = {}; }

if (this.urls[name].match(/(\.|=)json/)) {
  if (elt.hasClassName('ofc')) {
    var w = elt.attributes.width ? elt.attributes.width.value : 800;
    var h = elt.attributes.height ? elt.attributes.height.value : 500;
	swfobject.embedSWF("/open-flash-chart.swf", elt.id, w, h, "9.0.0", "expressInstall.swf", {"data-file":this.urls[name]}, {wmode:'transparent'});
  } // else { /* protojs */ }
} else {
  if (typeof(elt) == 'function') {
    elt.replace('<div id="' + name + '"></div>');
  }
  elt.update('Loading data...');
  upd = new Ajax.Updater(elt.id, this.urls[name], {method:'get'});
}

},

Report.display_all = function(opts) {
$H(this.urls || {}).each(function(pair) { this.display(pair.key, opts) ;}, this);
}





if(typeof(window.Validation) == "undefined") {window.Validation = {}}






if(typeof(window.TGV2) == "undefined") {window.TGV2 = {}}






if(typeof(window.LeftRightSelector) == "undefined") {window.LeftRightSelector = {}}






if(typeof(window.Importer) == "undefined") {window.Importer = {}}


Importer.darken = function() {
$$('.command_button').map(function (x) {x.disable();}); $('importer_loading').show(); $('darken').show();

},

Importer.setup = function() {
$('import_result_div').setStyle('width:'+document.viewport.getWidth()-16+'px');

}




Event.observe(window, "load", function(ev) { $$("#import_result_div").each(function(elt) {Importer.setup.bind(elt)(ev) }) })


})(window);