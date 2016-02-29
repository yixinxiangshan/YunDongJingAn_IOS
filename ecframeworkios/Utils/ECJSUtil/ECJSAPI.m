//
//  ECJSAPI.m
//  IOSProjectTemplate
//
//  Created by 程巍巍 on 4/3/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import "ECJSAPI.h"
#import "ECJSUtil.h"
#import "NSObjectExtends.h"
#import "ECReflectionUtil.h"
#import "ECBaseViewController.h"
#import "ECBaseWidget.h"
#import "NSStringExtends.h"
#import "NSDictionaryExtends.h"
#import "NSArrayExtends.h"
#import "NSObjectExtends.h"

#import "Toast+UIView.h"
#import "ECViewUtil.h"
#import "ECNetRequest.h"
//#import "LocationUtil.h"
//#import "CLLocation+Category.h"
#import "Constants.h"
#import "ECJSConstants.h"

#import "ECAppUtil.h"
#import "ECPageUtil.h"
#import "ECWebWidget.h"
#import "ECBlankWidget.h"

#import "ECQRCapture.h"

#import "ECBaseView.h"
#import "ECBaseMultilevelMenu.h"
#import "ECBasePopView.h"
#import "ECCoreData.h"
#import "BlockAlertView.h"
#import "BlockActionSheet.h"
#import "CoreData+MagicalRecord.h"
#import "Caches.h"
#import "NSStringExtends.h"
#import "BlockAlertDateView.h"
#import "SVProgressHUD.h"
#import "APService.h"
#import "UIAlertView+Blocks.h"
#import "Reachability.h"
#import "ECMediaPlayer.h"
#import "SJAvatarBrowser.h"
#import "ECImageUtil.h"

@interface ECJSAPI ()

@property (nonatomic, strong) NSObject *context;
@end

@implementation ECJSAPI

- (id)init
{
    self = [super init];
    if (self) {
        [self setId:[@"ECJSAPI_" stringByAppendingString:[NSString randomString]]];
    }
    return self;
}

+ (void) callDeviceAPI:(NSString *)method params:(NSMutableDictionary *)params callbackId:(NSString *)callbackId action:(NSMutableDictionary *)action
{
    //处理action
    NSEnumerator *enumerator = [action keyEnumerator];
    id key;
    NSMutableArray *actionKeys = [NSMutableArray new];
    NSMutableArray *actionValues = [NSMutableArray new];
    // ECLog(@"callDeviceAPI 1: %@" , enumerator);
    while (key = [enumerator nextObject]) {
        if (![key isEqualToString:@"pid"]) {
            [actionKeys addObject:key];
            [actionValues addObject:action[key]];
            [params setObject:action[key] forKey:[@"_" stringByAppendingString:key]];
        }
    }
    
    if (callbackId && callbackId.length > 0) [params setObject:callbackId forKey:kCallbackId];
    // pid 必须有，否刚出错
    [params setObject:action[@"pid"] forKey:kJSContextId];
    if (method && method.length > 0) [params setObject:method forKey:kMethod];
    
    //解析接口名称
    // ECLog(@"callDeviceAPI 2: %@" , actionKeys);
    NSString *methodName = @"";
    for (NSString *s in actionKeys) {
        // ECLog(@"callDeviceAPI in : %@" , s);
        methodName = [methodName stringByAppendingString:[s stringByAppendingString:@"_"]];
    }
    // 因为emum解析时的顺序问题，在64位系统下，需要调换widget 和 page 的位置
    methodName = [methodName stringByReplacingOccurrencesOfString:@"widget_page_"
                                                       withString:@"page_widget_"];
    
    //exec
    ECJSContext *jsContext = (ECJSContext *)[NSObject findObjectWithId:action[@"pid"]];
    id result = (NSString *)[ECReflectionUtil callNSObject:[[ECJSAPI jsApiWithContext:jsContext] id] method:[methodName stringByAppendingString:[method stringByAppendingString:@":"]] arguments:@[params]];
    //异步返回结果
    if (![result isKindOfClass:[NSString class]] || ![result isEqualToString:@"_false"]){
        [ECJSContext callbackWithJSContextId:action[@"pid"] callbackId:callbackId argument:result];
        //ECJSContext *jsContext = (ECJSContext *)[NSObject findObjectWithId:action[@"pid"]];
        //        NSString *jsString ;
        //        if ([arg isKindOfClass:[NSString class]]) {
        //            jsString = [NSString stringWithFormat:@"_response_callbacks['%@']('%@');",callbackId,arg];
        //        }else{
        //            jsString = [NSString stringWithFormat:@"_response_callbacks['%@'](%@);",callbackId,[arg JSONString]];
        //        }
        //        ECLog(@"\n\n callbackWithId : %@ \n\n" ,jsString);
        //        return [self evaluateScript:jsString];
        //        jsContext
        //        JSContext *context = [JSContext contextWithJSGlobalContextRef:[ECJSContext ] ];
        //        JSValue *function = context[@"factorial"];
        //        JSValue *result = [function callWithArguments:@[@10]];
        //        NSLog(@"factorial(10) = %d", [resulttoInt32]);
    }
    
}

#pragma mark-
+ (ECJSAPI *)jsApiWithContext:(NSObject *)context
{
    ECJSAPI *api = [ECJSAPI new];
    api.context = context;
    return api;
}

#pragma mark- api
/**
 * 设置页面等待状态
 *
 * @param params
 * @return
 *
 *         $A().page("page_test_js").wait();
 */
