//
//  ECRefreshDelegate.m
//  ECDemoFrameWork
//
//  Created by EC on 9/16/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECRefreshDelegate.h"
#import "Constants.h"

@implementation ECRefreshDelegate
-(id)initWithEventConfig:(NSDictionary*)eventConfigDic pageContext:(ECBaseViewController*) pageContext widget:(ECBaseWidget*)widget{
    self = [super initWithEventConfig:eventConfigDic pageContext:pageContext widget:widget];
    return self;
}

#pragma refreshDelegate
- (void) refresh
{
    ECLog(@"refresh in delegate...");
    [self runJs];
}
@end
