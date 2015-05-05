//
//  ECOptionItemClick.h
//  ECDemoFrameWork
//
//  Created by cww on 13-9-18.
//  Copyright (c) 2013年 EC. All rights reserved.
//

#import "ECBaseEventDelegate.h"
#import "ECButton.h"

@protocol OptionItemClickDelegate <NSObject>

@required
- (void)onItemClick:(ECButton *)menuItem;

@end

@interface ECOptionItemClickDelegate : ECBaseEventDelegate <OptionItemClickDelegate>

-(id)initWithEventConfig:(NSDictionary*)eventConfigDic pageContext:(ECBaseViewController*) pageContext widget:(ECBaseWidget*)widget;

@end