- (NSString *)page_wait:(NSDictionary *)params
{
    //    NSString *page = params[@"_page"];
    //    ECBaseViewController *vc = (ECBaseViewController *)_context;
    //    if (page && [page length] > 0) {
    //        vc = (ECBaseViewController *)[NSObject findObjectWithId:page];
    //    }
    ECBaseViewController *vc = [ECJSAPI getPageController:params];
    [vc pageWait];
    return @"_false";
}

/**
 * 设置页面恢复等待状态
 *
 * @param params
 * @return
 *
 *         $A().page("page_test_js").resumeWait();
 */
- (NSString *)page_resumeWait:(NSDictionary *)params
{
    //    NSString *page = params[@"_page"];
    //    ECBaseViewController *vc = (ECBaseViewController *)_context;
    //    if (page && [page length] > 0) {
    //        vc = (ECBaseViewController *)[NSObject findObjectWithId:page];
    //    }
    ECBaseViewController *vc = [ECJSAPI getPageController:params];
    [vc pageResumeWait];
    return @"_false";
}

/**
 * 设置页面param
 *
 * @param params
 * @return
 *
 * @example <code>
 * $A().page("page_test_js").param({key:"testParam",value:"myparam"});
 * $A().page("page_test_js").param("testParam").then(function(data) {
 *   $A().app().makeToast(data);
 * });
 * </code>
 */
- (NSString *)page_param:(NSDictionary *)params
{
    //    NSString *page = params[@"_page"];
    //    ECBaseViewController *vc = (ECBaseViewController *)_context;
    //    if (page && [page length] > 0) {
    //        vc = (ECBaseViewController *)[NSObject findObjectWithId:page];
    //    }
    ECBaseViewController *vc = [ECJSAPI getPageController:params];
    NSString *param = params[@"_param"];
    NSString *key = params[@"key"];
    NSString *value = params[@"value"];
    
    if ((!param || param.length == 0) && ((key && key.length > 0))) {
        // NSLog(@"page_param : key(%@) , value(%@)" , key ,value);
        [vc putParam:key value:value];
        return @"_false";
    }else{
        NSString *result = [vc getParam:param];
        if ([[NSString stringWithFormat:@"%@",result] isEqualToString:@"(null)"])
            result = @"";
        return [NSString stringWithFormat:@"%@",result];
    }
    return @"_false";
}


/**
 * 设置页面data
 *
 * @param params
 * @return
 *
 * @example <code>
 * $A().page("page_test_js").data("{abc:123}");
 * $A().page("page_test_js").data().then(function(data) {
 *   $A().app().makeToast(data);
 * });
 * </code>
 */
- (NSString *)page_data:(NSDictionary *)params
{
    ECBaseViewController *vc = [ECJSAPI getPageController:params];
    
    NSString *param = params[@"_param"];
    if (!param || param.length == 0) {
        return [vc getParam:@"pageData"];
    }else{
        [vc putParam:@"pageData" value:param];
    }
    return @"_false";
}

/**
 * 执行page内的某个jsfun
 */
- (NSString *)page_callFun:(NSDictionary *)params
{
    // NSLog(@"page_callFun : %@",params);
    ECBaseViewController* controller = [ECJSAPI getPageController:params];
    // NSLog(@"page_callFun : %@",controller);
    [controller dispatchJSEvetn:params[@"pageName"] withParams:params[@"input"]];
    return @"_false";
}

/**
 *  page view append
 *  在给定的view（view_id）中加入 customproperties 为params 的view
 *  如果view_id为空，则在page.view 中加入新的view
 */
- (NSString *)page_view_append:(NSDictionary *)params
{
    NSString *viewId = params[@"_view"];
    UIView *view = ![viewId isEqualToString:@"_"] ? [NSObject findObjectWithId:viewId] : [[ECJSAPI getPageController:params] view];
    if (![view isKindOfClass:[UIView class]]) {
        // ECLog(@"page_view_append , view_id or page_id is error ...");
        return @"_false";
    }
    [view addSubviewWithProperties:[NSMutableDictionary dictionaryWithDictionary:params]];
    return @"_false";
}

/**
 *  找到widget 并向其中添加view
 */
- (NSString *)page_view_widget_append:(NSDictionary *)params
{
    NSString *viewId = params[@"_view"];
    ECBlankWidget *blankWidget = (ECBlankWidget *)[[ECJSAPI getPageController:params] getWidget:params[@"_widget"]];
    UIView *view = ![viewId isEqualToString:@"_"] ? [blankWidget findViewWithName:viewId] : blankWidget;
    [view addSubviewWithProperties:[NSMutableDictionary dictionaryWithDictionary:params]];
    return @"_false";
}

/**
 *  设置widget 初始化成功后的加调
 * page_widget_onCreated
 */
- (NSString *)page_widget_onCreated:(NSDictionary *)params
{
    [[ECJSAPI getPageController:params].pageJSEvent setObject:@{kJSContextId:params[kJSContextId], kEventId:params[kEventId], kMethod:params[kMethod]} forKey:[NSString stringWithFormat:@"%@.onCreated",params[@"_widget"]]];
    return @"_false";
}

/**
 *
 */
- (NSString *)page_widget_callFun:(NSDictionary *)params
{
    ECBaseWidget *widget = [[ECJSAPI getPageController:params] getWidget:params[@"_widget"]];
    [widget callMethod:@"callFun:param:" withArguments:@[params[@"name"],params[@"params"]]];
    return @"_false";
}


