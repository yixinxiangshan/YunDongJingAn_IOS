// Generated by CoffeeScript 1.9.1
(function() {
  var ECpageClass, Page;

  ECpageClass = (function() {
    var root;

    function ECpageClass() {}

    root = {};

    ECpageClass.prototype._page_name = "";

    ECpageClass.prototype._item_info = {};

    ECpageClass.prototype._platform = "";

    ECpageClass.prototype._listview_data = {
      pullable: false,
      hasFooterDivider: false,
      hasHeaderDivider: false,
      dividerHeight: 0,
      dividerColor: "#cccccc",
      data: [
        {
          viewType: "ListViewCellLine",
          _rightLayoutSize: 0,
          _leftLayoutSize: 60,
          centerTitle: "正在加载......"
        }
      ]
    };

    ECpageClass.prototype._constructor = function(_page_name) {
      this._page_name = _page_name;
      root = this;
      return this.prepareForInitView();
    };

    return ECpageClass;

  })();

  Page = new ECpageClass("page_tab_index");

}).call(this);
