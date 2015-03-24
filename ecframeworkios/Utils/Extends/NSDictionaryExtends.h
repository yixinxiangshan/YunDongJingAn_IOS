//
//  NSDictionaryExtends.h
//  Extends
//
//  Created by Alix on 9/24/12.
//  Copyright (c) 2012 ecloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extends)

/**
 * @param key key
 *
 * @return kvo 中的v的int值
 */
- (NSInteger)integerForKey:(NSString*)key;

/**
 * @param key key
 * 
 * @return kvo中的v的float值
 */
- (float)floatForKey:(NSString*)key;

/**
 * @see integerForKey:
 */
- (double)doubleForKey:(NSString*)key;

/**
 * @see integerForKey:
 */
- (BOOL)boolForKey:(NSString*)key;

/**
 *pragma mark - 将网络请求参数，转换成htmlBody格式
 */
- (NSString*)toHtmlBody;
/**
 * 添加必要参数
 */
- (NSMutableDictionary* )newParams;
/**
 * 判断是否为空
 */
-(BOOL)isEmpty;
@end

@interface NSDictionary (JSON)
/**
 *  将NSDictionary转化为NSData
 */
- (NSData *) JSONData;

/**
 *  将NSDictionary转化为NSString
 */

-(NSString *)JSONString;
@end