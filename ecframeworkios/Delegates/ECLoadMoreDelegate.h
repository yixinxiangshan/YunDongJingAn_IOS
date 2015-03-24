//
//  ECLoadMoreDelegate.h
//  ECDemoFrameWork
//
//  Created by EC on 9/16/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECBaseEventDelegate.h"

@protocol LoadMoreDelegate <NSObject>

- (void) loadMore:(NSString *)lastID;

@end
@interface ECLoadMoreDelegate : ECBaseEventDelegate <LoadMoreDelegate>
-(id)initWithEventConfig:(NSDictionary*)eventConfigDic pageContext:(ECBaseViewController*) pageContext widget:(ECBaseWidget*)widget;
@end
