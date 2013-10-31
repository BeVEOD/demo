
Ext.namespace('Ext.ux.plugins');Ext.ux.plugins.TextArea2HtmlEditor=function(config){Ext.apply(this,config);};Ext.extend(Ext.ux.plugins.TextArea2HtmlEditor,Ext.util.Observable,{config:'',onRender:function(htmlEditor){if(this.config!=''){el=Ext.get(this.config);htmlEditor.setValue(el.dom.value);el.remove();}},init:function(htmlEditor){htmlEditor.on('render',this.onRender,this);}});Ext.ux.plugins.InputButton2ExtButton=function(config){Ext.apply(this,config);};Ext.extend(Ext.ux.plugins.InputButton2ExtButton,Ext.util.Observable,{config:'',onRender:function(button){el=Ext.get(this.config);if(el){el.remove();}},init:function(button){el=Ext.get(this.config);if(el){button.setText(el.dom.value);button.type=el.dom.type;Ext.DomHelper.insertAfter(el,{tag:'div',id:this.config});this.config+=button.id;el.dom.id=this.config;}
button.on('render',this.onRender,this);}});Ext.StatePanel=function(config){this.state={};Ext.Panel.superclass.constructor.call(this,config);this.on('collapse',this.onStateCollapse,this);this.on('expand',this.onStateExpand,this);this.initPanelState();};Ext.extend(Ext.StatePanel,Ext.Panel,{onStateCollapse:function(el){this.state.collapsed=true;this.saveState();},onStateExpand:function(el){this.state.collapsed=false;this.saveState();},getState:function(){return this.state;},initPanelState:function(){var state=null;if(Ext.state.Manager)
state=Ext.state.Manager.get(this.stateId||this.id);if(state&&this.fireEvent('beforestaterestore',this,state)!==false){this.collapsed=state.collapsed;this.fireEvent('staterestore',this,state);}}});Ext.reg('statepanel',Ext.StatePanel);function booleanRenderer(val){return val=="true"?'<img src="/images/std/ok.png" alt="Yes"/>':'<img src="/images/std/ko.png" alt="No"/>'}
function buttonRenderer(val){}
Ext.app.SearchField=Ext.extend(Ext.form.TwinTriggerField,{initComponent:function(){Ext.app.SearchField.superclass.initComponent.call(this);this.on('keypress',function(f,e){this.onTrigger2Click();},this);},fireKey:function(e){Ext.app.SearchField.superclass.fireKey.call(this,e);if(!e.isSpecialKey()){this.fireEvent("keypress",this,e);}},trigger1Class:'x-form-clear-trigger',trigger2Class:'x-form-search-trigger',width:180,hasSearch:false,paramName:'query',items:[],onTrigger1Click:function(){if(this.hasSearch){this.el.dom.value='';this.store.clearFilter();this.hasSearch=false;}},onTrigger2Click:function(){var items=this.items;var v=this.getRawValue();var t;if(v.length<1){this.onTrigger1Click();return;}
this.store.filterBy(function(r){valueArr=v.split(/\ +/);for(var j=0;j<valueArr.length;j++){re=new RegExp(Ext.escapeRe(valueArr[j]),"i");keep=false;for(var i=0;i<items.length;i++){if(re.test(r.data[items[i].name])==true){keep=true;}}
if(!keep){return false;}}
return true;});this.hasSearch=true;}});