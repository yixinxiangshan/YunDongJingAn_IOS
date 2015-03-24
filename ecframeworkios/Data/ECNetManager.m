//
//  ECNetManager.m
//  ECDemoFrameWork
//
//  Created by EC on 8/29/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECNetManager.h"
#import "Reachability.h"

@interface ECNetManager ()
@property (nonatomic, strong) ASINetworkQueue* operationQueue;  // 事物队列
@end

@implementation ECNetManager


#pragma mark - 单例
+(id)sharedInstances{
    static ECNetManager* object = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [self new];
        object.requestCache = [NSMutableDictionary new];
    });
    return object;
}
#pragma mark -
-(id)init{
    self = [super init];
    if (self) {
        _operationQueue = [ASINetworkQueue new];
        _operationQueue.maxConcurrentOperationCount = 1;
        [_operationQueue go];
        return self;
    }
    return nil;
}
#pragma mark -
-(void)dealloc{
    [_operationQueue cancelAllOperations];
    _operationQueue = nil;
    //    [super dealloc];
}
#pragma mark - 添加一个请求
- (void)addOperation:(NSOperation*)_operation{
    if ([_operation isKindOfClass:[ASIHTTPRequest class]]) {
        // NSLog(@"addOperation");
        ECNetRequest* operation = (ECNetRequest*)_operation;
        if (nil == [self operationWithGUID:operation.md5Hash]) {
            
            [_operationQueue addOperation:_operation];
        }
    }
}

#pragma mark - 获取某一个operation
- (ECNetRequest*)operationWithGUID:(NSString*)_guid{
    for (NSOperation* operation in [_operationQueue operations]) {
        if ([operation isKindOfClass:[ASIHTTPRequest class]]) {
            if ([[(ECNetRequest*)operation md5Hash] isEqualToString:_guid]) {
                return (ECNetRequest*)operation;
            }
        }
        
    }
    return nil;
}
#pragma mark - 取消一个请求
- (void)cancelOperationWithGUID:(NSString*)_guid{
    for (NSOperation* operation in [_operationQueue operations]) {
        if ([operation isKindOfClass:[ASIHTTPRequest class]]) {
            if ([[(ECNetRequest*)operation md5Hash] isEqualToString:_guid]) {
                [operation cancel];
            }
        }
        
    }
}
#pragma mark - 取消某个请求

- (void)cancelOperationsWithDelegate:(id)delegate{
    for (NSOperation* operation in [_operationQueue operations]) {
        if ([operation isKindOfClass:[ASIHTTPRequest class]]) {
            if ([[(ECNetRequest*)operation delegate] isEqual:delegate]) {
                [operation cancel];
            }
        }
        
    }
}
#pragma mark - 取消所有请求
- (void)cancelAllOperationsAndNotClean{
    [_operationQueue cancelAllOperations];
}

#pragma mark - 是否有网络联接
+(BOOL)networdEnabled{
    return [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != kNotReachable;
}
+(BOOL)netEnabledWithWifi{
    return [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == kReachableViaWiFi;
}
#pragma mark - 可联网,但是在3G/E网的情况
+(BOOL)networdEnabledWithWWAN{
    return kReachableViaWWAN == [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
}


#pragma mark- 
+ (NSString *) requestURLWith:(NSDictionary *)params
{
    if ([[params valueForKey:@"method"] isEqual:@"token"] || [params valueForKey:@"access_token"]) {
        return TOKEN_URL;
    }
    
    NSString* apiversion = [params objectForKey:@"apiversion"];
    if (!apiversion || apiversion.length == 0) {
        apiversion = @"1.0";
    }
    
    return [NSString stringWithFormat:@"%@/%@/%@",API_URL,apiversion,[params objectForKey:@"method"]];
}
@end
