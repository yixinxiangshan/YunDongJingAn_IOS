//
//  ECEventUtil.h
//  ECDemoFrameWork
//
//  Created by EC on 9/11/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ECBaseViewController;
@class ECBaseWidget;

typedef enum {
    PageLevel = 0,
    WidgetLevel,
}EventLevel;

@interface ECEventUtil : NSObject

+ (void) setEventDelegate:(NSDictionary*) eventConfigDic pageContext:(ECBaseViewController*)pageContext widget:(ECBaseWidget*)widget eventLevel:(EventLevel)eventLevel;

+ (NSString*)getEventJsString:(NSDictionary*)eventConfigDic pageContext:(ECBaseViewController*)pageContext widget:(ECBaseWidget*)widget;

+ (NSString*)getEventJsString:(NSDictionary*)eventConfigDic pageContext:(ECBaseViewController*)pageContext widget:(ECBaseWidget*)widget bundleData:(NSDictionary*)bundleData;

@end
