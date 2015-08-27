# page类
class ECpageClass
  root = {} # 这是ECpageClass的一个实例的全局变量
  _page_name: "" # 属性
  _content: {}
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
    $A().app().openPage
      page_name:"page_my",
      params: {}
      close_option: ""

  onCreated: () ->
    $A().page().widget("#{@_page_name}_ListViewBase_0").refreshData JSON.stringify @_listview_data if root._platform? and root._platform == "ios"
#自定义函数
  onItemClick: (data) ->
    item = root._listview_data.data[data.position]
    if item.type?
      switch "#{item.type}"
        when "image"
          $A().app().fullImage
            imageurl: item.rightImage.imageSrc
            params: {}
        when "video"
          $A().page().playVideo
            _param: item.video_url
            params: {}
        when "comment"
          $A().app().openPage
            page_name: "page_comment_list"
            params:
              content_id: item.content_id
            close_option: ""

  onItemInnerClick: (data) ->
    item = @_listview_data.data[data.position]
    if item.type? and item.type == 'ok'
      $A().lrucache().get("phone").then (phone) ->
        if phone? and phone != ""
          $A().app().makeToast "正在提交"
          $A().app().callApi
            method: "trade/coupons/create"
            cms_coupon_id: item.content_id
            cacheTime: 0
          .then (data1) ->
            if data1.success == true
              $A().app().makeToast "提交成功，谢谢您的申请，请到我的课程中添加运动记录。"
              $A().page().setTimeout("2000").then () ->
                root._listview_data.data[7].btnType = "cancel"
                root._listview_data.data[7].type = "cancel"
                root._listview_data.data[7].btnTitle = "添加运动记录"
                root._listview_data.data[7].content_id = "#{item.content_id}"
                $A().page().widget("#{root._page_name}_ListViewBase_0").refreshData JSON.stringify root._listview_data
            else
              $A().app().makeToast "提交失败，请重试或者检查您的网络是否打开。"
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
    if item.type? and item.type == 'cancel'
      $A().lrucache().get("phone").then (phone) ->
        if phone? and phone != ""
          $A().app().makeToast "正在添加运动记录"
          $A().app().callApi
            method: "comment/comments/create"
            content_id: item.content_id
            typenum: 1
            cacheTime: 0
          .then (data1) ->
            if data1.success == true
              $A().app().makeToast "提交成功，请到我的课程中查询我的运动记录。"
            else
              $A().app().makeToast "提交失败，请重试或者检查您的网络是否打开。"
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

  onResult: (data) ->

#---------------------------------------具体业务代码---------------------------------------------

  prepareForInitView: () ->
    $A().app().platform().then (platform) ->
      root._platform = platform
    $A().page().param("info").then (info) ->
      $A().app().callApi
        method: "content/coupons/detail"
        content_id: info
        cacheTime: 0
      .then (data) ->
        if data.errors?
          if data.errors[0].error_num?
            $A().app().makeToast "网络状态不好，请重新加载"
          else
            $A().app().makeToast "没有网络"
        else
          root._content = data.content_info
          root._listview_data.data = []

          root._listview_data.data.push
            viewType: "ListViewCellGroupTitle"
            textTitle: "课程相关"

          root._listview_data.data.push
            viewType: "ListViewCellLine"
            centerTitle: "课程器械"
            rightImage: {
              imageType: "imageServer"
              imageSize: "middle"
              imageSrc: "#{root._content.image_cover.url}"
            }
            type: "image"
            hasFooterDivider: "true"

          root._listview_data.data.push
            viewType: "ListViewCellLine"
            centerTitle: "课程视频"
            video_url: "#{root._content.video_url.url}"
            type: "video"
            hasFooterDivider: "true"

          root._listview_data.data.push
            viewType: "ListViewCellGroupTitle"
            textTitle: "课程内容"

          root._listview_data.data.push
            viewType: "ListViewCellArticle"
            content: "#{root._content.content}"
            hasFooterDivider: "true"

          root._listview_data.data.push
            viewType: "ListViewCellGroupTitle"
            textTitle: "课程评论"

          root._listview_data.data.push
            viewType: "ListViewCellLine"
            centerTitle: "查看所有评论"
            content_id: "#{root._content.id}"
            type: "comment"
            hasFooterDivider: "true"

          $A().app().callApi
            method: "trade/coupons/show"
            cms_coupon_id: "#{root._content.id}"
            cacheTime: 0
          .then (data1) ->
            if data1.errors?
              if data1.errors[0].error_num?
                $A().app().makeToast "网络状态不好，请重新加载"
              else
                $A().app().makeToast "没有网络"
            else
              if data1.order.length == 1
                root._listview_data.data.push
                  viewType: "ListViewCellButton"
                  btnTitle: "添加运动记录"
                  btnType: "cancel"
                  type: "cancel"
                  content_id: "#{root._content.id}"
              else
                root._listview_data.data.push
                  viewType: "ListViewCellButton"
                  btnTitle: "我要申请",
                  btnType: "ok"
                  type: "ok"
                  content_id: "#{root._content.id}"

              $A().page().widget("#{root._page_name}_ListViewBase_0").refreshData JSON.stringify root._listview_data
#启动程序
new ECpageClass("page_lesson_info")
