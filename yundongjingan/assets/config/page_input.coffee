# page类
class ECpageClass
  root = {}  # 这是ECpageClass的一个实例的全局变量
  _page_name : "" # 属性
  _item_info : {}
  _platform:""
  _listview_data:
    pullable: false
    hasFooterDivider: true
    hasHeaderDivider: true
    dividerHeight: 1
    dividerColor: "#EBEBEB"
    data: [
      {
        viewType: "ListViewCellInputText"
        inputType:"text"
        hint:""
        type:"captcha"
        inputText:""
        name:"input"
      }
      {
        viewType: "ListViewCellButton"
        btnTitle: "确 定"
        btnType : "ok"
        name:"ok"
      }

    ]

  _constructor: (@_page_name) ->
    root = this
    #获取其他界面传来的数据
    @prepareForInitView()

    $A().page().widget("#{@_page_name}_ListViewBase_0").data JSON.stringify @_listview_data
    $A().page().widget("#{@_page_name}_ListViewBase_0").onItemInnerClick (data)-> root.onItemInnerClick(data)
    $A().page().widget("#{@_page_name}_ListViewBase_0").onItemClick (data)-> root.onItemClick(data)
    $A().page().widget("ActionBar").onItemClick (data)-> root.onActionBarItemClick(data)
    $A().page().onResume ()-> root.onResume()
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
    $A().page().param("info").then (data) ->
      data = JSON.parse data
      root._item_info = data
      root._listview_data.data[0].hint = data.hint
      root._listview_data.data[0].inputText = data.inputText
      $A().page().widget("#{root._page_name}_ListViewBase_0").refreshData JSON.stringify root._listview_data
#自定义函数
    $A().page().widget("#{@_page_name}_ListViewBase_0").refreshData JSON.stringify @_listview_data if root._platform? and root._platform == "ios"
    root.setActionBartitle()
  onItemClick: (data) ->


  onItemInnerClick: (data) ->
# $A().app().makeToast JSON.stringify data.position
    item = root._listview_data.data[data.position]

    # data._form = JSON.parse data._form
    input = if data._form.input? then data._form.input else ""
    # position =
    switch "#{item.name}"
      when "ok"
        if input != ""
          $A().page("#{root._item_info.page_name}").param {key: "#{root._item_info.key}" , value: "#{input}"}
          $A().app().makeToast "正在设置"
          $A().page().setTimeout("2000").then () ->
            $A().app().closePage()

  onResume: () ->
    $A().page().param("_setting_changed").then (data) ->
      if data != ""
        $A().page().param {key: "_setting_changed" , value: ""}
        # 本地刷新
        initPage()
  onResult: () ->

#---------------------------------------具体业务代码---------------------------------------------

  prepareForInitView: () ->
    $A().app().platform().then (platform) ->
      root._platform = platform

  setActionBartitle:() ->
    $A().page().setTimeout("100").then () ->
      $A().page("page_input").widget("ActionBar").title
        title: "#{@_item_info.hint}"
#启动程序
new ECpageClass("page_input")