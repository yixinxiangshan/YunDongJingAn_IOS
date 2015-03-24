//
//  ECNavItemClick.m
//  ECDemoFrameWork
//
//  Created by cww on 13-9-18.
//  Copyright (c) 2013年 EC. All rights reserved.
//

#import "ECNavItemClickDelegate.h"
#import "Constants.h"

@interface ECNavItemClickDelegate ()
@property (strong, nonatomic) NSMutableDictionary* bundleData;

@end

@implementation ECNavItemClickDelegate
-(id)initWithEventConfig:(NSDictionary*)eventConfigDic pageContext:(ECBaseViewController*) pageContext widget:(ECBaseWidget*)widget{
    self = [super initWithEventConfig:eventConfigDic pageContext:pageContext widget:widget];
    return self;
}

#pragma ItemClickDelegate
- (void)onItemClick:(KxMenuItem *)menuItem
{
    ECLog(@"customitem click delegate...  %@ ",menuItem.position);
    if (menuItem) {
        if (!_bundleData) {
            _bundleData = [NSMutableDictionary dictionaryWithObjectsAndKeys:menuItem.position, @"position", menuItem.viewId, @"itemId", nil];
        }else{
            [_bundleData setObject:menuItem.position forKey:@"position"];
            [_bundleData setObject:menuItem.viewId forKey:@"itemId"];
        }
        
        [self runJs:_bundleData];
    }
}
@end
