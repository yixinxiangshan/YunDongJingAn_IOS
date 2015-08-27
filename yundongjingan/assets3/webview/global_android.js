var response_callbacks = {};
var _response_callbacks = {};
var unique_id = 1;
// 环境设置
var _env = {
    debug: _debug,
    env: "android_web", //android java ios web
    parent_id: _pid,
    lang: _lang
};

var callCoreApi = function(method ,params, callback , action){
  var callback_id = putCallback(callback);
  var event_id = null;
  if ("function" == typeof params) {
      event_id = putCallback(params);
      params = {
          _event_id: event_id
      };
  }
  // 处理参数
    var str = ""
    if ("string" == typeof params)
        str = JSON.stringify({ _param: params });
    else{
        for(i in params)
            if(typeof params[i] != "string")
                params[i] = JSON.stringify(params[i])
        str = JSON.stringify(params)
    }
  WebviewApi.callCoreApi(method, ("undefined" == typeof str ? "{}" : str), callback_id, JSON.stringify(action));
};
function putCallback(callback) {
    var callback_id = 'webview_' + (unique_id++) + new Date().getTime();
    _response_callbacks[callback_id] = callback;
    return callback_id;
}

function callDeviceApi(method ,params, callback){
  var callback_id = 'cb_'+(unique_id++)+'_'+new Date().getTime();
  response_callbacks[callback_id] = callback;
  if(params!==null&&typeof params!="undefined"){
    var str = "string" == typeof params ? params :JSON.stringify(params);
    Original[method](str,callback_id);
  }else
    Original[method](callback_id);
}


//调用设备原生方法
var $O = {};
$O.postEvent = function (method , para1 ,para2 ,para3){
  if ("undefined" == typeof para1) para1 = null
  if ("undefined" == typeof para2) para2 = null
  if ("undefined" == typeof para3) para3 = null
  Original.postEvent(method,para1,para2,para3);
}
var postEvent = $O.postEvent;
$O.callApi = function( method , param , success , fail, version ){
  if(!version) 
    version = "1.0";
  if(!fail) 
    vail = function(){};
  param.method = method;
  if(!param.version) 
    param.version = version;
  try{
    callDeviceApi('postRequest' ,param, success);
  }catch(e){
    fail(e)
  }
}
$O.getAppconfig  = function(callback){
    if (typeof Original == "undefined")
      return callback({})
//    return ECOriginal.getDecorateConfig();
  callDeviceApi('getDecorateConfig' ,null, callback);
}
//获取完整的网络请求参数
$O.pullQueue = function (params,callback){
  callDeviceApi('pullQueue' ,params, callback);
//  return Original.getNetParams(params,callback);
}
//获取完整的网络请求参数
$O.getNetParam = function (params,callback){
  callDeviceApi('getNetParams' ,params, callback);
//  return Original.getNetParams(params,callback);
}
//项目配制及网络资源的本地路径
$O.getLocalPath = function (callback){
  callDeviceApi('getDecoratePath' ,null, callback);
//  return Original.getDecoratePath();
}
$O.getConfigFilePath = function(callback){
  callDeviceApi('getConfigFilePath' ,null, callback);
}
//获取项目配制
$O.getDecorateConfig = function (callback){
//  var config_str= Original.getDecorateConfig();
//  return $.parseJSON( config_str ).configs;
  callDeviceApi('getDecorateConfig' ,null, callback);
}

$O.setScrollable = function(param){
  Original.setScrollable(param);
}
$O.getPageParam = function(key , callback){
  callDeviceApi("getPageParam", key , callback);
}
$O.isLogin = function(callback){
   callDeviceApi("isLogin", null, callback);
}
// 加入缓存
$O.putCache = function(params,callback){
   callDeviceApi("putCache", params, callback);
}

// 获取缓存
$O.getCache = function(params,callback){
   callDeviceApi("getCache", params, callback);
}

// 获取缓存
$O.getCaches = function(params,callback){
   callDeviceApi("getCaches", params, callback);
}

// 删除缓存
$O.removeCaches = function(params,callback){
   callDeviceApi("removeCaches", params, callback);
}
// toast
$O.makeToast = function(params,callback){
   callDeviceApi("makeToast", params, callback);
}
// toast
$O.getConfigFile = function(params,callback){
   callDeviceApi("getConfigFile", params, callback);
}


var resized = false;
$(window).resize(function() {
    _startPage();
});
$(document).ready(function(){
  setTimeout(function(){
    _startPage();
  },500);
});
function _startPage(){
  if (resized)
      return;
    resized = true;
    initPage();
}



