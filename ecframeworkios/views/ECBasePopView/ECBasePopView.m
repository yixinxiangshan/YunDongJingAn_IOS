//
//  ECBasePopView.m
//  ECPopViewTest
//
//  Created by 程巍巍 on 4/29/14.
//  Copyright (c) 2014 Littocats. All rights reserved.
//

#import "ECBasePopView.h"

@interface ECBasePopView ()

@property (nonatomic, weak) UIView *activeView;
@end

@implementation ECBasePopView

+ (void)popView:(UIView *)customView fromView:(UIView *)activeView
{
    ECBasePopView *popView = [self shareInstance];
    popView.activeView = activeView;
    [popView defaultInit];
    
    [popView addSubview:customView];
    [popView fadeIn];
}

+ (ECBasePopView *)shareInstance
{
    static ECBasePopView *popView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        popView = [[ECBasePopView alloc] init];
    });
    return popView;
}

#pragma mark- init
- (void)defaultInit
{
    self.alpha = 0.0;
    [self setFrame:[self activeSpace]];
}

//
- (void)fadeIn
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.alpha = 1.0;
                     }];
}
- (void)fadeOut
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         for (UIView *subview in self.subviews) {
                             [subview removeFromSuperview];
                         }
                         [self removeFromSuperview];
                     }];
    
}
//计算弹也的位置
- (CGRect)activeSpace
{
    CGRect activeRect = CGRectZero;
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    CGRect viewRect = [_activeView convertRect:_activeView.frame toView:nil];
    //直接放在下面
    activeRect.origin.x = 0.0;
    activeRect.origin.y = viewRect.origin.y + viewRect.size.height;
    activeRect.size.width = screenBounds.size.width;
    activeRect.size.height = screenBounds.size.height - activeRect.origin.y;
    
    return activeRect;
}

#pragma mark-
- (void)didAddSubview:(UIView *)subview
{
    [super didAddSubview:subview];
    [subview setFrame:self.bounds];
    
}
- (void) willRemoveSubview:(UIView *)subview
{
    [self fadeOut];
}
@end
