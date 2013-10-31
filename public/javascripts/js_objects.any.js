(function( window, undefined ) {

if(typeof(window.Control) == "undefined") {window.Control = {}}

//var Control = {

  window.Control.num2LettersFR = function(nb) {
var number = parseInt(nb);
if (isNaN(number) || number < 0 || 999 < number) {
    return 'Veuillez entrer un nombre entier compris entre 0 et 999.';
}
 
var units2Letters = ['', 'un', 'deux', 'trois', 'quatre', 'cinq', 'six', 'sept', 'huit', 'neuf', 'dix', 'onze', 'douze', 'treize', 'quatorze', 'quinze', 'seize', 'dix-sept', 'dix-huit', 'dix-neuf'];
var tens2Letters = ['', 'dix', 'vingt', 'trente', 'quarante', 'cinquante', 'soixante', 'soixante', 'quatre-vingt', 'quatre-vingt'];
 
var units = number % 10,
      tens = (number % 100 - units) / 10,
      hundreds = (number % 1000 - number % 100) / 100;
 
var unitsOut, tensOut, hundredsOut;
 
if (number === 0) {
 return 'zéro';
} else {
 unitsOut = (units === 1 && tens > 0 && tens !== 8 ? 'et ' : '') + units2Letters[units];
 if (tens === 1 && units > 0) {
        tensOut = units2Letters[10 + units];
        unitsOut = '';
 } else if (tens === 7 || tens === 9) {
        tensOut = tens2Letters[tens] +' '+ (tens === 7 && units === 1 ? 'et ' : '') + units2Letters[10 + units];
        unitsOut = '';
 } else {
        tensOut = tens2Letters[tens];
 }
 
 tensOut += (units === 0 && tens === 8 ? 's' : '');
  hundredsOut = (hundreds > 1 ? units2Letters[hundreds] + ' ' : '') + (hundreds > 0 ? 'cent' : '') + (hundreds > 1 && tens == 0 && units == 0 ? 's' : '');
  return hundredsOut + (hundredsOut && tensOut ? ' ': '') + tensOut + (hundredsOut && unitsOut || tensOut && unitsOut ? '-': '') + unitsOut;
}
  }

//}
// window.Control = Control



if(typeof(window.Layout) == "undefined") {window.Layout = {}}

//var Layout = {

  window.Layout.ie_menu = function() {
this.onmouseover = function() {
	this.className += " iehover"
}
this.onmouseout = function() {
	this.className = this.className.replace(new RegExp(" iehover\\b"), "")
}
  };

  window.Layout.loadJSFile = function(js_file) {
var head = document.getElementsByTagName("head")[0];
var script = document.createElement("script");
script.setAttribute("type","text/javascript");
script.setAttribute("src", js_file);
head.appendChild(script);
  };

  window.Layout.setLanguage = function(lg) {
Storage.setCookie('lang', lg, null, '/');
document.location.reload();
  };

  window.Layout.set_document_domain_for_css_editor = function() {
if (document.referrer && document.referrer.split('/')[2].match(/des\..*\.faveod\.com/)) {
  document.domain = 'faveod.com';
}
  }

//}
// window.Layout = Layout


if ((navigator.userAgent.toLowerCase().indexOf('msie 6') != -1)) {
if (typeof(jQuery) != 'undefined') {
jQuery(document).ready(function($) {$("#menu LI").each(Layout.ie_menu)})
} else if (typeof(Prototype) != 'undefined') {
document.observe('dom:loaded', function(ev) { $$("#menu LI").each(function(elt) { Layout.ie_menu.bind(elt)(ev) }) })
} else {
alert("No way to select '#menu LI' for 'ie_menu'")
}
}

window.onload = function() {return Layout.set_document_domain_for_css_editor();}


if(typeof(window.Storage) == "undefined") {window.Storage = {}}

//var Storage = {

  window.Storage.setCookie = function(name, value, expires, path, domain, secure) {
var curCookie = name + "=" + escape(value) + ((expires) ? "; expires=" + (expires == -1 ? -1 : expires.toGMTString()) : "") + 
((path) ? "; path=" + path : "") + ((domain) ? "; domain=" + domain : "") + ((secure) ? "; secure" : ""); 
document.cookie = curCookie;
return document.cookie.indexOf(name) != -1;
  };

  window.Storage.createCookie = function(name,value,days) {
var expires = "";
if (days) {
    var date = new Date();
    date.setTime(date.getTime()+(days*24*60*60*1000));
    expires = "; expires="+date.toGMTString();
}
document.cookie = name+"="+value+expires+"; path=/";
  };

  window.Storage.readCookie = function(name) {
var nameEQ = name + "=",
  i,
  ca = document.cookie.split(';');
for(i=0 ; i < ca.length ; i++) {
    var c = ca[i];
    while (c.charAt(0) == ' ') {c = c.substring(1,c.length); }
    if (c.indexOf(nameEQ) == 0) {return c.substring(nameEQ.length,c.length);}
}
return null;
  };

  window.Storage.eraseCookie = function(name, path) {
document.cookie = name + '=';
Storage.setCookie(name,"",-1,path);
  }

//}
// window.Storage = Storage



if(typeof(window.AjaxTree) == "undefined") {window.AjaxTree = {}}

//var AjaxTree = {

//}
// window.AjaxTree = AjaxTree



if(typeof(window.Report) == "undefined") {window.Report = {}}

//var Report = {

//}
// window.Report = Report



if(typeof(window.Validation) == "undefined") {window.Validation = {}}

//var Validation = {

//}
// window.Validation = Validation



if(typeof(window.TGV2) == "undefined") {window.TGV2 = {}}

//var TGV2 = {

//}
// window.TGV2 = TGV2



if(typeof(window.LeftRightSelector) == "undefined") {window.LeftRightSelector = {}}

//var LeftRightSelector = {

  window.LeftRightSelector.left_right_selector_maj_nb = function(sel) {
if (typeof(jQuery) == 'undefined') {

    var th_in  = $(sel + ' .th_in').innerHTML.replace(/ \(.*\)/, '');
    var th_out = $(sel + ' .th_out').innerHTML.replace(/ \(.*\)/, '');

    $(sel + ' .th_in').update(th_in  + " (" + $$(sel + ' .selector_in LI:not(.hidden)').length + ")");
    $(sel + '.th_out').update(th_out + " (" + $$(sel + ' .selector_out LI:not(.hidden)').length + ")")

} else {

    var th_in  = $(sel + ' .th_in').html().replace(/ \(.*\)/, '');
    var th_out = $(sel + ' .th_out').html().replace(/ \(.*\)/, '');

    $(sel + ' .th_in').html(th_in  + " (" + $(sel + ' .selector_in LI:not(.hidden)').length + ")");
    $(sel + ' .th_out').html(th_out + " (" + $(sel + ' .selector_out LI:not(.hidden)').length + ")")

    $(sel + ' select').change();
}

  }

//}
// window.LeftRightSelector = LeftRightSelector



if(typeof(window.Importer) == "undefined") {window.Importer = {}}

//var Importer = {

//}
// window.Importer = Importer



})(window);