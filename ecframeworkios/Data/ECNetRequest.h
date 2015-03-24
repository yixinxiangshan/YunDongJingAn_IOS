//
//  ECNetRequest.h
//  ECMuse
//
//  Created by Alix on 10/23/12.
//  Copyright (c) 2012 ECloudSuperman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASICacheDelegate.h"
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"
#import "ECJsonUtil.h"
#import "Constants.h"
#import "ASIDownloadCache.h"

#pragma mark - 



@interface ECNetRequest : ASIFormDataRequest

typedef void (^netRequestFinished)(id data);
typedef void (^netRequestFaild)(id data);

@property (nonatomic, retain)  NSString*  md5Hash; // 用于标识符


+(ECNetRequest*)newInstance;

+(ECNetRequest*)newInstance:(NSString*)netUrl;

/**
 * 只是生成了一个请求,没有发送,只有添加到队列后才发送。
 * @param name 请求名字
 * @param params  请求参数
 * @param netDelegate 委托
 * @param finishedSelector 成功的函数
 * @param failSelector 失败的函数
 * @param useCache 是否使用缓存
 */

-(void)postNetRequest:(NSString*)name
               params:(NSDictionary*)params
             delegate:(id)netDelegate
     finishedSelector:(SEL)finishedSelector
         failSelector:(SEL)failSelector
             useCache:(BOOL)useCache;

-(void)postNetRequest:(NSString*)name
               params:(NSDictionary*)params
             delegate:(id)netDelegate
     finishedSelector:(SEL)finishedSelector
         failSelector:(SEL)failSelector;

- (void)postNetRequest:(NSDictionary *)params
         finishedBlock:(netRequestFinished)finishedBlock
            faildBlock:(netRequestFaild)faildBlock;
- (void)postNetRequest:(NSDictionary *)params
         finishedBlock:(netRequestFinished)finishedBlock
            faildBlock:(netRequestFaild)faildBlock
              useCache:(BOOL)useCache;

- (void) postWithFinishedBlock:(netRequestFinished)finishedBlock
                    faildBlock:(netRequestFaild)faildBlock;

- (NSString*)MD5HashWithParams:(NSDictionary*)params;

@end

/**
 * api接口method
 */
//获取token
NSString* tokenMethod();
//获取app信息
NSString* appInfo();
//获取子分类
NSString* sonSortList();
//获取分类中 内容列表
NSString* listByType();
//获取详细内容
NSString* contentInfo();
// 图片地址
NSString* imageURI();
// 申请宜码
NSString* addApplyMethod();
// 反聩
NSString* addComment();
// 教练
NSString* teacherList();
// 课程显示课表
NSString* scheduleByCourse();
// 教练显示课表
NSString* scheduleByTeacher();
// 场馆显示课表
NSString* scheduleByVenue();
// 时间显示课表
NSString* scheduleByWeekday();


