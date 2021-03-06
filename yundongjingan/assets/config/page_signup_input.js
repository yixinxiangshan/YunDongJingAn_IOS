// Generated by CoffeeScript 1.9.3
(function() {
  var ECpageClass, Page;

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
          viewType: "ListViewCellInputText",
          inputType: "text",
          hint: "姓名（必填）",
          name: "username",
          inputText: ""
        }, {
          viewType: "ListViewCellInputText",
          inputType: "number",
          hint: "年龄（必填）",
          name: "age",
          inputText: ""
        }, {
          viewType: "ListViewCellInputText",
          inputType: "number",
          hint: "电话（必填）",
          name: "phone",
          inputText: ""
        }, {
          viewType: "ListViewCellInputText",
          inputType: "text",
          hint: "单位（可选）",
          name: "address",
          inputText: ""
        }, {
          viewType: "ListViewCellButton",
          inputType: "number",
          btnTitle: "提 交",
          btnType: "ok",
          _type: "ok"
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
      $A().page().widget("ActionBar").onItemClick(function(data) {
        return root.onActionBarItemClick(data);
      });
      return $A().page().onCreated(function() {
        return root.onCreated();
      });
    };

    function ECpageClass(_page_name) {
      this._constructor(_page_name);
    }

    ECpageClass.prototype.onActionBarItemClick = function(data) {
      return $A().app().openPage({
        page_name: "page_my",
        params: {},
        close_option: ""
      });
    };

    ECpageClass.prototype.onCreated = function() {
      return $A().page().param("info").then(function(info) {
        root._item_info = JSON.parse(info);
        if (root._item_info.signup_id != null) {
          $A().app().callApi({
            method: "trade/signups/detail",
            signup_id: root._item_info.signup_id,
            cacheTime: 0
          }).then(function(data) {
            if (data.errors != null) {
              if (data.errors[0].error_num != null) {
                return $A().app().makeToast("网络状态不好，请重新加载");
              } else {
                return $A().app().makeToast("没有网络");
              }
            } else {
              root._listview_data.data[0].inputText = data.order.username;
              root._listview_data.data[1].inputText = "" + data.order.age;
              root._listview_data.data[2].inputText = "" + data.order.phone;
              root._listview_data.data[3].inputText = "" + data.order.address;
              root._listview_data.data.push({
                viewType: "ListViewCellButton",
                inputType: "number",
                btnTitle: "删 除",
                btnType: "cancel",
                _type: "cancel"
              });
              return $A().page().widget(root._page_name + "_ListViewBase_0").refreshData(JSON.stringify(root._listview_data));
            }
          });
        }
        if ((root._platform != null) && root._platform === "ios") {
          return $A().page().widget(root._page_name + "_ListViewBase_0").refreshData(JSON.stringify(root._listview_data));
        }
      });
    };

    ECpageClass.prototype.onItemClick = function(data) {};

    ECpageClass.prototype.onItemInnerClick = function(data) {
      var address, age, item, phone, username;
      item = this._listview_data.data[data.position];
      if ((item._type != null) && item._type === 'cancel') {
        return $A().app().showConfirm({
          ok: "确定",
          title: "警告",
          cancel: "取消",
          message: "删除之后将无法恢复，您需要重新申请。确定需要删除吗？"
        }).then(function(result) {
          if (result.state === "ok") {
            $A().app().makeToast("正在删除");
            return $A().app().callApi({
              method: "trade/signups/destroy",
              id: root._item_info.signup_id,
              cacheTime: 0
            }).then(function(data) {
              if (data.success === true) {
                $A().app().makeToast("删除成功。");
                return $A().page().setTimeout("2000").then(function() {
                  return $A().app().closePage();
                });
              } else {
                return $A().app().makeToast("删除失败，请重试或者检查您的网络是否打开。");
              }
            });
          } else {
            return false;
          }
        });
      } else {
        username = data._form.username != null ? data._form.username : "";
        age = data._form.age != null ? data._form.age : "";
        phone = data._form.phone != null ? data._form.phone : "";
        address = data._form.address != null ? data._form.address : "";
        if (username === "") {
          return $A().app().makeToast("请输入您的姓名");
        } else if (age === "") {
          return $A().app().makeToast("请输入您的年龄");
        } else if (phone === "") {
          return $A().app().makeToast("请输入您的电话");
        } else {
          if ((item._type != null) && item._type === 'ok') {
            $A().app().makeToast("正在提交");
            if (root._item_info.signup_id != null) {
              return $A().app().callApi({
                method: "trade/signups/modify",
                id: root._item_info.signup_id,
                cms_content_id: root._item_info.content_id,
                title: root._item_info.content_title,
                username: username,
                age: age,
                phone: phone,
                address: address,
                cacheTime: 0
              }).then(function(data) {
                if (data.success === true) {
                  $A().app().makeToast("提交成功，谢谢您的申请。");
                  return $A().page().setTimeout("2000").then(function() {
                    return $A().app().closePage();
                  });
                } else {
                  return $A().app().makeToast("提交失败，请重试或者检查您的网络是否打开。");
                }
              });
            } else {
              return $A().app().callApi({
                method: "trade/signups/create",
                cms_content_id: root._item_info.content_id,
                title: root._item_info.content_title,
                username: username,
                age: age,
                phone: phone,
                address: address,
                cacheTime: 0
              }).then(function(data) {
                if (data.success === true) {
                  $A().app().makeToast("提交成功，谢谢您的申请。");
                  return $A().page().setTimeout("2000").then(function() {
                    return $A().app().closePage();
                  });
                } else {
                  return $A().app().makeToast("提交失败，请重试或者检查您的网络是否打开。");
                }
              });
            }
          }
        }
      }
    };

    ECpageClass.prototype.onResume = function() {};

    ECpageClass.prototype.onResult = function(data) {};

    ECpageClass.prototype.prepareForInitView = function() {
      return $A().app().platform().then(function(platform) {
        return root._platform = platform;
      });
    };

    return ECpageClass;

  })();

  Page = new ECpageClass("page_signup_input");

}).call(this);
