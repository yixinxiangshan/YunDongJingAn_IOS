(function() {
    var response_callbacks = {};
    var unique_id = 10;

    // 环境设置
    var _env = {
        debug: _debug,
        env: "ios", //android java ios web
        parent_id: _pid,
        lang: _lang,
        is_obj_input: typeof _is_obj_input == "undefined" ? false : true
    };

    var callCoreApi = function(method, params, callback, action) {
        var callback_id = putCallback(callback);
        //新的 javascript bridge 不需要把对像转换在string 
        if (_env.is_obj_input) {
            var event_id = null;
            if ("function" == typeof params) {
                event_id = putCallback(params);
                params = event_id;
            }
            // 处理参数
            callDeviceApi(method, params, callback_id, action);
        } else {
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
                str = JSON.stringify({
                    _param: params
                });
            else {
                for (i in params)
                    if (typeof params[i] != "string")
                        params[i] = JSON.stringify(params[i])
                str = JSON.stringify(params)
            }
            
            callDeviceApi(method, ("undefined" == typeof str ? "{}" : str), callback_id, JSON.stringify(action));
        }
    };

    function putCallback(callback) {
        var callback_id = 'device_' + (unique_id++) + new Date().getTime();
        response_callbacks[callback_id] = callback;
        return callback_id;
    }
    this.callCoreApi = callCoreApi;
    this._env = _env;
    this._response_callbacks = response_callbacks;
    this._putCallback = putCallback
}).call(this);


function makeTorast(words) {
    // java接口
    //    var utilityNames = JavaImporter();
    //    utilityNames.importClass(com.ecloudiot.framework.javascript.JsAPI);
    //    with(utilityNames) {
    //        JsAPI.makeTorast(words);
    //    }
    MakeToast(words);
}
