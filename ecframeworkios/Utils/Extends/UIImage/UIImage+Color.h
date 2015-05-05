//
//  UIImage+color.h
//  UINavigationControllerDemo
//
//  Created by cheng on 13-10-17.
//  Copyright (c) 2013年 ecloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (Color)
+(UIImage *) imageWithColor:(UIColor *)color;
+(UIImage *) imageWithColor:(UIColor *)color size:(CGSize)size;
+(UIImage *) imageWithColor:(UIColor *)color size:(CGSize)size roundConerRadius:(NSInteger)radius;
+(UIImage *) imageWithColor:(UIColor *)color size:(CGSize)size boundColor:(UIColor *)boundColor ;
+(UIImage *) imageWithColor:(UIColor *)color size:(CGSize)size boundColor:(UIColor *)boundColor roundConerRadius:(CGFloat)radius;
@end
@interface UIImage (wiRoundedRectImage)
+ (UIImage *)createRoundedRectImage:(UIImage*)image radius:(NSInteger)r;
@end