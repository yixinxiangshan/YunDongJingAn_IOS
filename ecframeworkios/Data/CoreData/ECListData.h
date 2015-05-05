//
//  ECListData.h
//  NowMarry
//
//  Created by cheng on 13-12-30.
//  Copyright (c) 2013年 ecloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECListDataSupport.h"

@interface ECListDataSupport (ListData)

/**
 *  插入队列
 */
+ (BOOL) pushQueue:(NSString *)content sort1:(NSString *)sort1 sort2:(NSString *)sort2 creatAt:(NSString *)creatAt;
+ (BOOL) pushQueue:(NSString *)content sort1:(NSString *)sort1 sort2:(NSString *)sort2;

/**
 *  弹出队列
 */
+ (NSString *) pullQueue:(NSString *)sort1 sort2:(NSString *)sort2 count:(NSInteger)count;
+ (NSArray *) pullQueue:(NSString *)sort1 sort2:(NSString *)sort2;

/**
 *  插入队列
 */
+ (BOOL) pushStack:(NSString *)content sort1:(NSString *)sort1 sort2:(NSString *)sort2;

/**
 *  弹出队列
 */
+ (NSString *) pullStack:(NSString *)sort1 sort2:(NSString *)sort2 count:(NSInteger)count;
+ (NSArray *) pullStack:(NSString *)sort1 sort2:(NSString *)sort2;

/**
 *
 */
+ (BOOL) addList:(NSString *)content sort1:(NSString *)sort1 sort2:(NSString *)sort2 listType:(NSString *)listType state:(NSString *)state;

+ (NSArray *) pullListA:(NSString *)sort1 sort2:(NSString *)sort2 orderString:(NSString *)orderString;
+ (NSString *) pullListS:(NSString *)sort1 sort2:(NSString *)sort2 orderString:(NSString *)orderString;
@end
