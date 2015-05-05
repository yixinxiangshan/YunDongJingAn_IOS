//
//  ECRefreshDelegate.h
//  ECDemoFrameWork
//
//  Created by EC on 9/16/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECBaseEventDelegate.h"

@protocol RefreshDelegate <NSObject>

@required
- (void) refresh;

@end
@interface ECRefreshDelegate : ECBaseEventDelegate <RefreshDelegate>
-(id)initWithEventConfig:(NSDictionary*)eventConfigDic pageContext:(ECBaseViewController*) pageContext widget:(ECBaseWidget*)widget;
@end
