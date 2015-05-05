//
//  ECOptionItemClick.m
//  ECDemoFrameWork
//
//  Created by cww on 13-9-18.
//  Copyright (c) 2013年 EC. All rights reserved.
//

#import "ECOptionItemClick.h"
#import "Constants.h"

@interface ECOptionItemClickDelegate ()
@property (strong, nonatomic) NSMutableDictionary* bundleData;

@end



@implementation ECOptionItemClickDelegate
-(id)initWithEventConfig:(NSDictionary*)eventConfigDic pageContext:(ECBaseViewController*) pageContext widget:(ECBaseWidget*)widget{
    self = [super initWithEventConfig:eventConfigDic pageContext:pageContext widget:widget];
    return self;
}

#pragma ItemClickDelegate
- (void)onItemClick:(ECButton *)menuItem
{
    ECLog(@"option item click delegate...");
    if (menuItem) {
        if (!_bundleData) {
            _bundleData = [NSMutableDictionary dictionaryWithObjectsAndKeys:menuItem.title, @"title", menuItem.viewId, @"itemId", nil];
        }else{
            [_bundleData setValue:menuItem.title forKey:@"title"];
            [_bundleData setValue:menuItem.viewId forKey:@"itemId"];
        }
        
        [self runJs:_bundleData];
    }
}
@end
