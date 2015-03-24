//
//  ECButtonClickDelegate.m
//  NowMarry
//
//  Created by cheng on 13-12-9.
//  Copyright (c) 2013年 ecloud. All rights reserved.
//

#import "ECButtonClickDelegate.h"
#import "Constants.h"

@interface ECButtonClickDelegate ()
@property (strong, nonatomic) NSMutableDictionary* bundleData;

@end

@implementation ECButtonClickDelegate

-(id)initWithEventConfig:(NSDictionary*)eventConfigDic pageContext:(ECBaseViewController*) pageContext widget:(ECBaseWidget*)widget{
    self = [super initWithEventConfig:eventConfigDic pageContext:pageContext widget:widget];
    return self;
}

- (void)onButtonClick:(ECButton*)button{
    ECLog(@"on click in delegate...");
    if (button) {
        if (!_bundleData) {
            _bundleData = [NSMutableDictionary dictionaryWithObjectsAndKeys:button.viewId, @"viewId",  nil];
        }else{
            [_bundleData setValue:button.viewId forKey:@"viewId"];
        }
        
        [self runJs:_bundleData];
    }
}

@end