/**
 * 设置、获取widget数据
 *
 * @param params
 * @return Ohmer-Apr 1, 2014 6:57:50 PM
 */
- (id)page_widget_data:(NSDictionary *)params
{
    ECBaseViewController *page = [ECJSAPI getPageController:params];
    NSString *param = params[@"_param"];
    if (!param || param.length == 0) {
        return [page getWidgetData:params[@"_widget"]];
    }else{
        [page putWidgetData:param withWidgetId:params[@"_widget"]];
        return @"_flase";
    }
}

/**
 *  打开弹出widget
 */
- (NSString *)page_widget_pop:(NSDictionary *)params
{
    ECBaseViewController *page = [ECJSAPI getPageController:params];
    ECBaseWidget *widget = [page getWidget:params[@"_widget"]];
    [widget setDataDic:[params[@"widget_data"] JSONValue]];
    [ECBasePopView popView:widget fromView:[NSObject findObjectWithId:params[@"pop_from"]]];
    return @"_false";
}

/**
 *  navigationbar  back button click
 */
- (NSString *)page_widget_onBackClick:(NSDictionary *)params
{
    NSString* widget_id= [[NSString alloc] initWithFormat:@"%@_%@" , [ECJSAPI getPageController:params].id,params[@"_widget"] ];
    [[ECJSAPI getPageController:params].pageJSEvent setObject:@{kJSContextId:params[kJSContextId], kEventId:params[kEventId], kMethod:params[kMethod]} forKey:[NSString stringWithFormat:@"%@.%@",widget_id,kOnBackClick]];
    return @"_false";
}

/**
 *
 */
- (NSString *)page_widget_onFixedItemDisplay:(NSDictionary *)params
{
    NSString* widget_id= [[NSString alloc] initWithFormat:@"%@_%@" , [ECJSAPI getPageController:params].id,params[@"_widget"] ];
    [[ECJSAPI getPageController:params].pageJSEvent setObject:@{kJSContextId:params[kJSContextId], kEventId:params[kEventId], kMethod:params[kMethod]} forKey:[NSString stringWithFormat:@"%@.%@",widget_id,@"onFixedItemDisplay"]];
    return @"_false";
}
/**
 *
 */
- (NSString *)page_widget_onItemClick:(NSDictionary *)params
{
    NSString* widget_id= [[NSString alloc] initWithFormat:@"%@_%@" , [ECJSAPI getPageController:params].id,params[@"_widget"] ];
    // actionbar比较特殊，直接获取
    if ([params[@"_widget"] isEqual:@"ActionBar"])
        widget_id = @"ActionBar";
    [[ECJSAPI getPageController:params].pageJSEvent setObject:@{kJSContextId:params[kJSContextId], kEventId:params[kEventId], kMethod:params[kMethod]} forKey:[NSString stringWithFormat:@"%@.%@",widget_id , kOnItemClick]];
    return @"_false";
}
/**
 * FormWidget on submit
 */
- (NSString *)page_widget_onSubmit:(NSDictionary *)params
{
    NSString* widget_id= [[NSString alloc] initWithFormat:@"%@_%@" , [ECJSAPI getPageController:params].id,params[@"_widget"] ];
    [[ECJSAPI getPageController:params].pageJSEvent setObject:@{kJSContextId:params[kJSContextId], kEventId:params[kEventId], kMethod:params[kMethod]} forKey:[NSString stringWithFormat:@"%@.%@",widget_id,@"onSubmit"]];
    return @"_false";
}
/**
 *  FormWidget onSubmitSuccess
 */
- (NSString *)page_widget_onSubmitSuccess:(NSDictionary *)params
{
    NSString* widget_id= [[NSString alloc] initWithFormat:@"%@_%@" , [ECJSAPI getPageController:params].id,params[@"_widget"] ];
    [[ECJSAPI getPageController:params].pageJSEvent setObject:@{kJSContextId:params[kJSContextId], kEventId:params[kEventId], kMethod:params[kMethod]} forKey:[NSString stringWithFormat:@"%@.%@",widget_id,@"onSubmitSuccess"]];
    return @"_false";
}


/**
 *  ListViewBase page_widget_onItemInnerClick
 */
- (NSString *)page_widget_onItemInnerClick:(NSDictionary *)params
{
    NSString* widget_id= [[NSString alloc] initWithFormat:@"%@_%@" , [ECJSAPI getPageController:params].id,params[@"_widget"] ];
    [[ECJSAPI getPageController:params].pageJSEvent setObject:@{kJSContextId:params[kJSContextId], kEventId:params[kEventId], kMethod:params[kMethod]} forKey:[NSString stringWithFormat:@"%@.%@",widget_id,@"onItemInnerClick"]];
    return @"_false";
}

/**
 *  ListViewBase page_widget_onChange
 */
- (NSString *)page_widget_onChange:(NSDictionary *)params
{
    NSString* widget_id= [[NSString alloc] initWithFormat:@"%@_%@" , [ECJSAPI getPageController:params].id,params[@"_widget"] ];
    [[ECJSAPI getPageController:params].pageJSEvent setObject:@{kJSContextId:params[kJSContextId], kEventId:params[kEventId], kMethod:params[kMethod]} forKey:[NSString stringWithFormat:@"%@.%@",widget_id,@"onChange"]];
    return @"_false";
}




