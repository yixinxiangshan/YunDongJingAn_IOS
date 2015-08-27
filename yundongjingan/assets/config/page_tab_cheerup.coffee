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
    data: [
      {
        viewType: "ListViewCellLine",
        _rightLayoutSize: 0
        _leftLayoutSize: 0
        centerTitle: "运动加油站",
        btnType: "ok"
        _type: "cheerup"
        hasFooterDivider: "true"
        leftImage: {
          imageType: "imageServer"
          imageSize: "middle"
          imageSrc: "3006088.jpg"
        }
      }
      {
        viewType: "ListViewCellLine",
        _rightLayoutSize: 0
        _leftLayoutSize: 0
        centerTitle: "场馆优惠",
        btnType: "ok"
        _type: "coupon"
        hasFooterDivider: "true"
        leftImage: {
          imageType: "imageServer"
          imageSize: "middle"
          imageSrc: "3013652.jpg"
        }
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
    # $A().page().onResume ()-> root.onResume()
    # $A().page().onResult (data)-> root.onResult(data)
    $A().page().onCreated -> root.onCreated()

  constructor: (_page_name) ->
    @_constructor(_page_name)

  onActionBarItemClick: (data) ->
    if data == "2"
      $A().app().openPage
        page_name:"page_my",
        params: {}
        close_option: ""

  onCreated: () ->
    $A().page().widget("#{@_page_name}_ListViewBase_0").refreshData JSON.stringify @_listview_data if root._platform? and root._platform == "ios"

#自定义函数
  onItemClick: (data) ->
    item = @_listview_data.data[data.position]
    if item._type? and item._type == 'cheerup'
      $A().app().openPage
        page_name: "page_cheerup_list"
        params: []
        close_option: ""
    else
      $A().app().openPage
        page_name: "page_coupon_main"
        params: []
        close_option: ""

  onItemInnerClick: (data) ->

  onResume: () ->

  onResult: (data) ->

#---------------------------------------具体业务代码---------------------------------------------

  prepareForInitView: () ->
    $A().app().platform().then (platform) ->
      root._platform = platform

#启动程序
new ECpageClass("page_tab_cheerup")