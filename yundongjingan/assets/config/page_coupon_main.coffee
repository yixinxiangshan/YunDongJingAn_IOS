# page类
class ECpageClass
  root = {} # 这是ECpageClass的一个实例的全局变量
  _page_name: "" # 属性
  _platform: ""
  _item_info: {}
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
        _leftLayoutSize: 75
        centerTitle: "静安游泳馆"
        _type: "43581"
        leftImage: {
          imageType: "imageServer"
          imageSize: "middle"
          imageSrc: "3007010.jpg"
        }
        hasFooterDivider: "true"
      }
      {
        viewType: "ListViewCellLine"
        _rightLayoutSize: 0
        _leftLayoutSize: 75
        centerTitle: "静安体育馆"
        _type: "13502"
        leftImage: {
          imageType: "imageServer"
          imageSize: "middle"
          imageSrc: "3006987.jpg"
        }
        hasFooterDivider: "true"
      }
      {
        viewType: "ListViewCellLine"
        _rightLayoutSize: 0
        _leftLayoutSize: 75
        centerTitle: "其他"
        _type: "0"
        leftImage: {
          imageType: "imageServer"
          imageSize: "middle"
          imageSrc: "3013652.jpg"
        }
        hasFooterDivider: "true"
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
    # $A().page().widget("#{@_page_name}_ListViewBase_0").onResume (data)-> root.onResume(data)
    # $A().page().widget("#{@_page_name}_ListViewBase_0").onResult (data)-> root.onResult(data)
    $A().page().onCreated -> root.onCreated()

  constructor: (_page_name) ->
    @_constructor(_page_name)

  onCreated: () ->
    $A().page().widget("#{@_page_name}_ListViewBase_0").refreshData JSON.stringify @_listview_data if root._platform? and root._platform == "ios"

  onActionBarItemClick: (data) ->
    $A().app().openPage
      page_name:"page_my",
      params: {}
      close_option: ""

#自定义函数
  onResult: (data) ->

  onItemClick: (data) ->
    item = @_listview_data.data[data.position]
    if item._type
      $A().app().openPage
        page_name: "page_coupon_list"
        params:
          info: item._type
        close_option: ""

  onItemInnerClick: (data) ->

  onResume: () ->

#---------------------------------------具体业务代码---------------------------------------------

  prepareForInitView: () ->
    $A().app().platform().then (platform) ->
      root._platform = platform

#启动程序
new ECpageClass("page_coupon_main")