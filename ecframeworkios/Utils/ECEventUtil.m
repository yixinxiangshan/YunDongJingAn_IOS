//
//  ECEventUtil.m
//  ECDemoFrameWork
//
//  Created by EC on 9/11/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECEventUtil.h"
#import "ECBaseViewController.h"
#import "ECBaseWidget.h"
#import "NSDictionaryExtends.h"
#import "NSStringExtends.h"
#import "ECReflectionUtil.h"
#import "ECDataUtil.h"
#import "ECJsonUtil.h"
#import "Constants.h"

@implementation ECEventUtil

+ (void) setEventDelegate:(NSDictionary*) eventConfigDic pageContext:(ECBaseViewController*)pageContext widget:(ECBaseWidget*)widget eventLevel:(EventLevel)eventLevel{
    if ([eventConfigDic isEmpty]) 
        return;
    NSString* eventName = [eventConfigDic objectForKey:@"name"];
    if ([eventName isEmpty]) 
        return;
    NSString* viewId = [eventConfigDic objectForKey:@"id"];
    NSString* eventDelegateName = [NSString stringWithFormat:@"EC%@Delegate",[eventName featureString]];
    NSString* setEventMethodName = [NSString stringWithFormat:@"setOn%@Delegate:",[eventName featureString]];
    
    ECLog(@"handle event : %@   %@",eventDelegateName,setEventMethodName);
    
    NSArray* methodParams = [NSArray arrayWithObjects:eventConfigDic,pageContext,widget,nil];
    id delegateInstance = [ECReflectionUtil initClass:eventDelegateName selectName:@"initWithEventConfig:pageContext:widget:" multiObjects:methodParams];
    switch (eventLevel) {
        case PageLevel:
            [ECReflectionUtil performSelectorWithInvoker:pageContext selectName:setEventMethodName objectOne:delegateInstance objectTwo:nil];
            break;
        case WidgetLevel:
            if (![viewId isEmpty]) {
                setEventMethodName = [NSString stringWithFormat:@"%@viewId:",setEventMethodName];
            }
            [ECReflectionUtil performSelectorWithInvoker:widget selectName:setEventMethodName objectOne:delegateInstance objectTwo:viewId];
            break;
            
        default:
            break;
    }
    
}

+ (NSString*)getEventJsString:(NSDictionary*)eventConfigDic pageContext:(ECBaseViewController*)pageContext widget:(ECBaseWidget*)widget{
    return [self getEventJsString:eventConfigDic pageContext:pageContext widget:widget bundleData:nil];
}

+ (NSString*)getEventJsString:(NSDictionary*)eventConfigDic pageContext:(ECBaseViewController*)pageContext widget:(ECBaseWidget*)widget bundleData:(NSDictionary*)bundleData{
    NSString* jString = @"var params = ";
    NSArray* params = [eventConfigDic objectForKey:@"params"];
    NSMutableDictionary* newParams = [NSMutableDictionary new];
    for (NSDictionary* dic in params) {
        [newParams setObject:[ECDataUtil getValuePurpose:[dic objectForKey:@"value"] pageContext:pageContext widget:widget bundleData:bundleData] forKey:[dic objectForKey:@"key"]];
    }
    jString = [NSString stringWithFormat:@"%@%@;%@",jString,[ECJsonUtil stringWithDic:newParams],[eventConfigDic objectForKey:@"javascript"]];
    ECLog(@"getEventJsString: %@",jString);
    return jString;
}

@end
