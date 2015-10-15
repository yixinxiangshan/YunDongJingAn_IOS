//
//  ECMapAnnotation.h
//  XuHuiTiYuShengHuo
//
//  Created by cww on 13-6-27.
//  Copyright (c) 2013年 EC. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface ECMapAnnotation : NSObject<MKAnnotation>
{
    UIImage *image;
    NSNumber *latitude;
    NSNumber *longitude;
    
    NSString *title;
    NSString *subtitle;
}

@property (nonatomic) UIImage *image;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic)  NSString *title;
@property (nonatomic) NSString *subtitle;

@property (nonatomic) NSInteger tag;
@property (nonatomic) NSString* sorts;
@property (nonatomic) NSInteger position;
@end
