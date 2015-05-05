//
//  UIView+Size.h
//  ECDemoFrameWork
//
//  Created by EC on 9/6/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Size)

@property (nonatomic, strong, readonly)NSMutableArray* views;

/**
 * 将试图放入另外一个试图
 * @param insertType 放入试图的方式，自适应大小(3)、自适应大小改变父控件大小()、适应父控件的大小(1)
 */
- (void)insertViewToView:(UIView *)view insertType:(int) insertType position:(int)position;
- (void)resetContainerFrame;

@end
