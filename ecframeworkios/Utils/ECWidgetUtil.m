//
//  ECWidgetUtil.m
//  ECDemoFrameWork
//
//  Created by EC on 9/2/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECWidgetUtil.h"
#import "ECBaseViewController.h"
#import "ECBaseWidget.h"
#import "ECReflectionUtil.h"
#import "NSStringExtends.h"
#import "NSDictionaryExtends.h"
#import "ECDataUtil.h"
#import "ECJsonUtil.h"
#import "Constants.h"
#import "ECNetUtil.h"
#import "ECAppUtil.h"
#import "ECEventUtil.h"

@interface WidgetNetData : NSObject
@property (nonatomic, strong) NSDictionary* dataSourceDic;
@property (nonatomic, strong) ECBaseViewController* pageContext;
@property (nonatomic, strong) ECBaseWidget* widget;
@property (nonatomic, assign) GetWidgetStatus status;

+(WidgetNetData*) newInstance:(NSDictionary*) dataSourceDic pageContext:(ECBaseViewController*)pageContext widget:(ECBaseWidget*)widget status:(GetWidgetStatus)status;

@end

@implementation WidgetNetData

+(WidgetNetData*) newInstance:(NSDictionary*) dataSourceDic pageContext:(ECBaseViewController*)pageContext widget:(ECBaseWidget*)widget status:(GetWidgetStatus)status{
    return [[WidgetNetData alloc] initWithDataSource:dataSourceDic pageContext:pageContext widget:widget status:status];
}
-(WidgetNetData*)initWithDataSource:(NSDictionary*) dataSourceDic pageContext:(ECBaseViewController*)pageContext widget:(ECBaseWidget*)widget status:(GetWidgetStatus)status{
    self = [super init];
    if (self) {
        _dataSourceDic = dataSourceDic;
        _pageContext = pageContext;
        _widget = widget;
        _status = status;
        [widget setWidgetNetData:self];
    }
    return self;
}

- (void)getWidgetNetData{
    // get value through net
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:[ECNetUtil generateNetParams:_dataSourceDic pageContext:_pageContext widget:nil]];
    ECLog(@"params = %@",params);
    if (_status == AddWidgetData) {
        [params setObject:[_dataSourceDic objectForKey:@"lastId"] forKey:@"lastid"];
    }
    //TODO: 删除不适用缓存
    [[ECNetRequest newInstance] postNetRequest:[NSString stringWithFormat:@"%@.widgetData",[_widget controlId]]
                                        params:params
                                      delegate:self
                              finishedSelector:@selector(netRequestFinished:)
                                  failSelector:@selector(netRequestFailed:)
                                      useCache:NO];

}

- (void) netRequestFinished:(NSNotification *) noti
{
    [self removeObserver:noti];
    NSDictionary* dataDic = noti.userInfo;
    [ECWidgetUtil putWidgetData:_pageContext widget:_widget dataDic:dataDic status:_status];
}
- (void) netRequestFailed:(NSNotification *) noti
{
    [self removeObserver:noti];
    [ECWidgetUtil putWidgetData:_pageContext widget:_widget dataDic:nil status:_status];
}
- (void) removeObserver:(NSNotification *) noti{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NSString stringWithFormat:@"%@.widgetData.finished",[_widget controlId]] object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NSString stringWithFormat:@"%@.widgetData.failed",[_widget controlId]] object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:noti.name object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:noti.name object:nil];
}

#pragma mark-
- (void) dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

@implementation ECWidgetUtil

+ (id)initWidget:(NSDictionary*)configDic pageContext:(ECBaseViewController*)pageContext{
    NSString* widgetName = [configDic objectForKey:@"xtype"];
    if ([widgetName isEmpty]) {
        return nil;
    }
    NSArray* finishedWidgets = [NSArray arrayWithObjects:@"ECTabWidget",@"ECItemNewsWidget",@"ECListViewWidget",@"ECListViewBase",@"ECGridWidget",@"ECGroupWidget",@"ECWebWidget",@"ECActionBarWidget",@"ECButtonWidget",@"ECFormWidget", @"ECSlideShowWidget", @"ECMapWidget",@"ECSearchWidget",@"ECChannelWidget",@"ECBlankWidget",@"ECPagerWidget",@"E", nil];
    widgetName = [NSString stringWithFormat:@"EC%@",widgetName];
    if (NSClassFromString(widgetName) == nil || ![finishedWidgets containsObject:widgetName]) {
        ECLog(@"there is no such widget : %@ , or it is no finished .",widgetName);
        return nil;
    }
    ECLog(@"ECWidgetUtil init widget : %@",widgetName);
//    ECBaseWidget* widget = [ECReflectionUtil performSelector:widgetName selectName:@"initWithConfigDic:pageContext:" objectOne:configDic objectTwo:pageContext];
    Class class = NSClassFromString(widgetName);
    ECBaseWidget *widget = [class alloc];
    widget = [widget initWithConfigDic:configDic pageContext:pageContext];
    
    return widget;
}
# pragma - mark 发起控件数据请求
+ (void) initWidgetData:(ECBaseViewController*)pageContext widget:(ECBaseWidget*)widget dataSourceDic:(NSDictionary*)dataSourceDic{
    [self getWidgetData:pageContext widget:widget dataSourceDic:dataSourceDic status:InitWidgetData];
}

