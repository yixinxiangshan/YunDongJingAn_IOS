//
//  ECCacheData.m
//  NowMarry
//
//  Created by cheng on 13-12-31.
//  Copyright (c) 2013年 ecloud. All rights reserved.
//

#import "ECCacheData.h"
#import "DataCache.h"
#import "NSDateExtends.h"
#import "ECJsonUtil.h"

#define ECCacheDataTopLabel @"ECCacheDataTopLabel"
#define ECCacheDataBottomLabel @"ECCacheDataBottomLabel"

#define STATEDefault @"STATEDefault"

@implementation ECCacheDataSupport (CacheData)

+ (BOOL) putCache:(NSString *)content sort1:(NSString *)sort1 sort2:(NSString *)sort2 md5:(NSString *)md5  cacheTime:(NSDate *)cache_time state:(NSString *)state
{
    return [[[self class] sharedInstance] putCache:content sort1:sort1 sort2:sort2 md5:md5 cacheTime:cache_time state:state];
}
+ (BOOL) putCache:(NSString *)content sort1:(NSString *)sort1 sort2:(NSString *)sort2 md5:(NSString *)md5  cacheTime:(NSDate *)cache_time
{
    return [self putCache:content sort1:sort1 sort2:sort2 md5:md5 cacheTime:cache_time state:nil];
}
+ (BOOL) putCache:(NSString *)content sort1:(NSString *)sort1 sort2:(NSString *)sort2 md5:(NSString *)md5
{
    return [self putCache:content sort1:sort1 sort2:sort2 md5:md5 cacheTime:nil];
}

+ (NSArray *) getCacheA:(NSString *)md5 sort1:(NSString *)sort1 sort2:(NSString *)sort2
{
    return [[[self class] sharedInstance] getCache:md5 sort1:sort1 sort2:sort2];
}
+ (NSString *) getCacheS:(NSString *)md5 sort1:(NSString *)sort1 sort2:(NSString *)sort2
{
        return [[NSString alloc] initWithData:[ECJsonUtil dataWithObject:[[self class] getCache:md5 sort1:sort1 sort2:sort2]] encoding:NSUTF8StringEncoding];
}


#pragma mark-
- (BOOL) putCache:(NSString *)content sort1:(NSString *)sort1 sort2:(NSString *)sort2 md5:(NSString *)md5 cacheTime:(NSDate *)cache_time state:(NSString *)state
{
    if (!content || !sort1 || !sort2) {
        return NO;
    }
    cache_time = cache_time ? cache_time : [NSDate new];
    state = state ? state : STATEDefault;
    
    NSManagedObjectContext *moc =  self.managedObjectContext;
    
    // 添加、保存
    DataCache* cache = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([DataCache class]) inManagedObjectContext:moc];
    cache.content = [content dataUsingEncoding:NSUTF8StringEncoding];
    cache.sort1 = sort1;
    cache.sort2 = sort2;
    cache.cache_time = cache_time;
    cache.state = state;
    cache.iD = [self nextID];
    cache.md5 = md5;
    
    return [[ECCacheDataSupport sharedInstance] saveContext];

}

- (NSArray *) getCache:(NSString *)md5 sort1:(NSString *)sort1 sort2:(NSString *)sort2
{
    NSManagedObjectContext *moc =  self.managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:NSStringFromClass([DataCache class])
                                              inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init] ;
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"md5 ==  %@ AND sort1 == %@ AND sort2 == %@",md5 , sort1, sort2];
    
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    if (error == nil) {
        array = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            NSComparisonResult result = [((DataCache *)obj1).iD compare:((DataCache *)obj2).iD];
            
            return result == NSOrderedDescending; // 升序
        }];
        
        NSMutableArray* result = [NSMutableArray new];
        
        for (int i = 0; i < array.count; i ++) {
            DataCache* cache = [array objectAtIndex:i];
            NSString* content = [[NSString alloc] initWithData:cache.content encoding:NSUTF8StringEncoding];
            NSString* sort1 = cache.sort1;
            NSString* sort2 = cache.sort2;
            NSString* cache_time = [(NSDate *)cache.cache_time stringWithFormat:@"yyyy-MM-dd HH:ss:mm"];
            NSString* state = cache.state;
            NSNumber* iD = cache.iD;
            NSString* md5 = cache.md5;
            
            [result addObject:@{@"content": content, @"sort1": sort1, @"sort2": sort2, @"creat_at":cache_time, @"id": iD, @"state": state, @"md5":md5}];
        }
        return result;
    } else {
        NSLog(@"ListDataError:%@", [error localizedDescription]);
    }
    return nil;
}


#pragma mark-
- (NSNumber *) nextID
{
    NSNumber* ID = [NSNumber numberWithInteger:[[self topID] integerValue]+1];
    [[NSUserDefaults standardUserDefaults] setObject:ID forKey:ECCacheDataTopLabel];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return ID;
}
- (NSNumber *) topID
{
    NSNumber* ID = [[NSUserDefaults standardUserDefaults] objectForKey:ECCacheDataTopLabel];
    if (!ID) {
        ID = [NSNumber numberWithInteger:0];
    }
    
    
    return ID;
}

@end
