//
//  UIImage+color.m
//  UINavigationControllerDemo
//
//  Created by cheng on 13-10-17.
//  Copyright (c) 2013年 ecloud. All rights reserved.
//

#import "UIImage+Color.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import <math.h>

@implementation UIImage (Color)
+(UIImage *) imageWithColor:(UIColor *)color
{
    return [UIImage imageWithColor:color size:CGSizeMake(1, 1)];
    
}
+(UIImage *) imageWithColor:(UIColor *)color size:(CGSize)size
{
    return [UIImage imageWithColor:color size:size boundColor:nil roundConerRadius:0];
}
+(UIImage *) imageWithColor:(UIColor *)color size:(CGSize)size roundConerRadius:(NSInteger)radius
{
    return [UIImage imageWithColor:color size:size boundColor:nil roundConerRadius:radius];
}
+(UIImage *) imageWithColor:(UIColor *)color size:(CGSize)size boundColor:(UIColor *)boundColor
{
    return [UIImage imageWithColor:color size:size boundColor:boundColor roundConerRadius:0];
}
+(UIImage *) imageWithColor:(UIColor *)color size:(CGSize)size boundColor:(UIColor *)boundColor roundConerRadius:(CGFloat)radius
{
    if (!boundColor) {
        boundColor = color;
    }
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);//填充颜色
    CGContextSetStrokeColorWithColor(context, boundColor.CGColor);//线框颜色
    /*画圆角矩形*/
    CGContextSetLineWidth(context, 2.0);//线的宽度
    
    CGContextMoveToPoint(context, size.width, size.height-2*radius);  // 开始坐标右边开始
    CGContextAddArcToPoint(context, size.width, size.height, size.width-2*radius, size.height, radius);  // 右下角角度
    CGContextAddArcToPoint(context, 0, size.height, 0, size.height-2*radius, radius); // 左下角角度
    CGContextAddArcToPoint(context, 0, 0, size.width-2*radius, 0, radius); // 左上角
    CGContextAddArcToPoint(context, size.width, 0, size.width, size.height-2*radius, radius); // 右上角
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
    
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
@implementation UIImage (wiRoundedRectImage)

+ (UIImage *)createRoundedRectImage:(UIImage*)image radius:(NSInteger)radius
{
    CGSize size = image.size;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor colorWithPatternImage:image].CGColor);//填充颜色
    
    /*画圆角矩形*/
    CGContextSetLineWidth(context, 2.0);//线的宽度
    
    CGContextMoveToPoint(context, size.width, size.height-2*radius);  // 开始坐标右边开始
    CGContextAddArcToPoint(context, size.width, size.height, size.width-2*radius, size.height, radius);  // 右下角角度
    CGContextAddArcToPoint(context, 0, size.height, 0, size.height-2*radius, radius); // 左下角角度
    CGContextAddArcToPoint(context, 0, 0, size.width-2*radius, 0, radius); // 左上角
    CGContextAddArcToPoint(context, size.width, 0, size.width, size.height-2*radius, radius); // 右上角
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end