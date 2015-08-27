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
  _content_id: ""
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
      page_name: "page_my",
      params: {}
      close_option: ""

  onCreated: () ->

  onItemClick: (data) ->

  onItemInnerClick: (data) ->
    item = root._listview_data.data[data.position]
    if item._type? and item._type == 'ok'
      $A().lrucache().get("phone").then (phone) ->
        if phone? and phone != ""
          $A().app().openPage
            page_name: "page_comment_input"
            params:
              info: root._content_id
            close_option: ""
        else
          $A().app().showConfirm
            ok: "登陆"
            cancel: "取消"
            title: "警告"
            message: "您尚未登陆，请先登陆"
          .then (data) ->
            if data.state == "ok"
              $A().app().openPage
                page_name: "page_login",
                params: {}
                close_option: ""
            if data.state == "cancel"
              return false

  onResume: () ->
    $A().app().callApi
      method: "comment/comments"
      content_id: root._content_id
      cacheTime: 0
    .then (data) ->
      if data.errors?
        if data.errors[0].error_num?
          $A().app().makeToast "网络状态不好，请重新加载"
        else
          $A().app().makeToast "没有网络"
      else
        root._listview_data.data = []

        if data.count == 0
          root._listview_data.data = []
          root._listview_data.data.push
            viewType: "ListViewCellLine"
            centerTitle: "暂无信息"
        else
          for content in data.content_list
            if content.admin_reply == ""
              admin_reply = ""
            else
              admin_reply = "管理员回复：" + content.admin_reply
            root._listview_data.data.push
              viewType: "ListViewCellTwoLineText"
              headTitle: "#{content.content}"
              headTime: "#{content.updated_at}"
              subTitle: "#{content.nickname}"
              expandTitle: admin_reply
              _leftLayoutSize: 75,
              hasFooterDivider: "true"
        root._listview_data.data.push
          viewType: "ListViewCellButton",
          btnTitle: "我要评论",
          btnType: "ok"
          _type: "ok"
        $A().page().widget("#{root._page_name}_ListViewBase_0").refreshData JSON.stringify root._listview_data

  onResult: (data) ->

#---------------------------------------具体业务代码---------------------------------------------
  prepareForInitView: () ->
    $A().app().platform().then (platform) ->
      root._platform = platform
    $A().page().param("content_id").then (content_id) ->
      root._content_id = content_id

#启动程序
Page = new ECpageClass("page_comment_list")