/**
 *  actionBar title
 */
- (NSString *)page_widget_title:(NSDictionary *)params
{
    ECBaseViewController *page = [ECJSAPI getPageController:params];
    NSString *title = params[@"title"];
    if (!title || title.length == 0) {
        return [ECReflectionUtil callNSObject:page.actionBar.id method:@"title" arguments:nil];
    }else{
        [ECReflectionUtil callNSObject:page.actionBar.id method:@"setTitle:" arguments:@[title]];
    }
    return @"_false";
}

/**
 *  page_widget_refreshData
 */
- (NSString *)page_widget_refreshData:(NSDictionary *)params
{
    //    ECBaseViewController *page = [ECJSAPI getPageController:params];
    //    [ECReflectionUtil callNSObject:params[@"_widget"] method:@"refreshWidgetData:" arguments:@[params[@"_param"]]];
    ECBaseWidget *widget = [[ECJSAPI getPageController:params] getWidget:params[@"_widget"]];
    // NSLog(@"page_widget_refreshData  widget  : %@" , widget);
    // NSLog(@"page_widget_refreshData  widget  : %@" , widget.id);
    // NSLog(@"page_widget_refreshData widget: %@" ,widget );
    [widget callMethod:@"refreshWidgetData:" withArguments:@[params[@"_param"]]];
    return @"_false";
}

/**
 * 更新listviewwidget 的 某个cell
 */
- (NSString *)page_widget_updateItem:(NSDictionary *)params
{
    ECBaseWidget *widget = [[ECJSAPI getPageController:params] getWidget:params[@"_widget"]];
    //    NSLog(@"page_widget_updateItem data1: %@" , params[@"data"]);
    //    NSString *param = [@{@"position":[params[@"position"] JSONData], @"data":[params[@"data"] JSONData] } JSONString];
    //    NSLog(@"page_widget_updateItem data2: %@" , param);
    [widget callMethod:@"refreshWidgetItem:" withArguments: @[ [params[@"_param"] JSONValue] ] ] ;
    return @"_false";
}
/**
 * 更新listviewwidget 的 一组cell
 */
- (NSString *)page_widget_updateItems:(NSDictionary *)params
{
    ECBaseWidget *widget = [[ECJSAPI getPageController:params] getWidget:params[@"_widget"]];
    
    // NSLog(@"page_widget_updateItem page: %@" , widget);
    //    NSString *param = [@{@"position":[params[@"position"] JSONData], @"data":[params[@"data"] JSONData] } JSONString];
    //    NSLog(@"page_widget_updateItem data2: %@" , param);
    [widget callMethod:@"refreshWidgetItems:" withArguments: @[ [params[@"data"] JSONValue] ] ] ;
    return @"_false";
}
/**
 *  page_widget_itemClick
 */
- (NSString *)page_widget_itemClick:(NSDictionary *)params
{
    ECBaseWidget *widget = [[ECJSAPI getPageController:params] getWidget:params[@"_widget"]];
    // NSLog(@"page_widget_refreshData widget: %@" ,widget );
    [widget callMethod:@"itemClick:" withArguments:@[params[@"_param"]]];
    //    [ECReflectionUtil callNSObject:params[@"_widget"] method:@"itemClick:" arguments:@[params[@"_param"]]];
    return @"_false";
}
/**
 *  page_view_widget_onClick
 *  view 点击事件
 */
- (NSString *)page_view_widget_onClick:(NSDictionary *)params
{
    NSDictionary *event = @{kJSContextId:params[kJSContextId], kEventId:params[kEventId], kMethod:params[kMethod]};
    NSInteger clickCount = [params[@"clickCount"] integerValue];
    NSString *eventId = [NSString stringWithFormat:@"%@_onClick-%i",params[@"_view"],clickCount ? clickCount : 1];
    
    UIView *view = [(ECBlankWidget *)[[ECJSAPI getPageController:params] getWidget:params[@"_widget"]] findViewWithName:params[@"_view"]];
    [view setOnClickEvent:@{@"event": event,@"eventId":eventId}];
    
    return @"_false";
}

- (NSString *)page_view_widget_text:(NSDictionary *)params
{
    UIView *view = [(ECBlankWidget *)[[ECJSAPI getPageController:params] getWidget:params[@"_widget"]] findViewWithName:params[@"_view"]];
    [view callMethod:@"setText:" withArguments:@[params[@"_param"]]];
    return @"_false";
}

- (NSString *)page_setTimeout:(NSDictionary *)params{
    //    NSLog(@"page_setTimeout event : %@" , event);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, [params[@"_param"] doubleValue] * USEC_PER_SEC ), dispatch_get_main_queue(), ^{
        [ECJSContext callbackWithJSContextId:params[kJSContextId] callbackId:params[kCallbackId] argument:@""];
    });
    return @"_false";
}

/**
 *openQRCapture
 */
- (NSString *)page_openQRCapture:(id)params
{
     NSLog(@"JSAPI page_openQRCapture: %@ %@ %@",params[kJSContextId],params[kEventId],params[kMethod]);
//        NSDictionary *event = @{kJSContextId:params[kJSContextId], kEventId:params[kEventId], kMethod:params[kMethod]};
//        NSLog(@"page_openQRCapture event : %@" , event);
    [ECQRCapture start:^(NSString *resultString) {
        [[ECJSAPI getPageController:params] dispatchJSEvetn:@"onResult" withParams:@{@"codeString":resultString} ];
        // [self.class dispatch_page_on_event:event withParams:resultString];
    }];
    return @"_false";
}
/**
 * playVideo
 */
