// Generated by CoffeeScript 1.9.3
(function() {
  var ECpageClass, Page;

  ECpageClass = (function() {
    var root;

    root = {};

    ECpageClass.prototype._page_name = "";

    ECpageClass.prototype._item_info = {};

    ECpageClass.prototype._platform = "";

    ECpageClass.prototype._id = 0;

    ECpageClass.prototype._listview_data = {
      pullable: false,
      hasFooterDivider: true,
      hasHeaderDivider: true,
      dividerHeight: 1,
      dividerColor: "#cccccc",
      data: [
        {
          viewType: "ListViewCellInputText",
          inputType: "text",
          hint: "请输入您的评论",
          lines: 3,
          name: "content"
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
      $A().lrucache().get("phone").then(function(phone) {
        return root._listview_data.data[1].inputText = (phone != null) && phone !== "" ? phone : "";
      });
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
      if ((root._platform != null) && root._platform === "ios") {
        return $A().page().widget(this._page_name + "_ListViewBase_0").refreshData(JSON.stringify(this._listview_data));
      }
    };

    ECpageClass.prototype.onItemClick = function(data) {};

    ECpageClass.prototype.onItemInnerClick = function(data) {
      var content;
      content = data._form.content != null ? data._form.content : "";
      if (content === "") {
        return $A().app().makeToast("请输入您的评论！");
      } else {
        $A().app().makeToast("正在提交");
        return $A().app().callApi({
          method: "comment/comments/create",
          content_id: root._id,
          content: content,
          typenum: 2,
          cacheTime: 0
        }).then(function(data) {
          if (data.success === true) {
            $A().app().makeToast("提交成功，谢谢您的评论。");
            return $A().page().setTimeout("2000").then(function() {
              return $A().app().closePage();
            });
          } else {
            return $A().app().makeToast("提交失败，请重试或者检查您的网络是否打开。");
          }
        });
      }
    };

    ECpageClass.prototype.onResume = function() {};

    ECpageClass.prototype.onResult = function(data) {};

    ECpageClass.prototype.prepareForInitView = function() {
      $A().app().platform().then(function(platform) {
        return root._platform = platform;
      });
      return $A().page().param("info").then(function(info) {
        return root._id = info;
      });
    };

    return ECpageClass;

  })();

  Page = new ECpageClass("page_comment_input");

}).call(this);
