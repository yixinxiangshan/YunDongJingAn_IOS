//
//  NSDictionaryExtends.m
//  Extends
//
//  Created by Alix on 9/24/12.
//  Copyright (c) 2012 ecloud. All rights reserved.
//

#import "NSDictionaryExtends.h"
#import "Constants.h"
#import "NSStringExtends.h"
#import "Utils.h"
#import "ECNetUtil.h"
#import "ECAppUtil.h"

@implementation NSDictionary (Extends)
#pragma mark - 
- (NSInteger)integerForKey:(NSString *)key{
    id obj = [self valueForKey:key];
    if (obj) {
        return [obj integerValue];
    }
    return 0;
}
#pragma mark - 
- (float)floatForKey:(NSString *)key{
    id obj = [self valueForKey:key];
    if (obj) {
        return [obj floatValue];
    }
    return 0.;
}
#pragma mark - 
- (double)doubleForKey:(NSString *)key{
    id obj = [self valueForKey:key];
    if (obj) {
        return [obj doubleValue];
    }
    return 0.;
}
#pragma mark -
- (BOOL)boolForKey:(NSString *)key{
    id obj = [self valueForKey:key];
    if (obj) {
        return [obj boolValue];
    }
    return NO;
}

#pragma mark - 将网络请求参数，转换成htmlBody格式
- (NSString*)toHtmlBody{
    NSArray* keys = [self.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSMutableString* tempString = [[NSMutableString alloc] init];
    for(id key in keys){
        [tempString appendFormat:@"%@=%@&",key,[self objectForKey:key ]];
    }
    NSString* returnString = [tempString substringToIndex:([tempString length]-1)];
    return returnString;
}


#pragma mark -添加必要参数

- (NSMutableDictionary* )newParams{
    NSMutableDictionary* terminalParams = [NSMutableDictionary dictionaryWithDictionary:self];
    // 添加 callid
    if (nil == [terminalParams valueForKey:@"call_id"]) {
        [terminalParams setValue:[NSString randomCallID] forKey:@"call_id"];
    }
    // 没有 method 设置默认method
    if (nil == [terminalParams valueForKey:@"method"]) {
        ECLog(@"params error: no method!!");
        return nil;
    }
    // 设置 api_key
    if (nil == [terminalParams valueForKey:@"api_key"]) {
        [terminalParams setValue:[ApiKey getApiKey] forKey:@"api_key"];
    }
    // 设置 返回格式
    [terminalParams setValue:@"json" forKey:@"format"];
    // 设置 sig
    if (nil == [terminalParams valueForKey:@"sig"]) {
        NSString* sig = [NSString calcSigHashWithMehtodName:[terminalParams valueForKey:@"method"]
                                                     callID:[terminalParams valueForKey:@"call_id"]
                                                     apiKey:[terminalParams valueForKey:@"api_key"]
                                                     secret:[ApiKey getApiSecret]];
        
        [terminalParams setValue:sig forKey:@"sig"];
    }
    // 设置 apiversion
    if (nil == [terminalParams valueForKey:@"apiversion"]) {
        [terminalParams setValue:API_VERSION forKey:@"apiversion"];
    }
    // 添加 udid 参数
    if (nil == [terminalParams valueForKey:@"devicenumber"]) {
        [terminalParams setValue:[UIDevice UDID] forKey:@"devicenumber"];
    }
    
    // 设置 token
    if (nil == [terminalParams valueForKey:@"access_token"] && ![[terminalParams valueForKey:@"method"] isEqualToString:@"token"]) {
        if ([AccessToken getToken]) {
            [terminalParams setValue:[AccessToken getToken] forKey:@"access_token"];
        }
    }
   
    return  terminalParams;

}
-(BOOL)isEmpty{
    return ([self count] == 0);
}
@end

@implementation NSDictionary (JSON)
//将NSDictionary转化为NSData
-(NSData*)JSONData
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self
                                                options:kNilOptions
                                                  error:&error];
    if (error != nil) return nil;
    return result;
}

//将NSDictionary转化为NSString
- (NSString *) JSONString
{
    return [[NSString alloc] initWithData:[self JSONData] encoding:NSUTF8StringEncoding];
}
@end