- (NSString *)page_playVideo:(NSDictionary *)params
{
    NSString *url = [NSString stringWithFormat:@"%@%@", BASE_VIDEO_URL, params[@"_param"]];
    ECLog(@"url: %@", url);
    [[ECMediaPlayer shareInstance] playWithURL:url];
    return @"_false";
}
 
/**
 * 设置页面onResult事件
 *
 * @param params
 * @return
 *
 * @example <code>
 * $A().page("page_test_js").onResult().then(function(res) {
 *     $A().app().makeToast("onResult");
 * });
 * </code>
 */
- (NSString *)page_onResult:(NSDictionary *)params
{
    NSLog(@"page on result %@", params);
    [[ECJSAPI getPageController:params].pageJSEvent setObject:@{kJSContextId:params[kJSContextId], kEventId:params[kEventId], kMethod:params[kMethod]} forKey:@"onResult"];
    return @"_false";
}


/**
 * 设置页面onResume事件
 *
 * @param params
 * @return
 *
 * @example <code>
 * $A().page("page_test_js").onResume().then(function(res) {
 *     $A().app().makeToast("onResume");
 * });
 * </code>
 */
- (NSString *)page_onResume:(NSDictionary *)params
{
    [[ECJSAPI getPageController:params].pageJSEvent setObject:@{kJSContextId:params[kJSContextId], kEventId:params[kEventId], kMethod:params[kMethod]} forKey:kOnPageResume];
    return @"_false";
}

/**
 *  设置页面 page_onPageSelected 事件，只有pager内的page才会触发
 */
- (NSString *)page_onPageSelected:(NSDictionary *)params
{
    [[ECJSAPI getPageController:params].pageJSEvent setObject:@{kJSContextId:params[kJSContextId], kEventId:params[kEventId], kMethod:params[kMethod]} forKey:@"onPageSelected"];
    // NSLog(@"page_onPageSelected %@" , params);
    return @"_false";
    
}



/**
 * 设置页面onCreated事件
 *
 * @param params
 * @return Ohmer-Apr 1, 2014 6:57:50 PM
 *
 * @example <code>
 * $A().page("page_test_js").onResume().then(function(res) {
 *     $A().app().makeToast("onResume");
 * });
 * </code>
 */
- (NSString *)page_onCreated:(NSDictionary *)params
{
    [[ECJSAPI getPageController:params].pageJSEvent setObject:@{kJSContextId:params[kJSContextId], kEventId:params[kEventId], kMethod:params[kMethod]} forKey:kOnPageCreated];
    return @"_false";
}

/**
 * app_phone
 */
- (NSString *)app_phone:(NSDictionary *)params
{
    //NSLog(@"params: %@", params);
    NSString * phoneNumber = params[@"_param"];
    NSLog(@"phone: %@", phoneNumber);
    if (!phoneNumber || [phoneNumber isEqualToString:@""]) {
        NSLog(@"参数传弟错误，method : app_phone");
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]]];
    return @"_false";
}

/**
 *  app_openPage
 */
- (NSString *)app_openPage:(NSDictionary *)params
{
    NSString *closeOption = params[@"close_option"];
    NSString *pageName = params[@"page_name"];
    NSString *pageParams = params[@"params"];
    if ([closeOption isEqualToString:@"close"]) {
        [ECPageUtil openNewPageWithFinished:pageName params:pageParams];
    }else{
        [ECPageUtil openNewPage:pageName params:pageParams];
    }
    return @"_false";
}
/**
 *  app_closePage
 */
- (NSString *)app_closePage:(NSDictionary *)params{
    [ECPageUtil closeNowPage:@""];
    return @"_false";
}
/**
 * 输出log
 *
 * @param params
 * @return
 *
 * @example <code>
 * $A().app().log("test");
 * </code>
 */
- (NSString *)app_log:(NSDictionary *)params
{
    NSString *sub = @"-page";
    // NSString *pageId = [ECJSAPI getPageIdWithJSContextId:params[kJSContextId] callbackId:params[kCallbackId]];
    NSArray *callbackArr = [params[kCallbackId] componentsSeparatedByString:@"_"];
    if (![callbackArr[0] isEqualToString:@"device"]) {
        sub = @"-web";
    }
    //    ECLog(@"[ECJS|%@|%@] %@%@\n%@",params[kJSContextId],params[kCallbackId],pageId,sub,params[@"_param"]);
    ECLog(@"[ECJS ------ ]+ : %@",params[@"_param"]);
    return @"_false";
}

/**
 *  app_makeToast
 */
- (NSString *)app_makeToast:(NSDictionary *)params
{
    NSString *toastMassage = params[@"_param"];
    if (toastMassage && toastMassage.length > 0) {
        [ECViewUtil toast:toastMassage];
    }
    return @"_false";
}
/**
 *  app_showLoadingDialog
 */
- (NSString *)app_showLoadingDialog:(NSDictionary *)params
{
    // ECLog(@"app_showLoadingDialog");
    NSString *loadingMassage = params[@"content"];
    [SVProgressHUD showWithStatus:loadingMassage];
    return @"_false";
}

/**
 *  app_showLoadingDialog
 */
- (NSString *)app_closeLoadingDialog:(NSDictionary *)params
{
    // ECLog(@"app_closeLoadingDialog");
    [SVProgressHUD dismiss];
    return @"_false";
}

