// Generated by CoffeeScript 1.9.3
(function() {
  var ECpageClass;

  ECpageClass = (function() {
    var root;

    root = {};

    ECpageClass.prototype._page_name = "";

    ECpageClass.prototype._content_info = {};

    ECpageClass.prototype._platform = "";

    ECpageClass.prototype._listview_data = {
      pullable: false,
      hasFooterDivider: true,
      hasHeaderDivider: true,
      dividerHeight: 1,
      dividerColor: "#EBEBEB"
    };

    ECpageClass.prototype._isOnline = true;

    ECpageClass.prototype._constructor = function(_page_name1) {
      this._page_name = _page_name1;
      root = this;
      this.prepareForInitView();
      $A().page().widget(this._page_name + "_SatelliteWidget_0").data(JSON.stringify(this._listview_data));
      $A().page().widget(this._page_name + "_SatelliteWidget_0").onItemInnerClick(function(data) {
        return root.onItemInnerClick(data);
      });
      $A().page().widget(this._page_name + "_SatelliteWidget_0").onItemClick(function(data) {
        return root.onItemClick(data);
      });
      return $A().page().onCreated(function() {
        return root.onCreated();
      });
    };

    function ECpageClass(_page_name) {
      this._constructor(_page_name);
    }

    ECpageClass.prototype.onCreated = function() {
      $A().app().netState().then(function(net_state) {
        if (net_state === "offline") {
          root._isOnline = false;
          return $A().app().makeToast("没有网络");
        } else {
          return $A().page().setTimeout("3000").then(function() {
            return $A().app().callApi({
              method: "project/projects/detail",
              cacheTime: 0
            }).then(function(data) {
              if (data.errors != null) {
                root._isOnline = false;
                if (data.errors[0].error_num != null) {
                  return $A().app().makeToast("网络状态不好，请重新加载");
                } else {
                  return $A().app().makeToast("没有网络");
                }
              }
            });
          });
        }
      });
      if ((root._platform != null) && root._platform === "ios") {
        return $A().page().widget(this._page_name + "_SatelliteWidget_0").refreshData(JSON.stringify(this._listview_data));
      }
    };

    ECpageClass.prototype.onItemClick = function(data) {
      if (root._isOnline) {
        return $A().app().openPage({
          page_name: "page_index_tab",
          params: data.id,
          close_option: ""
        });
      } else {
        return $A().app().makeToast("无法连接服务器，请检查网络状况，并重新启动应用");
      }
    };

    ECpageClass.prototype.onItemInnerClick = function(data) {};

    ECpageClass.prototype.onResume = function() {};

    ECpageClass.prototype.onResult = function(data) {};

    ECpageClass.prototype.prepareForInitView = function() {
      return $A().app().platform().then(function(platform) {
        return root._platform = platform;
      });
    };

    return ECpageClass;

  })();

  new ECpageClass("page_index");

}).call(this);
