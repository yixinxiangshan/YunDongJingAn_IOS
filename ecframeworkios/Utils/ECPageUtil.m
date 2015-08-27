//
//  ECPageUtil.m
//  ECDemoFrameWork
//
//  Created by EC on 9/2/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECPageUtil.h"
#import "NSStringExtends.h"
#import "NSObjectExtends.h"
#import "Constants.h"
#import "ECJsonUtil.h"
#import "ECDataUtil.h"
#import "ECNetUtil.h"
#import "ECNetRequest.h"
#import "ECAppUtil.h"
#import "ECAppDelegate.h"
#import "NSDictionaryExtends.h"
#import "NSArrayExtends.h"
#import "ECWidgetUtil.h"
//#import "ECJSUtil.h"
#import "Constants.h"


@interface ECPageData : NSObject

@property (nonatomic, strong) NSDictionary* pageDic;
@property (nonatomic, strong) ECBaseViewController* pageContext;

+(ECPageData*) newInstance:(NSDictionary*) pageDic pageContext:(ECBaseViewController*) pageContext;

@end

@implementation ECPageData
+(ECPageData*) newInstance:(NSDictionary*) pageDic pageContext:(ECBaseViewController*) pageContext{
    return [[ECPageData alloc] initWithPageDic:pageDic pageContext:pageContext];
}
-(id)initWithPageDic:(NSDictionary*) pageDic pageContext:(ECBaseViewController*) pageContext{
    self = [super init];
    if (self) {
        _pageDic = pageDic;
        _pageContext = pageContext;
        [pageContext setPageData:self];
    }
    return self;
}
-(void) getPageData:(NSDictionary*) dataSourceDic{
    if (!_pageDic || !dataSourceDic || !_pageContext) {
        return;
    }
    if ([dataSourceDic objectForKey:@"method"] && [(NSString*)[dataSourceDic objectForKey:@"method"] isExpression]) {
        // get value through expression
        NSString* pageString = [ECDataUtil getValuePurpose:[dataSourceDic objectForKey:@"method"] pageContext:_pageContext widget:nil bundleData:nil];
        [ECPageUtil putPageString:pageString pageContext:_pageContext];
        [ECPageUtil initWidgets:_pageDic pageContext:_pageContext];
    }else if(![[dataSourceDic objectForKey:@"method"] isEmpty]){
        // get value through net
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:[ECNetUtil generateNetParams:dataSourceDic pageContext:_pageContext widget:nil]];
        ECLog(@"params = %@",params);
        NSString* pageId = [_pageDic objectForKey:@"page_id"];
        //TODO: 删除不适用缓存
        [[ECNetRequest newInstance] postNetRequest:[NSString stringWithFormat:@"%@.pageString",pageId]
                                            params:params
                                          delegate:self
                                  finishedSelector:@selector(netRequestFinished:)
                                      failSelector:nil
                                          useCache:NO];
    }else{
        [ECPageUtil initWidgets:_pageDic pageContext:_pageContext];
    }
}
- (void) netRequestFinished:(NSNotification *) noti
{
    [self removeObserver];
    NSDictionary* dataDic = noti.userInfo;
    [ECPageUtil putPageString:[ECJsonUtil stringWithDic:dataDic] pageContext:_pageContext];
    [ECPageUtil initWidgets:_pageDic pageContext:_pageContext];
}
- (void) netRequestFailed:(NSNotification *) noti
{
    [self removeObserver];
    [ECPageUtil initWidgets:_pageDic pageContext:_pageContext];
}
- (void) removeObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NSString stringWithFormat:@"%@.pageString.finished",[_pageDic objectForKey:@"page_id"]] object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NSString stringWithFormat:@"%@.pageString.failed",[_pageDic objectForKey:@"page_id"]] object:nil];
}

@end

@implementation ECPageUtil

