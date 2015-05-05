(function() {
    var response_callbacks = {};
    var unique_id = 10;

    // 环境设置
    var _env = {
        debug: _debug,
        env: "android", //android java ios web
        parent_id: _pid,
        lang: _lang
    };
    var callCoreApi = function(method, params, callback, action) {
        var callback_id = putCallback(callback);
        var event_id = null;
        if ("function" == typeof params) {
            event_id = putCallback(params);
            params = {
                _event_id: event_id
            }
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
        // 操作系统接口
        callDeviceApi(method, ("undefined" == typeof str ? "{}" : str), callback_id, JSON.stringify(action));
        // var jsapi = com.ecloudiot.framework.javascript.JsAPI
        // jsapi.callDeviceApi(method, ("undefined" == typeof str ? "{}" : str), callback_id, JSON.stringify(action));
    };

    function putCallback(callback) {
        var callback_id = 'device_' + (unique_id++) + new Date().getTime();
        response_callbacks[callback_id] = callback;
        return callback_id;
    }
    // callback时有些函数接收对象参数，需要从这里中转一下
    function object_callback(callback_id , param){
        this._response_callbacks[callback_id](JSON.parse(param))
    }

    this.callCoreApi = callCoreApi;
    this._env = _env;
    this._response_callbacks = response_callbacks;
    this._object_callback = object_callback;
}).call(this);


// function makeTorast(words) {
//     // java接口
//     var utilityNames = JavaImporter();
//     utilityNames.importClass(com.ecloudiot.framework.javascript.JsAPI);
//     with(utilityNames) {
//         JsAPI.makeTorast(words);
//     }
// }

