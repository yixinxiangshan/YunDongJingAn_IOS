//
//  ECListData.m
//  NowMarry
//
//  Created by cheng on 13-12-30.
//  Copyright (c) 2013年 ecloud. All rights reserved.
//

#import "ECListData.h"
#import "List.h"
#import "NSStringExtends.h"
#import "NSDateExtends.h"
#import "ECJsonUtil.h"

#define ECListDataTopLabel @"ECListDataTopLabel"
#define ECListDataBottomLabel @"ECListDataBottomLabel"

#define LISTTYPE_QUEUE @"LISTTYPE_QUEUE"
#define LISTTYPE_STACK @"LISTTYPE_STACK"

#define STATEDefault @"STATEDefault"

typedef NS_ENUM(NSInteger, ListType) {ListTypeAll = 0, ListTypeQueue = 1, ListTypeStack = 2};

@implementation ECListDataSupport (ListData)

#pragma mark- Queue

/**
 *  插入队列
 */
+ (BOOL) pushQueue:(NSString *)content sort1:(NSString *)sort1 sort2:(NSString *)sort2
{
    return [self pushQueue:content sort1:sort1 sort2:sort2 creatAt:nil];
}
+ (BOOL) pushQueue:(NSString *)content sort1:(NSString *)sort1 sort2:(NSString *)sort2 creatAt:(NSString *)creatAt
{
    return [[[self class] sharedInstance] pushData:content sort1:sort1 sort2:sort2 creatAt:nil state:nil listType:ListTypeQueue];
}

/**
 *  弹出队列
 */
+ (NSArray *) pullQueue:(NSString *)sort1 sort2:(NSString *)sort2
{
    return [[[self class] sharedInstance] pullData:0 sort1:sort1 sort2:sort2 creatAt:nil state:nil listType:ListTypeQueue];
}
+ (NSString *) pullQueue:(NSString *)sort1 sort2:(NSString *)sort2 count:(NSInteger)count
{
    id r = [[[self class] sharedInstance] pullData:count sort1:sort1 sort2:sort2 creatAt:nil state:nil listType:ListTypeQueue];
    NSDictionary* dic = @{@"list": r};
    NSString* result = [ECJsonUtil stringWithDic:dic];
    return result;
}

/**
 *  插入堆栈
 */
+ (BOOL) pushStack:(NSString *)content sort1:(NSString *)sort1 sort2:(NSString *)sort2
{
    return [[[self class] sharedInstance] pushData:content sort1:sort1 sort2:sort2 creatAt:nil state:nil listType:ListTypeStack];
}

/**
 *  弹出堆栈
 */
+ (NSString *) pullStack:(NSString *)sort1 sort2:(NSString *)sort2 count:(NSInteger)count
{
    NSString* result = [NSString stringWithFormat:@"{\"list\":%@}",[[NSString alloc] initWithData:[ECJsonUtil dataWithObject:[[[self class] sharedInstance] pullData:count sort1:sort1 sort2:sort2 creatAt:nil state:nil listType:ListTypeStack]] encoding:NSUTF8StringEncoding]];
    return result;
}
+ (NSArray *) pullStack:(NSString *)sort1 sort2:(NSString *)sort2
{
    return [[[self class] sharedInstance] pullData:0 sort1:sort1 sort2:sort2 creatAt:nil state:nil listType:ListTypeStack];
}

/**
 *
 */

