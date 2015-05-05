//
//  NSMutableDictionaryExtends.h
//  Extends
//
//  Created by Alix on 9/25/12.
//  Copyright (c) 2012 ecloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Extends)
/**
 * 设置非空值
 */
- (void)setNotNilString:(NSString*)str forKey:(NSString*)key;

/**
 * 设置非空对象
 */
- (void)setNotNilObject:(id)obj forKey:(NSString*)key;
@end

