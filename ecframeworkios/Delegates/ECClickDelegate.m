//
//  ECClickDelegate.m
//  ECDemoFrameWork
//
//  Created by EC on 9/11/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECClickDelegate.h"
#import "Constants.h"

@implementation ECClickDelegate

-(id)initWithEventConfig:(NSDictionary*)eventConfigDic pageContext:(ECBaseViewController*) pageContext widget:(ECBaseWidget*)widget{
    self = [super initWithEventConfig:eventConfigDic pageContext:pageContext widget:widget];
    return self;
}

- (void)onClick:(UIView*)view{
    ECLog(@"on click in delegate...");
    [self runJs];
}

@end
