//
//  ECNetUtil.h
//  ECDemoFrameWork
//
//  Created by EC on 8/29/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECNetRequest.h"
#import "ECDataUtil.h"

@interface ECNetUtil : NSObject
+ (void) applyToken;
+ (NSDictionary*) generateNetParams:(NSDictionary*)dataSourceDic pageContext:(ECBaseViewController*)pageContext widget:(ECBaseWidget*)widget;
+ (BOOL)checkError:(NSString*)responseString;
@end

@interface AccessToken : NSObject
+ (AccessToken *) shareInstance;

/**
 * 向服务器申请 access_token
 */
+ (void) applyToken;

/**
 * 获取保存的 access_token
 */
+ (NSString *) getToken;

/**
 * 获取保存的 push_token
 */
+ (NSString *) getPushToken;

/**
 * 删除保存的 access_token push_token
 */
+ (void) deleteToken;
/**
 * 根据配置文件中dataSource部分，生成获取网络的参数
 */

@end

typedef void (^ApplyApiKeyFinished)();
@interface ApiKey : NSObject
+ (ApiKey *) shareInstance;
/**
 * 向服务器申请 access_token
 */
+ (void) applyApiKey:(NSString *)projectNumber;
+ (void) applyApiKey:(NSString *)projectNumber didFinished:(ApplyApiKeyFinished)finishedBlock;
/**
 * 获取保存的 api_key
 */
+ (NSString *) getApiKey;
/**
 * 获取保存的 api_secret
 */
+ (NSString *) getApiSecret;

+ (void) deletApiKey;
@end


typedef void (^DownloadDecorateConfigFinished)();
typedef void (^DownloadDecorateResourceFinished)();
@interface Decorate : NSObject

@property (strong, nonatomic, readonly, getter = getDecorateConfig) NSDictionary* decorateConfig;
@property (strong, nonatomic, readonly, getter = getDecoratePath) NSString* decoratePath;

+ (Decorate *) shareInstance;
/**
 *  获取样式配置
 */
+ (void) downloadDecorateConfig;
+ (void) downloadDecorateConfig:(DownloadDecorateConfigFinished)finishBlock;
/**
 *  获取样式配置
 */
+ (void) downloadDecorateResource;
+ (void) downloadDecorateResource:(DownloadDecorateResourceFinished)finishBlock;

/**
 *  清除 decorate 信息
 */
+ (void) deleteDecorate;
@end