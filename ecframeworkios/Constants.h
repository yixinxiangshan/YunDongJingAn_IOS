//
//  Constants.h
//  ECDemoFrameWork
//
//  Created by EC on 8/28/13.
//  Copyright (c) 2013 EC. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface Constants : NSObject

+ (id) objectForKey:(NSString *)key;
+ (NSString *) configURL;
@end

//#define API_VERSION     [Constants objectForKey:@"API_VERSION"]
//#define API_KEY         [Constants objectForKey:@"API_KEY"]
//#define CLIENT_SECRET   [Constants objectForKey:@"CLIENT_SECRET"]
//#define TOKEN_URL       [Constants objectForKey:@"TOKEN_URL"]
//#define API_URL         [Constants objectForKey:@"API_URL"]
//#define CONFIG_URL [Constants configURL]
//#define BASE_URL_IMAGE  @"http://is.hudongka.com"


#define API_VERSION     @"1.0"
#define API_KEY         @"c7871624c24b756de846c377f4cacea5"
#define CLIENT_SECRET   @"ac72368dee715a7e347f02f3263b59c5"
#define TOKEN_URL       @"http://856854478.cloudapi.nowapp.cn/oauth/token"
#define API_URL         @"http://856854478.cloudapi.nowapp.cn/api"
#define CONFIG_URL      @"http://jingan.nowapp.cn/eceditor/downCoffee"
#define BASE_URL_IMAGE  @"http://is.hudongka.com"
#define AES_KEY        @"ECloudChangeFuture"

#define ISIOS7          ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define EC_DEBUG_ON 0
#define EC_ENCRYPT_ON 0

#if EC_DEBUG_ON

#define ECLog(...) NSLog(__VA_ARGS__)
#else
//#define ECLog(...)
#define ECLog(...) NSLog(__VA_ARGS__)
#endif

