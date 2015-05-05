//
//  ECNetManager.h
//  ECDemoFrameWork
//
//  Created by EC on 8/29/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECNetRequest.h"

@interface ECNetManager : NSObject

/**
 * 单例
 */
+(id)sharedInstances;
/**
 *存放未就续 请求
 */
@property (nonatomic, strong) NSMutableDictionary* requestCache;
/**
 * 添加一个请求
 */
- (void)addOperation:(NSOperation*)_operation;

/**
 * 取消一个请求
 */
- (void)cancelOperationWithGUID:(NSString*)_guid;
/**
 * 取消某个请求
 */
- (void)cancelOperationsWithDelegate:(id)delegate;

/**
 * 获取某一个operation
 */
- (ECNetRequest*)operationWithGUID:(NSString*)_guid;

/**
 * 取消所有请求
 */
- (void)cancelAllOperationsAndNotClean;

/**
 * 可在wifi下联接上互联网
 */
+(BOOL)netEnabledWithWifi;
/**
 * 可联网,但是在3G/E网的情况
 */
+(BOOL)networdEnabledWithWWAN;

/**
 * 是否有网络联接
 */
+(BOOL)networdEnabled;

@end
