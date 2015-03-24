//
//  ECWidgetUtil.h
//  ECDemoFrameWork
//
//  Created by EC on 9/2/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ECBaseViewController;
@class ECBaseWidget;


typedef enum {
    InitWidgetData = 0,
    RefreshWidgetData,
    AddWidgetData,
}GetWidgetStatus;

@interface ECWidgetUtil : NSObject

+ (id)initWidget:(NSDictionary*)configDic pageContext:(ECBaseViewController*)pageContext;
/**
 * 初始化控件时 获取数据
 */
+ (void) initWidgetData:(ECBaseViewController*)pageContext widget:(ECBaseWidget*)widget dataSourceDic:(NSDictionary*)dataSourceDic;

+ (void) refreshWidgetData:(ECBaseViewController*)pageContext widget:(ECBaseWidget*)widget dataSourceDic:(NSDictionary*)dataSourceDic;

+ (void) addWidgetData:(ECBaseViewController*)pageContext widget:(ECBaseWidget*)widget dataSourceDic:(NSDictionary*)dataSourceDic lastId:(NSString*)lastId;
/**
 *  判断数据源是否有效
 */
+ (BOOL)isWidgetDataAvailableFor:(ECBaseWidget *)widget in:(ECBaseViewController *)pageContext with:(NSDictionary *)dataSourceDic;
+ (void) getWidgetData:(ECBaseViewController*)pageContext widget:(ECBaseWidget*)widget dataSourceDic:(NSDictionary*)dataSourceDic status:(GetWidgetStatus)status;
/**
 * 将获取到的数据交给控件
 */
+ (void) putWidgetData:(ECBaseViewController*)pageContext widget:(ECBaseWidget*)widget dataDic:(NSDictionary*)dataDic status:(GetWidgetStatus)status;

+ (void) setEventDelegate:(NSDictionary*) eventConfigDic pageContext:(ECBaseViewController*)pageContext widget:(ECBaseWidget*)widget;
/**
 为控件设置属性
 */
+ (void) setAttrsForWidget:(NSString*) attrsString controlId:(NSString*)controlId;

+ (ECBaseWidget*)getWidget:(NSString*)controlId;

/**
 *  callWidgetMethod
 *  根据 controlId, methodName, param1, param2 找到widget,并调用方法
 */
+ (void) callWidgetMethod:(NSString *)controlId name:(NSString *)methodName param1:(NSString *)param1 param2:(NSString *)param2;

/**
 *  刷新控件 by cww
 */
+ (void) refershWidget:(NSString *)widgetId dataSource:(NSString *)dataSource;
@end
