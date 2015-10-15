//
//  ECMapAnnotation.m
//  XuHuiTiYuShengHuo
//
//  Created by cww on 13-6-27.
//  Copyright (c) 2013年 EC. All rights reserved.
//

#import "ECMapAnnotation.h"

@implementation ECMapAnnotation
@synthesize image;
@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

- (CLLocationCoordinate2D)coordinate;
{
    
    return coordinate;
}

- (NSString *)title
{
    return title;
}

// optional
- (NSString *)subtitle
{
    return subtitle;
}

@end