+(NSString*) loadConfigString:(NSString*) pageName{
    // ECLog(@"loadConfigString pageName = %@",pageName);
    if ([pageName isEmpty]) {
        return nil;
    }
    NSString* pageConfigString = [[NSString alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/config/%@.json",[NSString appConfigPath],pageName] encoding:NSUTF8StringEncoding error:NULL];
    return pageConfigString;
}
+(void) openNewPage:(NSString*)pageName params:(NSString*)paramString{
    ECBaseViewController* baseViewController = [[ECBaseViewController alloc] initWithPageName:pageName params:paramString];
    
    if (![[ECAppUtil shareInstance] controllers]) {
        
        //设置为启动界面
        UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:baseViewController];
        [ECAppDelegate appDelegate].window.rootViewController = navController;
        [[ECAppDelegate appDelegate].window makeKeyAndVisible];
    }else{
        ECBaseViewController* nowController = [[ECAppUtil shareInstance] getNowController];
        [[nowController navigationController] pushViewController:baseViewController animated:YES];
    }
}
+(void) openNewPageWithFinished:(NSString*)pageName params:(NSString*)paramString{
    ECBaseViewController* baseViewController = [[ECBaseViewController alloc] initWithPageName:pageName params:paramString];
    
    if (![[ECAppUtil shareInstance] controllers] || [[[ECAppUtil shareInstance] controllers] count]<1) {
        //设置为启动界面
        UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:baseViewController];
        [ECAppDelegate appDelegate].window.rootViewController = navController;
        [[ECAppDelegate appDelegate].window makeKeyAndVisible];
    }else if ([[[ECAppUtil shareInstance] controllers] count]==1){
        ECBaseViewController* nowController = [[ECAppUtil shareInstance] getNowController];
        UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:baseViewController];
        [ECAppDelegate appDelegate].window.rootViewController = navController;
        [[ECAppDelegate appDelegate].window makeKeyAndVisible];
        [[[ECAppUtil shareInstance] controllers] removeObject:nowController];
    }else{
        ECBaseViewController* nowController = [[ECAppUtil shareInstance] getNowController];
        UINavigationController* navController = [nowController navigationController];
        [navController popViewControllerAnimated:NO];
        [navController pushViewController:baseViewController animated:YES];
    }
}

+ (void) openNewPageWithFinishedOthers:(NSString *)pageName params:(NSString *)paramString
{
    [[[ECAppUtil shareInstance] controllers] removeAllObjects];
    
    ECBaseViewController* baseViewController = [[ECBaseViewController alloc] initWithPageName:pageName params:paramString];
    
    //设置为启动界面
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:baseViewController];
    [ECAppDelegate appDelegate].window.rootViewController = navController;
    [[ECAppDelegate appDelegate].window makeKeyAndVisible];
}

+(void)closeNowPage:(NSString*)successJs{
    // ECLog(@"close now page : %@",successJs);
    [[ECAppUtil shareInstance] putParam:@"close_page_success_js" value:successJs];
    [[[[ECAppUtil shareInstance] getNowController] navigationController] popViewControllerAnimated:YES];
}


+(ECBaseViewController*)initPage:(NSString*)pageName params:(NSString*)paramString{
    ECBaseViewController* baseViewController = [[ECBaseViewController alloc] initWithPageName:pageName params:paramString];
    return baseViewController;
}

+(ECBaseViewController*)initPage:(NSString*)pageName params:(NSString*)paramString parentView:(UIView*)parentView{
    ECBaseViewController* baseViewController = [[ECBaseViewController alloc] initWithPageName:pageName params:paramString parentView:parentView];
    return baseViewController;
}

+(NSString*) getPageNibName:(NSString*) pageConfigString{
    if ([pageConfigString isEmpty]) {
        return nil;
    }
    NSDictionary* pageDic = [ECJsonUtil objectWithJsonString:pageConfigString];
    if (pageDic) {
        NSString* pageNibName = [pageDic objectForKey:@"page_layout"];
        return [pageNibName toCamelCase:YES];
    }
    return nil;
}

