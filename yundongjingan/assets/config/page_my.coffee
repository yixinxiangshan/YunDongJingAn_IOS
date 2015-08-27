# page类
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
        _leftLayoutSize: 0 #60
# leftImage:
#     imageType: "assets"
#     imageSize: "mini"
#     imageSrc: "webview/images/icon/default/article.png"
        centerTitle: "未登录"
        rightImage:
          imageType: "assets"
          imageSize: "fitSize"
          imageSrc: "webview/images/icon/default/listview_right.png"
        name: "mycenter"
        hasFooterDivider: "true"
      }
      {
        viewType: "ListViewCellGroupTitle"
        textTitle: "我的课程"
      }
      {
        viewType: "ListViewCellLine"
        _rightLayoutSize: 0
        _leftLayoutSize: 0
        centerTitle: "我的已申请课程"
        name: "lesson"
        hasFooterDivider: "true"
      }
      {
        viewType: "ListViewCellLine"
        _rightLayoutSize: 0
        _leftLayoutSize: 0
        centerTitle: "我的运动记录"
        name: "activity"
        hasFooterDivider: "true"
      }
      {
        viewType: "ListViewCellGroupTitle"
        textTitle: "我的订单"
      }
      {
        viewType: "ListViewCellLine"
        _rightLayoutSize: 0
        _leftLayoutSize: 0
        centerTitle: "我的场馆优惠"
        name: "coupon"
        hasFooterDivider: "true"
      }
      {
        viewType: "ListViewCellLine"
        _rightLayoutSize: 0
        _leftLayoutSize: 0
        centerTitle: "我的赛事报名"
        name: "signup"
        hasFooterDivider: "true"
      }
      {
        viewType: "ListViewCellLine"
        _rightLayoutSize: 0
        _leftLayoutSize: 0
        centerTitle: "我的你点我送"
        name: "send"
        hasFooterDivider: "true"
      }
#            {
#                viewType: "ListViewCellLine"
#                _rightLayoutSize: 0
#                _leftLayoutSize: 0
#                centerTitle: "提醒管理"
#                name:"notification"
#                hasFooterDivider:"true"
#            }
#            {
#                viewType: "ListViewCellLine"
#                _rightLayoutSize: 0
#                _leftLayoutSize: 0
#                centerTitle: "意见反馈"
#                name:"feedback"
#                hasFooterDivider:"true"
#            }
      {
        viewType: "ListViewCellGroupTitle"
        textTitle: "其他"
      }
      {
        viewType: "ListViewCellLine"
        _rightLayoutSize: 0
        _leftLayoutSize: 0
        centerTitle: "扫一扫"
        name: "scan"
        hasFooterDivider: "true"
      }
      {
        viewType: "ListViewCellLine"
        _rightLayoutSize: 0
        _leftLayoutSize: 0
        centerTitle: "设置"
        name: "setting"
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
    $A().page().onResume ()-> root.onResume()
    # $A().page().onResult (data)-> root.onResult(data)
    $A().page().onCreated -> root.onCreated()

  constructor: (_page_name) ->
    @_constructor(_page_name)

  onCreated: () ->
    $A().lrucache().get("phone").then (phone) ->
# $A().app().makeToast "phone" + "#{phone}"
      if phone? and phone != ""
        root._listview_data.data[0].centerTitle = "#{phone}"
      else
        root._listview_data.data[0].centerTitle = "未登录"
      $A().page().widget("#{root._page_name}_ListViewBase_0").refreshData JSON.stringify root._listview_data
#自定义函数
#root.

  onItemClick: (data) ->
# $A().app().makeToast JSON.stringify data.position
    item = @_listview_data.data[data.position]
    switch "#{item.name}"
      when "mycenter"
# $A().lrucache().set
#     key:"name"
#     value:"pengpeng"
        $A().lrucache().get("phone").then (phone) ->
# $A().app().makeToast JSON.stringify data
# $A().lrucache().set
#     key:"name"
#     value:""
          if phone? and phone != ""
            $A().app().openPage
              page_name: "page_mycenter",
              params: {}
              close_option: ""
          else
            $A().app().openPage
              page_name: "page_login",
              params: {}
              close_option: ""
#            when "course_list"
#                $A().app().openPage
#                    page_name:"page_course_list",
#                    params: {}
#                    close_option: ""
#            when "feedback"
#                $A().app().openPage
#                    page_name:"page_feedback",
#                    params: {}
#                    close_option: ""
      when "setting"
#                $A().app().makeToast  "意见反馈"
#                $A().app().ttsPlay  "意见反馈"
        $A().app().openPage
          page_name: "page_setting",
          params: {}
          close_option: ""
#            when "notification"
#                $A().app().openPage
#                    page_name:"page_notification_manage",
#                    params: {}
#                    close_option: ""
      when "lesson"
        $A().lrucache().get("phone").then (phone) ->
          if phone? and phone != ""
            $A().app().openPage
              page_name: "page_mycoupon_list"
              params:
                info: 528
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
                  page_name:"page_login",
                  params: {}
                  close_option: ""
              if data.state == "cancel"
                return false
      when "activity"
        $A().lrucache().get("phone").then (phone) ->
          if phone? and phone != ""
            $A().app().openPage
              page_name: "page_activity_list"
              params: {}
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
                  page_name:"page_login",
                  params: {}
                  close_option: ""
              if data.state == "cancel"
                return false
      when "coupon"
        $A().lrucache().get("phone").then (phone) ->
          if phone? and phone != ""
            $A().app().openPage
              page_name: "page_mycoupon_list"
              params:
                info: 1038
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
                  page_name:"page_login",
                  params: {}
                  close_option: ""
              if data.state == "cancel"
                return false
      when "signup"
        $A().lrucache().get("phone").then (phone) ->
          if phone? and phone != ""
            content =
            {
              content_id: item.content_id
            }
            $A().app().openPage
              page_name: "page_signup_list"
              params:
                info: JSON.stringify content
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
                  page_name:"page_login",
                  params: {}
                  close_option: ""
              if data.state == "cancel"
                return false
      when "send"
        $A().lrucache().get("phone").then (phone) ->
          if phone? and phone != ""
            content =
            {
              content_id: ""
            }
            $A().app().openPage
              page_name: "page_send_list"
              params:
                info: JSON.stringify content
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
                  page_name:"page_login",
                  params: {}
                  close_option: ""
              if data.state == "cancel"
                return false
      when "scan"
        $A().page("page_my").openQRCapture({})

  onItemInnerClick: (data) ->

  onResult: (data) ->

  onResume: () ->
    $A().page("page_my").param("_setting_changed").then (data) ->
      if data? and data != ""
        $A().page("page_my").param {key: "_setting_changed", value: ""}
        # 本地刷新
        root.onCreated()

#---------------------------------------具体业务代码---------------------------------------------
  prepareForInitView: () ->
    $A().app().platform().then (platform) ->
      root._platform = platform

#启动程序
new ECpageClass("page_my")