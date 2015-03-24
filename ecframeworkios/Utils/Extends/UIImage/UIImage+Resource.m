//
//  UIImage+Resource.m
//  ECIOSProject
//
//  Created by 程巍巍 on 3/18/14.
//  Copyright (c) 2014 ecloud. All rights reserved.
//

#import "UIImage+Resource.h"
#import "NSStringExtends.h"

@implementation UIImage (Resource)

+ (UIImage *) imageWithPath:(NSString *)path
{
    NSArray *routes = [path componentsSeparatedByString:@"/"];
    
    UIImage *image = [UIImage imageNamed:[routes lastObject]];
    if (!image) {
        image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@%@",[NSString appConfigPath],[path hasPrefix:@"/"] ? @"" : @"/",path]];
    }
    
    return image;
}
@end
