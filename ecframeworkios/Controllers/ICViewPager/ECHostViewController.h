//
//  ECHostViewController.h
//  IOSProjectTemplate
//
//  Created by Zongzhan on 10/29/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "ViewPagerController.h"

@protocol ContentDelegate

-(UIViewController *) getContentView:(NSUInteger)index;
-(void) didChangeTabToIndex:(NSUInteger)index;

@end




@interface ECHostViewController : ViewPagerController

@property (assign,nonatomic) id<ContentDelegate> contentDelegate;

-(id) initPagers:(NSInteger )pageCount;
@end