+(void) initPage:(ECBaseViewController*) pageContext pageConfigString:(NSString*)pageConfigString{
    if (pageContext.waitBeforeLoadView) {
        return;
    }
//    NSLog(@"pageConfigString length = %lu",(unsigned long)[pageConfigString length]);
//    NSLog(@"pageConfigString = %@",pageConfigString);
//
    //save page-level params
    
    // start parse pageString
    NSDictionary* pageDic = [ECJsonUtil objectWithJsonString:pageConfigString];
    
    //save page id
    // pageContext.pageId = [pageDic objectForKey:@"page_id"];
    
    //触发页面启动事件
    //    NSString* jsString = [NSString stringWithFormat:@"%@.onPageCreated(\"{\\\"pageId\\\":\\\"%@\\\"}\")",pageContext.pageId,pageContext.pageId];
    //    if ([[[ECJSUtil shareInstance] runJS:jsString] boolValue]) {
    //        return;
    //    }
    
    
    // save page inside configs
    if ([pageDic objectForKey:@"configs"]) {
        NSArray* configsArray = [pageDic objectForKey:@"configs"];
        for(id dic in configsArray){
            if ([dic objectForKey:@"key"] && [dic objectForKey:@"value"]) {
                NSString* value =[dic objectForKey:@"value"];
                if ([value isExpression]) {
                    value = [ECDataUtil getValuePurpose:value pageContext:pageContext widget:nil bundleData:nil];
                }
                [pageContext putParam:[dic objectForKey:@"key"] value:value];
            }
        }
    }
    
    //TODO: set event
    
    //set actionBar default state
    [self setActionBarWith:pageDic pageContext:pageContext];
    //get page-level data
    //    NSDictionary* dataSourceDic = [pageDic objectForKey:@"datasource"];
    //    if (dataSourceDic) {
    //        NSDictionary* dataDic = [dataSourceDic objectForKey:@"data"];
    //        if ([dataDic isEmpty]) {
    //            [[ECPageData newInstance:pageDic pageContext:pageContext] getPageData:dataSourceDic];
    //            return;
    //        }
    //        [self putPageString:[ECJsonUtil stringWithDic:dataDic] pageContext:pageContext];
    //    }
    //init controls(widgets)
    //    [self initWidgets:pageDic pageContext:pageContext];
    
}
+ (void) getPageData:(NSDictionary*) pageDic pageContext:(ECBaseViewController*) pageContext
{
    //get page-level data
    NSDictionary* dataSourceDic = [pageDic objectForKey:@"datasource"];
    if (dataSourceDic) {
        NSDictionary* dataDic = [dataSourceDic objectForKey:@"data"];
        if ([dataDic isEmpty]) {
            [[ECPageData newInstance:pageDic pageContext:pageContext] getPageData:dataSourceDic];
            return;
        }
        [self putPageString:[ECJsonUtil stringWithDic:dataDic] pageContext:pageContext];
    }
    //init controls(widgets)
    [self initWidgets:pageDic pageContext:pageContext];
}

+ (void) initWidgets:(NSDictionary*) pageDic pageContext:(ECBaseViewController*) pageContext{
    if (pageContext.waitBeforeLoadView) {
        return;
    }
    if (!pageDic) {
        return;
    }
    
    NSArray* autoStartCtrls = [pageDic objectForKey:@"auto_start_controls"];
    if ([autoStartCtrls isEmpty]) {
        return;
    }
    NSArray* controls = [pageDic objectForKey:@"controls"];
    if ([controls isEmpty]) {
        return;
    }
    //ECLog(@"pageUtil initWidgets");
    for (NSString* ctrlId in autoStartCtrls) {
        for (NSDictionary* controlConfigDic in controls) {
            NSString* controlId = [controlConfigDic objectForKey:@"control_id"];
            if ([controlId isEqualToString:ctrlId]) {
                //init widget through widgetutil
                [ECWidgetUtil initWidget:controlConfigDic pageContext:pageContext];
            }
        }
    }
    pageContext.isWidgetInit = YES;
}

