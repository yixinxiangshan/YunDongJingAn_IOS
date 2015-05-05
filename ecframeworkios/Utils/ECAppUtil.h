//
//  ECAppUtil.h
//  ECDemoFrameWork
//
//  Created by EC on 8/28/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECBaseViewController.h"

@interface ECAppUtil : NSObject

@property (nonatomic, strong) NSMutableArray       * controllers;
@property (nonatomic, strong) ECBaseViewController * nowPageContext;
@property (nonatomic, strong) NSMutableDictionary  * appMap;

+(ECAppUtil*)shareInstance;

-(void)setOnPageStarted:(ECBaseViewController*) controller;
-(void)setOnPageDestroyed:(ECBaseViewController*) controller;

- (ECBaseViewController*)getNowController;

- (NSString *) infalateSon;

- (void) putParam:(NSString*)key value:(NSString *)value ;
- (NSString* )getParam:(NSString*)key;

/**
 *  根据 pageId 获取 page
 */
+ (ECBaseViewController *) getPageContextWithId:(NSString *)pageId;

/**
 * 清空token/enterpriseid/apikey/sonSortList
 */
+ (void)clearApp;

/**
 * 清空缓存
 */
+ (void)clearCache:(BOOL)isAlert;

+(NSString*) getSystemInfo;

/**
 * 获取项目配制及网络资源的本地路径
 */
+ (NSString *) getDecoratePath:(id)data;

/**
 *  获取项目配制
 */
+ (NSDictionary *) getDecorateConfig;

/**
 *  获取完整的网络请求参数
 */
+ (NSString *) getNetParam:(id)data;

/**
 *  获取app配置
 */
+ (id) getPreference:(NSString *)key;
/**
 *  设置app 属性,可以接受  NSString NSDictionary NSArray
 */
+ (void) setPreference:(id)preference forKey:(NSString *)key;

/**
 *  填充App
 */
+ (void) inflateApp:(NSString *)codeString;

/**
 *  填充App
 */
+ (void) deleteInflateAppInfo;

/**
 * 获取当前版本
 */
+ (NSString *)getAppVersion;

/**
 * 获取当前版本
 */
+ (BOOL)checkNewVersion;

/**
 *  分享
 */
+ (void) shareString:(NSString *)shareString;
@end

@interface ECUser : NSObject

typedef void (^signUserSuccessedBlock)();
typedef void (^signUserFaildBlock)(NSString* errorMessage);

@property (strong, nonatomic, getter = getUserInfo, setter = setUserInfo:) NSDictionary* userInfo;

@property (nonatomic, copy) signUserSuccessedBlock signUserSuccessedBlock;
@property (nonatomic, copy) signUserFaildBlock signUserFaildBlock         ;

+ (ECUser *) shareInstance;
/**
 *  验证用户信息
 */
+ (void) signUser:(NSArray *)signConfig successedBlock:(signUserSuccessedBlock)successedBlock faildBlock:(signUserFaildBlock)faildBlock;

+ (void) deleteUserInfo;

+ (void) saveUserName:(NSString *)username;
+ (NSString *) getUserName;
+ (void) deleteUserName;
+ (BOOL) isLogin;
@end