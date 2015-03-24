//
//  ECCacheData.h
//  NowMarry
//
//  Created by cheng on 13-12-31.
//  Copyright (c) 2013年 ecloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECCacheDataSupport.h"

@interface ECCacheDataSupport (CacheData)


+ (BOOL) putCache:(NSString *)content sort1:(NSString *)sort1 sort2:(NSString *)sort2 md5:(NSString *)md5  cacheTime:(NSDate *)cache_time state:(NSString *)state;
+ (BOOL) putCache:(NSString *)content sort1:(NSString *)sort1 sort2:(NSString *)sort2 md5:(NSString *)md5  cacheTime:(NSDate *)cache_time;
+ (BOOL) putCache:(NSString *)content sort1:(NSString *)sort1 sort2:(NSString *)sort2 md5:(NSString *)md5;


+ (NSArray *) getCacheA:(NSString *)md5 sort1:(NSString *)sort1 sort2:(NSString *)sort2;
+ (NSString *) getCacheS:(NSString *)md5 sort1:(NSString *)sort1 sort2:(NSString *)sort2;

@end
