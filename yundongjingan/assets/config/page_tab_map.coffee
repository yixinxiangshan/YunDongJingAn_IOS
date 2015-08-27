# page类
class ECpageClass
  root = {} # 这是ECpageClass的一个实例的全局变量
  _page_name: "" # 属性
  _content_info: {}
  _platform: ""
  _listview_data:
    pullable: false
    hasFooterDivider: true
    hasHeaderDivider: true
    dividerHeight: 1
    dividerColor: "#EBEBEB"

  _constructor: (@_page_name) ->
    root = this
    #获取其他界面传来的数据
    @prepareForInitView()

    $A().page().widget("#{@_page_name}_MapWidget_0").data JSON.stringify @_listview_data
    $A().page().widget("#{@_page_name}_MapWidget_0").onItemInnerClick (data)-> root.onItemInnerClick(data)
    $A().page().widget("#{@_page_name}_MapWidget_0").onItemClick (data)-> root.onItemClick(data)
    $A().page().widget("ActionBar").onItemClick (data)-> root.onActionBarItemClick(data)
    $A().page().onResume ()-> root.onResume()
    $A().page().onResult (data)-> root.onResult(data)
    $A().page().onCreated -> root.onCreated()

  constructor: (_page_name) ->
    @_constructor(_page_name)

  onCreated: () ->

#自定义函数
  onActionBarItemClick: (data) ->
    if data == "1"
      $A().app().openPage
        page_name:"page_my",
        params: {}
        close_option: ""

  onItemClick: (data) ->

  onItemInnerClick: (data) ->
#    item = @_listview_data.data[data.position]
#    if item._type? and item._type == 'coupon'
#      $A().app().openPage
#        page_name: "page_coupon_list"
#        params: []
#        close_option: ""
#    else if item._type? and item._type == 'send'
#      $A().app().openPage
#        page_name: "page_tab_send"
#        params: []
#        close_option: ""
#    else if item._type? and item._type == 'signup'
#      $A().app().openPage
#        page_name: "page_tab_signup"
#        params: []
#        close_option: ""
#    else if item._type? and item._type == 'news'
#      $A().app().openPage
#        page_name: "page_tab_news"
#        params: []
#        close_option: ""
#    else
#      $A().app().openPage
#        page_name: "page_empty"
#        params: []
#        close_option: ""

  onResume: () ->

  onResult: (data) ->

#---------------------------------------具体业务代码---------------------------------------------

  prepareForInitView: () ->
    $A().app().platform().then (platform) ->
      root._platform = platform

#启动程序
new ECpageClass("page_tab_map")