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
        viewType: "ListViewCellImage"
        image:
          imageType: "resource"
          imageSize: "middle"
          imageSrc: "proj_icon"
        bottomTitle: "运动静安"
        titlePosition: "center"  #left  right
        _type: "logo"
        hasFooterDivider: "true"
      }
# {
#     viewType: "ListViewCellLine"
#     _rightLayoutSize: 0
#     _leftLayoutSize: 0
#     centerTitle: "清除缓存"
#     _type:"clear"

# }
      {
        viewType: "ListViewCellLine"
        _rightLayoutSize: 0
        _leftLayoutSize: 0
        centerTitle: "检测新版本"
        _type: "update"
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

  onActionBarItemClick: (data) ->
    $A().app().openPage
      page_name:"page_my",
      params: {}
      close_option: ""

  onCreated: () ->
    $A().page().widget("#{@_page_name}_ListViewBase_0").refreshData JSON.stringify @_listview_data if root._platform? and root._platform == "ios"
#自定义函数
  onResult: (data) ->

  onItemClick: (data) ->
    if @_listview_data.data[data.position]._type == "update"
# $A().app().makeToast  "正在检查新版本信息"
      $A().app().showLoadingDialog
# title:"添加课程"
        content: "正在检查新版本信息"
      $A().app().callApi
        method: "projects/detail"
        cacheTime: 0
      .then (res) ->
        $A().app().preference {key: "net_version_num", value: data.version_num}
        $A().app().preference {key: "net_version_url", value: data.download_url}
        $A().app().getAppVersion().then (version)->
          $A().app().closeLoadingDialog()
          if parseFloat(data.version_num) > parseFloat(version)
            data.description = "" if !data.description?
            $A().app().confirmDownloadNewVersion
              ok: "下载"
              data: "最新版本:#{data.version_num}\n\n【更新内容】\n" + data.description if data.description?
          else
            $A().app().showConfirm
              ok: "确认"
              message: "已是最新版本"
              title: "版本确认"

  onItemInnerClick: (data) ->
    if @_listview_data.data[data.position]._type == "logout"
# $A().app().makeToast JSON.stringify data
      $A().app().showConfirm
        title: "退出当前账号"
        ok: "确认退出"
        cancel: "取消",
        message: "退出当前帐号。"#清空你的康复记录
      .then (data) ->
        if data.state == "ok"
#清掉token
# $A().app().preference {key: "access_token" ,value:""}
#清掉手机号  手机号 标记是否登录
          $A().lrucache().set {key: "phone", value: ""}

          $A().page("page_my").param {key: "_setting_changed", value: "true"}
          $A().page("page_home").param {key: "_setting_changed", value: "true"}

          #清掉课程

          $A().app().makeToast "正在退出"
          $A().page().setTimeout("2000").then () ->
            $A().app().closePage()

  onResume: () ->

#---------------------------------------具体业务代码---------------------------------------------

  prepareForInitView: () ->
    $A().app().platform().then (platform) ->
      root._platform = platform
    $A().app().getAppVersion().then (version)->
      root._listview_data.data[0].bottomTitle = "运动静安 " + "#{version}"
    $A().lrucache().get("phone").then (phone) ->
      if phone? and phone != ""
        root._listview_data.hasFooterDivider = false
        root._listview_data.data.push
          viewType: "ListViewCellButton"
          btnTitle: "退出当前账号"
          btnType: "ok"
          _type: "logout"
# $A().page().widget("#{@_page_name}_ListViewBase_0").data JSON.stringify @_listview_data

#启动程序
Page = new ECpageClass("page_setting")