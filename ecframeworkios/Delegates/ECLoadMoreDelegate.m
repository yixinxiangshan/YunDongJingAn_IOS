//
//  ECLoadMoreDelegate.m
//  ECDemoFrameWork
//
//  Created by EC on 9/16/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECLoadMoreDelegate.h"
#import "Constants.h"

@implementation ECLoadMoreDelegate
-(id)initWithEventConfig:(NSDictionary*)eventConfigDic pageContext:(ECBaseViewController*) pageContext widget:(ECBaseWidget*)widget{
    self = [super initWithEventConfig:eventConfigDic pageContext:pageContext widget:widget];
    return self;
}
#pragma LoadMoreDelegate
- (void) loadMore:(NSString *)lastID
{
    ECLog(@"load more in delegate...");
    [self runJs];
}
@end