+ (void) setActionBarWith:(NSDictionary *)pageDic pageContext:(ECBaseViewController *)pageContext
{
    [[pageContext navigationController] setNavigationBarHidden:NO];
    
    if (!pageDic) {
        return;
    }
    //ECLog(@"pageUtil initWidgets");
    NSArray* autoStartCtrls = [pageDic objectForKey:@"auto_start_controls"];
    if ([autoStartCtrls isEmpty]) {
        return;
    }
    NSArray* controls = [pageDic objectForKey:@"controls"];
    if ([controls isEmpty]) {
        return;
    }
    for (NSString* ctrlId in autoStartCtrls) {
        for (NSDictionary* controlConfigDic in controls) {
            NSString* controlId = [controlConfigDic objectForKey:@"control_id"];
            if ([controlId isEqualToString:ctrlId]) {
                if ([controlId contain:@"ActionBarWidget"]) {
                    //init widget through widgetutil
                    [ECWidgetUtil initWidget:controlConfigDic pageContext:pageContext];
                }
            }
        }
    }
}

+(void) savePageParams:(NSString*) paramsString pageContext:(ECBaseViewController*)pageContext{
    if ([paramsString isEmpty] || !pageContext) {
        return;
    }
    //key-value array
    id paramsObj = [ECJsonUtil objectWithJsonString:paramsString];
    if (paramsObj && [paramsObj isNSxxxClass:[NSArray class]]) {
        for (id dic in (NSArray*)paramsObj) {
            if ([dic objectForKey:@"key"] && [dic objectForKey:@"value"]) {
                [pageContext putParam:[dic objectForKey:@"key"] value:[dic objectForKey:@"value"]];
            }
        }
        return;
    }
    //json object
    if (paramsObj && [paramsObj isNSxxxClass:[NSDictionary class]]) {
        for (NSString* key in [(NSDictionary*)paramsObj allKeys]) {
            if ([paramsObj objectForKey:key]) {
                [pageContext putParam:key value:[paramsObj objectForKey:key]];
            }
        }
    }
    
}
+ (void)putPageString:(NSString*)pageString pageContext:(ECBaseViewController*) pageContext{
    //TODO: 数据适配器
    NSArray *adapter = [self getPageDataAdapter:pageContext];
    NSDictionary *resData = [pageString JSONValue];
    id newPageString = nil;
    if (adapter) {
        newPageString = [ECDataUtil adapterDataFree:pageContext widget:nil adapters:adapter resData:resData];
    }
    newPageString ? [pageContext putParam:PAGE_DATA_KEY value:[ECJsonUtil stringWithDic:newPageString]] : [pageContext putParam:PAGE_DATA_KEY value:pageString];
}

+ (void) putPageParams:(NSString*)paramsString{
    if (paramsString == nil || [paramsString isEmpty]) {
        return;
    }
    NSDictionary* paramsDic = [ECJsonUtil objectWithJsonString:paramsString];
    if (paramsDic == nil || [paramsDic isEmpty]) {
        return;
    }
    if ([paramsDic objectForKey:@"configs"]) {
        NSArray* configsArray = [paramsDic objectForKey:@"configs"];
        for(id dic in configsArray){
            if ([dic objectForKey:@"key"] && [dic objectForKey:@"value"]) {
                [[[ECAppUtil shareInstance] nowPageContext] putParam:[dic objectForKey:@"key"] value:[dic objectForKey:@"value"]];
            }
        }
    }
    else{
        NSEnumerator* keys = [paramsDic keyEnumerator];
        for (NSString* key in keys) {
            [[[ECAppUtil shareInstance] nowPageContext] putParam:key value:[paramsDic objectForKey:key]];
        }
    }
}


//editor by cww
+ (NSString *) getPageParam:(NSString*)key
{
    return [[[ECAppUtil shareInstance] nowPageContext] getParam:key];
}

//by cww
+ (void) putPageParam:(NSString *)keyString param:(NSString *)param
{
    [[[ECAppUtil shareInstance] nowPageContext] putParam:keyString value:param];
}

// by cww
+ (NSArray *) getPageDataAdapter:(ECBaseViewController *) pageContext
{
    NSDictionary *pageConfig = [ECJsonUtil objectWithJsonString:pageContext.pageConfigSTring];
    
    NSArray *adapter = [[pageConfig objectForKey:@"datasource"] objectForKey:@"adapter"];
    if (!adapter || adapter.count == 0) {
        return nil;
    }
    return adapter;
}
@end