/**
 *  app_platform
 */
- (NSString *)app_platform:(NSDictionary *)params
{
    return @"ios";
}

/**
 *  app_preference
 */
- (NSString *)app_preference:(NSDictionary *)params
{
    NSString *param = params[@"_param"];
    NSString *key = params[@"key"];
    NSString *value = params[@"value"];
    
    //    if ((!param || param.length == 0) && ((key && key.length > 0) && (value && value.length > 0))) {
    if ((!param || param.length == 0) && ((key && key.length > 0) && value)) {
        [ECAppUtil setPreference:value forKey:key];
        return @"_false";
    }else{

        NSLog(param, @"param 为空!!!!!!!");
        NSString *result = [ECAppUtil getPreference:key];
        ECLog(@"app_preference %@" , result);
        return result;
    }
    return @"_false";
}

//网络请求
- (NSString *)app_callApi:(NSDictionary *)params
{
    [[ECNetRequest newInstance] postNetRequest:params finishedBlock:^(id data) {
        [ECJSContext callbackWithJSContextId:params[kJSContextId] callbackId:params[kCallbackId] argument:data];
    } faildBlock:^(id data) {
        [ECJSContext callbackWithJSContextId:params[kJSContextId] callbackId:params[kCallbackId] argument:data];
    }];
    return @"_false";
}

// 显示confirm
- (NSString *)app_showConfirm:(NSDictionary *)params{
    
    if (![params[@"cancel"] isEmpty]) {
        [UIAlertView showWithTitle:params[@"title"]
                           message:params[@"message"]
                 cancelButtonTitle:params[@"cancel"]
                 otherButtonTitles:@[params[@"ok"]]
                          tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                              if (buttonIndex == [alertView cancelButtonIndex]) {
                                  [ECJSContext callbackWithJSContextId:params[kJSContextId] callbackId:params[kCallbackId] argument:[@"{\"state\":\"cancel\"}" JSONValue]];
                              } else {
                                  [ECJSContext callbackWithJSContextId:params[kJSContextId] callbackId:params[kCallbackId] argument:[@"{\"state\":\"ok\"}" JSONValue]];
                              }
                          }];
    }else{
        [UIAlertView showWithTitle:params[@"title"]
                           message:params[@"message"]
                 cancelButtonTitle:params[@"ok"]
                 otherButtonTitles:nil
                          tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                              [ECJSContext callbackWithJSContextId:params[kJSContextId] callbackId:params[kCallbackId] argument:[@"{\"state\":\"ok\"}" JSONValue]];
                          }];
    }
    return @"_false";
}
// 显示日期confirm
- (NSString *)app_showDatepickerConfirm:(NSDictionary *)params{
    NSString* dateString = @"";
    // NSLog(@"app_showDatepickerConfirm");
    BlockAlertDateView *alert = [BlockAlertDateView promptWithDate:params[@"defaultDay"] title:params[@"title"] dateString:&dateString];
    [alert setCancelButtonWithTitle:params[@"cancel"] block:^{
        [ECJSContext callbackWithJSContextId:params[kJSContextId] callbackId:params[kCallbackId] argument:[@"{\"state\":\"cancel\"}" JSONValue]];
    }];
    [alert setDestructiveButtonWithTitle:params[@"ok"] block:^{
        [ECJSContext callbackWithJSContextId:params[kJSContextId] callbackId:params[kCallbackId] argument:[[[NSString alloc] initWithFormat:@"{\"state\":\"ok\",\"value\":\"%@\"}" , [ECAppUtil getPreference:@"_popDatePickerViewValue"]] JSONValue]];
    }];
    [alert show];
    return @"_false";
}

// 显示单选confirm
- (NSString *)app_showRadioConfirm:(NSDictionary *)params{
    BlockAlertView *alert = [BlockAlertView alertWithTitle:params[@"title"] message:@""];
    NSArray* items = [params[@"items"] componentsSeparatedByString:@"-"];
    for(id obj in items)
    {
        //        if([obj length] == 0)           //空串的长度为0
        if(![obj isEqualToString:@""])   //与空串进行比较(字符串是不能进行==比较的，要使用函数)
            [alert addButtonWithTitle:obj imageIdentifier:@"blue" block:^{
                [ECJSContext callbackWithJSContextId:params[kJSContextId] callbackId:params[kCallbackId] argument:[[[NSString alloc] initWithFormat:@"{\"state\":\"ok\",\"target\":\"%@\"}" , obj] JSONValue]];
            }];
    }
    //    [alert setCancelButtonWithTitle:params[@"cancel"] block:^{
    //        [ECJSContext callbackWithJSContextId:params[kJSContextId] callbackId:params[kCallbackId] argument:[@"{\"state\":\"cancel\"}" JSONValue]];
    //    }];
    //    [alert setDestructiveButtonWithTitle:params[@"ok"] block:^{
    //        [ECJSContext callbackWithJSContextId:params[kJSContextId] callbackId:params[kCallbackId] argument:[[[NSString alloc] initWithFormat:@"{\"state\":\"ok\",\"target\":\"%@\"}" ,items[0]] JSONValue]];
    //    }];
    
    [alert setCancelButtonWithTitle:@"取消" block:nil];
    [alert show];
    return @"_false";
}


