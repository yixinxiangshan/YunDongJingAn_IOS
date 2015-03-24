//
//  NSMutableArrayExtends.h
//  Extends
//
//  Created by Alix on 9/25/12.
//  Copyright (c) 2012 ecloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Extends)
/**
 * 添加1个非空字符
 */
- (void)addNotNilString:(NSString*)str;

/**
 * 添加1个非空对象
 */
- (void)addNotNilObject:(id)obj;

/**
 * 翻转
 */
- (void)reverse;
- (NSArray*)reverseArray;
@end
