//
//  ECImageExtends.h
//  ECDemoFrameWork
//
//  Created by cheng on 13-12-26.
//  Copyright (c) 2013年 EC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (extends)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;

- (UIImage *) imageFromView:(UIView *)view;
@end
