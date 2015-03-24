//
//  UIImage+Resize.m
//  jinganledongtiyu
//
//  Created by cheng on 13-11-21.
//  Copyright (c) 2013年 eCloud. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)
- (UIImage *) fitToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
}

- (UIImage *) fitToWidth:(float)width
{
    float height = width * self.size.height / self.size.width;
    
    return [self fitToSize:CGSizeMake(width, height)];
}

- (UIImage *) fitToHeight:(float)height
{
    float width = height * self.size.width / self.size.height;
    return [self fitToSize:CGSizeMake(width, height)];
}
@end
