# page类
class ECpageClass
  root = {} # 这是ECpageClass的一个实例的全局变量
  _page_name: "" # 属性
# _item_info : {}
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
        _leftLayoutSize: 0
# leftImage:
#     imageType: "assets"
#     imageSize: "mini"
#     imageSrc: "webview/images/icon/default/article.png"
        centerTitle: "姓名"
        centerRightdes: "未设置"
        type: "nickname"
        hasFooterDivider: "true"
      }
      {
        viewType: "ListViewCellLine"
        _rightLayoutSize: 0
        _leftLayoutSize: 0
        centerTitle: "性别"
        centerRightdes: "未填写"
        type: "sex"
        hasFooterDivider: "true"

      }
      {
        viewType: "ListViewCellLine"
        _rightLayoutSize: 0
        _leftLayoutSize: 0
        centerTitle: "生日"
        centerRightdes: "未填写"
        type: "birthday"
        hasFooterDivider: "true"
      }
      {
        viewType: "ListViewCellLine"
        _rightLayoutSize: 0
        _leftLayoutSize: 0
        centerTitle: "账号"
        centerRightdes: "未填写"
        type: "phone"
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
    $A().page().onResume -> root.onResume()
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
    # $A().page().setTimeout("100").then ()->
    root.getNetResource()
  onItemClick: (data) ->
# $A().app().log JSON.stringify data
    item = root._listview_data.data[data.position]
    position = data.position
    switch "#{item.type}"
      when "nickname"
        info =
          key: "nickname"
          page_name: root._page_name
          hint: "设置姓名"
          inputText: if item.centerRightdes? and item.centerRightdes != "未设置"  then item.centerRightdes else ""
        $A().app().openPage
          page_name: "page_input",
          params:
            info: JSON.stringify info
          close_option: ""
# $A().app().showInputConfirm
#     title:"#{item.centerTitle}"
#     # target:"#{item.centerRightdes}"
#     cancel:"取消"
#     ok:"确定"
# $A().app().makeToast JSON.stringify data

      when "sex"
        $A().app().showRadioConfirm
          ok: "确定",
# cancel:"取消"
          title: "#{item.centerTitle}"
          target:  if item.centerRightdes? and item.centerRightdes != "未填写" then "#{item.centerRightdes}" else "男"
          items: "男-女"
        .then (data) ->
          if  data.state == "ok"
            sex =
              "男": 0
              "女": 1
            root._listview_data.data[position].centerRightdes = data.target
            $A().page().widget("#{root._page_name}_ListViewBase_0").refreshData JSON.stringify root._listview_data
            $A().app().callApi
              method: "users/modify"
              sex: "#{sex[data.target]}"
              cacheTime: 0

      when "birthday"
        $A().app().showDatepickerConfirm
          ok: "确定",
          cancel: "取消"
          defaultDay:  if item.centerRightdes? and item.centerRightdes != "未填写" then "#{item.centerRightdes}" else ""
          title: "#{item.centerTitle}"
        .then (data) ->
          if  data.state == "ok"
            root._listview_data.data[position].centerRightdes = data.value
            $A().page().widget("#{root._page_name}_ListViewBase_0").refreshData JSON.stringify root._listview_data
            $A().app().callApi
              method: "users/modify"
              birthday: "#{data.value}"
              cacheTime: 0
      when "phone"
        $A().app().makeToast "账号不可修改"

  onItemInnerClick: (data) ->
    item = root._listview_data.data[data.position]
    if item._type? and item._type == "back"
      $A().app().closePage()

  onResume: () ->
    $A().page().param("nickname").then (data) ->
      if data != ""
        $A().page().param {key: "nickname", value: ""}
        root._listview_data.data[0].centerRightdes = data
        $A().page().widget("#{root._page_name}_ListViewBase_0").refreshData JSON.stringify root._listview_data
        $A().app().callApi
          method: "users/modify"
          nickname: "#{data}"
          cacheTime: 0
#---------------------------------------具体业务代码---------------------------------------------

  prepareForInitView: () ->
    $A().app().platform().then (platform) ->
      root._platform = platform
    $A().lrucache().get("phone").then (phone) ->
      if phone? and phone != ""
        root._listview_data.data[3].centerRightdes = phone

  getNetResource: () ->
    $A().app().callApi
      method: "users/detail"
      cacheTime: 0
    .then (data) ->
      $A().app().log "users/detail" + JSON.stringify data
      sex =
        0: "男"
        1: "女"
      if data? and data != ""
        root._listview_data.data[0].centerRightdes = data.nickname if data.nickname? and data.nickname != ""

        root._listview_data.data[1].centerRightdes = sex[data.sex] if data.sex? and data.sex != ""
        root._listview_data.data[2].centerRightdes = root.date2str(data.birthday) if data.birthday? and data.birthday != ""
        $A().page().widget("#{root._page_name}_ListViewBase_0").refreshData JSON.stringify root._listview_data

  date2str: (date) ->
# reg = new RegExp("//d{4}-//d{2}-//d{2}","g");
    substr = date.substring(0, 10)
    return substr
#启动程序
new ECpageClass("page_mycenter")