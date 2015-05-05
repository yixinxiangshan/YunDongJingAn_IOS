//
//  ECGroupItemDelegate.h
//  ECDemoFrameWork
//
//  Created by EC on 10/25/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECBaseEventDelegate.h"

@protocol OnGroupItemClickDelegate <NSObject>

@required
-(void)onClick:(NSString*)groupId position:(NSString*)position;

@end

@interface ECGroupItemClickDelegate : ECBaseEventDelegate <OnGroupItemClickDelegate>

-(id)initWithEventConfig:(NSDictionary*)eventConfigDic pageContext:(ECBaseViewController*) pageContext widget:(ECBaseWidget*)widget;

@end
