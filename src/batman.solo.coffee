#
# batman.nodep.coffee
# batman.js
#
# Created by Nick Small
# Copyright 2011, Shopify
#

`
/*!
  * Reqwest! A x-browser general purpose XHR connection manager
  * copyright Dustin Diaz 2011
  * https://github.com/ded/reqwest
  * license MIT
  */
!function(window){function serial(a){var b=a.name;if(a.disabled||!b)return"";b=enc(b);switch(a.tagName.toLowerCase()){case"input":switch(a.type){case"reset":case"button":case"image":case"file":return"";case"checkbox":case"radio":return a.checked?b+"="+(a.value?enc(a.value):!0)+"&":"";default:return b+"="+(a.value?enc(a.value):!0)+"&"}break;case"textarea":return b+"="+enc(a.value)+"&";case"select":return b+"="+enc(a.options[a.selectedIndex].value)+"&"}return""}function enc(a){return encodeURIComponent(a)}function reqwest(a,b){return new Reqwest(a,b)}function init(o,fn){function error(a){o.error&&o.error(a),complete(a)}function success(resp){o.timeout&&clearTimeout(self.timeout)&&(self.timeout=null);var r=resp.responseText;switch(type){case"json":resp=eval("("+r+")");break;case"js":resp=eval(r);break;case"html":resp=r}fn(resp),o.success&&o.success(resp),complete(resp)}function complete(a){o.complete&&o.complete(a)}this.url=typeof o=="string"?o:o.url,this.timeout=null;var type=o.type||setType(this.url),self=this;fn=fn||function(){},o.timeout&&(this.timeout=setTimeout(function(){self.abort(),error()},o.timeout)),this.request=getRequest(o,success,error)}function setType(a){if(/\.json$/.test(a))return"json";if(/\.jsonp$/.test(a))return"jsonp";if(/\.js$/.test(a))return"js";if(/\.html?$/.test(a))return"html";if(/\.xml$/.test(a))return"xml";return"js"}function Reqwest(a,b){this.o=a,this.fn=b,init.apply(this,arguments)}function getRequest(a,b,c){if(a.type!="jsonp"){var f=xhr();f.open(a.method||"GET",typeof a=="string"?a:a.url,!0),setHeaders(f,a),f.onreadystatechange=readyState(f,b,c),a.before&&a.before(f),f.send(a.data||null);return f}var d=doc.createElement("script"),e=getCallbackName(a);window[e]=function(b){a.success&&a.success(b)},d.type="text/javascript",d.src=a.url,d.async=!0,d.onload=function(){head.removeChild(d),delete window[e]},head.insertBefore(d,topScript)}function getCallbackName(a){var b=a.jsonpCallback||"callback";if(a.url.substr(-(b.length+2))==b+"=?"){var c="reqwest_"+uniqid++;a.url=a.url.substr(0,a.url.length-1)+c;return c}var d=new RegExp(b+"=([\\w]+)");return a.url.match(d)[1]}function setHeaders(a,b){var c=b.headers||{};c.Accept="text/javascript, text/html, application/xml, text/xml, */*",c["X-Requested-With"]=c["X-Requested-With"]||"XMLHttpRequest";if(b.data){c["Content-type"]="application/x-www-form-urlencoded";for(var d in c)c.hasOwnProperty(d)&&a.setRequestHeader(d,c[d],!1)}}function readyState(a,b,c){return function(){a&&a.readyState==4&&(twoHundo.test(a.status)?b(a):c(a))}}var twoHundo=/^20\d$/,doc=document,byTag="getElementsByTagName",topScript=doc[byTag]("script")[0],head=topScript.parentNode,xhr="XMLHttpRequest"in window?function(){return new XMLHttpRequest}:function(){return new ActiveXObject("Microsoft.XMLHTTP")},uniqid=0;Reqwest.prototype={abort:function(){this.request.abort()},retry:function(){init.call(this,this.o,this.fn)}},reqwest.serialize=function(a){var b=a[byTag]("input"),c=a[byTag]("select"),d=a[byTag]("textarea");return(v(b).chain().toArray().map(serial).value().join("")+v(c).chain().toArray().map(serial).value().join("")+v(d).chain().toArray().map(serial).value().join("")).replace(/&$/,"")},reqwest.serializeArray=function(a){for(var b=this.serialize(a).split("&"),c=0,d=b.length,e=[],f;c<d;c++)b[c]&&(f=b[c].split("="))&&e.push({name:f[0],value:f[1]});return e};var old=window.reqwest;reqwest.noConflict=function(){window.reqwest=old;return this},window.reqwest=reqwest}(this)
`

(exports ? this).reqwest = if window? then window.reqwest else reqwest

Batman.Request::send = (data) ->
  @loading yes

  reqwest
    url: @get 'url'
    method: @get 'method'
    type: @get 'type'
    data: data || @get 'data'

    success: (response) =>
      @set 'response', response
      @success response

    failure: (error) =>
      @set 'response', error
      @error error

    complete: =>
      @loading no
      @loaded yes

prefixes = ['Webkit', 'Moz', 'O', 'ms', '']
Batman.mixins.animation =
  initialize: ->
    for prefix in prefixes
      @style["#{prefix}Transform"] = 'scale(0, 0)'
      @style.opacity = 0

      @style["#{prefix}TransitionProperty"] = "#{if prefix then '-' + prefix.toLowerCase() + '-' else ''}transform, opacity"
      @style["#{prefix}TransitionDuration"] = "0.8s, 0.55s"
      @style["#{prefix}TransformOrigin"] = "left top"
    @
  show: (addToParent) ->
    show = =>
      @style.opacity = 1
      for prefix in prefixes
        @style["#{prefix}Transform"] = 'scale(1, 1)'
      @

    if addToParent
      addToParent.append?.appendChild @
      addToParent.before?.parentNode.insertBefore @, addToParent.before

      setTimeout show, 0
    else
      show()
    @
  hide: (shouldRemove) ->
    @style.opacity = 0
    for prefix in prefixes
      @style["#{prefix}Transform"] = 'scale(0, 0)'

    setTimeout((=> @parentNode?.removeChild @), 600) if shouldRemove
    @
