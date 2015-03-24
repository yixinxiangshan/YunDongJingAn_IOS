//
//  ECNetRequest.m
//  ECMuse
//
//  Created by Alix on 10/23/12.
//  Copyright (c) 2012 ECloudSuperman. All rights reserved.
//

#import "ECNetRequest.h"
#import "Extends.h"
#import "Reachability.h"
#import "ECCoreData.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "Utils.h"
#import "ECNetManager.h"
#import "NSDateExtends.h"
#import "NSDictionaryExtends.h"
#import "Constants.h"
#import "ECNetUtil.h"

@interface ECNetRequest ()
@property (nonatomic, strong) NSString* name;
@property (nonatomic, weak) id netDelegate;
@property (nonatomic, assign) SEL finishedSelector;
@property (nonatomic, assign) SEL failedSelector;

@property (nonatomic, assign) BOOL forToken;

@property (nonatomic, copy) netRequestFinished finishedBlock;
@property (nonatomic, copy) netRequestFaild faildBlock;


@end

@implementation ECNetRequest
@synthesize  name = _name;
@synthesize md5Hash = _md5Hash;

#pragma mark -
-(void)dealloc{
    _md5Hash = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
+(ECNetRequest*)newInstance{
    return [ECNetRequest newInstance:API_URL];
}

+(ECNetRequest*)newInstance:(NSString*)netUrl{
    ECNetRequest *request = [[ECNetRequest alloc] initWithURL:[NSURL URLWithString:netUrl]];
    
    //设置基本参数
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
	[request setTimeOutSeconds:120];
    [request setRequestMethod:@"POST"];
	[request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded; charset=UTF-8;"];
    [request setDidFinishSelector:@selector(postRequestFinished)];
    [request setDidFailSelector:@selector(postRequestFailed)];
	[request setDelegate:request];
    
    return request;
}

#pragma mark - 网络请求

-(void)postNetRequest:(NSString*)name
               params:(NSDictionary*)params
             delegate:(id)netDelegate
     finishedSelector:(SEL)finishedSelector
         failSelector:(SEL)failedSelector
             useCache:(BOOL)useCache{
    //register notification receiver
    _name = [name stringByAppendingString:[NSString randomString]];
    _netDelegate = netDelegate;
    _finishedSelector = finishedSelector;
    _failedSelector = failedSelector;
    
    
    if(finishedSelector)
        [[NSNotificationCenter defaultCenter] addObserver:netDelegate selector:finishedSelector name:[NSString stringWithFormat:@"%@.finished",_name] object:nil];
    if(failedSelector)
        [[NSNotificationCenter defaultCenter] addObserver:netDelegate selector:failedSelector name:[NSString stringWithFormat:@"%@.failed",_name] object:self];
//    _netDelegate = nil;
    
    NSMutableDictionary* terminalParams = [params newParams];
    if (nil==terminalParams) {
        return;
    }
    [self setMd5Hash:[self MD5HashWithParams:terminalParams]];
    
    
    //if useCache is YES ,return cachedata
    if (useCache) {
//        NSData* data = [[ECCoreDataSupport sharedInstance]
//                        cachesWithMd5Hash:[self md5Hash]];
        NSData *data = [[ECCoreDataSupport sharedInstance] getCachesWithMd5:[self md5Hash]
                                                                      sort1:nil
                                                                      sort2:nil];
        if (data && [data length]) {
            ECLog(@"read data from  caches files");
            NSDictionary* dicData = [self parsingRespnseData:data];
            if (dicData != nil) {
                [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@.finished",_name] object:nil userInfo:dicData];
            }
            return ;
        }
        
    }
    [self setForToken:NO];
    if ([[terminalParams valueForKey:@"method"] isEqual:@"token"])
    {
        [self setForToken:YES];
    }else{
        NSString* apiversion = [terminalParams objectForKey:@"apiversion"];
        [self setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",self.url,apiversion,[terminalParams objectForKey:@"method"]]]];
    }
    // ECLog(@"request params:%@", [terminalParams description]);
    // ECLog(@"request URL : %@",self.url);

    //处理文件
    for (NSString* key in [terminalParams allKeys]) {
        NSString* value = [terminalParams objectForKey:key];
        if ([NSNull null] == (NSNull *)value) {
            continue;
        }
        if ([value hasPrefix:@"file://"]) {
            ECLog(@"%@",[value substringFromIndex:7]);
            [self addFile:[value substringFromIndex:7]  forKey:key];
//            [terminalParams removeObjectForKey:key];
        }else{
            [self addPostValue:[terminalParams objectForKey:key] forKey:key];
        }
        
    }
    
    if (![[terminalParams valueForKey:@"method"] isEqual:@"token"] && ![terminalParams valueForKey:@"access_token"]) {
        ECLog(@"access_token is nil , apply access_token ...");
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(continueRequest:) name:@"applyToken.finished" object:nil];
        [ECNetUtil applyToken];
        //加入未就续请求缓存
        [[[ECNetManager sharedInstances] requestCache] setObject:self forKey:_name];
        return;
    }
    //    [ECViewUtil showLoadingDialog:nil loadingMessage:@"loading..." cancelAble:NO];
    [[ECNetManager sharedInstances] addOperation:self];

}
- (void) continueRequest:(NSNotification *)noti
{
    ECLog(@"apply access_token done , continue request ...");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"applyToken.finished" object:nil];
    if (![noti.userInfo valueForKey:@"access_token"]) {
        //TODO: add error message for apply token failed
        [self postRequestFailed];
        [[[ECNetManager sharedInstances] requestCache] removeObjectForKey:_name];
        return;
    }
    [self addPostValue:[noti.userInfo valueForKey:@"access_token"] forKey:@"access_token"];
    [[ECNetManager sharedInstances] addOperation:self];
    
    //加入请求队列后，移出未就续请求缓存
    [[[ECNetManager sharedInstances] requestCache] removeObjectForKey:_name];
}

-(void)postNetRequest:(NSString*)name
               params:(NSDictionary*)params
             delegate:(id)netDelegate
     finishedSelector:(SEL)finishedSelector
         failSelector:(SEL)failSelector{
    [self postNetRequest:name params:params delegate:netDelegate finishedSelector:finishedSelector failSelector:failSelector useCache:YES];
}

- (void) postNetRequest:(NSDictionary *)params
          finishedBlock:(netRequestFinished)finishedBlock
             faildBlock:(netRequestFaild)faildBlock
{
    [self postNetRequest:params finishedBlock:finishedBlock faildBlock:faildBlock useCache:NO];
}
- (void) postNetRequest:(NSDictionary *)params
          finishedBlock:(netRequestFinished)finishedBlock
             faildBlock:(netRequestFaild)faildBlock
               useCache:(BOOL)useCache
{
    self.finishedBlock = finishedBlock;
    self.faildBlock = faildBlock;
    
    [self postNetRequest:@"Block.netRequest"
                  params:params
                delegate:nil
        finishedSelector:nil
            failSelector:nil
                useCache:useCache];
}
- (void) postWithFinishedBlock:(netRequestFinished)finishedBlock
                    faildBlock:(netRequestFaild)faildBlock
{
    self.finishedBlock = finishedBlock;
    self.faildBlock = faildBlock;
    [self setDidFinishSelector:@selector(postRequestFinished)];
    [self setDidFailSelector:@selector(postRequestFailed)];
    
    [[ECNetManager sharedInstances] addOperation:self];
}

-(void) postRequestFinished{
    // [ECViewUtil closeLoadingDialog];
    NSString* responseString = [self responseString];
    // ECLog(@"postRequestFinished responseString length:%@",responseString);
    //TODO: add checkerror method in netutil
    if ([responseString rangeOfString:@"\"error\""].location != NSNotFound || [responseString rangeOfString:@"\"Error\""].location != NSNotFound) {
        [self postRequestFailed];
    }
    else{
        NSDictionary* data = [self parsingRespnseData:self.responseData];
        //判断是否是JSON数据，需修正
        if (!data && responseString) {
            if (self.finishedBlock) {
                self.finishedBlock(responseString);
            }
            return;
        }
        //处理JSON数据
        if(!_forToken)
            data = [data objectForKey:@"data"];
        if (data != nil && (NSNull *)data != [NSNull null]) {
//            [[ECCoreDataSupport sharedInstance] saveCachesWithData:[ECJsonUtil dataWithDic:data]
//                                                           md5Hash:[self md5Hash]];
            [[ECCoreDataSupport sharedInstance] putCachesWithContent:[ECJsonUtil dataWithDic:data]
                                                                 md5:[self md5Hash]
                                                               sort1:nil
                                                               sort2:nil
                                                             timeout:15];
            
            //判断通知 _netDelegate是否已经被销毁，若已被销毁，则不发通知(未从通知中心移除）
            if ([_netDelegate respondsToSelector:_finishedSelector]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@.finished",_name] object:nil userInfo:data];
            }
            if (self.finishedBlock) {
                self.finishedBlock(data);
            }
        }else{
            [self postRequestFailed];
        }
    }
}
-(void) postRequestFailed{
    [ECViewUtil closeLoadingDialog];
    //TODO: check diffrent error ,use diffrent errorID
    ECLog(@"postRequestFailed responseString:%@",self.responseString);
    NSDictionary* data = [self parsingRespnseData:self.responseData];
    data = [data objectForKey:@"data"];
    if (data == nil || (NSNull *)data == [NSNull null]) {
        NSDictionary* errorEntry = [NSDictionary dictionaryWithObjectsAndKeys:@"网络请求错误",@"errordes",@"300",@"errorId", nil];
        data = [NSDictionary dictionaryWithObjectsAndKeys:errorEntry,@"error", nil];
    }
    
    //判断通知 _netDelegate是否已经被销毁，若已被销毁，则从通知中心移除
    if ([_netDelegate respondsToSelector:_failedSelector]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@.failed",_name] object:self userInfo:data];
    }
    
    if (self.faildBlock) {
        self.faildBlock(data);
    }
}

-(NSDictionary*)parsingRespnseData:(NSData*) dataSrc{
    NSDictionary* data = nil;
    //处理数据
    id obj = [ECJsonUtil objectWithJsonData:dataSrc];
    if ([obj isNSxxxClass:[NSDictionary class]]) {
        data = (NSDictionary*)obj;
        return data;
    }else{
        return nil;
    }
}

#pragma mark - 根据参数生成唯一hash值
- (NSString*)MD5HashWithParams:(NSDictionary*)params{
    if (params == nil) {
        return nil;
    }
    NSMutableDictionary* tempPrams = [NSMutableDictionary dictionaryWithDictionary:params];
    [tempPrams removeObjectForKey:@"call_id"];
    [tempPrams removeObjectForKey:@"sig"];
    [tempPrams setObject:[[NSDate date] sectionTime:4] forKey:@"time"];

    NSString* tempString = [tempPrams toHtmlBody];
    return [tempString md5Hash];
    
}
@end






#pragma mark - 根据request params 获取 MD5hash 

@interface NSString (request)
/**
 * 缓存中的md5Hash值
 */
+(NSString*)requestHashMD5WithPostParams:(NSDictionary*)dict;
@end

@implementation NSString (request)

+(NSString*)requestHashMD5WithPostParams:(NSDictionary*)dict{
    if (dict) {
        
    }
    return nil;
}

@end


#pragma mark - api接口method
//获取token
NSString* tokenMethod(){
    return @"token";
}
//获取app信息
NSString* appInfo(){
    return @"projects/detail";
}
// 图片地址
NSString* imageURI(){
    return @"http://is.hudongka.com/";
}
