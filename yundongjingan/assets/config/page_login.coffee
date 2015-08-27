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
        viewType: "ListViewCellGroupTitle"
        textTitle: "手机号验证"

      }
      {
        viewType: "ListViewCellInputTextWithButton"
        inputType: "phone"
        inputText: ""
        hint: "手机号"
        btnName: "验证"
        name: "phone"
      }
      {
        viewType: "ListViewCellInputText"
        inputType: "number"
        hint: "验证码"
        type: "captcha"
        inputText: ""
        name: "code"
      }
      {
        viewType: "ListViewCellButton"
        btnTitle: "使 用"
        btnType: "ok"
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

  onCreated: () ->
#自定义函数
    $A().page().widget("#{@_page_name}_ListViewBase_0").refreshData JSON.stringify @_listview_data if root._platform? and root._platform == "ios"

  onActionBarItemClick: (data) ->
    $A().app().openPage
      page_name:"page_my",
      params: {}
      close_option: ""

#root.
  onItemClick: (data) ->


  onItemInnerClick: (data) ->
    $A().app().log JSON.stringify data
    # data._form = JSON.parse data._form
    phone = if data._form.phone? then data._form.phone else ""
    code = if data._form.code? then data._form.code else ""
    if parseInt(data.position) == 1
      if parseInt(phone.length) == 11
        $A().app().callApi
          method: "user/get_regcode"
          mobile: "#{phone}"
          cacheTime: 0
        # .then (data) ->
        # $A().app().log JSON.stringify data
        $A().app().makeToast "正在获取验证码"
      else
        $A().app().makeToast "请输入正确的手机号"
    if parseInt(data.position) == 3
      if code? and code != "" and code.length == 6
        $A().app().makeToast "验证中……"
        $A().app().callApi
          method: "user/login_bycode"
          mobile: "#{phone}"
          code: "#{code}"
          cacheTime: 0
        .then (res) ->
          if res.success
            $A().app().makeToast "登录成功"
            #记录一些信息
            $A().page("page_my").param {key: "_setting_changed", value: "true"}
            $A().page("page_home").param {key: "_setting_changed", value: "true"}

            # 把手机号存到本地
            $A().lrucache().set
              key: "phone"
              value: "#{phone}"
            $A().page().setTimeout("1000").then () ->
              $A().app().closePage()
          else
            $A().app().makeToast "登录失败"
#更新界面数据
      else
        $A().app().makeToast "请输入正确的验证码"

  onResume: () ->

#---------------------------------------具体业务代码---------------------------------------------

  prepareForInitView: () ->
    $A().app().platform().then (platform) ->
      root._platform = platform

#启动程序
new ECpageClass("page_login")


