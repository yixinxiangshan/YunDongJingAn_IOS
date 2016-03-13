// Generated by CoffeeScript 1.9.3
(function() {
  var ECpageClass;

  ECpageClass = (function() {
    var root;

    root = {};

    ECpageClass.prototype._page_name = "";

    ECpageClass.prototype._item_info = {};

    ECpageClass.prototype._platform = "";

    ECpageClass.prototype._listview_data = {
      pullable: false,
      hasFooterDivider: true,
      hasHeaderDivider: true,
      dividerHeight: 1,
      dividerColor: "#EBEBEB",
      data: [
        {
          viewType: "ListViewCellLine",
          _rightLayoutSize: 0,
          _leftLayoutSize: 0,
          centerTitle: "未登录",
          rightImage: {
            imageType: "assets",
            imageSize: "fitSize",
            imageSrc: "webview/images/icon/default/listview_right.png"
          },
          name: "mycenter",
          hasFooterDivider: "true"
        }, {
          viewType: "ListViewCellGroupTitle",
          textTitle: "我的课程"
        }, {
          viewType: "ListViewCellLine",
          _rightLayoutSize: 0,
          _leftLayoutSize: 0,
          centerTitle: "我的已申请课程",
          name: "lesson",
          hasFooterDivider: "true"
        }, {
          viewType: "ListViewCellLine",
          _rightLayoutSize: 0,
          _leftLayoutSize: 0,
          centerTitle: "我的运动记录",
          name: "activity",
          hasFooterDivider: "true"
        }, {
          viewType: "ListViewCellGroupTitle",
          textTitle: "我的订单"
        }, {
          viewType: "ListViewCellLine",
          _rightLayoutSize: 0,
          _leftLayoutSize: 0,
          centerTitle: "我的场馆优惠",
          name: "coupon",
          hasFooterDivider: "true"
        }, {
          viewType: "ListViewCellLine",
          _rightLayoutSize: 0,
          _leftLayoutSize: 0,
          centerTitle: "我的赛事报名",
          name: "signup",
          hasFooterDivider: "true"
        }, {
          viewType: "ListViewCellLine",
          _rightLayoutSize: 0,
          _leftLayoutSize: 0,
          centerTitle: "我的你点我送",
          name: "send",
          hasFooterDivider: "true"
        }, {
          viewType: "ListViewCellGroupTitle",
          textTitle: "其他"
        }, {
          viewType: "ListViewCellLine",
          _rightLayoutSize: 0,
          _leftLayoutSize: 0,
          centerTitle: "扫一扫",
          name: "scan",
          hasFooterDivider: "true"
        }, {
          viewType: "ListViewCellLine",
          _rightLayoutSize: 0,
          _leftLayoutSize: 0,
          centerTitle: "设置",
          name: "setting",
          hasFooterDivider: "true"
        }
      ]
    };

    ECpageClass.prototype._constructor = function(_page_name1) {
      this._page_name = _page_name1;
      root = this;
      this.prepareForInitView();
      $A().page().widget(this._page_name + "_ListViewBase_0").data(JSON.stringify(this._listview_data));
      $A().page().widget(this._page_name + "_ListViewBase_0").onItemInnerClick(function(data) {
        return root.onItemInnerClick(data);
      });
      $A().page().widget(this._page_name + "_ListViewBase_0").onItemClick(function(data) {
        return root.onItemClick(data);
      });
      $A().page().onResume(function() {
        return root.onResume();
      });
      $A().page().onResult(function(data) {
        return root.onResult(data);
      });
      return $A().page().onCreated(function() {
        return root.onCreated();
      });
    };

    function ECpageClass(_page_name) {
      this._constructor(_page_name);
    }

    ECpageClass.prototype.onCreated = function() {
      return $A().lrucache().get("phone").then(function(phone) {
        if ((phone != null) && phone !== "") {
          root._listview_data.data[0].centerTitle = "" + phone;
        } else {
          root._listview_data.data[0].centerTitle = "未登录";
        }
        return $A().page().widget(root._page_name + "_ListViewBase_0").refreshData(JSON.stringify(root._listview_data));
      });
    };

    ECpageClass.prototype.onItemClick = function(data) {
      var item;
      item = this._listview_data.data[data.position];
      switch ("" + item.name) {
        case "mycenter":
          return $A().lrucache().get("phone").then(function(phone) {
            if ((phone != null) && phone !== "") {
              return $A().app().openPage({
                page_name: "page_mycenter",
                params: {},
                close_option: ""
              });
            } else {
              return $A().app().openPage({
                page_name: "page_login",
                params: {},
                close_option: ""
              });
            }
          });
        case "setting":
          return $A().app().openPage({
            page_name: "page_setting",
            params: {},
            close_option: ""
          });
        case "lesson":
          return $A().lrucache().get("phone").then(function(phone) {
            if ((phone != null) && phone !== "") {
              return $A().app().openPage({
                page_name: "page_mycoupon_list",
                params: {
                  info: 528
                },
                close_option: ""
              });
            } else {
              return $A().app().showConfirm({
                ok: "登陆",
                cancel: "取消",
                title: "警告",
                message: "您尚未登陆，请先登陆"
              }).then(function(data) {
                if (data.state === "ok") {
                  $A().app().openPage({
                    page_name: "page_login",
                    params: {},
                    close_option: ""
                  });
                }
                if (data.state === "cancel") {
                  return false;
                }
              });
            }
          });
        case "activity":
          return $A().lrucache().get("phone").then(function(phone) {
            if ((phone != null) && phone !== "") {
              return $A().app().openPage({
                page_name: "page_activity_list",
                params: {},
                close_option: ""
              });
            } else {
              return $A().app().showConfirm({
                ok: "登陆",
                cancel: "取消",
                title: "警告",
                message: "您尚未登陆，请先登陆"
              }).then(function(data) {
                if (data.state === "ok") {
                  $A().app().openPage({
                    page_name: "page_login",
                    params: {},
                    close_option: ""
                  });
                }
                if (data.state === "cancel") {
                  return false;
                }
              });
            }
          });
        case "coupon":
          return $A().lrucache().get("phone").then(function(phone) {
            if ((phone != null) && phone !== "") {
              return $A().app().openPage({
                page_name: "page_mycoupon_list",
                params: {
                  info: 1038
                },
                close_option: ""
              });
            } else {
              return $A().app().showConfirm({
                ok: "登陆",
                cancel: "取消",
                title: "警告",
                message: "您尚未登陆，请先登陆"
              }).then(function(data) {
                if (data.state === "ok") {
                  $A().app().openPage({
                    page_name: "page_login",
                    params: {},
                    close_option: ""
                  });
                }
                if (data.state === "cancel") {
                  return false;
                }
              });
            }
          });
        case "signup":
          return $A().lrucache().get("phone").then(function(phone) {
            var content;
            if ((phone != null) && phone !== "") {
              content = {
                content_id: item.content_id
              };
              return $A().app().openPage({
                page_name: "page_signup_list",
                params: {
                  info: JSON.stringify(content)
                },
                close_option: ""
              });
            } else {
              return $A().app().showConfirm({
                ok: "登陆",
                cancel: "取消",
                title: "警告",
                message: "您尚未登陆，请先登陆"
              }).then(function(data) {
                if (data.state === "ok") {
                  $A().app().openPage({
                    page_name: "page_login",
                    params: {},
                    close_option: ""
                  });
                }
                if (data.state === "cancel") {
                  return false;
                }
              });
            }
          });
        case "send":
          return $A().lrucache().get("phone").then(function(phone) {
            var content;
            if ((phone != null) && phone !== "") {
              content = {
                content_id: ""
              };
              return $A().app().openPage({
                page_name: "page_send_list",
                params: {
                  info: JSON.stringify(content)
                },
                close_option: ""
              });
            } else {
              return $A().app().showConfirm({
                ok: "登陆",
                cancel: "取消",
                title: "警告",
                message: "您尚未登陆，请先登陆"
              }).then(function(data) {
                if (data.state === "ok") {
                  $A().app().openPage({
                    page_name: "page_login",
                    params: {},
                    close_option: ""
                  });
                }
                if (data.state === "cancel") {
                  return false;
                }
              });
            }
          });
        case "scan":
          return $A().page("page_my").openQRCapture({});
      }
    };

    ECpageClass.prototype.onItemInnerClick = function(data) {};

    ECpageClass.prototype.onResult = function(data) {
      $A().app().makeToast("正在签到");
      return $A().app().callApi({
        method: "comment/comments/create",
        content_id: data.codeString,
        content: "签到",
        typenum: 1,
        cacheTime: 0
      }).then(function(data1) {
        if (data1.success === true) {
          return $A().app().makeToast("签到成功，谢谢。");
        } else {
          return $A().app().makeToast("提交失败，请重试或者检查您的网络是否打开。");
        }
      });
    };

    ECpageClass.prototype.onResume = function() {
      return $A().page("page_my").param("_setting_changed").then(function(data) {
        if ((data != null) && data !== "") {
          $A().page("page_my").param({
            key: "_setting_changed",
            value: ""
          });
          return root.onCreated();
        }
      });
    };

    ECpageClass.prototype.prepareForInitView = function() {
      return $A().app().platform().then(function(platform) {
        return root._platform = platform;
      });
    };

    return ECpageClass;

  })();

  new ECpageClass("page_my");

}).call(this);
