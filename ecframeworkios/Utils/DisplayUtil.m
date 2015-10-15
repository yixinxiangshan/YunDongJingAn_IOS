//
//  DisplayUtil.m
//  ECFramework
//
//  Created by EC on 2/27/13.
//  Copyright (c) 2013 ecloud. All rights reserved.
//

#import "DisplayUtil.h"
#import "UMNavigationController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColorExtends.h"

@implementation DisplayUtil

// 屏幕尺寸
CGRect screenBounds(){
    return [UIScreen mainScreen].bounds;
}
// 屏幕宽度
CGFloat validWidth(){
    return [UIScreen mainScreen].bounds.size.width;
}
// 去除statusBar的高度 或 及导航条的高度
CGFloat validHeight(){
    UMNavigationController* ctrl = (UMNavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    //NSLog(@"valid height: %f", height);
    NSLog(@"nav : %hhd, status: %hhd", [UIApplication sharedApplication].statusBarHidden, ctrl.navigationBarHidden);
    if (NO == [UIApplication sharedApplication].statusBarHidden) {

        CGRect frame = [UIApplication sharedApplication].statusBarFrame;
        height -= CGRectGetHeight(frame);
    }
    if(NO == ctrl.navigationBarHidden){
        CGFloat navHeight = ctrl.navigationBar.frame.size.height;
        height -= navHeight;
    }
    
    return height;
}

// 整个屏幕的高度
CGFloat totalHeight(){
    return [UIScreen mainScreen].bounds.size.height;
}

+ (void)setShadowAndCorlor:(UIView*)view{
    //设置圆角
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 6.0f;
    
//    //设置阴影，无效
//    view.layer.shadowColor = [UIColor blackColor].CGColor;
//    view.layer.shadowOffset = CGSizeMake(2, -3);
//    view.layer.shadowOpacity = 1;
//    view.layer.shadowRadius = 5.0;
    
    //设置 边框
    view.layer.borderColor = [UIColor colorWithHexString:@"#7C7C7C"].CGColor;
    view.layer.borderWidth = 0.5;
    
}

+ (NSString *) slippingName:(NSInteger)slippingType
{
    switch (slippingType) {
        case UIEventslippingUp:
            return @"nUIEventslippingUp";
        case UIEventslippingDown:
            return @"nUIEventslippingDown";
        case UIEventslippingLeft:
            return @"nUIEventslippingLeft";
        case UIEventslippingRight:
            return @"nUIEventslippingRight";
    }
    return @"nUIEventslippingDefault";
}
@end
