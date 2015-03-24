//
//  ECMapUtil.h
//  ECDemoFrameWork
//
//  Created by cheng on 13-12-23.
//  Copyright (c) 2013年 EC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"

@class ECAnnotation;

#define USER_LOCATION_HAS_UPDATED @"USER_LOCATION_HAS_UPDATED"

@interface ECMapUtil : NSObject

@property (strong, nonatomic) BMKMapManager* mapManager;
@property (nonatomic) BOOL isManagerStart;

@property (strong, nonatomic) BMKUserLocation* userLocation;

+ (id) shareInstance;

/**
 *  启动地图管理器
 */
- (void) startBaiduMapManager;

/**
 *  启动地图管理器
 */
- (void) stopBaiduMapManager;

/**
 *  生成BMKPointAnnotation
 */
+ (ECAnnotation *) annotationWith:(NSString *)title subTitle:(NSString *)subTitle coordinate:(CLLocationCoordinate2D)coordinate;
/**
 * CLLocationCoordinate2D
 */
+ (CLLocationCoordinate2D) coordinateWith:(CGFloat)latitude longitude:(CGFloat)longitude;

/**
 *  centerPoint with annotations
 */
+ (CLLocationCoordinate2D) centerPointWith:(NSArray *)annotations;

/**
 *  span with distance and centerPoint(m)
 */
+ (BMKCoordinateSpan) spanWith:(CLLocationCoordinate2D)point distance:(CGFloat)distance;

/**
 *  给定 annotations 最大范围（m）
 */
+ (CGFloat) maxDistanceFor:(NSArray *)annotations;

+ (NSString*)getMyBundlePath:(NSString *)filename;
@end

@interface ECAnnotation : BMKPointAnnotation
@property (nonatomic) NSDictionary* config;
@property (nonatomic) NSInteger position;

- (instancetype) initWith:(NSDictionary *)config;
@end