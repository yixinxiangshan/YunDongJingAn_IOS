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
    $A().page().param("info").then (info) ->
      root._item_info = JSON.parse info

  onItemClick: (data) ->
    item = @_listview_data.data[data.position]
    if item.order_id?
      content =
      {
        content_id: item.content_id
        content_title: item.content_title
        order_id: item.order_id
        consignee_id: item.consignee_id
      }
      $A().app().openPage
        page_name: "page_send_input"
        params:
          info: JSON.stringify content
        close_option: ""

  onItemInnerClick: (data) ->

  onResume: () ->
    $A().app().callApi
      method: "trade/ships/detail"
      cms_content_id: root._item_info.content_id
      cacheTime: 0
    .then (data) ->
      if data.errors?
        if data.errors[0].error_num?
          if data.errors[0].error_msg?
            root._listview_data.data = []
            root._listview_data.data.push
              viewType: "ListViewCellLine"
              centerTitle: data.errors[0].error_msg
            $A().page().widget("#{root._page_name}_ListViewBase_0").refreshData JSON.stringify root._listview_data
          else
            $A().app().makeToast "网络状态不好，请重新加载"
        else
          $A().app().makeToast "没有网络"
      else
        root._listview_data.data = []
        for content in data.order
          root._listview_data.data.push
            viewType: "ListViewCellLine"
            centerTitle: "#{content.consignee_name}"
            centerBottomdes: "#{content.updated_at}"
            content_id: "#{content.cms_content_id}"
            content_title: "#{content.title}"
            order_id: "#{content.id}"
            consignee_id: "#{content.user_consignee_id}"
            hasFooterDivider: "true"
        $A().page().widget("#{root._page_name}_ListViewBase_0").refreshData JSON.stringify root._listview_data

  onResult: (data) ->

#---------------------------------------具体业务代码---------------------------------------------
  prepareForInitView: () ->
    $A().app().platform().then (platform) ->
      root._platform = platform

#启动程序
Page = new ECpageClass("page_send_list")
