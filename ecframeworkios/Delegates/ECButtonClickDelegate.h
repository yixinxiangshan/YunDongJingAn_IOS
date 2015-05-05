//
//  ECButtonClickDelegate.h
//  NowMarry
//
//  Created by cheng on 13-12-9.
//  Copyright (c) 2013年 ecloud. All rights reserved.
//

#import "ECBaseEventDelegate.h"
#import "ECButton.h"

@protocol onButtonClickDelegate <NSObject>

@required
- (void)onButtonClick:(ECButton*)button;

@end

@interface ECButtonClickDelegate : ECBaseEventDelegate <onButtonClickDelegate>

-(id)initWithEventConfig:(NSDictionary*)eventConfigDic pageContext:(ECBaseViewController*) pageContext widget:(ECBaseWidget*)widget;

@end
