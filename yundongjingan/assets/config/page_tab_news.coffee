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
        viewType: "ListViewCellButton",
        btnTitle: "赛事报名",
        btnType: "ok"
        _type: "0"
      }
      {
        viewType: "ListViewCellButton",
        btnTitle: "最新消息",
        btnType: "ok"
        _type: "519"
      }
      {
        viewType: "ListViewCellButton",
        btnTitle: "主题活动",
        btnType: "ok"
        _type: "520"
      }
      {
        viewType: "ListViewCellButton",
        btnTitle: "楼宇特色",
        btnType: "ok"
        _type: "521"
      }
      {
        viewType: "ListViewCellButton",
        btnTitle: "静安体彩",
        btnType: "ok"
        _type: "522"
      }
      {
        viewType: "ListViewCellButton",
        btnTitle: "竞技体育",
        btnType: "ok"
        _type: "523"
      }
      {
        viewType: "ListViewCellButton",
        btnTitle: "公共体育",
        btnType: "ok"
        _type: "524"
      }
      {
        viewType: "ListViewCellButton",
        btnTitle: "其他",
        btnType: "ok"
        _type: "1970"
      }
    ]

  _constructor: (@_page_name) ->
    root = this
    #获取其他界面传来的数据
    @prepareForInitView()

    $A().page().widget("#{@_page_name}_ListViewBase_0").data JSON.stringify root._listview_data
    $A().page().widget("#{@_page_name}_ListViewBase_0").onItemInnerClick (data)-> root.onItemInnerClick(data)
    $A().page().widget("#{@_page_name}_ListViewBase_0").onItemClick (data)-> root.onItemClick(data)
    $A().page().widget("ActionBar").onItemClick (data)-> root.onActionBarItemClick(data)
    # $A().page().onResume ()-> root.onResume()
    # $A().page().onResult (data)-> root.onResult(data)
    $A().page().onCreated -> root.onCreated()

  constructor: (_page_name) ->
    @_constructor(_page_name)

  onActionBarItemClick: (data) ->
    if data == "3"
      $A().app().openPage
        page_name:"page_my",
        params: {}
        close_option: ""

  onCreated: () ->
    $A().page().widget("#{@_page_name}_ListViewBase_0").refreshData JSON.stringify @_listview_data if root._platform? and root._platform == "ios"
  #自定义函数
  onItemClick: (data) ->
    item = root._listview_data.data[data.position]
    if item._type
      if item._type == "0"
#        $A().app().openUrl
#          _param: "http://tyj.jingan.gov.cn"
        $A().app().openPage
          page_name: "page_tab_signup"
          params: []
          close_option: ""
      else
        $A().app().openPage
          page_name: "page_tab_news_list"
          params:
            sort_id: item._type
          close_option: ""

  onItemInnerClick: (data) ->

  onResume: () ->

  onResult: (data) ->

    #---------------------------------------具体业务代码---------------------------------------------

  prepareForInitView: () ->
    $A().app().platform().then (platform) ->
      root._platform = platform

#启动程序
new ECpageClass("page_tab_news")