//
//  MSCoreData.h
//  DeliciousCake
//
//  Created by Alix on 1/3/13.
//  Copyright (c) 2013 ecloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECCoreDataSupport.h"

@interface ECCoreDataSupport (MSSPA)
/**
 * 缓存数据
 * @return @YES 保存成功 @NO保存失败
 * @param   content     要保存的数据
 * @param   create_at   数据在何时保存的
 * @param   md5         content的hash值
 * @param   timeout     超时时间，单位为分钟,默认为15分钟
 */
- (BOOL)putCachesWithContent:(NSData*)data
                          md5:(NSString*)md5
                        sort1:(NSString *)sort1
                        sort2:(NSString *)sort2
                      timeout:(NSTimeInterval)timeout;

/**
 * 获取缓存中的数据
 * @return  缓存中的数据
 * @param   md5Hash 根据md5Hash值查询缓存数据
 */
- (NSData*)getCachesWithMd5:(NSString*)md5;
- (NSArray*)getCachesWithMd5:(NSString *)md5
                      sort1:(NSString *)sort1
                      sort2:(NSString *)sort2;

/**
 *  删除缓存
 */
- (BOOL) removeCacheWithMd5:(NSString *)md5
                       sort1:(NSString *)sort1
                      sort2:(NSString *)sort2;
/**
 * 清除所有
 */
- (void) deleteAllCaches;
@end
