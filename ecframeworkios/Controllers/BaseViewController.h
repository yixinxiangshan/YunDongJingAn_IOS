//
//  BaseViewController.h
//  YHMapDemo
//
//  Created by 单徐梅 on 15/10/2.
//
//

#import <UIKit/UIKit.h>
#import "ECNetRequest.h"
#import "IIViewDeckController.h"
#import "IIWrapController.h"
#import "Constants.h"

//#import "Models.h"
//#import "ECClearApp.h"
//#import "Utils.h"
//#import "Extends.h"
//#import "ECViews.h"
//#import "ECNeedLoginView.h"

@interface BaseViewController: UMViewController<IIViewDeckControllerDelegate>

@property (nonatomic, strong) NSString* configName;
@property (nonatomic, strong) NSString* instanceName;
@property (nonatomic, strong) NSDictionary* configs;
@property (nonatomic, strong) NSDictionary* styles;
@property (nonatomic, strong) NSDictionary* netDataRelevant;
@property (nonatomic, assign) BOOL isNeedLogin;
@property (nonatomic, assign) BOOL isShowContent;

@property (nonatomic, assign) BOOL isLocalData;
@property (nonatomic, strong) NSString* requestId;
@property (nonatomic, strong) NSString* requestIdKey;
@property (nonatomic, strong) NSString* method;

@property (nonatomic, strong) NSString* navTitle;

//@property (nonatomic, strong) ECNeedLoginView* needLoginView;

/**
 * 网络请求回调函数(错误时)
 */
- (void)webRequestFailed:(ASIHTTPRequest*)request;

/**
 * 网络请求数据处理
 */
- (void)handleRequestData:(NSData*)data;
/**
 * show loading
 */
- (void)showLoading:(NSString*)message;
/**
 * remove loading
 */
- (void)removeLoading;
/**
 * 退出程序
 */
- (void)exitApp;


@end