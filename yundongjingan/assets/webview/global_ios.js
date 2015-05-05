var _response_callbacks = {};
var unique_id = 1;

var _env = {
    debug: _debug,
    env: "ios_web", //android java ios web
    parent_id: _pid,
    lang: _lang,
    is_obj_input: typeof _is_obj_input == "undefined" ? false : true
};
window.onerror = function(err) {
    log('window.onerror: ' + err);
}
var bridge = {};
document.addEventListener('WebViewJavascriptBridgeReady', onBridgeReady, false)

function onBridgeReady(event) {
    bridge = event.bridge;
    var uniqueId = 1;
    // 初始化 桥接 
    bridge.init(function(message, responseCallback) {
        var data = {
            'Javascript Responds': 'Wee!'
        };
        responseCallback(data);
    });
    //注册 接口 给 oc 调用，暂时不用
    bridge.registerHandler('postEvent', function(data, responseCallback) {

    });
    bridge.registerHandler('sendMsgtoWebView', function(msg, responseCallback) {
        ECLog("msg in sendMsgWebView handler ......");

        pushMsg($.parseJSON(msg));
    });
    setTimeout(initConfig, 100);
};
var Original = {
    postEvent: function(methodName, param1, param2, param3) {
        var params = {
            "methodName": methodName,
            "param1": param1,
            "param2": param2,
            "param3": param3
        }
        bridge.send(params, null);
    },

    //获取项目配制及网络资源的本地路径
    getDecoratePath: function(responseCallback) {
        bridge.callHandler('getDecoratePath', null, responseCallback);
    },
    //获取项目配制
    getDecorateConfig: function(responseCallback) {
        bridge.callHandler('getDecorateConfig', null, responseCallback);
    },

    //
    getNetParam: function(params, responseCallback) {
        bridge.callHandler('getNetParam', params, responseCallback);
    }
};

function callWidgetMethod(controlId, methodName, param1, param2) {
    var params = {
        "controlId": controlId,
        "methodName": methodName,
        "param1": param1,
        "param2": param2
    }
    bridge.callHandler('callWidgetMethod', params, null);
};

function callDeviceApi(methodName, params, responseCallback) {
    bridge.callHandler(methodName, params, responseCallback);
}

function ECLog(msg) {
    bridge.callHandler('ECLog', msg, null);
}

function log(tag, message) {
    var param = {
        tag: tag,
        message: message
    }
    bridge.callHandler('callLog', param, null);
}
/*---------iOS- 异步接口-----------------------*/
//单通道js接口
function callCoreApi(method, params, callback, action) {
    var callback_id = putCallback(callback);
    if (_env.is_obj_input) {
        var event_id = null;
        if ("function" == typeof params) {
            event_id = putCallback(params);
            params = event_id;
        }
        var param_bridge = {
            method: method,
            paramString: params,
            callbackId: callback_id,
            action: action
        };
        bridge.callHandler('callCoreApi', param_bridge, null);
    } else {
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
            str = JSON.stringify({
                _param: params
            });
        else {
            for (i in params)
                if (typeof params[i] != "string")
                    params[i] = JSON.stringify(params[i])
            str = JSON.stringify(params)
        }
        var params = {
            method: method,
            paramString: ("undefined" == typeof str ? "{}" : str),
            callbackId: callback_id,
            action: JSON.stringify(action)
        };
        bridge.callHandler('callCoreApi', params, null);
    }

}

function putCallback(callback) {
    var callback_id = 'webview_' + (unique_id++) + new Date().getTime();
    _response_callbacks[callback_id] = callback;
    return callback_id;
}

//调用设备原生方法
var $O = {};

//获取完整的网络请求参数
$O.getNetParamIos = function(params, responseCallBack) {
    Original.getNetParams(params, responseCallBack);
}
//项目配制及网络资源的本地路径
$O.getLocalPathIos = function(responseCallBack) {
    Original.getDecoratePath(responseCallBack);
}
//获取项目配制
$O.getDecorateConfigIos = function(responseCallBack) {
    Original.getDecorateConfig(function(response) {
        var config = $.parseJSON(response).configs;
        responseCallBack(config);
    });
}
$O.setScrollable = function(param) {
    Original.setScrollable(param);
}


$O.postEvent = function(method, para1, para2, para3) {
    if ("undefined" == typeof para1) para1 = null
    if ("undefined" == typeof para2) para2 = null
    if ("undefined" == typeof para3) para3 = null
    Original.postEvent(method, para1, para2, para3);
}
var postEvent = $O.postEvent;
$O.callApi = function(method, param, success, fail, version) {
    if (!version)
        version = "1.0";
    if (!fail)
        vail = function() {};
    param.method = method;
    if (!param.version)
        param.version = version;
    try {
        callDeviceApi('postRequest', param, success);
    } catch (e) {
        fail(e)
    }
}
$O.getAppconfig = function(callback) {
    if (typeof Original == "undefined")
        return callback({})
        //    return ECOriginal.getDecorateConfig();
    callDeviceApi('getDecorateConfig', null, callback);
}
//获取完整的网络请求参数
$O.pullQueue = function(params, callback) {
    callDeviceApi('pullQueue', params, callback);
    //  return Original.getNetParams(params,callback);
}
//获取完整的网络请求参数
$O.getNetParam = function(params, callback) {
    callDeviceApi('getNetParams', params, callback);
    //  return Original.getNetParams(params,callback);
}
//项目配制及网络资源的本地路径
$O.getLocalPath = function(callback) {
    callDeviceApi('getDecoratePath', null, callback);
    //  return Original.getDecoratePath();
}
$O.getConfigFilePath = function(callback) {
    callDeviceApi('getConfigFilePath', null, callback);
}
//获取项目配制
$O.getDecorateConfig = function(callback) {
    //  var config_str= Original.getDecorateConfig();
    //  return $.parseJSON( config_str ).configs;
    callDeviceApi('getDecorateConfig', null, callback);
}

$O.setScrollable = function(param) {
    Original.setScrollable(param);
}
$O.getPageParam = function(key, callback) {
    callDeviceApi("getPageParam", key, callback);
}
$O.isLogin = function(callback) {
    callDeviceApi("isLogin", null, callback);
}
// 加入缓存
$O.putCache = function(params, callback) {
    callDeviceApi("putCache", params, callback);
}

// 获取缓存
$O.getCache = function(params, callback) {
    callDeviceApi("getCache", params, callback);
}

// 获取缓存列表
$O.getCaches = function(params, callback) {
    callDeviceApi("getCaches", params, callback);
}

// 删除缓存
$O.removeCaches = function(params, callback) {
    callDeviceApi("removeCaches", params, callback);
}
// toast
$O.makeToast = function(params, callback) {
    callDeviceApi("makeToast", params, callback);
}
