class ECpageClass
  root = {} # 这是ECpageClass的一个实例的全局变量
  _page_name: "" # 属性
  _item_info: {}
  _platform: ""
  _id: 0
  _listview_data:
    pullable: false
    hasFooterDivider: true
    hasHeaderDivider: true
    dividerHeight: 1
    dividerColor: "#cccccc"
    data: [
      {
        viewType: "ListViewCellInputText"
        inputType: "text"
        hint: "请输入您的评论"
        lines: 3
        name: "content"
      }
      {
        viewType: "ListViewCellButton"
        inputType: "number"
        btnTitle: "提 交"
        btnType: "ok"
        _type: "ok"
      }
    ]

  _constructor: (@_page_name) ->
    root = this
    #获取其他界面传来的数据
    @prepareForInitView()
    $A().lrucache().get("phone").then (phone) ->
      root._listview_data.data[1].inputText = if phone? and phone != "" then phone else ""

    $A().page().widget("#{@_page_name}_ListViewBase_0").data JSON.stringify @_listview_data
    $A().page().widget("#{@_page_name}_ListViewBase_0").onItemInnerClick (data)-> root.onItemInnerClick(data)
    $A().page().widget("#{@_page_name}_ListViewBase_0").onItemClick (data)-> root.onItemClick(data)
    $A().page().widget("ActionBar").onItemClick (data)-> root.onActionBarItemClick(data)
    # $A().page().onResume (data)-> root.onResume()
    # $A().page().onResult (data)-> root.onResult(data)
    $A().page().onCreated -> root.onCreated()

  constructor: (_page_name) ->
    @_constructor(_page_name)

  onActionBarItemClick: (data) ->
    $A().app().openPage
      page_name:"page_my",
      params: {}
      close_option: ""

  onCreated: () ->
    $A().page().widget("#{@_page_name}_ListViewBase_0").refreshData JSON.stringify @_listview_data if root._platform? and root._platform == "ios"
#自定义函数

  onItemClick: (data) ->

  onItemInnerClick: (data) ->
    content = if data._form.content? then data._form.content else ""
    if content == ""
      $A().app().makeToast "请输入您的评论！"
    else
      $A().app().makeToast "正在提交"
      $A().app().callApi
        method: "comment/comments/create"
        content_id: root._id
        content: content
        typenum: 2
        cacheTime: 0
      .then (data) ->
        if data.success == true
          $A().app().makeToast "提交成功，谢谢您的评论。"
          $A().page().setTimeout("2000").then () ->
            $A().app().closePage()
        else
          $A().app().makeToast "提交失败，请重试或者检查您的网络是否打开。"

  onResume: () ->

  onResult: (data) ->

#---------------------------------------具体业务代码---------------------------------------------
  prepareForInitView: () ->
    $A().app().platform().then (platform) ->
      root._platform = platform
    $A().page().param("info").then (info) ->
      root._id = info

#启动程序
Page = new ECpageClass("page_comment_input")
