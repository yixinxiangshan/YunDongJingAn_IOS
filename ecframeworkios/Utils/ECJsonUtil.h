//
//  ECJsonParser.h
//  ECMuse
//
//  Created by Alix on 10/22/12.
//  Copyright (c) 2012 ECloudSuperman. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * json解析
 */
@interface ECJsonUtil : NSObject{
    
}
/**
 * 解析
 * @return 返回解析对象
 * @param   jsonString  未解析前的json字符串
 * @param   jsonData    未解析前的json字节流
 */
+ (id)objectWithJsonString:(NSString*)jsonString;
+ (id)objectWithJsonData:(NSData*)jsonData;
/**
 * nsdictionary 生成 json
 */
+ (NSString*)stringWithDic:(NSDictionary*)dic;
/**
 * nsdictionary 生成 nsdata
 */
+ (NSData *)dataWithDic:(NSDictionary *)dic;

+ (NSData *) dataWithObject:(id)object;
@end
