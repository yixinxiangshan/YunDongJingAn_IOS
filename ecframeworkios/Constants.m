//
//  Constants.m
//  ECIOSProject
//
//  Created by 程巍巍 on 3/18/14.
//  Copyright (c) 2014 ecloud. All rights reserved.
//

#import "Constants.h"
#import "AppInfo.h"
#import "NSStringExtends.h"

@implementation Constants

+ (NSString *) objectForKey:(NSString *)key
{
    return [[self constants] objectForKey:key];
}

+ (NSString *) configURL
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"IOSProjectTemplateConfigURL"];
}

+ (NSDictionary *)constants
{
    static NSDictionary *constants = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (EC_DEBUG_ON) {
//            constants = [[NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/javascript/debug_app_info.json",[NSString appLibraryPath]] encoding:NSUTF8StringEncoding error:nil] JSONValue];
            
            NSString *constantsSource = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/javascript/debug_app_info.json",[NSString appLibraryPath]] encoding:NSUTF8StringEncoding error:nil];
            constantsSource = [constantsSource stringByReplacingOccurrencesOfString:@"/\\*([\\u0000-\\uFFFF]+?)\\*/" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, constantsSource.length)];
            constants = [constantsSource JSONValue];
        }else{
            constants = [ConstantsString JSONValue];
        }
    });
    return constants;
}
@end

