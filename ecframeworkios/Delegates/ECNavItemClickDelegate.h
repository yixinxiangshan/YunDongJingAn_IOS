//
//  ECNavItemClick.h
//  ECDemoFrameWork
//
//  Created by cww on 13-9-18.
//  Copyright (c) 2013年 EC. All rights reserved.
//

#import "ECBaseEventDelegate.h"
#import "KxMenu.h"

@protocol NavItemClickDelegate <NSObject>

@required
- (void)onItemClick:(KxMenuItem *)item;

@end

@interface ECNavItemClickDelegate : ECBaseEventDelegate <NavItemClickDelegate>
-(id)initWithEventConfig:(NSDictionary*)eventConfigDic pageContext:(ECBaseViewController*) pageContext widget:(ECBaseWidget*)widget;


@end
