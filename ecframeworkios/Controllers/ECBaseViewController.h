//
//  ECBaseViewController.h
//  ECDemoFrameWork
//
//  Created by EC on 9/2/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECActionBarWidget.h"
#import "ECViewUtil.h"
#import "ECJSConstants.h"

@class ECPageData;
@class ECBaseWidget;
@class ECJSContext;

@interface ECBaseViewController : UIViewController

@property (nonatomic, strong) NSMutableDictionary* mMap;
@property (nonatomic, strong) NSString* pageName;
@property (nonatomic, strong) NSString* pageId;
@property (nonatomic, strong) NSString* pageConfigSTring;
@property (nonatomic, strong) ECPageData* pageData; //用于缓存该页面请求数据的实例
@property (nonatomic, strong) UIView* parentView;
@property (nonatomic) BOOL isCreated;
@property (nonatomic) BOOL isWidgetInit;

/**
 *  缓存 actionBar(NavigationBar) 左视图、title视图、右视图
 */
@property (nonatomic, strong) ECActionBarWidget* actionBar;

-(id) initWithPageName:(NSString*)pageName;
-(id) initWithPageName:(NSString*)pageName params:(NSString*)paramsString;
/**
 * 适用于tab、channel等控件初始化子页面时使用
 */
-(id) initWithPageName:(NSString*)pageName params:(NSString*)paramsString parentView:(UIView*)parentView;
/**
 sava page-level params
 */
-(void) putParam:(NSString*)key value:(NSString*)value;
/**
get page-level params
 */
- (NSString*)getParam:(NSString*)key;
/**
 * 存放该页面中的控件
 */
- (void) putWidget:(NSString*)controlId widget:(ECBaseWidget*)widget;
- (ECBaseWidget*)getWidget:(NSString*)controlId;

- (void)openImagePiker:(id<SystemImagePickerDelegate>) imagePickerDelegate;

- (void) updateActionBar;


#pragma mark- ECJSSimpleAPI
@property (nonatomic, strong) ECJSContext *jsContext;

/**
 *  标志，是否暂停页面加载
 *  如果为 YES，则显示空白页面与 加载框
 *  默认为 NO
 */
@property (nonatomic) BOOL waitBeforeLoadView;


/**
 *  page 生命周期事件
 *  onCreat
 *  onResume
 *  onCreated
 *
 */
@property (nonatomic, strong) NSMutableDictionary *pageJSEvent;
@end

@class ECPageLifeCircleEvent;
@interface ECBaseViewController (ECJSSimpleAPI)

/**
 * 设置页面等待状态
 */
- (void)pageWait;

/**
 * 设置页面恢复等待状态
 */
- (void)pageResumeWait;

/**
 *  触发 生命周期事件
 */
- (void) dispatchLifeCircleEvetn:(NSString *)eventName;
- (BOOL)dispatchJSEvetn:(NSString *)eventName withParams:(id)params;

/**
 *  putWidgetData
 */
- (void) putWidgetData:(id)data withWidgetId:(NSString *)widgetId;

/**
 *  getWidgetData
 */
- (id)getWidgetData:(NSString *)widgetId;

@end