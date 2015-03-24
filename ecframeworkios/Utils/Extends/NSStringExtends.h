//
//  NSStringExtends.h
//  Extends
//
//  Created by Alix on 9/24/12.
//  Copyright (c) 2012 ecloud. All rights reserved.
//  参考Three20

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NSString (Extends)

/**
 * md5 hash值 (CC_MD5)
 */
@property (nonatomic, readonly) NSString* md5Hash;

/**
 * SHA1 hash值 (CC_SHA1)
 */
@property (nonatomic, readonly) NSString* sha1Hash;

/**
 * 是否为空串(只含有空格/换行/Tab字符)
 */
- (BOOL)isWhitespaceOrNewLine;

/**
 * 是否为空(长度大于0)
 */
- (BOOL)isEmpty;

/**
 * 获取App ~/Doucments 目录
 */
+ (NSString*)appDoucmentsPath;

/**
 * 获取App ~/Caches目录
 */
+ (NSString*)appCachesPath;

/**
 * 获取App ~/Library目录
 */
+ (NSString*)appLibraryPath;

/**
 * 获取App ~/Library目录
 */
+ (NSString*)appConfigPath;

/**
 * 获取App 静态资源目录
 */
+ (NSString*)appStaticResourcePath;
/**
 * 获取App ～/tmp目录
 */
+ (NSString*)appTmpPath;

/**
 * 获取文件的路径
 */
+ (NSString*)filepathWithRootDirectory:(NSString*)rootDir fileName:(NSString*)fileName;


/**
 * url编码
 */
- (NSString*)urlEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding;

/**
 * url编码
 */
- (NSString*)urlEncodedString;

/**
 * url string
 */
- (NSString*)urlString;

/**
 * url参数转为字典
 */
- (NSDictionary*)queryContentsUsingEncoding:(NSStringEncoding)encoding;

/**
 * 网络请求参数聚合
 */
+ (NSString*)polymerizeRequestParams:(NSDictionary*)params;

/**
 * 含有中文时的uri地址要转换一下
 */
- (NSString*)addingPercentEscapesUsingEncoding:(NSStringEncoding)encoding;
- (NSString*)addingPercentEscapes;

/**
 * create device uuid
 */
+ (NSString*)UDID NS_DEPRECATED_IOS(2_0, 5_0);

/**
 * 一个基于时间的网络请求中用到的id
 */
+ (NSString*)randomCallID;
/**
 * 一个基于时间的随机字符串
 */
+ (NSString*)randomString;
/**
 * 根据请求参数，生成sig
 */
+ (NSString*)calcSigHashWithMehtodName:(NSString*)method
                                callID:(NSString*)callID
                                apiKey:(NSString*)apiKey
                                secret:(NSString*)secret;

/**
 * 格式 yyyy-MM
 */
+ (NSString*)YearAndMouth;
/**
 * 判断是否包含字符串
 */
- (BOOL)contain:(NSString*)string;
/**
 * 去头去尾
 */
- (NSString*) slim;

- (NSString*) slimH;

- (NSString*) slimE;

/**
 * 字符串转义
 */
- (NSString* )transfer;
/**
 * 通过字符串获取对应值，判断该字符串是否为表达式
 */
- (BOOL)isExpression;
/**
 * 首字母大写
 */
- (NSString*)featureString;
/**
 * 转换为驼峰型字符串
 * @param firstUp 首字母大写
 */

- (NSString*) toCamelCase:(BOOL)firstUp;
- (NSString*) toUnderLineCase;

/**
 *  从 bundle 载入文件
 */
+ (NSString *)stringWithFileName:(NSString *) filename type:(NSString *)type;

/**
 *  将NSString转化为NSArray或者NSDictionary
 */
- (id) JSONValue;

- (NSRange) firstRangeOfRegex:(NSString *)regexString;
- (NSString *) substringWithRegex:(NSString *)regexString;
- (NSString *) stringByReplacingOccurrencesOfString:(NSString *)target withRegex:(NSString *)regexString byString:(NSString *)newString;

@end

#pragma mark - 获取设备号
@interface UIDevice (UUID)
+ (NSString*)UDID;
@end
