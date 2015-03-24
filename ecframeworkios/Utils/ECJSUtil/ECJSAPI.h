//
//  ECJSAPI.h
//  IOSProjectTemplate
//
//  Created by 程巍巍 on 4/3/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECJSAPI : NSObject

+ (void) callDeviceAPI:(NSString *)api params:(NSDictionary *)params callbackId:(NSString *)callbackId action:(NSDictionary *)action;


/**
 *
 */
+ (void)dispatch_page_on_event:(NSDictionary*)event withParams:(id)params;
@end

@class ECBaseViewController;
@interface ECJSAPI (ECJSAPI_JS)

+ (ECBaseViewController *)getPageWithJSContextId:(NSString *)jsContextId callbackId:(NSString *)callbackId;
+ (NSString *)getPageIdWithJSContextId:(NSString *)jsContextId callbackId:(NSString *)callbackId;
+ (ECBaseViewController *)getPageController:(NSDictionary *)params;
@end