+ (void) refreshWidgetData:(ECBaseViewController*)pageContext widget:(ECBaseWidget*)widget dataSourceDic:(NSDictionary*)dataSourceDic{
    [self getWidgetData:pageContext widget:widget dataSourceDic:dataSourceDic status:RefreshWidgetData];
}

+ (void) addWidgetData:(ECBaseViewController*)pageContext widget:(ECBaseWidget*)widget dataSourceDic:(NSDictionary*)dataSourceDic lastId:(NSString*)lastId{
    NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithDictionary:dataSourceDic];
    if (lastId==nil || [lastId isEmpty]) {
        return;
    }
    [tempDic setObject:lastId forKey:@"lastId"];
    [self getWidgetData:pageContext widget:widget dataSourceDic:tempDic status:AddWidgetData];
}

+ (BOOL) isWidgetDataAvailableFor:(ECBaseWidget *)widget in:(ECBaseViewController *)pageContext with:(NSDictionary *)dataSourceDic
{
    if ([dataSourceDic isEmpty])
        return NO;
    if ([dataSourceDic[@"method"] isEmpty]) {
        return NO;
    }
    return YES;
}
+ (void) getWidgetData:(ECBaseViewController*)pageContext widget:(ECBaseWidget*)widget dataSourceDic:(NSDictionary*)dataSourceDic status:(GetWidgetStatus)status{
    if ([dataSourceDic isEmpty]) 
        return;
    NSDictionary* dataDic = [dataSourceDic objectForKey:@"data"];
    // use data from config
    if (![dataDic isEmpty]) {
        [self putWidgetData:pageContext widget:widget dataDic:dataDic status:status];
        return;
    }
    NSString* methodName = [dataSourceDic objectForKey:@"method"];
    
    //editor by cww
//    if (![methodName isEmpty]) {
//        [self putWidgetData:pageContext widget:widget dataDic:nil status:status];
//        return;
//    }
    if ([methodName isEmpty]) {
        [self putWidgetData:pageContext widget:widget dataDic:nil status:status];
        return;
    }
    // get data through expression 
    if ([methodName isExpression]) {
        NSString* dataString = [ECDataUtil getValuePurpose:methodName pageContext:pageContext widget:widget bundleData:nil];
        dataDic = [ECJsonUtil objectWithJsonString:dataString];
        [self putWidgetData:pageContext widget:widget dataDic:dataDic status:status];
        return;
    }
    // get data from net
    [[WidgetNetData newInstance:dataSourceDic pageContext:pageContext widget:widget status:status] getWidgetNetData];
}

+ (void) putWidgetData:(ECBaseViewController*)pageContext widget:(ECBaseWidget*)widget dataDic:(NSDictionary*)dataDic status:(GetWidgetStatus)status{
    switch (status) {
        case InitWidgetData:
            [widget putWidgetData:dataDic];
            break;
        case RefreshWidgetData:
            [widget refreshWidgetData:dataDic];
            break;
        case AddWidgetData:
            [widget addWidgetData:dataDic];
            break;
            
        default:
            break;
    }
}
+ (void) setEventDelegate:(NSDictionary*) eventConfigDic pageContext:(ECBaseViewController*)pageContext widget:(ECBaseWidget*)widget{
    [ECEventUtil setEventDelegate:eventConfigDic pageContext:pageContext widget:widget eventLevel:WidgetLevel];
}

+ (void) setAttrsForWidget:(NSString*) attrsString controlId:(NSString*)controlId{
    ECBaseWidget *widget = [self getWidget:controlId];
    [widget setAttrs:attrsString];
}

+ (ECBaseWidget*)getWidget:(NSString*)controlId{
    if ([controlId isEmpty]) {
        return nil;
    }
    return [[[ECAppUtil shareInstance] getNowController] getWidget:controlId];
}

+ (void) callWidgetMethod:(NSString *)controlId name:(NSString *)methodName param1:(NSString *)param1 param2:(NSString *)param2
{
    ECBaseWidget* widget = [[self class] getWidget:controlId];
    SEL method = NSSelectorFromString(methodName);
    
    if ([widget respondsToSelector:method]) {
        [widget performSelector:method withObject:param1 withObject:param2];
    }else{
        ECLog(@"widget with name  %@  or method with name %@ is nil ...",controlId,methodName);
    }
}

// 刷新控件 by cww
+ (void) refershWidget:(NSString *)widgetId dataSource:(NSString *)dataSource
{
    [self refreshWidgetData:[[ECAppUtil shareInstance] nowPageContext] widget:[self getWidget:widgetId] dataSourceDic:[ECJsonUtil objectWithJsonString:dataSource]];
}
@end