//TODO:需测试
+ (BOOL) addList:(NSString *)content sort1:(NSString *)sort1 sort2:(NSString *)sort2 listType:(NSString *)listType state:(NSString *)state
{
    ListType type;
    if ([listType isEqualToString:LISTTYPE_QUEUE]) {
        type = ListTypeQueue;
    }
    if ([listType isEqualToString:LISTTYPE_STACK]) {
        type = ListTypeStack;
    }
    
    return [[self sharedInstance] pushData:content sort1:sort1 sort2:sort2 creatAt:nil state:state listType:type];
}
+ (NSArray *) pullListA:(NSString *)sort1 sort2:(NSString *)sort2 orderString:(NSString *)orderString
{
    NSArray* result = [[self sharedInstance] pullData:0 sort1:sort1 sort2:sort2 creatAt:nil state:nil listType:ListTypeAll];
    
    result = [result sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSComparisonResult compareResult = [[obj1 objectForKey:orderString] compare:[obj2 objectForKey:orderString]];
        return compareResult == NSOrderedDescending;
    }];
    
    return result;
}
+ (NSString *) pullListS:(NSString *)sort1 sort2:(NSString *)sort2 orderString:(NSString *)orderString
{
    return [[NSString alloc] initWithData:[ECJsonUtil dataWithObject:[self pullListA:sort1 sort2:sort2 orderString:orderString]] encoding:NSUTF8StringEncoding];
}
#pragma mark- private method
- (BOOL) pushData:(NSString *)content sort1:(NSString *)sort1 sort2:(NSString *)sort2 creatAt:(NSDate *)creatAt state:(NSString *)state listType:(ListType)listType
{
    if (!content || !sort1 || !sort2) {
        return NO;
    }
    creatAt = creatAt ? creatAt : [NSDate new];
    state = state ? state : STATEDefault;
    
    NSManagedObjectContext *moc =  self.managedObjectContext;
    
    // 添加、保存
    List* list = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([List class]) inManagedObjectContext:moc];
    list.content = [content dataUsingEncoding:NSUTF8StringEncoding];
    list.sort1 = sort1;
    list.sort2 = sort2;
    list.create_at = creatAt;
    list.state = state;
    list.iD = [self nextID];
    list.list_type = [NSNumber numberWithInteger:listType];
    
    return [[ECListDataSupport sharedInstance] saveContext];
    

}
- (NSArray *) pullData:(NSInteger)count sort1:(NSString *)sort1 sort2:(NSString *)sort2 creatAt:(NSDate *)creatAt state:(NSString *)state listType:(ListType)listType
{
    NSManagedObjectContext *moc =  self.managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:NSStringFromClass([List class])
                                              inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init] ;
    [request setEntity:entityDescription];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"list_type ==  %@ AND sort1 == %@ AND sort2 == %@",[NSNumber numberWithInteger:listType] , sort1, sort2];
    if (creatAt) {
        predicate = [predicate predicateWithSubstitutionVariables:@{@"create_at": creatAt}];
    }
    if (state) {
        predicate = [predicate predicateWithSubstitutionVariables:@{@"state": state}];
    }
    
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    if (error == nil) {
        array = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            NSComparisonResult result = [((List *)obj1).iD compare:((List *)obj2).iD];
            
            return result == (listType ? NSOrderedAscending : NSOrderedDescending); // 升序
            return [((List *)obj1).iD integerValue] <= [((List *)obj2).iD integerValue] ?  NSOrderedAscending:  NSOrderedDescending;
        }];

        NSMutableArray* result = [NSMutableArray new];
        
        for (int i = 0; i < (count == 0 ? array.count : (count <= array.count ? count : array.count)); i ++) {
            List* list = [array objectAtIndex:i];
            NSString* content = [[NSString alloc] initWithData:list.content encoding:NSUTF8StringEncoding];
//            NSString* sort1 = list.sort1;
//            NSString* sort2 = list.sort2;
//            NSString* creat_at = [(NSDate *)list.create_at stringWithFormat:@"yyyy-MM-dd HH:ss:mm"];
//            NSNumber* iD = list.iD;
            
//            [result addObject:@{@"content": content, @"sort1": sort1, @"sort2": sort2, @"creat_at":creat_at, @"id": iD}];
            [result addObject:[ECJsonUtil objectWithJsonString:content]];
            [moc deleteObject:list];
        }
        [self saveContext];
        return result;
    } else {
        NSLog(@"ListDataError:%@", [error localizedDescription]);
    }
    
    return nil;
}
- (NSArray *) pullQueue:(NSString *)sort1 sort2:(NSString *)sort2
{
    return nil;
}

#pragma mark-
- (NSNumber *) nextID
{
    NSNumber* ID = [NSNumber numberWithInteger:[[self topID] integerValue]+1];
    [[NSUserDefaults standardUserDefaults] setObject:ID forKey:ECListDataTopLabel];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return ID;
}
- (NSNumber *) topID
{
    NSNumber* ID = [[NSUserDefaults standardUserDefaults] objectForKey:ECListDataTopLabel];
    if (!ID) {
        ID = [NSNumber numberWithInteger:0];
    }
    
    
    return ID;
}
@end
