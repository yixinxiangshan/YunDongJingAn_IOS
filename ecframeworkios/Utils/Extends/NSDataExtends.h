//
//  NSDataExtends.h
//  IOSExtends
//
//  Created by Alix on 9/24/12.
//  Copyright (c) 2012 ecloud. All rights reserved.
//  参考了Three20

#import <Foundation/Foundation.h>

@interface NSData (Extends)
/**
 * 数据的md5值 (CC_MD5)
 *
 * @return md5 hash值
 */
@property (nonatomic, readonly) NSString* md5Hash;

/**
 * 数据的SHA1值 (CC_SHA1)
 *
 * @return SHA1 hash值
 */
@property (nonatomic, readonly) NSString* sha1Hash;

/**
 * Create an NSData from a base64 encoded representation
 * Padding '=' characters are optional. Whitespace is ignored.
 * @return the NSData object
 */
+ (id)dataWithBase64EncodedString:(NSString *)string;

/**
 * Marshal the data into a base64 encoded representation
 *
 * @return the base64 encoded string
 */
- (NSString *)base64Encoding;


@end
