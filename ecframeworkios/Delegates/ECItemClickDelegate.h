//
//  ECItemClickDelegate.h
//  ECDemoFrameWork
//
//  Created by EC on 9/16/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECBaseEventDelegate.h"

@protocol OnItemClickDelegate <NSObject>

@required
- (void)onItemClick:(NSString *)itemID;

@end
@interface ECItemClickDelegate : ECBaseEventDelegate <OnItemClickDelegate>
-(id)initWithEventConfig:(NSDictionary*)eventConfigDic pageContext:(ECBaseViewController*) pageContext widget:(ECBaseWidget*)widget;
@end
