//
//  ECBaseEventDelegate.m
//  ECDemoFrameWork
//
//  Created by EC on 9/11/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECBaseEventDelegate.h"
#import "ECBaseViewController.h"
#import "ECBaseWidget.h"
#import "ECEventUtil.h"
#import "ECAppDelegate.h"
#import "ECJSUtil.h"
#import "ECJsonUtil.h"

@implementation ECBaseEventDelegate

-(id)initWithEventConfig:(NSDictionary*)eventConfigDic pageContext:(ECBaseViewController*) pageContext widget:(ECBaseWidget*)widget{
    self = [super init];
    if (self) {
        _eventConfigDic = eventConfigDic;
        _pageContext = pageContext;
        _widget = widget;
    }
    return self;
}
- (void) runJs{
    [self runJs:nil];
}


- (void) runJs:(NSDictionary*)bundleData{
    [[[ECAppDelegate appDelegate] jsUtil] runJS:[ECEventUtil getEventJsString:_eventConfigDic pageContext:_pageContext widget:_widget bundleData:bundleData]];
}

- (void) runJsD:(NSDictionary*)tempEventConfigDic{
    [self runJsD:tempEventConfigDic bundleData:nil];
}
- (void) runJsD:(NSDictionary*)tempEventConfigDic bundleData:(NSDictionary*)bundleData{
    [[[ECAppDelegate appDelegate] jsUtil] runJS:[ECEventUtil getEventJsString:tempEventConfigDic pageContext:_pageContext widget:_widget bundleData:bundleData]];
}
- (NSDictionary*) matchPosition:(NSString*)label value:(NSString*)value{
    return [self matchPosition:label value:value eventConfigDic:_eventConfigDic];
}
- (NSDictionary*) matchPosition:(NSString*)label value:(NSString*)value eventConfigDic:(NSDictionary*)eventConfigDic{
    NSString* eventConfigString = [ECJsonUtil stringWithDic:eventConfigDic];
    eventConfigString = [eventConfigString stringByReplacingOccurrencesOfString:label withString:value];
    NSDictionary* tempEventConfigDic = [ECJsonUtil objectWithJsonString:eventConfigString];
    return tempEventConfigDic;
}
@end
