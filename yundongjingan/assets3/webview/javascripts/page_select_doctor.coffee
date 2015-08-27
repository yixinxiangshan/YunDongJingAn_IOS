@initPage = ()->
    $A().app().preference( "doctor_group_id" ).then (res) ->
        if res? && res != ""
            $A().app().preference( "sickness_id" ).then (r1) ->
                if r1? && r1 != ""
                    $A().app().openPage
                        page_name:"page_index_tab"
                        params: {}
                        close_option: "close"
                else
                    showDoctorSelector(res)
#            alert JSON.stringify res
#            $(".qrcode").hide()
        else
            showQrSelector()
    $A().page("page_select_doctor").onResult (data)->
        #alert ""+JSON.stringify(data)
        if data.type == "qrcaputre"
            doctor_group_id = data.codeString
            $A().app().callApi({
                method: "user/users/doctorinfo_edit"
                doctor_group_id: doctor_group_id
            }).then (r1)->
                # alert JSON.stringify r1
                $A().app().preference( {key :"doctor_group_name" , value : r1.name } )
                $A().app().preference( {key :"doctor_group_id" , value : doctor_group_id } )
                $A().app().makeToast("请选择医生及诊断");
                showDoctorSelector(doctor_group_id)
        #        $A().page("page_activity").widget("page_activity_WebWidget_0").callFun
        #            name : "addFriend"
        #            params :
        #                ucontent_id : data.codeString
        return "_false"

showQrSelector = () ->
    $(".selqrcode").show()
    $(".qrcode").tap () ->
        $A().page("page_select_doctor").openQRCapture({});

showDoctorSelector = (doctor_group_id) ->
    $(".seldoctor").show()
    $(".selqrcode").hide()
    $A().app().preference( "doctor_group_name" ).then (r1) ->
        $(".seldoctor h3").html r1
    $(".doctorsubmit").tap () ->
        doctor_id = $("#seloptions1 input:checked").val()
        sickness_id = $("#seloptions2 input:checked").val()
        if doctor_id == "" || sickness_id == ""
            return alert "请选择医生及诊断"
        $A().app().callApi({
            method: "user/users/doctorinfo_edit"
            sickness_id: sickness_id
            doctor_id:doctor_id
            cacheTime: 0
        }).then (res) ->
            
            $A().app().preference( {key :"sickness_id" , value : sickness_id } )
            $A().app().preference( {key :"doctor_id" , value : doctor_id } )
            $A().app().openPage
                page_name:"page_home"
                params: {}
                close_option: "close"

    $A().app().callApi({
        method: "content/doctor_groups/doctors"
        doctor_group_id: doctor_group_id
        cacheTime: 0
    }).then (r2)->
        html = ""
        for item in r2.result
            html = html+"<span ><input type=\"radio\" name=\"doctors\" id=\"#{item.id}\" value=\"#{item.id}\"/> <label for=\"#{item.id}\">#{item.title}</label></span>"
        $("#seloptions1").html html

    $A().app().callApi({
        method: "content/doctor_groups/sickness"
        doctor_group_id: doctor_group_id
        cacheTime: 0
    }).then (r2)->
        html = ""
        for item in r2.sorts
            html = html+"<span ><input type=\"radio\" name=\"sickness\" id=\"#{item.id}\" value=\"#{item.id}\"/> <label for=\"#{item.id}\">#{item.cnname}</label></span>"
        $("#seloptions2").html html
#        alert JSON.stringify r2