- (NSString *)app_checkRemoteVersion:(NSDictionary *)params
{
    NSDictionary *apiParam = @{@"method":@"projects/detail"};
    [[ECNetRequest newInstance] postNetRequest:apiParam finishedBlock:^(id data) {
        [ECAppUtil setPreference:[data objectForKey:@"version_num"] forKey:@"net_version_num"];
        [ECAppUtil setPreference:[data objectForKey:@"download_url"] forKey:@"net_version_url"];
    } faildBlock:^(id data) {
        ;
    }];
    return @"_false";
}

- (NSString *)app_getRemoteVersion:(NSDictionary *)params
{
    //    NSLog(@"app_getRemoteVersion :%@",[ECAppUtil getPreference:@"net_version_num"]);
    return [ECAppUtil getPreference:@"net_version_num"];
}

- (NSString *)app_getAppVersion:(NSDictionary *)params
{
    //    NSLog(@"appinfo : %@",[[NSBundle mainBundle] infoDictionary]);
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}


- (NSString *)app_confirmDownloadNewVersion:(NSDictionary *)params
{

//    [UIAlertView showWithTitle:@"发现新版本"
//                       message:params[@"data"]
//             cancelButtonTitle:@"取消"
//             otherButtonTitles:@[params[@"ok"]]
//                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
//                          if (buttonIndex == [alertView cancelButtonIndex]) {
//                          } else {
//                              NSString *url = [ECAppUtil getPreference:@"net_version_url"];
//                              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//                          }
//                      }];
    return @"_false";
}

- (NSString *)app_openUrl:(NSString *)url
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    return @"_false";
}

- (NSString *)app_netState:(NSDictionary *)params
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return @"offline";
    } else {
        return @"mobile";
    }
    
    return @"_false";
}

- (NSString *)app_fullImage:(NSDictionary *)params
{
    NSString *imgSrc = params[@"imageurl"];
    imgSrc=[ECImageUtil getImageWholeUrl:imgSrc];
    ECLog(@"image source: %@", imgSrc);
    //[SJAvatarBrowser showImage:imgSrc];
    return @"_false";
}



#pragma mark- db api
/**
 *  db_getCache
 */
- (id)db_getCache:(NSDictionary *)params
{
    NSString * result = [[NSString alloc] initWithData:[[[ECCoreDataSupport sharedInstance] getCachesWithMd5:params[@"md5"]
                                                                                                       sort1:params[@"sort1"]
                                                                                                       sort2:params[@"sort2"]] firstObject]
                                              encoding:NSUTF8StringEncoding];
    return @{@"result":result};
}

/**
 *  db_getCache
 */
- (id)db_putCache:(NSDictionary *)params
{
    [[ECCoreDataSupport sharedInstance] putCachesWithContent:params[@"content"]
                                                         md5:params[@"md5"]
                                                       sort1:params[@"sort1"]
                                                       sort2:params[@"sort2"]
                                                     timeout:[params[@"cache_time"] doubleValue]];
    return @"_false";
}


