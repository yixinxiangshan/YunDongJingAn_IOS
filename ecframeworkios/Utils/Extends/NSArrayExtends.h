//
//  NSArrayExtends.h
//  IOSExtends
//
//  Created by Alix on 9/24/12.
//  Copyright (c) 2012 ecloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Extends)

/**
 * @return nil  或第1个指定Class实例对象
 */
- (id)firstObjectWithClass:(Class)cls;

/**
 * @return 指定index处的对象 (用于数组越界查询)
 */
- (id)valueAtIndex:(NSUInteger)index;


/**
 * @return 是否为空 yes为空
 */
- (BOOL)isEmpty;

/**
 * @return 第1个元素
 */
//- (id)firstObject;

/**
 * @return sort后的array
 */
- (NSArray*)sortedArray;

/**
 * @return 翻转后的array
 */
- (NSArray*)reversedArray;


@end

@interface NSArray (JSON)
/**
 *  将NSDictionary转化为NSData
 */
- (NSData *) JSONData;

/**
 *  将NSDictionary转化为NSString
 */

-(NSString *)JSONString;
@end