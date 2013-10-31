
(function(){function append(name,method)
{if(!Array.prototype[name])
Array.prototype[name]=method;};append("contains",function(elements){return this.every(function(element){return this.indexOf(element)>=0;},elements);});append("exfiltrate",function(elements){return this.filter(function(element){return this.indexOf(element)<0;},elements);});append("every",function(fn,scope){for(var i=0;i<this.length;i++)
if(!fn.call(scope||window,this[i],i,this))
return false;return true;});append("filter",function(fn,scope){var r=[];for(var i=0;i<this.length;i++)
if(fn.call(scope||window,this[i],i,this))
r.push(this[i]);return r;});append("forEach",function(fn,scope){for(var i=0;i<this.length;i++)
fn.call(scope||window,this[i],i,this);});append("getRange",function(start,end){var items=this;if(items.length<1)
return[];start=start||0;end=Math.min(typeof end=="undefined"?this.length-1:end,this.length-1);var r=[];if(start<=end)
for(var i=start;i<=end;i++)
r[r.length]=items[i];else
for(var i=start;i>=end;i--)
r[r.length]=items[i];return r;});append("indexOf",function(subject,offset){for(var i=offset||0;i<this.length;i++)
if(this[i]===subject)
return i;return-1;});append("inArray",function(subject){for(var i=0;i<this.length;i++)
if(subject==this[i])
return true;return false;});append("insertAt",function(index,element){for(var k=this.length;k>index;k--)
this[k]=this[k-1];this[index]=element;return this;});append("map",function(fn,scope){scope=scope||window;var r=[];for(var i=0;i<this.length;i++)
r[r.length]=fn.call(scope,this[i],i,this);return r;});append("removeAt",function(index){for(var k=index;k<this.length-1;k++)
this[k]=this[k+1];this.length--;return this;});append("randomize",function(){return this.sort(function(){return(Math.round(Math.random())-0.5)});});append("some",function(fn,scope){for(var i=0;i<this.length;i++)
if(fn.call(scope||window,this[i],i,this))
return true;return false;});append("unique",function(){return this.filter(function(element,index,array){return array.indexOf(element)>=index;});});})();(function(){function append(name,method)
{if(!String.prototype[name])
String.prototype[name]=method;}
append("trim",function(){return this.replace(/(^\s+|\s+$)/g,"");});append("ltrim",function(){return this.replace(/^\s*/g,"");});append("rtrim",function(){return this.replace(/\s*$/g,"");});append("collapseSpaces",function(){return this.trim().replace(/\s{2,}/g," ").replace(/{(Keyword):\s*(.*?)\s*}/gi,"{$1:$2}");});append("format",function(substrings){var subRegExp=/(?:%(\d+))/mg,currPos=0,r=[];do
{var match=subRegExp.exec(this);if(match&&match[1])
{if(match.index>currPos)
r.push(this.substring(currPos,match.index));r.push(substrings[parseInt(match[1])]);currPos=subRegExp.lastIndex;}}
while(match);if(currPos<this.length)
r.push(this.substring(currPos,this.length));return r.join("");});append("remove",function(start,length){var s='';if(start>0)
s=this.substring(0,start);if(start+length<this.length)
s+=this.substring(start+length,this.length);return s;});append("reverse",function(){if(!this)
return'';var a=(this+'').split('');a.reverse();return a.join('');});append("repeat",function(count,separator){var t=this,s="";while(--count+1>0)
s+=(separator&&count!=0)?t+separator:t;return s;});append("pad",function(length,ch,direction){length=length||30;direction=direction||0;ch=ch||' ';var t=this;while(t.length<length)
t=(direction==1)?t+=ch:ch+t;return t;});append("capitalize",function(){var w=this.split(' ');for(var i=0;i<w.length;i++)
w[i]=w[i].charAt(0).toUpperCase()+w[i].substring(1).toLowerCase();return w.join(" ");});append("camelize",function(){return this.replace(/[-_]([a-z])/ig,function(z,b){return b.toUpperCase()});});append("truncate",function(length,suffix){length=length||50;suffix=suffix===undefined?"...":suffix;return this.length>length?this.slice(0,length-suffix.length)+suffix:this;});append("stripTags",function(){return this.replace(/<\/?[^>]+>/gi,'');});})();if(!Object.keys){Object.keys=(function(){var hasOwnProperty=Object.prototype.hasOwnProperty,hasDontEnumBug=!{toString:null}.propertyIsEnumerable("toString"),DontEnums=['toString','toLocaleString','valueOf','hasOwnProperty','isPrototypeOf','propertyIsEnumerable','constructor'],DontEnumsLength=DontEnums.length;return function(o){if(typeof o!="object"&&typeof o!="function"||o===null)
throw new TypeError("Object.keys called on a non-object");var result=[];for(var name in o){if(hasOwnProperty.call(o,name))
result.push(name);}
if(hasDontEnumBug){for(var i=0;i<DontEnumsLength;i++){if(hasOwnProperty.call(o,DontEnums[i]))
result.push(DontEnums[i]);}}
return result;};})();}