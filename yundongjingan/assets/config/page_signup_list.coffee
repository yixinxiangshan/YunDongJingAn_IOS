class ECpageClass
  root = {} # 这是ECpageClass的一个实例的全局变量
  _page_name: "" # 属性
  _item_info: {}
  _platform: ""
  _listview_data:
    pullable: false
    hasFooterDivider: false
    hasHeaderDivider: false
    dividerHeight: 0
    dividerColor: "#cccccc"
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
    $A().page().onResume (data)-> root.onResume()
    $A().page().onResult (data)-> root.onResult(data)
    $A().page().onCreated -> root.onCreated()

  constructor: (_page_name) ->
    @_constructor(_page_name)

  onCreated: () ->
    $A().page().param("info").then (info) ->
      root._item_info = JSON.parse info

  onItemClick: (data) ->
    item = @_listview_data.data[data.position]
    content =
    {
      content_id: item.content_id
      content_title: item.content_title
      signup_id: item.signup_id
    }
    $A().app().openPage
      page_name: "page_signup_input"
      params:
        info: content
      close_option: ""

  onItemInnerClick: (data) ->

  onResume: () ->
    $A().app().callApi
      method: "trade/signups/detail"
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
            centerTitle: "#{content.username}"
            centerBottomdes: "#{content.updated_at}"
            content_id: "#{content.cms_content_id}"
            content_title: "#{content.title}"
            signup_id: "#{content.id}"
        $A().page().widget("#{root._page_name}_ListViewBase_0").refreshData JSON.stringify root._listview_data

  onResult: (data) ->

    #---------------------------------------具体业务代码---------------------------------------------
  prepareForInitView: () ->
    $A().app().platform().then (platform) ->
      root._platform = platform

#启动程序
Page = new ECpageClass("page_signup_list")
