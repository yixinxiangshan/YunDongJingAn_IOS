function $A(a){if(!a)return[];if("toArray"in Object(a))return a.toArray();for(var b=a.length||0,c=Array(b);b--;)c[b]=a[b];return c}function $w(a){return Object.isString(a)?(a=a.strip(),a?a.split(/\s+/):[]):[]}function $H(a){return new Hash(a)}function $R(a,b,c){return new ObjectRange(a,b,c)}var Prototype={Version:1.7,ScriptFragment:"<script[^>]*>([\\S\\s]*?)</script\\s*>",JSONFilter:/^\/\*-secure-([\s\S]*)\*\/\s*$/,emptyFunction:function(){},K:function(a){return a}},Abstract={},Try={these:function(){for(var a,b=0,c=arguments.length;c>b;b++){var d=arguments[b];try{a=d();break}catch(e){}}return a}},Class=function(){function b(){}function c(){function d(){this.initialize.apply(this,arguments)}var a=null,c=$A(arguments);Object.isFunction(c[0])&&(a=c.shift()),Object.extend(d,Class.Methods),d.superclass=a,d.subclasses=[],a&&(b.prototype=a.prototype,d.prototype=new b,a.subclasses.push(d));for(var e=0,f=c.length;f>e;e++)d.addMethods(c[e]);return d.prototype.initialize||(d.prototype.initialize=Prototype.emptyFunction),d.prototype.constructor=d,d}function d(b){var c=this.superclass&&this.superclass.prototype,d=Object.keys(b);a&&(b.toString!=Object.prototype.toString&&d.push("toString"),b.valueOf!=Object.prototype.valueOf&&d.push("valueOf"));for(var e=0,f=d.length;f>e;e++){var g=d[e],h=b[g];if(c&&Object.isFunction(h)&&"$super"==h.argumentNames()[0]){var i=h;h=function(a){return function(){return c[a].apply(this,arguments)}}(g).wrap(i),h.valueOf=function(a){return function(){return a.valueOf.call(a)}}(i),h.toString=function(a){return function(){return a.toString.call(a)}}(i)}this.prototype[g]=h}return this}var a=function(){for(var a in{toString:1})if("toString"===a)return!1;return!0}();return{create:c,Methods:{addMethods:d}}}();(function(){function r(a){switch(a){case null:return c;case void 0:return d}var b=typeof a;switch(b){case"boolean":return e;case"number":return f;case"string":return g}return h}function s(a,b){for(var c in b)a[c]=b[c];return a}function t(a){try{return K(a)?"undefined":null===a?"null":a.inspect?a.inspect():a+""}catch(b){if(b instanceof RangeError)return"...";throw b}}function u(a){return v("",{"":a},[])}function v(b,c,d){var e=c[b];r(e)===h&&"function"==typeof e.toJSON&&(e=e.toJSON(b));var f=a.call(e);switch(f){case k:case j:case l:e=e.valueOf()}switch(e){case null:return"null";case!0:return"true";case!1:return"false"}var g=typeof e;switch(g){case"string":return e.inspect(!0);case"number":return isFinite(e)?e+"":"null";case"object":for(var i=0,n=d.length;n>i;i++)if(d[i]===e)throw new TypeError("Cyclic reference to '"+e+"' in object");d.push(e);var o=[];if(f===m){for(var i=0,n=e.length;n>i;i++){var p=v(i,e,d);o.push(p===void 0?"null":p)}o="["+o.join(",")+"]"}else{for(var q=Object.keys(e),i=0,n=q.length;n>i;i++){var b=q[i],p=v(b,e,d);p!==void 0&&o.push(b.inspect(!0)+":"+p)}o="{"+o.join(",")+"}"}return d.pop(),o}}function w(a){return JSON.stringify(a)}function x(a){return $H(a).toQueryString()}function y(a){return a&&a.toHTML?a.toHTML():String.interpret(a)}function z(a){if(r(a)!==h)throw new TypeError;var c=[];for(var d in a)b.call(a,d)&&c.push(d);if(q)for(var e=0;d=p[e];e++)b.call(a,d)&&c.push(d);return c}function A(a){var b=[];for(var c in a)b.push(a[c]);return b}function B(a){return s({},a)}function C(a){return!(!a||1!=a.nodeType)}function D(b){return a.call(b)===m}function F(a){return a instanceof Hash}function G(b){return a.call(b)===i}function H(b){return a.call(b)===l}function I(b){return a.call(b)===k}function J(b){return a.call(b)===n}function K(a){return a===void 0}var a=Object.prototype.toString,b=Object.prototype.hasOwnProperty,c="Null",d="Undefined",e="Boolean",f="Number",g="String",h="Object",i="[object Function]",j="[object Boolean]",k="[object Number]",l="[object String]",m="[object Array]",n="[object Date]",o=false,p=["toString","toLocaleString","valueOf","hasOwnProperty","isPrototypeOf","propertyIsEnumerable","constructor"],q=function(){for(var a in{toString:1})if("toString"===a)return!1;return!0}(),E="function"==typeof Array.isArray&&Array.isArray([])&&!Array.isArray({});E&&(D=Array.isArray),s(Object,{extend:s,inspect:t,toJSON:o?w:u,toQueryString:x,toHTML:y,keys:Object.keys||z,values:A,clone:B,isElement:C,isArray:D,isHash:F,isFunction:G,isString:H,isNumber:I,isDate:J,isUndefined:K})})(),Object.extend(Function.prototype,function(){function b(a,b){for(var c=a.length,d=b.length;d--;)a[c+d]=b[d];return a}function c(c,d){return c=a.call(c,0),b(c,d)}function d(){var a=(""+this).match(/^[\s\(]*function[^(]*\(([^)]*)\)/)[1].replace(/\/\/.*?[\r\n]|\/\*(?:.|[\r\n])*?\*\//g,"").replace(/\s+/g,"").split(",");return 1!=a.length||a[0]?a:[]}function e(b){if(2>arguments.length&&Object.isUndefined(arguments[0]))return this;if(!Object.isFunction(this))throw new TypeError("The object is not callable.");var d=function(){},e=this,f=a.call(arguments,1),g=function(){var a=c(f,arguments),d=this instanceof g?this:b;return e.apply(d,a)};return d.prototype=this.prototype,g.prototype=new d,g}function f(c){var d=this,e=a.call(arguments,1);return function(a){var f=b([a||window.event],e);return d.apply(c,f)}}function g(){if(!arguments.length)return this;var b=this,d=a.call(arguments,0);return function(){var a=c(d,arguments);return b.apply(this,a)}}function h(b){var c=this,d=a.call(arguments,1);return b=1e3*b,window.setTimeout(function(){return c.apply(c,d)},b)}function i(){var a=b([.01],arguments);return this.delay.apply(this,a)}function j(a){var c=this;return function(){var d=b([c.bind(this)],arguments);return a.apply(this,d)}}function k(){if(this._methodized)return this._methodized;var a=this;return this._methodized=function(){var c=b([this],arguments);return a.apply(null,c)}}var a=Array.prototype.slice,l={argumentNames:d,bindAsEventListener:f,curry:g,delay:h,defer:i,wrap:j,methodize:k};return Function.prototype.bind||(l.bind=e),l}()),function(a){function b(){return this.getUTCFullYear()+"-"+(this.getUTCMonth()+1).toPaddedString(2)+"-"+this.getUTCDate().toPaddedString(2)+"T"+this.getUTCHours().toPaddedString(2)+":"+this.getUTCMinutes().toPaddedString(2)+":"+this.getUTCSeconds().toPaddedString(2)+"Z"}function c(){return this.toISOString()}a.toISOString||(a.toISOString=b),a.toJSON||(a.toJSON=c)}(Date.prototype),RegExp.prototype.match=RegExp.prototype.test,RegExp.escape=function(a){return(a+"").replace(/([.*+?^=!:${}()|[\]\/\\])/g,"\\$1")};var PeriodicalExecuter=Class.create({initialize:function(a,b){this.callback=a,this.frequency=b,this.currentlyExecuting=!1,this.registerCallback()},registerCallback:function(){this.timer=setInterval(this.onTimerEvent.bind(this),1e3*this.frequency)},execute:function(){this.callback(this)},stop:function(){this.timer&&(clearInterval(this.timer),this.timer=null)},onTimerEvent:function(){if(!this.currentlyExecuting)try{this.currentlyExecuting=!0,this.execute(),this.currentlyExecuting=!1}catch(a){throw this.currentlyExecuting=!1,a}}});Object.extend(String,{interpret:function(a){return null==a?"":a+""},specialChar:{"\b":"\\b","	":"\\t","\n":"\\n","\f":"\\f","\r":"\\r","\\":"\\\\"}}),Object.extend(String.prototype,function(){function prepareReplacement(a){if(Object.isFunction(a))return a;var b=new Template(a);return function(a){return b.evaluate(a)}}function gsub(a,b){var e,c="",d=this;if(b=prepareReplacement(b),Object.isString(a)&&(a=RegExp.escape(a)),!a.length&&!a.source)return b=b(""),b+d.split("").join(b)+b;for(;d.length>0;)e=d.match(a),e&&e[0].length>0?(c+=d.slice(0,e.index),c+=String.interpret(b(e)),d=d.slice(e.index+e[0].length)):(c+=d,d="");return c}function sub(a,b,c){return b=prepareReplacement(b),c=Object.isUndefined(c)?1:c,this.gsub(a,function(a){return 0>--c?a[0]:b(a)})}function scan(a,b){return this.gsub(a,b),this+""}function truncate(a,b){return a=a||30,b=Object.isUndefined(b)?"...":b,this.length>a?this.slice(0,a-b.length)+b:this+""}function strip(){return this.replace(/^\s+/,"").replace(/\s+$/,"")}function stripTags(){return this.replace(/<\w+(\s+("[^"]*"|'[^']*'|[^>])+)?>|<\/\w+>/gi,"")}function stripScripts(){return this.replace(RegExp(Prototype.ScriptFragment,"img"),"")}function extractScripts(){var a=RegExp(Prototype.ScriptFragment,"img"),b=RegExp(Prototype.ScriptFragment,"im");return(this.match(a)||[]).map(function(a){return(a.match(b)||["",""])[1]})}function evalScripts(){return this.extractScripts().map(function(script){return eval(script)})}function escapeHTML(){return this.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;")}function unescapeHTML(){return this.stripTags().replace(/&lt;/g,"<").replace(/&gt;/g,">").replace(/&amp;/g,"&")}function toQueryParams(a){var b=this.strip().match(/([^?#]*)(#.*)?$/);return b?b[1].split(a||"&").inject({},function(a,b){if((b=b.split("="))[0]){var c=decodeURIComponent(b.shift()),d=b.length>1?b.join("="):b[0];void 0!=d&&(d=decodeURIComponent(d)),c in a?(Object.isArray(a[c])||(a[c]=[a[c]]),a[c].push(d)):a[c]=d}return a}):{}}function toArray(){return this.split("")}function succ(){return this.slice(0,this.length-1)+String.fromCharCode(this.charCodeAt(this.length-1)+1)}function times(a){return 1>a?"":Array(a+1).join(this)}function camelize(){return this.replace(/-+(.)?/g,function(a,b){return b?b.toUpperCase():""})}function capitalize(){return this.charAt(0).toUpperCase()+this.substring(1).toLowerCase()}function underscore(){return this.replace(/::/g,"/").replace(/([A-Z]+)([A-Z][a-z])/g,"$1_$2").replace(/([a-z\d])([A-Z])/g,"$1_$2").replace(/-/g,"_").toLowerCase()}function dasherize(){return this.replace(/_/g,"-")}function inspect(a){var b=this.replace(/[\x00-\x1f\\]/g,function(a){return a in String.specialChar?String.specialChar[a]:"\\u00"+a.charCodeAt().toPaddedString(2,16)});return a?'"'+b.replace(/"/g,'\\"')+'"':"'"+b.replace(/'/g,"\\'")+"'"}function unfilterJSON(a){return this.replace(a||Prototype.JSONFilter,"$1")}function isJSON(){var a=this;return a.blank()?!1:(a=a.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g,"@"),a=a.replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g,"]"),a=a.replace(/(?:^|:|,)(?:\s*\[)+/g,""),/^[\],:{}\s]*$/.test(a))}function evalJSON(sanitize){var json=this.unfilterJSON(),cx=/[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g;cx.test(json)&&(json=json.replace(cx,function(a){return"\\u"+("0000"+a.charCodeAt(0).toString(16)).slice(-4)}));try{if(!sanitize||json.isJSON())return eval("("+json+")")}catch(e){}throw new SyntaxError("Badly formed JSON string: "+this.inspect())}function parseJSON(){var a=this.unfilterJSON();return JSON.parse(a)}function include(a){return this.indexOf(a)>-1}function startsWith(a){return 0===this.lastIndexOf(a,0)}function endsWith(a){var b=this.length-a.length;return b>=0&&this.indexOf(a,b)===b}function empty(){return""==this}function blank(){return/^\s*$/.test(this)}function interpolate(a,b){return new Template(this,b).evaluate(a)}var NATIVE_JSON_PARSE_SUPPORT=false;return{gsub:gsub,sub:sub,scan:scan,truncate:truncate,strip:String.prototype.trim||strip,stripTags:stripTags,stripScripts:stripScripts,extractScripts:extractScripts,evalScripts:evalScripts,escapeHTML:escapeHTML,unescapeHTML:unescapeHTML,toQueryParams:toQueryParams,parseQuery:toQueryParams,toArray:toArray,succ:succ,times:times,camelize:camelize,capitalize:capitalize,underscore:underscore,dasherize:dasherize,inspect:inspect,unfilterJSON:unfilterJSON,isJSON:isJSON,evalJSON:NATIVE_JSON_PARSE_SUPPORT?parseJSON:evalJSON,include:include,startsWith:startsWith,endsWith:endsWith,empty:empty,blank:blank,interpolate:interpolate}}());var Template=Class.create({initialize:function(a,b){this.template=""+a,this.pattern=b||Template.Pattern},evaluate:function(a){return a&&Object.isFunction(a.toTemplateReplacements)&&(a=a.toTemplateReplacements()),this.template.gsub(this.pattern,function(b){if(null==a)return b[1]+"";var c=b[1]||"";if("\\"==c)return b[2];var d=a,e=b[3],f=/^([^.[]+|\[((?:.*?[^\\])?)\])(\.|\[|$)/;if(b=f.exec(e),null==b)return c;for(;null!=b;){var g=b[1].startsWith("[")?b[2].replace(/\\\\]/g,"]"):b[1];if(d=d[g],null==d||""==b[3])break;e=e.substring("["==b[3]?b[1].length:b[0].length),b=f.exec(e)}return c+String.interpret(d)})}});Template.Pattern=/(^|.|\r|\n)(#\{(.*?)\})/;var $break={},Enumerable=function(){function a(a,b){try{this._each(a,b)}catch(c){if(c!=$break)throw c}return this}function b(a,b,c){var d=-a,e=[],f=this.toArray();if(1>a)return f;for(;(d+=a)<f.length;)e.push(f.slice(d,d+a));return e.collect(b,c)}function c(a,b){a=a||Prototype.K;var c=!0;return this.each(function(d,e){if(c=c&&!!a.call(b,d,e,this),!c)throw $break},this),c}function d(a,b){a=a||Prototype.K;var c=!1;return this.each(function(d,e){if(c=!!a.call(b,d,e,this))throw $break},this),c}function e(a,b){a=a||Prototype.K;var c=[];return this.each(function(d,e){c.push(a.call(b,d,e,this))},this),c}function f(a,b){var c;return this.each(function(d,e){if(a.call(b,d,e,this))throw c=d,$break},this),c}function g(a,b){var c=[];return this.each(function(d,e){a.call(b,d,e,this)&&c.push(d)},this),c}function h(a,b,c){b=b||Prototype.K;var d=[];return Object.isString(a)&&(a=RegExp(RegExp.escape(a))),this.each(function(e,f){a.match(e)&&d.push(b.call(c,e,f,this))},this),d}function i(a){if(Object.isFunction(this.indexOf)&&-1!=this.indexOf(a))return!0;var b=!1;return this.each(function(c){if(c==a)throw b=!0,$break}),b}function j(a,b){return b=Object.isUndefined(b)?null:b,this.eachSlice(a,function(c){for(;a>c.length;)c.push(b);return c})}function k(a,b,c){return this.each(function(d,e){a=b.call(c,a,d,e,this)},this),a}function l(a){var b=$A(arguments).slice(1);return this.map(function(c){return c[a].apply(c,b)})}function m(a,b){a=a||Prototype.K;var c;return this.each(function(d,e){d=a.call(b,d,e,this),(null==c||d>=c)&&(c=d)},this),c}function n(a,b){a=a||Prototype.K;var c;return this.each(function(d,e){d=a.call(b,d,e,this),(null==c||c>d)&&(c=d)},this),c}function o(a,b){a=a||Prototype.K;var c=[],d=[];return this.each(function(e,f){(a.call(b,e,f,this)?c:d).push(e)},this),[c,d]}function p(a){var b=[];return this.each(function(c){b.push(c[a])}),b}function q(a,b){var c=[];return this.each(function(d,e){a.call(b,d,e,this)||c.push(d)},this),c}function r(a,b){return this.map(function(c,d){return{value:c,criteria:a.call(b,c,d,this)}},this).sort(function(a,b){var c=a.criteria,d=b.criteria;return d>c?-1:c>d?1:0}).pluck("value")}function s(){return this.map()}function t(){var a=Prototype.K,b=$A(arguments);Object.isFunction(b.last())&&(a=b.pop());var c=[this].concat(b).map($A);return this.map(function(b,d){return a(c.pluck(d))})}function u(){return this.toArray().length}function v(){return"#<Enumerable:"+this.toArray().inspect()+">"}return{each:a,eachSlice:b,all:c,every:c,any:d,some:d,collect:e,map:e,detect:f,findAll:g,select:g,filter:g,grep:h,include:i,member:i,inGroupsOf:j,inject:k,invoke:l,max:m,min:n,partition:o,pluck:p,reject:q,sortBy:r,toArray:s,entries:s,zip:t,size:u,inspect:v,find:f}}();Array.from=$A,function(){function d(a,b){for(var c=0,d=this.length>>>0;d>c;c++)c in this&&a.call(b,this[c],c,this)}function e(){return this.length=0,this}function f(){return this[0]}function g(){return this[this.length-1]}function h(){return this.select(function(a){return null!=a})}function i(){return this.inject([],function(a,b){return Object.isArray(b)?a.concat(b.flatten()):(a.push(b),a)})}function j(){var a=b.call(arguments,0);return this.select(function(b){return!a.include(b)})}function k(a){return(a===!1?this.toArray():this)._reverse()}function l(a){return this.inject([],function(b,c,d){return 0!=d&&(a?b.last()==c:b.include(c))||b.push(c),b})}function m(a){return this.uniq().findAll(function(b){return-1!==a.indexOf(b)})}function n(){return b.call(this,0)}function o(){return this.length}function p(){return"["+this.map(Object.inspect).join(", ")+"]"}function q(a,b){if(null==this)throw new TypeError;var c=Object(this),d=c.length>>>0;if(0===d)return-1;if(b=Number(b),isNaN(b)?b=0:0!==b&&isFinite(b)&&(b=(b>0?1:-1)*Math.floor(Math.abs(b))),b>d)return-1;for(var e=b>=0?b:Math.max(d-Math.abs(b),0);d>e;e++)if(e in c&&c[e]===a)return e;return-1}function r(a,b){if(null==this)throw new TypeError;var c=Object(this),d=c.length>>>0;if(0===d)return-1;Object.isUndefined(b)?b=d:(b=Number(b),isNaN(b)?b=0:0!==b&&isFinite(b)&&(b=(b>0?1:-1)*Math.floor(Math.abs(b))));for(var e=b>=0?Math.min(b,d-1):d-Math.abs(b);e>=0;e--)if(e in c&&c[e]===a)return e;return-1}function s(){var e,c=[],d=b.call(arguments,0),f=0;d.unshift(this);for(var g=0,h=d.length;h>g;g++)if(e=d[g],!Object.isArray(e)||"callee"in e)c[f++]=e;else for(var i=0,j=e.length;j>i;i++)i in e&&(c[f]=e[i]),f++;return c.length=f,c}function t(a){return function(){if(0===arguments.length)return a.call(this,Prototype.K);if(void 0===arguments[0]){var c=b.call(arguments,1);return c.unshift(Prototype.K),a.apply(this,c)}return a.apply(this,arguments)}}function u(a){if(null==this)throw new TypeError;a=a||Prototype.K;for(var b=Object(this),c=[],d=arguments[1],e=0,f=0,g=b.length>>>0;g>f;f++)f in b&&(c[e]=a.call(d,b[f],f,b)),e++;return c.length=e,c}function v(a){if(null==this||!Object.isFunction(a))throw new TypeError;for(var e,b=Object(this),c=[],d=arguments[1],f=0,g=b.length>>>0;g>f;f++)f in b&&(e=b[f],a.call(d,e,f,b)&&c.push(e));return c}function w(a){if(null==this)throw new TypeError;a=a||Prototype.K;for(var b=arguments[1],c=Object(this),d=0,e=c.length>>>0;e>d;d++)if(d in c&&a.call(b,c[d],d,c))return!0;return!1}function x(a){if(null==this)throw new TypeError;a=a||Prototype.K;for(var b=arguments[1],c=Object(this),d=0,e=c.length>>>0;e>d;d++)if(d in c&&!a.call(b,c[d],d,c))return!1;return!0}function z(a,b){b=b||Prototype.K;var c=arguments[2];return y.call(this,b.bind(c),a)}var a=Array.prototype,b=a.slice,c=a.forEach;if(c||(c=d),a.map&&(u=t(Array.prototype.map)),a.filter&&(v=Array.prototype.filter),a.some)var w=t(Array.prototype.some);if(a.every)var x=t(Array.prototype.every);var y=a.reduce;if(!a.reduce)var z=Enumerable.inject;Object.extend(a,Enumerable),a._reverse||(a._reverse=a.reverse),Object.extend(a,{_each:c,map:u,collect:u,select:v,filter:v,findAll:v,some:w,any:w,every:x,all:x,inject:z,clear:e,first:f,last:g,compact:h,flatten:i,without:j,reverse:k,uniq:l,intersect:m,clone:n,toArray:n,size:o,inspect:p});var A=function(){return 1!==[].concat(arguments)[0][0]}(1,2);A&&(a.concat=s),a.indexOf||(a.indexOf=q),a.lastIndexOf||(a.lastIndexOf=r)}();var Hash=Class.create(Enumerable,function(){function a(a){this._object=Object.isHash(a)?a.toObject():Object.clone(a)}function b(a,b){var c=0;for(var d in this._object){var e=this._object[d],f=[d,e];f.key=d,f.value=e,a.call(b,f,c),c++}}function c(a,b){return this._object[a]=b}function d(a){return this._object[a]!==Object.prototype[a]?this._object[a]:void 0}function e(a){var b=this._object[a];return delete this._object[a],b}function f(){return Object.clone(this._object)}function g(){return this.pluck("key")}function h(){return this.pluck("value")}function i(a){var b=this.detect(function(b){return b.value===a});return b&&b.key}function j(a){return this.clone().update(a)}function k(a){return new Hash(a).inject(this,function(a,b){return a.set(b.key,b.value),a})}function l(a,b){return Object.isUndefined(b)?a:(b=String.interpret(b),b=b.gsub(/(\r)?\n/,"\r\n"),b=encodeURIComponent(b),b=b.gsub(/%20/,"+"),a+"="+b)}function m(){return this.inject([],function(a,b){var c=encodeURIComponent(b.key),d=b.value;if(d&&"object"==typeof d){if(Object.isArray(d)){for(var h,e=[],f=0,g=d.length;g>f;f++)h=d[f],e.push(l(c,h));return a.concat(e)}}else a.push(l(c,d));return a}).join("&")}function n(){return"#<Hash:{"+this.map(function(a){return a.map(Object.inspect).join(": ")}).join(", ")+"}>"}function o(){return new Hash(this)}return{initialize:a,_each:b,set:c,get:d,unset:e,toObject:f,toTemplateReplacements:f,keys:g,values:h,index:i,merge:j,update:k,toQueryString:m,inspect:n,toJSON:f,clone:o}}());Hash.from=$H,Object.extend(Number.prototype,function(){function a(){return this.toPaddedString(2,16)}function b(){return this+1}function c(a,b){return $R(0,this,!0).each(a,b),this}function d(a,b){var c=this.toString(b||10);return"0".times(a-c.length)+c}function e(){return Math.abs(this)}function f(){return Math.round(this)}function g(){return Math.ceil(this)}function h(){return Math.floor(this)}return{toColorPart:a,succ:b,times:c,toPaddedString:d,abs:e,round:f,ceil:g,floor:h}}());var ObjectRange=Class.create(Enumerable,function(){function a(a,b,c){this.start=a,this.end=b,this.exclusive=c}function b(a,b){var d,c=this.start;for(d=0;this.include(c);d++)a.call(b,c,d),c=c.succ()}function c(a){return this.start>a?!1:this.exclusive?this.end>a:this.end>=a}return{initialize:a,_each:b,include:c}}());
var $ = {};
var $O = {
	TAG: "JS-System",
  clearInflated : function(){
    return clearInflated();
  },
  getPageId : function(){
    return getPageId();
  },
  callWidgetMethod : function(controlId,methodName,param1,param2){
    callWidgetMethod(controlId,methodName,param1,param2);
  },
  getLocalUserInfo : function(params){
    return getLocalUserInfo(params);
  },
  putLocalUserInfo :function(params){
    //TODO
  },
  inflateApp: function(codeString){
    inflateApp(codeString);
  },
  getDecorateConfig : function(){
    return getDecorateConfig();
  },
	getTextView: function(id) {
//		with(utilityNames) {
//			return JsViewUtility.GetTextViewById(id);
//		}
	},
	textViewSetText: function(id, text) {
//		with(utilityNames) {
//			$O.getTextView(id).setText(text);
//		}
	},
  isLogin : function(){
    return isUserLogin();
  },
  saveUserName : function(username){
    saveUserName(username);
  },
  getUserName: function(){
    return getUserName();
  },

  deleteUserName : function()
  {
    deleteUserName();
  },
	toast : function(msg){
    toast(msg);
  },
  putPageParams : function(params){
    putPageParams(params);
  },
  putPageParam : function(key,value){
    putPageParam(key,value);
  },
  getPageParam : function(key){
    var str = getPageParam(key);
    return String(str);
  },
  getValuePurpose : function(control_id, desc, bundle_string){
    return getValuePurpose(control_id, desc, bundle_string);
  },
	getJsonFile: function(filename) {
		return $O.getFile(filename).evalJSON();
	},
  
  getPushToken: function(){
    return getPushToken();
  },
	//获取 asses 或 raw 的文件文本内容
	getFile: function(filename) {
//		with(utilityNames) {
//			var str = JsUtility.getSysFileString(filename);
//		}
//		return String(str);
	},
	writeFile: function(filename, content) {

	},
	// 缓存
  putCache: function(sort1, sort2, md5, content, cache_time) {
        if (!cache_time)
            cache_time = 10;
        var obj = {}
        if (sort1 != null && typeof sort1 != "undefined")
            obj.sort1 = sort1;
        if (sort2 != null && typeof sort2 != "undefined")
            obj.sort2 = sort2;
        if (md5 != null && typeof md5 != "undefined")
            obj.md5 = md5;
        if (content != null && typeof content != "undefined")
            obj.content = content;
        obj.cache_time = cache_time;
        var para = Object.toJSON(obj)
        putCache(para)
    },
  getCache: function(sort1, sort2, md5) {
        var obj = {}
        if (sort1 != null && typeof sort1 != "undefined")
            obj.sort1 = sort1;
        if (sort2 != null && typeof sort2 != "undefined")
            obj.sort2 = sort2;
        if (md5 != null && typeof md5 != "undefined")
            obj.md5 = md5;
        var para = Object.toJSON(obj)
        return getCache(para)
	},
  removeCaches: function(sort1, sort2, md5) {
        var obj = {}
        if (sort1 != null && typeof sort1 != "undefined")
            obj.sort1 = sort1;
        if (sort2 != null && typeof sort2 != "undefined")
            obj.sort2 = sort2;
        if (md5 != null && typeof md5 != "undefined")
            obj.md5 = md5;
        var para = Object.toJSON(obj)
        removeCaches(para)
    },
	setCache: function(data, file) {
//		with(utilityNames) {
//			JsUtility.writeCacheString(data, file);
//		}
	},
	getDeviceId: function() {
//		with(utilityNames) {
//			var str = JsUtility.getDeviceId();
//		}
//		return String(str);
	},
	getPackageName: function() {
//		with(utilityNames) {
//			var str = JsUtility.getPackageName();
//		}
//		return String(str);
	},
  getAppVersion : function(){
    var appVersion = getAppVersion();
    return parseFloat(appVersion);
  },
  checkNewVersion : function(){
    return parseFloat(checkNewVersion());
  },
	// 长期保存在应用的配置
	getPreference: function(key) {
		return getPreference(key);
	},
	setPreference: function(key, value) {
    setPreference(key,value);
	},
	// app配置读取
	getApiKey: function() {
//		with(utilityNames) {
//			var str = JsUtility.GetApiKey();
//		}
//		return String(str);
	},
	getApiSecret: function() {
//		with(utilityNames) {
//			var str = JsUtility.GetApiSecret();
//		}
//		return String(str);
	},
	getDebugState: function() {
//		with(utilityNames) {
//			var str = JsUtility.GetDebugState();
//		}
//		return Boolean(str);
	},
	showAlert: function(msg, okTag) {
		$O.showConfirm(msg, okTag, "");
	},
	showConfirm: function(msg, okTag, cancelTag) {
		$O.postEvent("showConfirm", msg, okTag, cancelTag);
	},
	openOutUrl: function(url) {
		$O.postEvent("openWebBrowser", url, null, null);
	},
	finishNowActivity: function(params) {
		$O.postEvent("closeActivity", params, null, null);
	},
	postEvent: function(method, p1, p2, p3) {
			postEvent(method, p1, p2, p3);
	},
	getResouceId: function(resid, type) {
//		with(utilityNames) {
//			var str = JsUtility.getResouceId(resid, type);
//		}
//		return String(str);
	},
	getFormParams: function() {
//		with(utilityNames) {
//			var str = JsUtility.getFormParams();
//		}
//		return String(str);
	},
	setViewAttr: function(selector, methodName, params) {
		try {
//			with(utilityNames) {
//				JsViewUtility.setViewAttr(selector, methodName, params);
//			}
		} catch (e) {
			$L.E($O.TAG, "setViewAttr error:" + e);
		}
	},
	getViewAttr: function(selector, methodName) {
		var res = [];
		try {
//			with(utilityNames) {
//				var arr = JsViewUtility.getViewAttr(selector, methodName);
//
//				for (var i = 0; i < arr.size(); i++) {
//					res.push(String(arr.get(i)))
//				}
//			}
		} catch (e) {
			$L.E($O.TAG, "getViewAttr error:" + e);
		}
		return res;
	},
	// 设置view事件
	setViewEvent: function(selector, type, eventDealStr) {
		try {
			// $L.D($O.TAG, "setViewEvent :" + selector);
//			with(utilityNames) {
//				JsViewUtility.setViewEvent(selector, type, eventDealStr);
//			}
		} catch (e) {
			$L.E($O.TAG, "setViewEvent error:" + e);
		}
	},
	// 检测是否由旧版软件
	checkInstalledPackage: function(packageName) {
//		with(utilityNames) {
//			var bool = JsUtility.checkInstalledPackage(packageName);
//		}
		return Boolean(bool);
	},
	// 卸载软件
	uninstallApp: function(packageName) {
//		with(utilityNames) {
//			JsUtility.uninstallApp(packageName);
//		}
	},
	addTag: function(hashM, widgetViewId, fatherViewId) {
//		with(utilityNames) {
//			JsViewUtility.addTag(hashM, widgetViewId, fatherViewId);
//		}
	},
	getTag: function(key, widgetViewId, fatherViewId) {
//		with(utilityNames) {
//			var str = JsViewUtility.getTag(key, widgetViewId, fatherViewId);
//		}
		return String(str);
	},
	setContentView: function(layoutname) {
//		with(utilityNames) {
//			JsViewUtility.setContentView($O.getResouceId(layoutname, "layout"));
//		}
	},
	initWidgetConfig: function(json) {
//		with(utilityNames) {
//			JsViewUtility.initWidgetConfig(json);
//		}
	},
	openVideo: function(uri) {
//		with(utilityNames) {
//			JsViewUtility.openVideo(uri);
//		}
	},
	openQRCapture: function() {
    openQRCapture();
	},
	getLocation: function(locationgTag) {
    getLocation(locationgTag);
	},
  httpPost: function(url, data){
//    var res = "";
//    with(utilityNames) {
//       $L.D(this.TAG, "$H(data):" + $H(data).toQueryString());
//      var res = JsUtility.HttpRequest(url, $H(data).toQueryString(), $C.scopeid);
//    }
//    return res;
  },
  getWebHtml : function(template, data){
    var tpl_name = "_"+Math.floor(Math.random()*100000000);
    $.template_set(tpl_name , template);
    jsonData = {
      "input":data.evalJSON()
    };
    $L.D("System", "web template  "+template);
    $L.D("System", "web jsonData  = "+Object.toJSON(jsonData));
    var html = $.template(tpl_name,jsonData);
    $L.D("System", "web Html = "+html);
    return html;
  },
	// session文件
	getSession: function() {},
	writeSession: function() {},
	_e: null
};
alert = $O.showAlert;
confirm = $O.showConfirm;

(function($) {
    self = this
    self._tpl = {}

    $["template"] = function(tmpl, data) {
        return (template(tmpl, data));
    }

    $["tmpl"] = function(tmpl, data) {
        return $(template(tmpl, data));
    }

    $['template_set'] = function(name , value){
        self._tpl[name] = value
    }
    $['getISUrl'] = function(id, width, height) {
      var size;
      if (typeof id !== "string") {
        id = id.url.split("/")[id.url.split("/").length - 1];
      }
      size = "";
      if (width) {
        if (!height) {
          size = "_" + width;
        } else {
          size = "_" + width + "x" + height;
        }
      } else {
        if (height) {
          size = "_x" + height;
        }
      }
      return "http://is.hudongka.com/" + (id.split('.')[0]) + size + "." + (id.split('.')[1]);
    }
    
    $['template_get'] = function(name){
        return self._tpl[name]
    }
    var template = function(str, data) {
        //If there's no data, let's pass an empty object so the user isn't forced to.
        if (!data)
            data = {};
        return tmpl(str, data);
    };
    
    (function() {
      var cache = {};
      this.tmpl = function tmpl(str, data) {
          // // var fn = !/\W/.test(str) ? cache[str] = cache[str] || tmpl(document.getElementById(str).innerHTML) : new Function("obj", "var p=[],print=function(){p.push.apply(p,arguments);};" + "with(obj){p.push('" + str.replace(/[\r\t\n]/g, " ").replace(/'(?=[^%]*%>)/g, "\t").split("'").join("\\'").split("\t").join("'").replace(/<%=(.+?)%>/g, "',$1,'").split("<%").join("');").split("%>").join("p.push('") + "');}return p.join('');");
        var fn = !/\W/.test(str) ? cache[str] = cache[str] || tmpl($.template_get(str)) : new Function("obj", "var p=[],print=function(){p.push.apply(p,arguments);};" + "with(obj){p.push('" + str.replace(/[\r\t\n]/g, " ").replace(/'(?=[^%]*%>)/g, "\t").split("'").join("\\'").split("\t").join("'").replace(/<%=(.+?)%>/g, "',$1,'").split("<%").join("');").split("%>").join("p.push('") + "');}return p.join('');");
        return data ? fn(data) : fn;
      };
    })();
})($);

// 控制器逻辑部分
var $C = {
	scopeid : 0,
	controller : null,
	handle : function(url,scopeid){
		// 参数解析
		var match = url.strip().match(/ecct\:\/\/([a-zA-Z0-9]*[-_]?[a-zA-Z0-9])+(\/[a-zA-Z0-9]*[-_]?[a-zA-Z0-9])*(.*)*/);
		$C.sync = (url.substr(0,5) != "pecct");
		$L.D("handle","match:"+match);
		if (!match)
			return false;
		if (!match[2])
			match[2] = "index";
		if (!match[3])
			match[3] = "";
		return $C.handleAction(match[1],match[2].replace("/",""),scopeid,match[3].toQueryParams());
	},
	handleAction : function(controller,action,scopeid,params){
		var tag = "action - "+controller+"."+action;
    var res = "";
		try {
			$L.D(tag,"input :"+params);
			var ctl = eval("new "+controller.capitalize() + 'Controller');
			$C.scopeid = scopeid;
			res = Object.toJSON( ctl[action](params) ) || "";
			$L.D(tag,"output:"+res);
		} catch(e) {
			$L.E(tag,e.toString());
		}
		return res;
	},
	exit : function(){
		$_C = null;
		$L = null
	},
	_e:null
};

var LogHandler = Class.create({
	initialize: function(params) {
		this.ErrorInfo = []
	},
	I:function(tag,msg){
		this.sysMsg({msg:msg,tag:tag,type:"Info"});
	},
	D:function(tag,msg){
		if ($M._debug)
			this.sysMsg({msg:msg,tag:tag,type:"Debug"});
	},
	W:function(tag,msg){
		this.sysMsg({msg:msg,tag:tag,type:"Warning"});
	},
	E:function(tag,msg){
		this.sysMsg({msg:msg,tag:tag,type:"Error"});
		this.ErrorInfo.push(msg);
	},
	sysMsg:function(params){
		// 参数
		if (!params.msg)
			this.msg = "";
		if (!this.tag)
			this.tag = "";
		// 执行
		if (this[$M._env+"Log"])
			this[$M._env+"Log"](params);
		else
			this.ErrorInfo.push("环境类型"+$M._env+"不存在，请检查设置。");
	},
	javaLog : function(params){
		java.lang.System.out.println(params.type+" : ["+params.tag+"] : " + params.msg);  
	},
	iosLog : function(params){
		
		switch (params.type){
			case "Info":
				NSLog("Info : "+params.msg);
			break;
			case "Debug":
				NSLog("Debug : "+params.msg);
			break;
			case "Warning": 
				NSLog("Warning : "+params.msg);
			break;
			case "Error":
				NSLog("Error : "+params.msg);
			break;
		}
		
	},
	_e:null
});
var $L = new LogHandler();

// 控制器逻辑部分
var AppController = Class.create({
	initialize: function() {
		this.name = "JS - app"
		this.callback = null;
		// $C.controller = this;
	},
	eval: function(params){
    if(typeof params != "undefined"){
  		$L.D(this.name , "params : "+params);
  		$L.D(this.name , "params : "+Object.toJSON(params));
    }
		return String(eval(params['cmd']));
	},
	// 选择器测试
	testSelector: function(){
		$O.setViewAttr("#activity_item_container_llayout .title , #fullscreen_loading_indicator TextView", "setText", "CharSequence:abcdefghijklmnopqrst");
		$O.setViewAttr("#activity_item_container_llayout", "setPadding", "DipPx:20 DipPx:20 DipPx:20 DipPx:20");
		$O.setViewAttr("#icon", "setImageResource", "ResDrawable:activity_demo_tab_icon_groups");
		$O.setViewAttr("#title", "setBackgroundResource", "ResDrawable:general_btn_ok_small_press");
		$O.setViewAttr("#subtitle", "setText", "CharSequence:" + $O.getViewAttr("TextView", "getText").join("-"));
		$O.setViewEvent("#button","click",encodeURIComponent("alert('click button','ecct://app/null')"));
		$O.setViewEvent("#subtitle6 ","click",encodeURIComponent("alert('click subtitle6','ecct://app/null')"));
	},
	exitConfim: function() {
		confirm("退出程序，确认？", "pecct://app/closeApp", "pecct://app/null");
	},
  testLog: function(params){
    $L.D(this.name , params);
//      NSLog(params);
  },
	startCheck: function() {
		token = Ajax.getToken();
		if (!token) {
			token = Ajax.getNewToken();
		}
		$L.D(this.name, token);
		// 如果token没获取到，清除token，退出软件
		if (typeof token != "string" || token.length != 32) {
			Ajax.saveToken("");
			return alert("网络请求失败，请在有网络的环境开启软件！", "pecct://app/closeApp");
		}
		// 提示版本更新
		if (!this.checkVersion()) {
			this.initApp();
		}
		 this.startNotiService();
	},
	checkVersion: function(params) {
		var newversion = this.versionIsNew();
		if (newversion == true) {
			if (params) alert("您当前已经是最新版本了！", "pecct://app/null");
			else return false;
		} else {
			var url = "pecct://app/downNewApp/?" + Object.toQueryString({
				url: newversion
			})
			confirm("有新版本，请点击确定下载更新！", url, "pecct://app/null");
			return true;
		}
	},
	openActivity : function(params){
			var actionbardata ={
				'withActionBar':'true',
				'withHomeItem':'true',
				'withHomeAsUp':'true',
				'title':params.title
			};
			var detailForm = {
				'contentid':params.id,
				'cmsSortId':params.cmsSortId,
				'barconfig':actionbardata,
				'title':params.title
			};
      var openString = "openActivity";
      if(params.openType == "openActivityWithFinished"){
        openString = "openActivityWithFinished";
      }
		$O.postEvent(openString, "" , params.pageName, Object.toJSON(detailForm));
	},
	alert : function(params){
		alert(params.word,"pecct://app/null");
	},
	toast : function(params){
		$O.toast(params.message);
	},
	showLoadingDialog_default_params: {
		"title": "加载中",
		"loadingMessage":"正在加载……"
	},
	showLoadingDialog : function(params){
		var requestparams = Object.cloneExtend(this.showLoadingDialog_default_params, params);
		$O.postEvent("showLoadingDialog",requestparams.title,requestparams.loadingMessage,false);
	},
	versionIsNew : function(){
		var res = Ajax.callAPI("project.getappinfo",{}, "1.0" ,true);
		$L.D(this.name , res);
//		$L.D(this.name , "res data:"+res.evalJSON().data);
//		$L.D(this.name , "point_message:"+res.evalJSON().data.point_data["point_message"]);
		if (res.evalJSON().data.point_data && res.evalJSON().data.point_data["point_message"]){
//			alert(res.evalJSON().data.point_data["point_message"],"pecct://app/null");
		}
		if(res.evalJSON().data && res.evalJSON().data.NewEdition){
			res = res.evalJSON().data.NewEdition;
			$L.D(this.name, "VersionNum:" + res.VersionNum + " - getAppVersion:" + $O.getAppVersion());
			if (parseFloat(res.VersionNum) > parseFloat($O.getAppVersion())) {
				return res.DownloadUrl;
			}
		}
		return true;
	},
	sendEmail: function(params) {
		$O.postEvent("sendEmail", params.title, params.mail, null);
	},
	callPhoneNumber: function(params) {
		$O.postEvent("callPhoneNumber", params.number, null, null);
	},
	//分享
	shareString: function(params) {
		$O.postEvent("shareString", params.text, null, null);
	},
	clearCache: function(params) {
		$O.clearCache();
    alert(params.word,"pecct://app/null");
	},
  openDialog: function(params) {
     $O.postEvent("openDialog", params.title, params.controlId, null);
	},
  openOutUrl: function(params) {
	  $O.openOutUrl(params.url);
	},
	downNewApp: function(params) {
		$O.openOutUrl(params.url);
		$O.finishNowActivity();
	},
	finishNowActivity : function(){
		$O.finishNowActivity(null);
	},
	finishNowActivity : function(params){
		$O.finishNowActivity(params.successUri);
	},
	closeApp: function() {
		$O.finishNowActivity();
	},
	initApp: function() {

		if($cfg.start_controller){
			$O.postEvent("openActivityWithFinished", "" ,$cfg.start_controller, "", null);
		}
		if ($cfg.uninstall_package && $O.checkInstalledPackage($cfg.uninstall_package)) {
			confirm($cfg.appname + "已全面升级，系统检测到您装有旧版本的软件，请点击“确认”卸载旧版软件。", "pecct://app/uninstallApp?package_name=" + $cfg.uninstall_package, "pecct://app/null");
		}
	},

	// 启动 notiSetvice
	startNotiService: function() {
    
		$O.postEvent("startNotiService", null, null, null, null);
	},
	// 查询服务器获取push信息
	checkPushInfo: function() {
		var res = Ajax.callAPI("content.getmypush", {}, "1.0", true);
		$L.D(this.name, res);
		res = res.evalJSON();
		$L.D(this.name, "start");
		if (res.data && res.data['PushInfo']) {
			$L.D(this.name, "in");
			var str1 = {
				"title": res.data['PushInfo'].CmsContentTitle,
				"iconName": "proj_icon",
				"notiActivityTag": "pecct://news/item?id=" + res.data['PushInfo'].CmsContentId + "&_refresh=true"
			};
			$O.postEvent("showNotification", Object.toJSON(str1), null, null, null);
		}

		$L.D(this.name, "end");
	},
	uninstallApp: function(params) {
		$O.uninstallApp(params.package_name);
	},
	'null': function(params) {
		$L.D(this.name, params.p);
	},
	getJsonFile : function(params){
		return $O.getJsonFile(params.fileName);
	},
  getWebHtml : function(params){
    return $O.getWebHtml(params.template, params.data);
  },
	_e: null
});

// 控制器逻辑部分
var ApplyController =  Class.create({
	initialize: function() {
		this.name = "apply";
		this.callback = null;
		$C.controller = this;
	},
	TAG:"JS-ApplyController",
	addApply_default_params: {
		"act_apply_id": 0,
		"text1": "",
		"text3": "",
		"text4": "",
		"text5": ""
	},
	// 报名
	apply : function(params){
		// params.viewtype = "apply";
		var requestparams = Object.cloneExtend(this.addApply_default_params, params);
		var res = this.addApply(requestparams);
	},
	//添加报名
	addApply : function(params){

		if(!params.text1||!params.text3){
			return alert("姓名或电话不能为空!", "pecct://app/null");	
		}

		var p = {
			act_apply_id: params.act_apply_id,
			text1: params.text1,
			text3: params.text3,
			text4: params.text4,
			text5: params.text5
		};
		var res = Ajax.callAPI("user.addapply",
			p, "1.0" ,true).evalJSON();

		var err = Ajax.checkError(res);
		if (err) return alert(err.errordes, "pecct://app/null");
		else return alert("报名成功！", "pecct://app/finishNowActivity");
	},
	_e:null
});

// 控制器逻辑部分
ContentController = Class.create({
	initialize: function() {
		this.name = "order"
	},
	TAG: "JS-ContentController",
	getcontentinfo: function(params) {
		var newParams = {
			"shopid": params.contentid
		};
		// $L.D(this.TAG, "newParams   = " + Object.toJSON(newParams));
      if ("true" == $O.getPreference(params.contentid)) {
	      	$O.postEvent("openActivity", "", "page_signin_changguan", Object.toJSON(newParams), null);
      }else{
          $O.postEvent("openActivity", "", "page_disclaimer", Object.toJSON(newParams), null);
      }
	},
	getMaterialInfo: function(params) {
		$L.D(this.TAG, "params   = " + Object.toJSON(params));
		$L.D(this.TAG, "params.productId = " + params.productId);
		var res = Ajax.callAPI("Product.get", {
			key: params.productId
		}, "1.0", true).evalJSON();
		var err = Ajax.checkError(res);
		if (err) return alert(err.errordes, "pecct://app/null");

// 数据容错处理
		if (!res.data || res.data == null || typeof res.data.error != "undefined") res = {
			ListByType: []
		};
		else res = res.data;
		$L.D(this.TAG, "response string  = " + Object.toJSON(res));
		var gralleryString = {
			"imgs": res.typeimgs
		};
    
    var groupString = {"groupList":[]}
		var videoUrl = ""
    if (res.type[0].video_url != "") {
    	videoUrl = "pecct://activity/openVideo?id=" + res.type[0].id + "&type="+res.type[0].type+"&videoUri=" + res.type[0].video_url;
			var videoTab = {
				"tableList": [{
					"tag": videoUrl,
					"title": "查看视频"
				}]
			}
			groupString.groupList.push(videoTab);
		}
    var baoxiuTab = {
  			"tableList": [{
					"tag": "pecct://content/baoxiu?contentid=" + res.info.id + "&title=" + res.info.title + "&address=" + encodeURIComponent(res.info.abstract) + "",
					"title": "设备报修"
				}]
			}
  groupString.groupList.push(baoxiuTab);

		$L.D(this.TAG, "itemString   = " + Object.toJSON(gralleryString));
   
		var newParams = {
      "shopid":res.shop[0].id,
			"title": res.info.title,
			"itemString": res.type[0],
			"cardString": res.info,
			"gralleryString": gralleryString,
			"groupString": groupString
		};
    
		$L.D(this.TAG, "newParams   = " + Object.toJSON(newParams));
//		$O.postEvent("openActivity", "", "page_signin_material", Object.toJSON(newParams), null);
     var pageName = "page_signin_material";
    if(typeof params.pageName != "undefined" && params.pageName !="" && params.pageName !=null){
        pageName = params.pageName;
    }
  	$O.postEvent("openActivity", "", pageName, Object.toJSON(newParams), null);
	},
	baoxiu: function(params) {
		var newdata = {
			ListByType: []
		};
		var item = {
			title: params.title,
			abstracts: params.address
		};
		newdata.ListByType.push(item);
		var newParams = {
			"contentid": parseInt(params.contentid),
			"shopInfo": newdata
		};
		$O.postEvent("openActivity", "", "page_fragment_apply", Object.toJSON(newParams), null);
	},
	openQRCapture: function() {
		alert(0);
		$O.openQRCapture();
	},
	_e: null
});

// 控制器逻辑部分
var HttpController = Class.create({

  initialize: function() {
    this.name = "http";
    this.callback = null;
    this.appconfig = null;
    this.token = null;
    // $C.controller = this;
  },

  TAG: "JS-HttpController",
  api_key: "",
  client_sectret: "",

  // token_url: "http://api.nowapp.cn/oauth/token",
  // api_url: "http://api.nowapp.cn/api/",
//  token_url: "http://openapi.nowapp.cn/oauth/token",
//  api_url: "http://openapi.nowapp.cn/api",
  token_url: "http://856854478.cloudapi.nowapp.cn/oauth/token/",
  api_url: "http://856854478.cloudapi.nowapp.cn/api/",

  // 如果没有token，直接返回false
  callAPI: function(method, params, version, force_new) {
    if (!force_new) force_new = false;
    return this.postApi(method, params, version, false, force_new);
  },
  callAPIThread: function(method, params, version, success) {
    this.postApi(method, params, version, success);
  },
  postApi: function(method, params, version, success, force_new) {
    $L.D(this.TAG, "method:" + method + ", force_new: " + force_new);
    // 读取缓存
    var saveparam = params;
    var filename = hex_md5($H(saveparam).toQueryString());
    if (!force_new) {
      var cachetime = $O.getCache(filename + "_time");
      if ("" != cachetime && 86400000 > (new Date()).getTime() - parseInt(cachetime)) {
        var cachestr = $O.getCache(filename);
        if ("" != cachestr) {
          return cachestr;
        }
      }
    }

    $O.postEvent("showProgressIndeterminateVisible", "true", null, null);
    if (!version) version = 1.0;
    params.access_token = this.getToken();
    $L.D(this.TAG, "postApi:" + params.access_token);
    if (!params.access_token) return false;
    var appconfig = this.getAppconfig();
    params.api_key = appconfig.api_key;
    params.call_id = this.getRandNum();
    params.method = method;
    params.format = "json";
    params.apiversion = version;
    params.sig = this.getSign(params.api_key, params.call_id, params.method);
    $L.D(this.TAG, "params:" + Object.toJSON(params));
    if (success) this.postThread(this.api_url, params, success);
    else {
      var res = this.post(this.api_url, params);

      // 保存缓存
      $O.setCache(res, filename);
      $O.setCache((new Date()).getTime() + "", filename + "_time");

      $O.postEvent("showProgressIndeterminateVisible", "false", null, null);
      $L.D(this.TAG, "api response string:" + Object.toJSON(res));
      return res;
    }
  },
  postThread: function(url, data, success) {
    // $L.D(this.TAG,url)
    $C.controller.callback = success;
    $O.httpPost(url, data);
//    with(utilityNames) {
//       $L.D(this.TAG, "$H(data):" + $H(data).toQueryString());
//      JsUtility.HttpRequestThread(url, $H(data).toQueryString(), $C.scopeid);
//    }
  },
  post: function(url, data) {
    return String($O.httpPost(url, data));
  },
  getToken: function() {
    var token = $O.getPreference("access_token");
    var push_android_token = $O.getPreference("push_android_token");
    if ("string" == typeof token && token.length == 32 && "string" == typeof push_android_token && push_android_token.length == 23) return token;
    return this.getNewToken();
  },
  saveToken: function(token) {
    this.token = token;
    $O.setPreference("access_token", token);
  },
  savePushAndroidToken: function(push_android_token) {
    $O.setPreference("push_android_token", push_android_token);
  },
  getNewToken: function() {
    var appconfig = this.getAppconfig();
    var api_key = appconfig.api_key;
    var device_number = $O.getDeviceId();
    var call_id = this.getRandNum();
    var md5var = this.getSign(api_key, call_id, "token");
    var res = this.post(this.token_url, {
      grant_type: "device",
      devicenumber: device_number,
      client_id: api_key,
      call_id: call_id,
      method: "token",
      sig: md5var
    }, true);
    res = res.evalJSON();
    token = (res != null && res.access_token) ? res.access_token : "";
    push_android_token = (res != null && res.push_android_token && res.push_android_token !="") ? res.push_android_token : "";
    if (push_android_token.length == 23) {
      Ajax.savePushAndroidToken(push_android_token);
    }
    if (token.length == 32) {
      Ajax.saveToken(token);
      return token;
    }
    return false
  },
  getRandNum: function() {
    return Math.ceil(Math.random() * 1000000000);
  },
  getSign: function(key, cid, method) {
    var appconfig = this.getAppconfig();
    var client_secret = appconfig.api_secret;
    var md5var = "api_key=" + key + "call_id=" + cid + "method=" + method + client_secret;
    return hex_md5(md5var);
  },

  getAppconfig: function() {
    if (this.appconfig == null) {
      this.appconfig = {
        api_key: $O.getApiKey(),
        api_secret: $O.getApiSecret(),
        debug: $O.getDebugState()
      };
    }
    return this.appconfig;
  },
  // 判断是否接口数据返回报错
  checkError: function(msg) {
    if (typeof msg != "string") msg = Object.toJSON(msg);
    if (new RegExp(RegExp.escape('"error":')).match(msg)) {
      var err = msg.evalJSON();
      if (err.data.error) {
        if ($M._debug) {
          alert("api - " + err.method + " 报错：" + err.data.error.errordes + "。参数：" + Object.toJSON(err.params) + "(调试信息)", "pecct://app/null");
        }
        return err.data.error;
      }
    }
    return false;
  },
  get: function() {},
  _e: null
});

var Ajax = new HttpController();


// api_key=582a377a32bc3da92d5554a679055a0acall_id=880184655method=tokenf39bee589e4e6284fde524dc58225664
// grant_type=device&devicenumber=000000000000000&client_id=582a377a32bc3da92d5554a679055a0a&call_id=880184655&method=token&sign=4e7c6c7edd8b295db4b0abc02eb989b2


/*
 * A JavaScript implementation of the RSA Data Security, Inc. MD5 Message
 * Digest Algorithm, as defined in RFC 1321.
 * Version 2.1 Copyright (C) Paul Johnston 1999 - 2002.
 * Other contributors: Greg Holt, Andrew Kepert, Ydnar, Lostinet
 * Distributed under the BSD License
 * See http://pajhome.org.uk/crypt/md5 for more info.
 */

/*
 * Configurable variables. You may need to tweak these to be compatible with
 * the server-side, but the defaults work in most cases.
 */
var hexcase = 0; /* hex output format. 0 - lowercase; 1 - uppercase        */
var b64pad = ""; /* base-64 pad character. "=" for strict RFC compliance   */
var chrsz = 8; /* bits per input character. 8 - ASCII; 16 - Unicode      */

/*
 * These are the functions you'll usually want to call
 * They take string arguments and return either hex or base-64 encoded strings
 */

function hex_md5(s) {
  return binl2hex(core_md5(str2binl(s), s.length * chrsz));
}

function b64_md5(s) {
  return binl2b64(core_md5(str2binl(s), s.length * chrsz));
}

function str_md5(s) {
  return binl2str(core_md5(str2binl(s), s.length * chrsz));
}

function hex_hmac_md5(key, data) {
  return binl2hex(core_hmac_md5(key, data));
}

function b64_hmac_md5(key, data) {
  return binl2b64(core_hmac_md5(key, data));
}

function str_hmac_md5(key, data) {
  return binl2str(core_hmac_md5(key, data));
}

/*
 * Perform a simple self-test to see if the VM is working
 */

function md5_vm_test() {
  return hex_md5("abc") == "900150983cd24fb0d6963f7d28e17f72";
}

/*
 * Calculate the MD5 of an array of little-endian words, and a bit length
 */

function core_md5(x, len) {
  /* append padding */
  x[len >> 5] |= 0x80 << ((len) % 32);
  x[(((len + 64) >>> 9) << 4) + 14] = len;

  var a = 1732584193;
  var b = -271733879;
  var c = -1732584194;
  var d = 271733878;

  for (var i = 0; i < x.length; i += 16) {
    var olda = a;
    var oldb = b;
    var oldc = c;
    var oldd = d;

    a = md5_ff(a, b, c, d, x[i + 0], 7, -680876936);
    d = md5_ff(d, a, b, c, x[i + 1], 12, -389564586);
    c = md5_ff(c, d, a, b, x[i + 2], 17, 606105819);
    b = md5_ff(b, c, d, a, x[i + 3], 22, -1044525330);
    a = md5_ff(a, b, c, d, x[i + 4], 7, -176418897);
    d = md5_ff(d, a, b, c, x[i + 5], 12, 1200080426);
    c = md5_ff(c, d, a, b, x[i + 6], 17, -1473231341);
    b = md5_ff(b, c, d, a, x[i + 7], 22, -45705983);
    a = md5_ff(a, b, c, d, x[i + 8], 7, 1770035416);
    d = md5_ff(d, a, b, c, x[i + 9], 12, -1958414417);
    c = md5_ff(c, d, a, b, x[i + 10], 17, -42063);
    b = md5_ff(b, c, d, a, x[i + 11], 22, -1990404162);
    a = md5_ff(a, b, c, d, x[i + 12], 7, 1804603682);
    d = md5_ff(d, a, b, c, x[i + 13], 12, -40341101);
    c = md5_ff(c, d, a, b, x[i + 14], 17, -1502002290);
    b = md5_ff(b, c, d, a, x[i + 15], 22, 1236535329);

    a = md5_gg(a, b, c, d, x[i + 1], 5, -165796510);
    d = md5_gg(d, a, b, c, x[i + 6], 9, -1069501632);
    c = md5_gg(c, d, a, b, x[i + 11], 14, 643717713);
    b = md5_gg(b, c, d, a, x[i + 0], 20, -373897302);
    a = md5_gg(a, b, c, d, x[i + 5], 5, -701558691);
    d = md5_gg(d, a, b, c, x[i + 10], 9, 38016083);
    c = md5_gg(c, d, a, b, x[i + 15], 14, -660478335);
    b = md5_gg(b, c, d, a, x[i + 4], 20, -405537848);
    a = md5_gg(a, b, c, d, x[i + 9], 5, 568446438);
    d = md5_gg(d, a, b, c, x[i + 14], 9, -1019803690);
    c = md5_gg(c, d, a, b, x[i + 3], 14, -187363961);
    b = md5_gg(b, c, d, a, x[i + 8], 20, 1163531501);
    a = md5_gg(a, b, c, d, x[i + 13], 5, -1444681467);
    d = md5_gg(d, a, b, c, x[i + 2], 9, -51403784);
    c = md5_gg(c, d, a, b, x[i + 7], 14, 1735328473);
    b = md5_gg(b, c, d, a, x[i + 12], 20, -1926607734);

    a = md5_hh(a, b, c, d, x[i + 5], 4, -378558);
    d = md5_hh(d, a, b, c, x[i + 8], 11, -2022574463);
    c = md5_hh(c, d, a, b, x[i + 11], 16, 1839030562);
    b = md5_hh(b, c, d, a, x[i + 14], 23, -35309556);
    a = md5_hh(a, b, c, d, x[i + 1], 4, -1530992060);
    d = md5_hh(d, a, b, c, x[i + 4], 11, 1272893353);
    c = md5_hh(c, d, a, b, x[i + 7], 16, -155497632);
    b = md5_hh(b, c, d, a, x[i + 10], 23, -1094730640);
    a = md5_hh(a, b, c, d, x[i + 13], 4, 681279174);
    d = md5_hh(d, a, b, c, x[i + 0], 11, -358537222);
    c = md5_hh(c, d, a, b, x[i + 3], 16, -722521979);
    b = md5_hh(b, c, d, a, x[i + 6], 23, 76029189);
    a = md5_hh(a, b, c, d, x[i + 9], 4, -640364487);
    d = md5_hh(d, a, b, c, x[i + 12], 11, -421815835);
    c = md5_hh(c, d, a, b, x[i + 15], 16, 530742520);
    b = md5_hh(b, c, d, a, x[i + 2], 23, -995338651);

    a = md5_ii(a, b, c, d, x[i + 0], 6, -198630844);
    d = md5_ii(d, a, b, c, x[i + 7], 10, 1126891415);
    c = md5_ii(c, d, a, b, x[i + 14], 15, -1416354905);
    b = md5_ii(b, c, d, a, x[i + 5], 21, -57434055);
    a = md5_ii(a, b, c, d, x[i + 12], 6, 1700485571);
    d = md5_ii(d, a, b, c, x[i + 3], 10, -1894986606);
    c = md5_ii(c, d, a, b, x[i + 10], 15, -1051523);
    b = md5_ii(b, c, d, a, x[i + 1], 21, -2054922799);
    a = md5_ii(a, b, c, d, x[i + 8], 6, 1873313359);
    d = md5_ii(d, a, b, c, x[i + 15], 10, -30611744);
    c = md5_ii(c, d, a, b, x[i + 6], 15, -1560198380);
    b = md5_ii(b, c, d, a, x[i + 13], 21, 1309151649);
    a = md5_ii(a, b, c, d, x[i + 4], 6, -145523070);
    d = md5_ii(d, a, b, c, x[i + 11], 10, -1120210379);
    c = md5_ii(c, d, a, b, x[i + 2], 15, 718787259);
    b = md5_ii(b, c, d, a, x[i + 9], 21, -343485551);

    a = safe_add(a, olda);
    b = safe_add(b, oldb);
    c = safe_add(c, oldc);
    d = safe_add(d, oldd);
  }
  return Array(a, b, c, d);

}

/*
 * These functions implement the four basic operations the algorithm uses.
 */

function md5_cmn(q, a, b, x, s, t) {
  return safe_add(bit_rol(safe_add(safe_add(a, q), safe_add(x, t)), s), b);
}

function md5_ff(a, b, c, d, x, s, t) {
  return md5_cmn((b & c) | ((~b) & d), a, b, x, s, t);
}

function md5_gg(a, b, c, d, x, s, t) {
  return md5_cmn((b & d) | (c & (~d)), a, b, x, s, t);
}

function md5_hh(a, b, c, d, x, s, t) {
  return md5_cmn(b ^ c ^ d, a, b, x, s, t);
}

function md5_ii(a, b, c, d, x, s, t) {
  return md5_cmn(c ^ (b | (~d)), a, b, x, s, t);
}

/*
 * Calculate the HMAC-MD5, of a key and some data
 */

function core_hmac_md5(key, data) {
  var bkey = str2binl(key);
  if (bkey.length > 16) bkey = core_md5(bkey, key.length * chrsz);

  var ipad = Array(16),
    opad = Array(16);
  for (var i = 0; i < 16; i++) {
    ipad[i] = bkey[i] ^ 0x36363636;
    opad[i] = bkey[i] ^ 0x5C5C5C5C;
  }

  var hash = core_md5(ipad.concat(str2binl(data)), 512 + data.length * chrsz);
  return core_md5(opad.concat(hash), 512 + 128);
}

/*
 * Add integers, wrapping at 2^32. This uses 16-bit operations internally
 * to work around bugs in some JS interpreters.
 */

function safe_add(x, y) {
  var lsw = (x & 0xFFFF) + (y & 0xFFFF);
  var msw = (x >> 16) + (y >> 16) + (lsw >> 16);
  return (msw << 16) | (lsw & 0xFFFF);
}

/*
 * Bitwise rotate a 32-bit number to the left.
 */

function bit_rol(num, cnt) {
  return (num << cnt) | (num >>> (32 - cnt));
}

/*
 * Convert a string to an array of little-endian words
 * If chrsz is ASCII, characters >255 have their hi-byte silently ignored.
 */

function str2binl(str) {
  var bin = Array();
  var mask = (1 << chrsz) - 1;
  for (var i = 0; i < str.length * chrsz; i += chrsz)
  bin[i >> 5] |= (str.charCodeAt(i / chrsz) & mask) << (i % 32);
  return bin;
}

/*
 * Convert an array of little-endian words to a string
 */

function binl2str(bin) {
  var str = "";
  var mask = (1 << chrsz) - 1;
  for (var i = 0; i < bin.length * 32; i += chrsz)
  str += String.fromCharCode((bin[i >> 5] >>> (i % 32)) & mask);
  return str;
}

/*
 * Convert an array of little-endian words to a hex string.
 */

function binl2hex(binarray) {
  var hex_tab = hexcase ? "0123456789ABCDEF" : "0123456789abcdef";
  var str = "";
  for (var i = 0; i < binarray.length * 4; i++) {
    str += hex_tab.charAt((binarray[i >> 2] >> ((i % 4) * 8 + 4)) & 0xF) + hex_tab.charAt((binarray[i >> 2] >> ((i % 4) * 8)) & 0xF);
  }
  return str;
}

/*
 * Convert an array of little-endian words to a base-64 string
 */

function binl2b64(binarray) {
  var tab = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
  var str = "";
  for (var i = 0; i < binarray.length * 4; i += 3) {
    var triplet = (((binarray[i >> 2] >> 8 * (i % 4)) & 0xFF) << 16) | (((binarray[i + 1 >> 2] >> 8 * ((i + 1) % 4)) & 0xFF) << 8) | ((binarray[i + 2 >> 2] >> 8 * ((i + 2) % 4)) & 0xFF);
    for (var j = 0; j < 4; j++) {
      if (i * 8 + j * 6 > binarray.length * 32) str += b64pad;
      else str += tab.charAt((triplet >> 6 * (3 - j)) & 0x3F);
    }
  }
  return str;
}

function getkey(farmTime) {
  if (farmTime == "") farmTime = "1247231732";
  tmpkey = "$#087asd!@#$0AHFH";
  return hex_md5(farmTime + tmpkey.substr(parseInt(farmTime) % 10, 20));
}

// 控制器逻辑部分
PanicbuyController = Class.create({
  initialize: function() {
		this.name = "panicbuy";
	},
	TAG: "JS-PanicbuyController",
	//标准版显示优惠业务
  getcontentinfo: function(params) {
  	$O.postEvent("showLoadingDialog", "加载中", "正在加载……", false);
		$L.D(this.TAG, "contentid = " + params.contentid);
		var res = Ajax.callAPI("content.getcontentinfo", {
			contentid: params.contentid
		}, "1.0", true).evalJSON();
		var err = Ajax.checkError(res);
		if (err) return alert(err.errordes, "pecct://app/null");

		// 数据容错处理
		if (!res.data || res.data == null || typeof res.data.error != "undefined") res = {
			ListByType: []
		};
		else res = res.data;
		$L.D(this.TAG, "response string  = " + Object.toJSON(res));
		var actionbarString = {
			"withActionBar": "true",
			"actionBarBg": "",
			"title": res.ContentInfo.Title
		};
		var panicbuyString = {
			"title": res.ContentInfo.Title,
			"imageName": res.ContentInfo.ImageCover,
			"summary": res.ContentInfo.Abstract,
			"content": res.ContentInfo.Content,
			"validStartTime": res.ContentInfo.apply_start_time,
			"validEndTime": res.ContentInfo.apply_end_time
		};
		var countString = {
			"timeString": res.ContentInfo.end_time
		};
		var cNum = res.ContentInfo.couponOrderNum;
		$L.D(this.TAG, "couponOrderNum = " + cNum);
		var t = null;
		var bg = null;
		var cAble = null;
    var date = new Date();
    var dateTime = date.getTime();
    var endTime = res.ContentInfo.end_time;
    endTime = endTime.replace("-","/").replace("-","/");
    endTime = Date.parse(endTime);
    // 判断优惠是否结束
		if (cNum == "0" || cNum == "1" && dateTime >= endTime) {
			t = "抢购结束";
			bg = "widget_panic_buy_applybt_inactive";
			cAble = "false";
		} else if (cNum == "1") {
			t = "开始抢购";
			bg = "widget_panic_buy_applybt_active_bg";
			cAble = "true";
		} else if (cNum != "0" || cNum != "1") {
			t = "优惠码：" + cNum;
			bg = "widget_panic_buy_applybt_inactive";
			cAble = "false";
		};
		var buttonString = {
			"text": t,
			"background": bg,
			"clickable": cAble
		};
		$L.D(this.TAG, "clickable = " + cAble);
		var startTime = /\d{4}-\d{1,2}-\d{1,2}/g.exec(res.ContentInfo.apply_start_time);
		var endTime = /\d{4}-\d{1,2}-\d{1,2}/g.exec(res.ContentInfo.apply_end_time);
		var groupString = {
			"groupList": [{
				"tableList": [{
					"tag": "",
					"title": startTime + "---" + endTime
				}]
			}, {
				"tableList": [{
					"tag": "pecct://activity/showMap?title=地址&address=" + encodeURIComponent(res.ContentInfo.address) + "&longitude=" + res.ContentInfo.longitude + "&latitude=" + res.ContentInfo.latitude + "",
					"title": "活动地点"
				}]
			}]
		};

		var newParams = {
			"actionbarString": actionbarString,
			"panicbuyString": panicbuyString,
			"countString": countString,
			"buttonString": buttonString,
			"contentId": res.ContentInfo.Id,
			"groupString": groupString
		};
		$O.postEvent("openActivity", "", "page_youhui_detail", Object.toJSON(newParams));
		$O.postEvent("closeLoadingDianlog", null, null, null);
	},
	//商户端验证优惠显示
	showCouponByInfo: function(params) {
		$O.postEvent("showLoadingDialog", "加载中", "正在加载……", false);
		var actionbarString = {
			"withActionBar": "true",
			"actionBarBg": "test_actionbar_bg",
			"title": params.title
		};
		var panicbuyString = {
			"title": params.title,
			"imageName": params.imageName,
			"summary": params.summary,
			"content": params.content,
			"validStartTime": params.validStartTime,
			"validEndTime": params.validEndTime
		};
		var countString = {
			"timeString": params.end_time
		};
		var cNum = params.couponOrderNum;
		$L.D(this.TAG, "couponOrderNum = " + cNum);
		var t = null;
		var bg = null;
		var cAble = null;

		t = "优惠码：" + cNum;
		bg = "widget_panic_buy_applybt_inactive";
		cAble = "false";

		var buttonString = {
			"text": t,
			"background": bg,
			"clickable": cAble
		};
		$L.D(this.TAG, "clickable = " + cAble);

		var newParams = {
			"actionbarString": actionbarString,
			"panicbuyString": panicbuyString,
			"countString": countString,
			"buttonString": buttonString
		};
		$O.postEvent("openActivity", "", "page_youhui_detail", Object.toJSON(newParams));
		$O.postEvent("closeLoadingDianlog", null, null, null);
	},
	getCouponInfo: function(params) {
		var res = Ajax.callAPI("content.getcontentinfo", {
			contentid: params.contentid
		}, "1.0", true).evalJSON();
		var err = Ajax.checkError(res);
		if (err) return alert(err.errordes, "pecct://app/null");

		// 数据容错处理
		if (!res.data || res.data == null || typeof res.data.error != "undefined") res = {
			ListByType: []
		};
		else res = res.data;
		var newParams = {
			'contentid': params.contentid
		};
		var cNum = res.ContentInfo.couponOrderNum;
		$L.D(this.TAG, "couponOrderNum = " + cNum);
		$O.postEvent("openActivity", "", "page_widget_listview_expand_yundong", Object.toJSON(newParams));
	},
	//判断是优惠还是乐动小站
	checkIsCoupon: function(params) {
		var newParams = {
			'contentid': params.contentid
		}
		if (params.cmsSortId == "481") {
			$O.postEvent("openActivity", "", "page_widget_listview_expand_kecheng", Object.toJSON(newParams));
		} else {
			this.getcontentinfo(params);
		}
	},
	//静安运动申领优惠业务
	showapplycoupon: function(params) {
		$L.D(this.TAG, "contentid = " + params.contentid);
		var applyres = Ajax.callAPI("activity.applycoupon", {
			contentid: params.contentid
		}, "1.0", true);
		$L.D(this.TAG, "applycouponinfo:" + applyres);
		applyres = applyres.evalJSON();
		var couNum = "0"
		if (applyres.data && applyres.data['Success']) {
			couNum = "优惠码：" + applyres.data['Success'].code
			var newParams = {
				'contentid': params.contentid
			};
			$O.postEvent("openActivity", "", "page_widget_listview_expand_yundong", Object.toJSON(newParams));

		} else if (applyres.data && applyres.data['error']) {
			// couNum = applyres.data['error'].errordes
      var errorMsg = "购买课程失败！";
      if(applyres.data['error'].errornum == "100315"){
        errorMsg = "您购买课程的数量已经超过限制了！";
      }
      if(applyres.data['error'].errornum == "100314"){
        errorMsg = "该课程已被购完！";
      }
			alert(errorMsg, "pecct://app/null");
		}
	},
	//标准版申领优惠业务
	applyCoupon: function(params) {
		$L.D(this.TAG, "contentid = " + params.contentid);
		var applyres = Ajax.callAPI("activity.applycoupon", {
			contentid: params.contentid
		}, "1.0", true);
		$L.D(this.TAG, "applycouponinfo:" + applyres);
		applyres = applyres.evalJSON();
		var couNum = "0"
		if (applyres.data && applyres.data['Success']) {
			couNum = "优惠码：" + applyres.data['Success'].code
		} else if (applyres.data && applyres.data['error']) {
			couNum = applyres.data['error'].errordes
		}
		var newData = {
			text: couNum,
			background: "widget_panic_buy_applybt_inactive",
			clickable: "false"
		}
		$O.postEvent("refershDataForWidget", Object.toJSON(newData), "ec_button_widget", "");

	},
	//标准版倒计时结束刷新抢购按钮状态
	couponfinished: function() {
		var newData = {
			text: "抢购结束",
			background: "widget_panic_buy_applybt_inactive",
			clickable: "false"
		}
		$O.postEvent("refershDataForWidget", Object.toJSON(newData), "ec_button_widget", "");
	},
	_e: null
});

// 控制器逻辑部分
var PointController =  Class.create({
	initialize: function() {
		this.name = "point";
		this.callback = null;
		$C.controller = this;
	},
	TAG:"JS-PointController",
	// 积分记录列表
	pointlist : function(params){
		params.viewtype = "point";
		params = this.parselistparams(params);
		var res = this.getpointlistdata(params);
		$O.postEvent("ClearView",params.target,null,null);
		$O.postEvent("insertViewIntoView", Object.toJSON(res) , "ListViewWidget:widget_listview_item_twoline_text" ,params.target);

	},
	parselistparams : function(params){

		// 设置默认值
		if(typeof params._hascomment == "undefined")
			params._hascomment = 0;
		if(typeof params._hasshare == "undefined")
			params._hasshare = 0;
		if(typeof params._hasup == "undefined")
			params._hasup = 0;
		if(typeof params.target == "undefined")
			params.target = "content_view";
		if(typeof params.orderbyname == "undefined")
			params.orderbyname = "id";
		if(typeof params.orderbybype == "undefined")
			params.orderbybype = "desc";
		if(typeof params.viewtype == "undefined")
			params.viewtype = "listview";
		return params;

	},
	getpointlistdata : function(params){

		params = this.parselistparams(params);
		var _refresh = (typeof params._refresh != "undefined");
		var res = Ajax.callAPI("user.getpointloglist",
			{pagesize:20}, "1.0" ,_refresh).evalJSON();
		// 数据容错处理
		// $L.D(this.TAG , "++++++++++++++++"+$H(res.data).toQueryString());
		if (!res.data || res.data == null || typeof res.data.error != "undefined")
			res = {ListByType:[]};
		else
			res = res.data;

		var newdata = { ListByType:[],_listimage:"none" };

		res['pointLogList'].each(function(obj){
			var abc = {
				title : obj.description,
				abstracts : obj.updated_at,
				id : obj.id,
				_uri : ""
			};
			newdata.ListByType.push(abc);
		});
		// 当前参数打包，刷新时使用
		var p = $H(params);
		p.unset('_refresh')
		newdata._uri = "pecct://point/pointlist?"+p.toQueryString();
		// res = Object.toJSON(newdata);
		return newdata;

	},
  disclaimer: function(params) {
    var newParams = {
			"shopid": params.shopid
		};
    $O.setPreference(params.shopid, "true");
    $O.postEvent("openActivityWithFinished", "", "page_signin_changguan", Object.toJSON(newParams), null);
  },
	signinWithLocation: function(params) {
		var p = $H(params);
		$O.postEvent("getLocation","pecct://point/signin?"+p.toQueryString(),null,null);
	},
	signin : function(params){
		$L.D(this.TAG, "response title  = "+params.title+",content  = "+params.content+",longitude  = "+params.lontitude+",latitude  = "+params.latitude);
		var res = Ajax.callAPI("content.addcomment", {
			contentid:params.contentid,title:params.title,content:params.content,typenum: 1,vote_star:params.vote_star,longitude:params.lontitude,latitude:params.latitude
		}, "1.0", true).evalJSON();
		var err = Ajax.checkError(res);
		if (err) return alert(err.errordes, "pecct://app/null");
		$L.D(this.TAG, "response string  = "+Object.toJSON(res));
		alert("签到成功\n本次签到于"+this.GetDate(0)+","+params.title, "pecct://app/null");
	},
  //获取指定天数后的指定格式日期
  GetDate: function(AddDayCount) 
  { 
    var dd = new Date(); 
    dd.setDate(dd.getDate()+AddDayCount);//获取AddDayCount天后的日期 
    var y = dd.getYear(); 
  	var m = (dd.getMonth()+1)<10?"0"+(dd.getMonth()+1):(dd.getMonth()+1);//获取当前月份的日期，不足10补0
  	var d = dd.getDate()<10?"0"+dd.getDate():dd.getDate(); //获取当前几号，不足10补0
  	return new Date().getFullYear() + "-"+m+"-"+d; 
  },
	_e:null
});

// 控制器逻辑部分
var UserController = Class.create({
	initialize: function() {
		this.name = "user"
	},
	TAG: "JS-UserController",
	//意见反馈
	feedbackPage: function(params) {
		// var isLogin = $O.getPreference("isLogin");
		// if ("true" != isLogin) return alert("需要登录才能反馈", "pecct://user/loginPage");
		$O.postEvent("openActivity", "", "page_feedback", "", null);
	},
	doFeedback: function(params) {
		var p = {
			content: params.content,
			contact: params.contact,
		};
		var res = Ajax.callAPI("content.addfeedback", p, "1.0", true).evalJSON();
		$L.D(this.TAG, "doFeedback:" + Object.toJSON(res));
		var err = Ajax.checkError(res);
		if (err) return alert(err.errordes, "pecct://app/null");
		else {
			alert("反馈成功！", "pecct://app/finishNowActivity");
		}
	},
	doComment_default_params: {
		"contentid": 0,
		"content": "",
		"contact": "",
		"vote_star": "",
    "alert":"评论成功"
	},
	doComment: function(params) {
		var requestparams = Object.cloneExtend(this.doComment_default_params, params);
    if(requestparams.content == "" || requestparams.vote_star == "4"){
      return alert("请输入完整内容", "pecct://app/null");
    }
		var input = {
			content_id: requestparams.contentid,
			title: requestparams.contact,
			content: requestparams.content,
			typenum: 2,
      vote_star:requestparams.vote_star
//			vote_star: requestparams.vote_star
		};
		$L.D(this.TAG, "contentid:" + requestparams.contentid);
		$L.D(this.TAG, "contentid:" + parseInt(requestparams.contentid));
		var res = Ajax.callAPI("comment/comments/create", input, "1.0", true);
		var err = Ajax.checkError(res);
		$L.D(this.TAG, "doComment fromComList:" + params.fromComList);
		if (err)
			return alert(err.errordes, "pecct://app/null");
		else {
			var successUri = "pecct://user/openActivity?pageName=page_list_comment"
			alert(requestparams.alert, "pecct://app/finishNowActivity?successUri=" + encodeURIComponent(successUri));
		}
	},
	// 登录
	loginPage: function(params) {
		$O.postEvent("openActivity", "", "page_login", "", null);
	},
	doLogin: function(params) {
		var p = {
			username: params.username,
			password: params.password,
		};
		var res = Ajax.callAPI("user.login", p, "1.0", true).evalJSON();
		$L.D(this.TAG, "doLogin:" + Object.toJSON(res));
		var err = Ajax.checkError(res);
		if (err) return alert(err.errordes, "pecct://app/null");
		else {
			$O.setPreference("isLogin", "true");
			var newtoken = "";
      var push_android_token = "";
			if (res.data && res.data.access_token) {
				newtoken = res.data.access_token;
			};
      if (res.data && res.data.push_android_token) {
  			push_android_token = res.data.push_android_token;
			};
			if (newtoken != "") {
				new HttpController().saveToken(newtoken);
			};
      if (push_android_token != "") {
  			new HttpController().savePushAndroidToken(push_android_token);
			};
			var userInfo = {
				"title": ""
			};
			var successUri = "pecct://user/refershDataForWidget?username="+p.username+"&widgetId=group_widget"
			alert("登录成功！", "pecct://app/finishNowActivity?successUri=" + encodeURIComponent(successUri));
			/*		$O.finishNowActivity();
			$O.postEvent("openActivity", "" ,"page_feedback", "", null);*/
		}
	},
	refershDataForWidget_default_params: {
		"newData": "",
		"widgetId": "",
	},
	refershDataForWidget: function(params) {
		var requestparams = Object.cloneExtend(this.refershDataForWidget_default_params, params);
      $L.D(this.TAG, "refershDataForWidget params username:" + params.username);
//		if(params.username == "undefined"){
//		  params.username  = ""
//		}
//    var userInfo = {
//			"title": params.username
//		};
    $O.postEvent("refershWidget","item_news_widget", "",null);
//		$O.postEvent("refershDataForWidget",Object.toJSON(userInfo), "item_news_widget", "");
		$O.postEvent("refershDataForWidget", requestparams.newData, requestparams.widgetId, "");
	},
  versionform: function() {
		  versionform = {
			'groupList': [{
				'tableList': [{
						'title': '意见反馈',
						'tag': 'pecct://user/feedbackPage'
					}, {
						'title': '查看新版本',
						'tag': 'pecct://app/checkVersion?successwords=true',
            'customView':'group_item_version',
            'summary': $O.getAppVersion()
					}, {
  					'title': '清理缓存',
						'tag': 'pecct://app/clearCache?word=缓存清理完成！'
					}
				]
			}]
		};
		return versionform.groupList;
	},
	loginform: function() {
		$L.D(this.TAG, "loginform:" + $O.getPreference("isLogin"));
		loginform = {
			'groupList': [{
				'tableList': [{
						'title': '登录',
						'tag': 'pecct://user/loginPage'
					}, {
						'title': '用户注册',
						'tag': 'pecct://user/regPage'
					}

				]
			}]
		};
		$L.D(this.TAG, "loginform isLogin:" + $O.getPreference("isLogin"));
		if ("true" == $O.getPreference("isLogin")) {
			loginform = {
				'groupList': [{
					'tableList': [{
						'title': '注销登录',
						'tag': 'pecct://user/logout'
					}]
				}]
			};
		};
		return loginform.groupList;
	},
	isLogin: function(params) {
		if ("true" == $O.getPreference("isLogin")) {
			this.logout();
		} else {
			$O.postEvent("openActivity", "", params.pageName, "", null);
		}
	},
	doLogout: function() {
		new HttpController().saveToken("");
    new HttpController().savePushAndroidToken("");
		$O.setPreference("isLogin", "false");
		alert("注销成功", "pecct://app/null");
//		var userInfo = {
//			"title": ""
//		};
//		this.refershDataForWidget({
//			"newData": Object.toJSON(userInfo),
//			"widgetId": "item_news_widget"
//		});
    var newParams = {
        "grant_type": "new_user"
	    };
    $O.postEvent("getNewToken", Object.toJSON(newParams),null, null);
    
    this.refershDataForWidget({
			"widgetId": "group_widget"
		});
    
		return;
	},
	logout: function() {
		confirm("确认退出登录么？", "pecct://user/doLogout", "pecct://app/null");
	},
	// 注册
	regPage: function(params) {
		$O.postEvent("openActivity", "", "page_register", "", null);
	},
	doRegister: function(params) {
		if (!(/^1[3|4|5|8][0-9]\d{4,8}$/.test(params.phonenumber))) {
			return alert("请输入完整的11位手机号码完成注册！", "pecct://app/null");
		}
		var p = {
			phonenumber: params.phonenumber,
			password: params.password,
		};
		var res = Ajax.callAPI("user.regbyphone", p, "1.0", true);
		var err = Ajax.checkError(res);
		if (err) return alert(err.errordes, "pecct://app/null");
		else {
//			$O.setPreference("isLogin", "true");
			var newtoken
			if (res.data && res.data.Success && res.data.Success.access_token) {
				newtoken = res.data.Success.access_token;
			};
			if (typeof newtoken != "undefined" && null != newtoken) {
				new HttpController().saveToken(newtoken);
			};
			/*			var successUri = "pecct://tabviewapp/showgroup?id=aboutus&target=activity_item_container_llayout"
			alert("注册成功！", "pecct://app/finishNowActivity?successUri=" + encodeURIComponent(successUri));*/
			$O.finishNowActivity();
			this.loginPage();
		}
	},
  //获取报名表单
	applyForm: function(params) {
		var res = Ajax.callAPI("user.getactapplielist", {
			id: params.applyFormId
		}, "1.0", true);
		var applyinfo = res.evalJSON();
		var applyFormCfg = {};
		var err = Ajax.checkError(res);
		if (err) return alert(err.errordes, "pecct://app/null");
		var thisform = applyinfo.data.actapplylist[0];
		$L.D(this.TAG, "applyForm:" + Object.toJSON(res));
		applyFormCfg.name = thisform.name;
		applyFormCfg.title = thisform.name;
		applyFormCfg.subtilte = "";
		applyFormCfg.success_redirect = "pecct://app/null";
		applyFormCfg.button_submit = "报 名";
		applyFormCfg._uri = "";
		applyFormCfg.post_uri = "pecct://user/doApply?act_apply_id=" + params.applyFormId;
		applyFormCfg.check_enable_uri = "";
		applyFormCfg.input_list = [];
		applyFormCfg.helper_list = [];
		var itemlist = thisform.form;
		for (k in itemlist) {
			var ipt = {};
			var item = itemlist[k];
			ipt.default_layout = item.type;
			if (item.type == "textnumber") ipt.default_layout = "number";
			ipt.name = k;
			ipt.background_wrods = item.cnname
			if (item.options) {
				ipt.selectlist = {};
				ipt.selectlist.options = item.options;
			}
			ipt.input_type = "";
			ipt.text = "";
			ipt.default_value = "";
			ipt.des_wrods = "";
			ipt.must_input = "";
			ipt.must_input_words = "";
			applyFormCfg.input_list.push(ipt);
		}
		return applyFormCfg;
	},
	addApply_default_params: {
		"act_apply_id": 0,
		"int1": "",
		"int2": "",
		"int3": "",
		"int4": "",
		"int5": "",
		"text1": "",
		"text2": "",
		"text3": "",
		"text4": "",
		"text5": "",
		"text6": "",
		"text7": "",
		"text8": "",
		"text9": "",
		"text10": "",
	},
	doApply: function(params) {
    $O.postEvent("showLoadingDialog", "加载中", "正在加载……", false);
		var requestparams = Object.cloneExtend(this.addApply_default_params, params);
		var input = {
			act_apply_id: requestparams.act_apply_id,
			int1: requestparams.int1,
			int2: requestparams.int2,
			int3: requestparams.int3,
			int4: requestparams.int4,
			int5: requestparams.int5,
			text1: requestparams.text1,
			text2: requestparams.text2,
			text3: requestparams.text3,
			text4: requestparams.text4,
			text5: requestparams.text5,
			text6: requestparams.text6,
			text7: requestparams.text7,
			text8: requestparams.text8,
			text9: requestparams.text9,
			text10: requestparams.text10
		};

		var res = Ajax.callAPI("user.addapply", input, "1.0", true);
		var err = Ajax.checkError(res);
		if (err) return alert(err.errordes, "pecct://app/null");
		else {
      $O.postEvent("closeLoadingDianlog", null, null, null);
			var successUri = "pecct://user/refershDataForWidget?widgetId=list_view_widget"
			// alert("报名成功！", "pecct://app/finishNowActivity?successUri=" + encodeURIComponent(successUri));
			alert("报名成功！", "pecct://app/finishNowActivity");
		}
	},
  getApplyInfo: function(params) {
     var groupString = {
			"groupList": [{
				"tableList": [{
					"tag": "pecct://app/null",
					"title": "姓名：      "+params.name
				}]
			}, {
				"tableList": [{
					"tag": "pecct://app/null",
					"title": "电话：       "+params.phone
				}]
			}, {
  			"tableList": [{
					"tag": "pecct://app/null",
					"title": "报名人数：    "+params.num
				}]
			}, {
  			"tableList": [{
					"tag": "pecct://app/null",
					"title": "参赛日期：     "+params.date
				}]
			}]
		};
    
    var newParams = {
			"groupString": groupString
		};
    $O.postEvent("openActivity", "", "page_apply_details", Object.toJSON(newParams), null);
  },
	doAddfav_default_params: {
		"contentid": 0
	},
	//加入收藏
	doAddfav: function(params) {
		var requestparams = Object.cloneExtend(this.doAddfav_default_params, params);
		var res = Ajax.callAPI("content.addfav", {
			contentid: requestparams.contentid
		}, "1.0", true);
		$L.D(this.TAG, "doAddfav:" + Object.toJSON(res));
		var err = Ajax.checkError(res);
		if (err) return alert("不能重复收藏", "pecct://app/null");
		else {
			alert("收藏成功！", "pecct://app/null");
		}
	},
	_e: null
});


// 环境设置
var $M = {
	_debug : true, 
	_env : "ios",//android java ios web
	_lang : _lang == "zh" ? "default": _lang,
	_e:""
}
Object.extend(Object,{
	cloneExtend : function(obj1, obj2){
		return Object.extend(Object.clone(obj1), obj2);
	},
	deepClone : function(obj){
		return Object.toJSON(obj).evalJSON();
	}
});

var $cfg = 

{
  "uninstall_package" : "",
  "appname" : "kangfubao_peng",
  "start_controller": "page_home",
  "guide_page":"",
  "startPushService": "false",
  "splash": {},
  "controllerFilter":{
  },
  "menu": [
  ]
}

