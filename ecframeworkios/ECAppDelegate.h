//
//  ECAppDelegate.h
//  ECDemoFrameWork
//
//  Created by EC on 8/27/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ECViewController;
@class ECJSUtil;

@interface ECAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ECViewController *viewController;
@property (nonatomic, strong) ECJSUtil* jsUtil;

+ (ECAppDelegate*) appDelegate;

@end
