//
//  ECBaseEventDelegate.h
//  ECDemoFrameWork
//
//  Created by EC on 9/11/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ECBaseViewController;
@class ECBaseWidget;

@interface ECBaseEventDelegate : NSObject

@property (nonatomic, strong) ECBaseWidget* widget;
@property (nonatomic, strong) ECBaseViewController* pageContext;
@property (nonatomic, strong) NSDictionary* eventConfigDic;

- (id)initWithEventConfig:(NSDictionary*)eventConfigDic pageContext:(ECBaseViewController*) pageContext widget:(ECBaseWidget*)widget;

- (void) runJs;

- (void) runJs:(NSDictionary*)bundleData;

- (void) runJsD:(NSDictionary*)tempEventConfigDic;

- (void) runJsD:(NSDictionary*)tempEventConfigDic bundleData:(NSDictionary*)bundleData;

- (NSDictionary*) matchPosition:(NSString*)label value:(NSString*)value;

- (NSDictionary*) matchPosition:(NSString*)label value:(NSString*)value eventConfigDic:(NSDictionary*)eventConfigDic;
@end
