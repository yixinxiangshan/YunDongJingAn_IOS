//
//  NSDateExtends.h
//  IOSExtends
//
//  Created by Alix on 9/24/12.
//  Copyright (c) 2012 ecloud. All rights reserved.
//  参考Three20

#import <Foundation/Foundation.h>

@interface NSDate (Extends)

/**
 * 格式化日期 
 *
 * @param fmt ISO 8601 Date Format(http://en.wikipedia.org/wiki/ISO_8601) 比如: yyyy-MM-dd
 *
 * @return 返回当前日期格式化后的描述形式
 */
- (NSString*)stringWithFormat:(NSString*)fmt;

/**
 * 根据字符串,和格式化描述参数返回日期
 *
 * @param dateDesc 日期格式化描述形式  如: 2012-12-12 08:00
 * 
 * @param fmt   ISO 8601 格式   如  yyyy-MM-dd HH:mm
 *
 * @return NSDate对象
 */
+ (NSDate*)dateFromString:(NSString*)dateDesc formate:(NSString*)fmt;

/**
 * 返回当前日期(当前时区的0:00点)
 */
+ (NSDate*)dateWithToday;

/**
 * 当前日期的时间为0:00的格式
 */
- (NSDate*)dateAtMidnight;
/**
 * 获取日期
 */
- (NSUInteger)getDate;

/**
 * 当前是哪一年
 */
- (NSUInteger)getYear;

/**
 * 当前日期是哪一月
 */
- (NSUInteger)getMonth;

/**
 * 当前是哪一天
 */
- (NSUInteger)getDay;

/**
 * 当前是几点
 */
- (NSUInteger)getHours;

/**
 * 当前时间的分
 */
- (NSUInteger)getMinutes;

/**
 * 当前时间的秒
 */
- (NSUInteger)getSeconds;
/**
 * 获取分段时间，对一小时进行分段，返回当前时间所处时间段尾节点的值，参数推荐为1-6
 */
- (NSString *) sectionTime:(int)section;

@end
