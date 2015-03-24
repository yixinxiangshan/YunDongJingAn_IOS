//
//  ECClickDelegate.h
//  ECDemoFrameWork
//
//  Created by EC on 9/11/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECBaseEventDelegate.h"

@protocol OnClickDelegate <NSObject>

@required
- (void)onClick:(UIView*)view;

@end

@interface ECClickDelegate : ECBaseEventDelegate <OnClickDelegate>

-(id)initWithEventConfig:(NSDictionary*)eventConfigDic pageContext:(ECBaseViewController*) pageContext widget:(ECBaseWidget*)widget;

@end
