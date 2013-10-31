/*
 *  JS:TGV - Javascript/JSON component to edit Literals, Arrays and Hashes
 *  (c) 2009 Sylvain Abelard - Made in France
 *
 *  Based on OpenWFEru densha - open source ruby workflow and bpm engine
 *  (c) 2007-2008 John Mettraux - Made in Japan
 *
 *  JS:TGV and OpenWFEru densha are freely distributable under the terms
 *  of a BSD-style license. JS:TGV makes use of the PrototypeJS framework.
 *
 *  For details, see the OpenWFEru web site: http://openwferu.rubyforge.org
 *
 * USAGE:
 *   // for each TGV field
 *   TGV.newJsonField($('your_html_id'), json_value, editable)
 * 
 * CAVEAT:
 *   IE6 may suffer from lots of events, added because it can't observe Forms
 *
 */

var TGV = function () {
    var idcounter = 0;
    var fields = new Hash();

    function nextId () {
        var id = "f__"+idcounter;
        idcounter += 1;
        return id;
    }

    function createEntry (parent) {
        var elt = new Element("div", {'id': nextId(), 'class': "_entry"});
        $(parent).insert({bottom: elt});
        return elt;
  }

  function renderDelFieldButton (parent, reinit) {
      var id  = nextId();
      var del = null;
        del = new Element('span', {'id': id,
          'onclick': 'TGV.beforeSubmit()',
          'class': "_minus _button " + (reinit ? '_clear' : '_del')}).update( reinit ? "Clear" : "&nbsp;&nbsp;" );

      $(parent).insert({bottom: del});
      del.observe('click', function(x) {TGV.removeEntry(id, reinit);return false});
  }

  function renderAddFieldButton (parent) {
      var id = nextId();
      var eRow = new Element('div', {'id': id});
      var ePlus = new Element('span', {'class': '_plus _button',
          title: 'Adds an entry'}).update('Add entry');
      $(parent).insert(eRow);
      eRow.insert({bottom: ePlus});
      eRow.insert({bottom: ' | '});

      ePlus.observe('click', function(x) {TGV.addField(id);return false});
      renderDelFieldButton(eRow, true);
  }

  //
  // FIELD CLASSES

  var Field = Class.create({
    initialize : function (parent, rw) {
      this.parent = $(parent);
      this.parent.metafield = this;
      this.rw = rw;
    },

    parentClass : function () {
      return this.parent.getAttribute("class");
    },

    findChildFieldWithClass : function (class_name) {
      var children = this.parent.immediateDescendants();

      for (var i=0; i < children.length; i++) {
        var child = children[i];
        if (child.getAttribute("class") == class_name) {
          return child.metafield;
        }
      }
      return null;
    }
  });


  var NoTypeField = Class.create(Field, {
      initialize : function ($super, parent, value, rw) {
          $super(parent, rw);
          this.elementId = nextId();
          this.element = new Element('div',
                                     {'id': this.elementId,
                                      'class': '_no_type_field'});
          this.parent.insert({bottom: this.element});

          this.addType('string');
          if (this.parentClass() != "_key") {
              this.addSpace();
              this.addType('array');
              this.addSpace();
              this.addType('hash');
          }
      },

    addSpace : function () {
        this.element.appendChild(document.createTextNode(" "));
    },

    addType : function (type_name) {
        var elt = new Element('a', {href: '#'}).update(type_name);
        var rw = this.rw;
        this.element.insert({bottom: elt});
	elt.observe('click', function(x) {TGV.replaceField(elt, type_name, rw); return false})
    },

    getValue : function () {
          return null;
    }
  });

  var StringField = Class.create(Field, {
    initialize : function ($super, parent, value, rw) {
      $super(parent, rw);
      this.render(value);
    },

    render : function (value) {
      if (this.rw) {
          this.element =  new Element("input", {'type': 'text', 'class': '_string_input',
          'onchange': 'TGV.beforeSubmit()'});
        // this.element.setAttribute("type", "text");
        // this.element.setAttribute("class", "_string_input");
        this.element.setAttribute("value", value.toString());

        var standalone = false;
        var parentClass = this.parent.getAttribute("class");
        if (parentClass == "_key") { this.element.setAttribute("style", "text-align: right"); }
        else if (parentClass != "_value") { standalone = true; }

        if (standalone) {
                eRow = createEntry(this.parent);
                eRow.appendChild(this.element);
                eBtn = createEntry(eRow);
                renderDelFieldButton(eBtn, true);
        } else { this.parent.appendChild(this.element); }
        // this.element.focus();
      }
      else {
          this.element = new Element("span", {'title': value}).update(value);
          this.parent.insert({bottom: this.element});
      }
    },

    getValue : function () {
      if (this.rw) {return this.element.value.strip(); }
      return this.element.nodeValue;
    }
  });

  var NumberField = Class.create(StringField, {
    getValue : function ($super) {
      return new Number($super());
    }
  });

  var BooleanField = Class.create(StringField, {
    getValue : function ($super) {
      return ($super() == "true");
    }
  });

  var HashEntryField = Class.create(Field, {
    initialize : function ($super, parent, key, value, rw) {
      $super(parent, rw);

        var eKey = new Element('dt', {'class': '_key'});
        this.parent.insert({bottom: eKey});

        if (this.rw) { renderDelFieldButton(eKey, false); }
        newField(eKey, key, rw);

        var eValue = new Element('dd', {'class': '_value'});
        this.parent.insert({bottom: eValue});
        newField(eValue, value, rw);
    },

    getValue : function () {
      cKey = this.findChildFieldWithClass("_key");
      cValue = this.findChildFieldWithClass("_value");
      return [ cKey.getValue(), cValue.getValue() ];
    }
  });


  var HashField = Class.create(Field,
  {
    initialize : function ($super, parent, value, rw) {
      $super(parent, rw);

        this.value = $H(value);
        this.element = new Element('dl', {'class': '_hash'});
        this.parent.insert({bottom: this.element});

        var root = this.element;
        this.value.keys().each(function(key) {
            var eRow = createEntry(root);
            new HashEntryField(eRow, key, value[key], rw);
        });

        if (this.rw) { renderAddFieldButton(root); }
    },

    getValue : function () {
        var result = new Hash();
        var children = this.element.immediateDescendants();
        for (var i=0; i < children.length; i++) {
          var child = $(children[i]);
          if (child.getAttribute("class") != "_entry") { continue; }
          var entryValue = child.metafield.getValue();
          result.set(entryValue[0], entryValue[1]);
        }
        return result;
    }
  });


  var ArrayEntryField = Class.create(Field, {

    initialize : function ($super, parent, key, value, rw) {
      $super(parent, rw);

        var eKey = new Element('li', {'class': '_key'});
        this.parent.insert({bottom: eKey});

        var eValue = new Element('span', {'class': '_value'});
        this.parent.insert({bottom: eValue});

        if (this.rw) { renderDelFieldButton(eValue, false); }
        newField(eValue, value, rw);
    },

    getValue : function () {
      cValue = this.findChildFieldWithClass("_value");
      return cValue.getValue();
    }
  });


  var ArrayField = Class.create(Field, {
    initialize : function ($super, parent, value, rw) {
      $super(parent, rw);

        this.element = new Element('ol', {'class': '_root _array'});
        this.parent.insert({bottom: this.element});

        var root = this.element;
        $A(value).each(function(value) {
            var eRow = createEntry(root);
            new ArrayEntryField(eRow, value, value, rw);
        });

        if (this.rw) { renderAddFieldButton(root); }
    },

    getValue : function () {
        var result = new Array;
        var i = -1;
        var children = this.element.immediateDescendants();
        for (var j=0; j < children.length; j++) {
          var child = children[j];
          if (child.getAttribute("class") != "_entry") { continue; }
	  i += 1;
          result[i] = child.metafield.getValue();
        };
        return result;
    }
  });

  //
  // FIELD BUILDERS

  function newField (parent, value, options) {
      var parentClass = $(parent).getAttribute("class");
      if (value == NoTypeField) {
              if ($(parent).hasClassName("_array"))
                  {   var elt = createEntry(parent);
                      new ArrayEntryField(elt, -1, NoTypeField, options); }
              else if (parent.hasClassName("_hash"))
                  {   var elt = createEntry(parent);
                      new HashEntryField(elt, '', NoTypeField, options); }
              else {
                  new NoTypeField(parent, value, options);
              } // infinite loop ?
      } else if (typeof(value) == "string") {
              new StringField(parent, value, options);
      } else if (typeof(value) == "number") {
              new NumberField(parent, value, options);
      } else if (typeof(value) == "boolean") {
              new BooleanField(parent, value, options);
      } else if (Object.isArray(value)) { new ArrayField(parent, value, options);
      } else if (typeof(value) == 'object') { new HashField(parent, value, options);
      } else { new NoTypeField(parent, value, options); }
  }

    //
    // the PUBLIC stuff

  return {
    newJsonField : function (parent, json_value, rw) {
      if (typeof(json_value) == "string" && json_value.isJSON()) {json_value = json_value.evalJSON(true); }

      // Add observer if form not already observed
      var tgv_form = $(parent).up('form');
      var obs_form = fields.find(function(f) {
        var k = $(f.key); var f_form = k.up('form');
	return (k && f_form && f_form == tgv_form);
      });
      if (tgv_form && typeof(obs_form) == 'undefined') {
        tgv_form.observe('submit', TGV.beforeSubmit);
        tgv_form.select('[type=submit]').map(function(sub) {
          sub.observe('click', TGV.beforeSubmit); });
      }

      fields.set($(parent).id, json_value);
      $(parent).value = Object.toJSON(json_value);
      newField(parent, json_value, rw);
    },

    addField : function (addItemElt, rw) {
      eAddItem = $(addItemElt);
      var parent = eAddItem.parentNode;
      eAddItem.remove();
      newField(parent, NoTypeField, true);
      renderAddFieldButton(parent);
    },

    replaceField : function (target, typename, rw) {
      target = $(target);
      var par = target.parentNode.parentNode;
      target.parentNode.remove();
      var initial_value = (typename == 'string') ? '' : ((typename == 'array') ? (new Array) : (new Object));
      newField(par, initial_value, rw);
    },

    removeEntry : function (button_id, reinit) {
      var button = $(button_id);
      var del = button.parentNode.parentNode;
      if (reinit === true) { newField(del.parentNode, NoTypeField, true); del.remove(); }
      else { del.remove(); }
    },

    extractForIE : function(elt) {
      var e = $(elt);
      if (e.hasClassName('_no_type_field')) {
          return null;
        } else if (e.hasClassName('_entry')) {
	  var str = $F(e.down('input._string_input'));
	} else if (e.hasClassName('_hash')) {
	  var hsh = $H({})
          var children = e.immediateDescendants();
          for (var i=0; i < children.length; i++) {
            var child = $(children[i]);
            if (!child.hasClassName("_entry")) { continue; }
            var hashkey = child.down('dt._key')
            if (hashkey) {hsh.set($F(hashkey.down('input._string_input')),
              TGV.extractForIE(child.down('dd._value').down(0))); }
          }
          return hsh;
	} else if (e.hasClassName('_array')) {

          var result = new Array;
          var i = -1;
          var children = this.element.immediateDescendants();
          for (var j=0; j < children.length; j++) {
            var child = children[j];
            if (child.getAttribute("class") != "_entry") { continue; }
	    i += 1;
            result[i] = TGV.extractForIE(child.down('._value').down('input._string_input'));
          };
          return result;
      }
    },

    beforeSubmit : function () {
      $H(fields).each(function(f) {
        var k = $(f.key);
	if (k) {
          var v = null;
	  if (Prototype.Browser.IE6()) {
            v = Object.toJSON(TGV.extractForIE(k.down(1)));
	  } else if (k.metafield) {
            v = Object.toJSON(k.metafield.getValue());
	  }
	  // v = (Prototype.Version >= "1.7") ? Object.toJSON(v) : v.toJSON();
          fields.set(f.key, v);
          k.down('input').value = v;
        }
      });
      return true; // fields
    }
  };

}();

if (Ajax && Ajax.Responders) {
  Ajax.Responders.register({ onCreate: function(request) { TGV.beforeSubmit() } })
};

