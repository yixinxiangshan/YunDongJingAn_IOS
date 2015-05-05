//
//  MSCoreData.m
//  DeliciousCake
//
//  Created by Alix on 1/3/13.
//  Copyright (c) 2013 ecloud. All rights reserved.
//

#import "ECCoreData.h"
#import "Caches.h"
#import "Extends.h"
#import "Utils.h"
#import "Constants.h"

@implementation ECCoreDataSupport (MSSPA)


- (BOOL) putCachesWithContent:(NSData *)data
                          md5:(NSString *)md5
                        sort1:(NSString *)sort1
                        sort2:(NSString *)sort2
                      timeout:(NSTimeInterval)timeout
{
    if (data && md5) {
        if (timeout <= 0) {
            timeout = 15;
        }
        
        //ECLog(@"putCache params : %@  sort1 = %@ sort2 = %@ \n content = %@",md5,sort1,sort2,[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        //先删除老的数据
        [self removeCacheWithMd5:md5 sort1:sort1 sort2:sort2];
        
        // 添加、保存
        Caches* cache = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Caches class]) inManagedObjectContext:self.managedObjectContext];
        cache.md5 = md5;
        cache.timeout = [NSNumber numberWithDouble:timeout];
        cache.content = data;
        cache.sort1 = sort1;
        cache.sort2 = sort2;
        cache.create_at = [NSDate date];
        
        
        [[ECCoreDataSupport sharedInstance] saveContext];
        if ([md5 isEqualToString:@"report"]) {
            //ECLog(@"cache : %@",[[NSString alloc] initWithData:cache.content encoding:NSUTF8StringEncoding]);
        }
        return YES;
    }
    return NO;
}

- (NSData *) getCachesWithMd5:(NSString *)md5
{
    return [[self getCachesWithMd5:md5 sort1:nil sort2:nil] firstObject];
}

- (NSArray *) getCachesWithMd5:(NSString *)md5
                        sort1:(NSString *)sort1
                        sort2:(NSString *)sort2
{
    //ECLog(@"getCaches params : %@  sort1 = %@ sort2 = %@",md5,sort1,sort2);
    NSManagedObjectContext *moc =  self.managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:NSStringFromClass([Caches class])
                                              inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init] ;
    [request setEntity:entityDescription];
    
    NSPredicate *predicate;
    if (sort2 && sort1 && sort1.length > 0 && sort2.length > 0) {
        predicate = sort2 && sort1 ? [NSPredicate predicateWithFormat:@"md5 == %@ AND sort2 == %@ AND sort1 == %@", md5,sort2,sort1] : nil;
    }else if (sort1 && sort1.length > 0){
        predicate = sort1 ? [NSPredicate predicateWithFormat:@"md5 == %@ AND sort1 == %@", md5,sort1] : nil;
    }else if (sort2 && sort2.length > 0){
        predicate = sort2 ? [NSPredicate predicateWithFormat:@"md5 == %@ AND sort2 == %@", md5,sort2] : nil;
    };
    
    //ECLog(@"query : %@",predicate);
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    //ECLog(@"coreData result : %@",array);
    if (error == nil) {
        if (array != nil) {
            NSMutableArray *result = [NSMutableArray new];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                Caches *cache = obj;
                NSTimeInterval deltaTime = [cache.create_at timeIntervalSinceNow] / 60;
                if (fabs(deltaTime) > [cache.timeout doubleValue] ){
                    
                }else{
                    //ECLog(@"缓存时间:@%@ %@ %f %f", cache.create_at, [NSDate date], deltaTime, fabs(deltaTime));
                    [result addObject:[obj content]];
                }
            }];
            return result;
        }
    } else {
        //ECLog(@"CoreDataError:%@", [error localizedDescription]);
    }
    return nil;
}

- (BOOL) removeCacheWithMd5:(NSString *)md5
                      sort1:(NSString *)sort1
                      sort2:(NSString *)sort2
{
    
    //ECLog(@"remove cache params : %@  sort1 = %@ sort2 = %@",md5,sort1,sort2);
    // 先执行删除
    NSManagedObjectContext *moc =  self.managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:NSStringFromClass([Caches class]) inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate;
    if (md5 && sort2 && sort1 && sort1.length > 0 && sort2.length > 0) {
        predicate = [NSPredicate predicateWithFormat:@"md5 == %@ AND sort2 == %@ AND sort1 == %@", md5,sort2,sort1] ;
    }else if (md5 && sort1 && sort1.length > 0){
        predicate = [NSPredicate predicateWithFormat:@"md5 == %@ AND sort1 == %@", md5,sort1];
    }else if (md5 && sort2 && sort2.length > 0){
        predicate = [NSPredicate predicateWithFormat:@"md5 == %@ AND sort2 == %@", md5,sort2] ;
    }else if (md5.length > 0){
        predicate = [NSPredicate predicateWithFormat:@"md5 == %@", md5];
    };
    
    [request setPredicate:predicate];
    
    
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    if (error == nil) {
        if (array != nil) {
            // 删除
            for (Caches* cache in array) {
                //NSLog(@"Caches remove md5 : %@",cache.md5);
                [moc deleteObject:cache];
            }
            if( ![[ECCoreDataSupport sharedInstance] saveContext]) {
                return NO;
            }
        }
    }
    return YES;
}

- (void) deleteAllCaches{
    [self.managedObjectContext deletedObjects];
    [ECViewUtil toast:@"缓存清理成功..."];
}
@end
