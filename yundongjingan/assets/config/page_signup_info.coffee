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
    dividerHeight: 0
    dividerColor: "#EBEBEB"
    data: [
      {
        viewType: "ListViewCellLine"
        _rightLayoutSize: 0
        _leftLayoutSize: 60
        centerTitle: "正在加载......"
      }
    ]

  _constructor: (@_page_name) ->
    root = this
    #获取其他界面传来的数据
    @prepareForInitView()

    $A().page().widget("#{@_page_name}_ListViewBase_0").data JSON.stringify @_listview_data
    $A().page().widget("#{@_page_name}_ListViewBase_0").onItemInnerClick (data)-> root.onItemInnerClick(data)
    $A().page().widget("#{@_page_name}_ListViewBase_0").onItemClick (data)-> root.onItemClick(data)
    # $A().page().onResume ()-> root.onResume()
    # $A().page().onResult (data)-> root.onResult(data)
    $A().page().onCreated -> root.onCreated()

  constructor: (_page_name) ->
    @_constructor(_page_name)

  onCreated: () ->
    $A().page().widget("#{@_page_name}_ListViewBase_0").refreshData JSON.stringify @_listview_data if root._platform? and root._platform == "ios"
  #自定义函数
  onItemClick: (data) ->

  onItemInnerClick: (data) ->
    item = @_listview_data.data[data.position]
    if item._type? and item._type == 'ok'
      content =
      {
        content_id: item.content_id
        content_title: item.content_title
      }
      $A().app().openPage
        page_name: "page_signup_input"
        params:
          info: content
        close_option: ""
    if item._type? and item._type == 'cancel'
      content =
      {
        content_id: item.content_id
      }
      $A().app().openPage
        page_name: "page_signup_list"
        params:
          info: content
        close_option: ""

  onResume: () ->

  onResult: (data) ->

    #---------------------------------------具体业务代码---------------------------------------------

  prepareForInitView: () ->
    $A().app().platform().then (platform) ->
      root._platform = platform
      $A().page().param("info").then (info) ->
        $A().app().callApi
          method: "content/news/detail"
          content_id: info
          cacheTime: 0
        .then (data) ->
          if data.errors?
            if data.errors[0].error_num?
              $A().app().makeToast "网络状态不好，请重新加载"
            else
              $A().app().makeToast "没有网络"
          else
            root._listview_data.data = []
            root._listview_data.data.push
              viewType: "ListViewCellArticleTitle"
              headTitle: "#{data.content_info.title}"
            root._listview_data.data.push
              viewType: "ListViewCellImage"
              image: {
                imageType: "imageServer"
                imageSize: "xlarge"
                imageSrc: "#{data.content_info.image_cover.url}"
              }
            root._listview_data.data.push
              viewType: "ListViewCellArticle"
              content: "#{data.content_info.content}"
            root._listview_data.data.push
              viewType: "ListViewCellButton",
              btnTitle: "我要申请",
              btnType: "ok"
              _type: "ok"
              content_id: "#{data.content_info.id}"
              content_title: "#{data.content_info.title}"
            root._listview_data.data.push
              viewType: "ListViewCellButton",
              btnTitle: "已申请列表",
              btnType: "cancel"
              _type: "cancel"
              content_id: "#{data.content_info.id}"
              content_title: "#{data.content_info.title}"
            $A().page().widget("#{root._page_name}_ListViewBase_0").refreshData JSON.stringify root._listview_data

#启动程序
new ECpageClass("page_signup_info")