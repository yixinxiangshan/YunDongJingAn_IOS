//
//  ECImageUtil.m
//  ECDemoFrameWork
//
//  Created by EC on 9/10/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECImageUtil.h"
#import "Constants.h"
#import "NSStringExtends.h"

@implementation ECImageUtil

+ (NSString*)getImageWholeUrl:(NSString*)imageName{
    if ([imageName isEmpty]) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@/%@",BASE_URL_IMAGE,imageName];
}

+ (NSString*)getFitImageWholeUrl:(NSString*)imageName{
    if ([imageName isEmpty]) 
        return nil;
    NSString* imageType = [imageName pathExtension];
    NSString* imagePureName = [imageName stringByDeletingPathExtension];
    if([imageType isEmpty] || (![imageType isEqualToString:@"jpg"] && ![imageType isEqualToString:@"png"])){
        return nil;
    }
    return [self getImageWholeUrl:[NSString stringWithFormat:@"%@_1080.%@",imagePureName,imageType]];
}

+ (NSString*)getSImageWholeUrl:(NSString*)imageName{
    if ([imageName isEmpty])
        return nil;
    NSString* imageType = [imageName pathExtension];
    NSString* imagePureName = [imageName stringByDeletingPathExtension];
    if([imageType isEmpty] || (![imageType isEqualToString:@"jpg"] && ![imageType isEqualToString:@"png"])){
        return nil;
    }
    return [self getImageWholeUrl:[NSString stringWithFormat:@"%@_600.%@",imagePureName,imageType]];
}


+ (UIImage *) imageWithUIColor:(UIColor *)color
{
    return [self imageWithUIColor:color size:CGSizeMake(1.0f, 1.0f)];
}
+ (UIImage *) imageWithUIColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect=CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
