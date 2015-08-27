// Generated by CoffeeScript 1.9.1
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
      dividerHeight: 0,
      dividerColor: "#EBEBEB",
      data: [
        {
          viewType: "ListViewCellButton",
          btnTitle: "场馆优惠",
          btnType: "ok",
          _type: "coupon"
        }, {
          viewType: "ListViewCellButton",
          btnTitle: "你点我送",
          btnType: "ok",
          _type: "send"
        }, {
          viewType: "ListViewCellButton",
          btnTitle: "赛事报名",
          btnType: "ok",
          _type: "signup"
        }, {
          viewType: "ListViewCellButton",
          btnTitle: "新闻发布",
          btnType: "ok",
          _type: "news"
        }, {
          viewType: "ListViewCellButton",
          btnTitle: "我的",
          btnType: "ok",
          _type: "mine"
        }
      ]
    };

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
      if ((root._platform != null) && root._platform === "ios") {
        return $A().page().widget(this._page_name + "_SatelliteWidget_0").refreshData(JSON.stringify(this._listview_data));
      }
    };

    ECpageClass.prototype.onItemClick = function(data) {};

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