#pragma mark- lruCache api
- (id)lrucache_get:(NSDictionary *)params
{
    return [self.class lrucache_get:params[@"_param"]];
}
+ (id)lrucache_get:(NSString *)param{
    // ECLog(@"lrucache_get: %@" , param);
    Caches *selCache = [Caches MR_findFirstByAttribute:@"md5" withValue:param];
    if (selCache == nil) {
        return @"";
    }else{
        return [[NSString alloc] initWithData:selCache.content  encoding:NSUTF8StringEncoding];
    }
}
- (id)lrucache_set:(NSDictionary *)params
{
    Caches *selCache = [Caches MR_findFirstByAttribute:@"md5" withValue:params[@"key"]];
    if (selCache) {
        selCache.content = [params[@"value"] dataUsingEncoding:NSUTF8StringEncoding];
    }else{
        Caches *cache = [Caches MR_createEntity];
        cache.content = [params[@"value"] dataUsingEncoding:NSUTF8StringEncoding];
        cache.md5 = params[@"key"];
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    return @"_false";
}

- (id)lrucache_remove:(NSDictionary *)params
{
    return [self.class lrucache_remove:params[@"_param"]];
}
+ (id)lrucache_remove:(NSString *)param{
    Caches *selCache = [Caches MR_findFirstByAttribute:@"md5" withValue:param];
    if (selCache != nil) {
        [selCache MR_deleteEntity];
    }
    return @"_true";
}

- (id)lrucache_clear:(NSDictionary *)params
{
    [Caches MR_truncateAll];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    return @"_true";
}

- (id)lrucache_massGet:(NSDictionary *)params
{
    NSArray *arrParams = [params[@"_param"] JSONValue];
    // NSLog(@"lrucache_massGet params : %@ ",params);
    NSMutableDictionary *results = [[NSMutableDictionary alloc] init];
    if ([arrParams isKindOfClass:[NSArray class]]) {
        //NSLog(@"lrucache_massGet array!");
        for(int i = 0; i < [arrParams count]; i++){
            NSString *param = arrParams[i];
            NSString *result = [self.class lrucache_get:param];
            if ([result length] >0 && [[result substringToIndex:1] isEqualToString:@"{"]) {
                //                result = [result jsonst]
                [results setValue:[result JSONValue] forKey:param];
                //                result = [[result JSONValue] JSONString];
            }else
                [results setValue:result forKey:param];
        }
    }
    // NSString* str = [results JSONString];
    // ECLog(@"lrucache_massGet : %@" ,str);
    return results;
}


- (id)lrucache_massRemove:(NSDictionary *)params
{
    NSArray *arrParams = [params[@"_param"] JSONValue];
    // NSLog(@"lrucache_massRemove params : %@ ",params);
    NSMutableDictionary *results = [[NSMutableDictionary alloc] init];
    if ([arrParams isKindOfClass:[NSArray class]]) {
        for(int i = 0; i < [arrParams count]; i++){
            NSString *param = arrParams[i];
            [self.class lrucache_remove:param];
        }
    }
    // NSLog(@"lrucache_massGet result : %@ ",results);
    // Caches
    return [results JSONString];
}

//通知、推送
- (NSString *)notification_remove:(NSDictionary *)params
{
    // NSLog(@"notification_remove params : %@ ",params);
    // NSString *notificationId = params[@"_param"];
    [APService deleteLocalNotificationWithIdentifierKey:params[@"notificationId"]];
    return @"_false";
}
//通知、推送
- (NSString *)notification_clear:(NSDictionary *)params
{
    // NSLog(@"notification_remove params : %@ ",params);
    //    NSString *notificationId = params[@"_param"];
    [APService clearAllLocalNotifications];
    
    return @"_false";
}

//通知、推送
- (NSString *)notification_add:(NSDictionary *)params
{
    // NSLog(@"notification_add params : %@ ",params);
    // NSString *notificationId = params[@"_param"];
    // NSDate *date =  [[NSDate alloc] initWithTimeInterval:5 sinceDate:[NSDate date]];
    // NSLog(@"notification_add params : %@ ",params);
    //    NSLog(@"notification_add params : %@ ",[NSString stringWithFormat:@"%@",params[@"broadcastTime"]]);
    //    NSLog(@"notification_add params : %d ",[[NSString stringWithFormat:@"%@",[params[@"broadcastTime"] substringWithRange:NSMakeRange(0, 10)]] intValue]);
    int time = [[NSString stringWithFormat:@"%@",[params[@"broadcastTime"]substringWithRange:NSMakeRange(0, 10)]] intValue];
    UILocalNotification *notification = [APService setLocalNotification:[[NSDate alloc] initWithTimeIntervalSince1970:time]
                                                              alertBody:[NSString stringWithFormat:@"%@ - %@", params[@"title"] , params[@"content"]]
                                                                  badge:-1
                                                            alertAction:@""
                                                          identifierKey:params[@"notificationId"]
                                                               userInfo:nil
                                                              soundName:nil];
    if (notification) {
        ECLog( @"设置本地通知成功" );
    } else {
        ECLog( @"设置本地通知失败" );
    }
    return @"_false";
}


//$A().notification().remove(notificationId) 0条评论 未指派

/**
 *  获取坐标
 */
//- (NSString *)map_location:(NSDictionary *)params
//{
//    [LocationUtil getUserLocationWith:^(NSArray *userLocation) {
//        CLLocationCoordinate2D location = [[userLocation lastObject] getBMKCoordinate2D];
//        NSString *locationString = [NSString stringWithFormat:@"{\"latitude\":%f, \"longitude\":%f}",location.latitude,location.longitude];
//        [ECJSContext callbackWithJSContextId:params[kJSContextId] callbackId:params[kCallbackId] argument:[locationString JSONValue]];
//    }];
//    return @"_false";
//}
#pragma mark- 处理page_on 事件
+ (void)dispatch_page_on_event:(NSDictionary*)event withParams:(id)params
{
    ECJSContext *jsContext = [NSObject findObjectWithId:event[@"_jsContextId"]];
    [jsContext callbackWithId:event[kEventId] argument:params];
}

#pragma mark- util
//- (ECBaseViewController *)pageFromParams:(NSDictionary *)params
//{
//
//    return [[self class] getPageWithJSContextId:params[@"_jsContextId"] callbackId:params[@"_callbackId"]];
//}
@end


#import "ECWebWidget.h"
@implementation ECJSAPI (ECJSAPI_JS)

+ (ECBaseViewController *)getPageWithJSContextId:(NSString *)jsContextId callbackId:(NSString *)callbackId
{
    NSArray *callbackarr = [callbackId componentsSeparatedByString:@"_"];
    ECBaseViewController* controller = nil;
    if ([callbackarr[0] isEqualToString:@"device"]) {
        controller = (ECBaseViewController *)((ECJSContext *)[NSObject findObjectWithId:jsContextId]).parent;
    }else{
        // 获取Webview的实例
        controller = (ECBaseViewController *)((ECWebView *)[NSObject findObjectWithId:jsContextId]).context;
    }
    // NSLog(@"getPageWithJSContextId : %@ | %@ ", controller.pageId , jsContextId );
    return controller;
}

+ (NSString *)getPageIdWithJSContextId:(NSString *)jsContextId callbackId:(NSString *)callbackId
{
    return [[self getPageWithJSContextId:jsContextId callbackId:callbackId] id];
}

// 通过参数获取ECBaseViewController
+ (ECBaseViewController *)getPageController:(NSDictionary *)params
{
    NSString *page = params[@"_page"];
    // ECLog(@"getPageController page: %@",page);
    
    ECBaseViewController *vc = nil;
    if (page && [page length] > 1) {
        vc = (ECBaseViewController *)[NSObject findObjectWithId:page];
    }else{
        vc = [ECJSAPI getPageWithJSContextId:params[@"_jsContextId"] callbackId:params[@"_callbackId"]];
    }
    
    return vc;
}
@end
