class ECpageClass
  root = {} # 这是ECpageClass的一个实例的全局变量
  _page_name: "" # 属性
  _item_info: {}
  _platform: ""
  _listview_data:
    pullable: false
    hasFooterDivider: true
    hasHeaderDivider: true
    dividerHeight: 1
    dividerColor: "#EBEBEB"
    data: [
      {
        viewType: "ListViewCellLine"
        _rightLayoutSize: 0
        _leftLayoutSize: 60
        centerTitle: "正在加载......"
      }
    ]
  _sort_id: ""
#    _theme = "default"

  _constructor: (@_page_name) ->
    root = this
    #获取其他界面传来的数据
    @prepareForInitView()
    #        $A().lrucache().get("phone").then (phone) ->
    #            root._listview_data.data[1].inputText =  if phone? and phone != "" then phone else ""

    $A().page().widget("#{@_page_name}_ListViewBase_0").data JSON.stringify @_listview_data
    $A().page().widget("#{@_page_name}_ListViewBase_0").onItemInnerClick (data)-> root.onItemInnerClick(data)
    $A().page().widget("#{@_page_name}_ListViewBase_0").onItemClick (data)-> root.onItemClick(data)
    $A().page().widget("ActionBar").onItemClick (data)-> root.onActionBarItemClick(data)
    $A().page().onResume (data)-> root.onResume()
    $A().page().onResult (data)-> root.onResult(data)
    $A().page().onCreated -> root.onCreated()

  constructor: (_page_name) ->
    @_constructor(_page_name)

  onActionBarItemClick: (data) ->
    $A().app().openPage
      page_name:"page_my",
      params: {}
      close_option: ""

  onCreated: () ->
    $A().app().callApi
      method: "trade/coupons/show"
      cacheTime: 0
      sort_id: root._sort_id
      simple_result: true
    .then (data) ->
      if data.errors?
        if data.errors[0].error_num?
          $A().app().makeToast "网络状态不好，请重新加载"
        else
          $A().app().makeToast "没有网络"
      else
        root._listview_data.data = []

        if data.order.length == 0
          root._listview_data.data = []
          root._listview_data.data.push
            viewType: "ListViewCellLine"
            centerTitle: "用户优惠券不存在"
          $A().page().widget("#{root._page_name}_ListViewBase_0").refreshData JSON.stringify root._listview_data
        else
          for order in data.order
            root._listview_data.data.push
              viewType: "ListViewCellLine"
              centerTitle: "#{order.content.title}"
              leftImage: {
                imageType: "imageServer"
                imageSize: "middle"
                imageSrc: "#{order.content.image_cover.url}"
              }
              _leftLayoutSize:75,
              centerBottomdes: "#{order.content.abstract}"
              content_id: "#{order.content.id}"
              hasFooterDivider: "true"
          $A().page().widget("#{root._page_name}_ListViewBase_0").refreshData JSON.stringify root._listview_data

  onItemClick: (data) ->
    item = @_listview_data.data[data.position]
    if item.content_id?
      if root._sort_id == "1038"
        $A().app().openPage
          page_name: "page_coupon_info"
          params:
            info: item.content_id
          close_option: ""
      if root._sort_id == "528"
        $A().app().openPage
          page_name: "page_lesson_info"
          params:
            info: item.content_id
          close_option: ""

  onItemInnerClick: (data) ->

  onResume: () ->

  onResult: (data) ->

    #---------------------------------------具体业务代码---------------------------------------------
  prepareForInitView: () ->
    $A().app().platform().then (platform) ->
      root._platform = platform
    $A().page().param("info").then (info) ->
      root._sort_id = info

#启动程序
Page = new ECpageClass("page_mycoupon_list")
