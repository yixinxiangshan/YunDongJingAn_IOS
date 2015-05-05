//
//  ECJsonParser.m
//  ECMuse
//
//  Created by Alix on 10/22/12.
//  Copyright (c) 2012 ECloudSuperman. All rights reserved.
//

#import "ECJsonUtil.h"
#import "Extends.h"
#import "Constants.h"

@interface ECJsonUtil ()

@end

@implementation ECJsonUtil

#pragma mark - 解系统提供方法解析
+ (id)objectWithJsonString:(NSString *)jsonString{
    if ([jsonString isEqualToString:@"null"]) {
        jsonString = @"{}";
    }
    id object = [ECJsonUtil objectWithJsonData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
//    ECLog(@"object with json string : %@",object);
    return object;
} 
+ (id)objectWithJsonData:(NSData *)jsonData{
    if (jsonData && ![jsonData isMemberOfClass:[NSNull class]] && [jsonData length]) {
        NSError *jsonParsingError = nil;
        id object = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonParsingError];
        if (jsonParsingError) {
            ECLog(@"jsonParsingError : %@",jsonParsingError );
            ECLog(@"jsonParsingError : %@",[[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding]);

            return nil;
        }
        return object;
    }
    return nil;
}

+ (NSString*)stringWithDic:(NSDictionary*)dic{
    
    if (!dic) {
        return @"";
    }
    NSError *err;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&err];
    if (err || !jsonData) {
        ECLog(@"NSJSONSerialization nsdictionary to nsdata error ...");
        return nil;
    }else{
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}
+ (NSData *)dataWithDic:(NSDictionary *)dic
{
    return [self dataWithObject:dic];
}

+ (NSData *) dataWithObject:(id)object
{
    if (![object isKindOfClass:[NSDictionary class]] && ![object isKindOfClass:[NSArray class]]) {
        return nil;
    }
    NSError *err;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&err];
    if (err || !jsonData) {
        NSLog(@"NSJSONSerialization nsdictionary to nsdata error ...");
        return nil;
    }else{
        return jsonData;
    }
}
@end
