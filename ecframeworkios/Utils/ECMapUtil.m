//
//  ECMapUtil.m
//  ECDemoFrameWork
//
//  Created by cheng on 13-12-23.
//  Copyright (c) 2013年 EC. All rights reserved.
//

#import "ECMapUtil.h"

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@implementation ECMapUtil

+ (id) shareInstance
{
    static ECMapUtil* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    
    return instance;
}

#pragma mark- startBaiduMapManager
- (void) startBaiduMapManager
{
    if (_isManagerStart) {
        return;
    }
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    self.isManagerStart = [_mapManager start:@"CaE2is7YQp6aOtb8ItqiP7te"  generalDelegate:nil];
    
    if (!_isManagerStart) {
        NSLog(@"manager start failed!");
    }else{
        NSLog(@"Manager start successed	!");
    }
}

- (void)stopBaiduMapManager
{
    self.isManagerStart = !_mapManager.stop;
}

#pragma mark-
+ (ECAnnotation *) annotationWith:(NSString *)title subTitle:(NSString *)subTitle coordinate:(CLLocationCoordinate2D)coordinate
{
    ECAnnotation* pointAnnotation = [[ECAnnotation alloc]init];
    pointAnnotation.coordinate = coordinate;
    pointAnnotation.title = title ? title : subTitle;
    pointAnnotation.subtitle = title ? subTitle : nil;
    
    return pointAnnotation;
}

+ (CLLocationCoordinate2D) coordinateWith:(CGFloat)latitude longitude:(CGFloat)longitude
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = latitude;
    coordinate.longitude = longitude;
    return coordinate;
}
#pragma mark-
- (void) setUserLocation:(BMKUserLocation *)userLocation
{
    _userLocation = userLocation;
    [[NSNotificationCenter defaultCenter] postNotificationName:USER_LOCATION_HAS_UPDATED object:nil];
}

#pragma mark-
+ (CLLocationCoordinate2D) centerPointWith:(NSArray *)annotations
{
    CGFloat n,s,w,e;
    ECAnnotation* annotation = [annotations firstObject];
    n = s = annotation.coordinate.latitude;
    w = e = annotation.coordinate.longitude;
    
    for (BMKPointAnnotation* an in annotations) {
        n = n > an.coordinate.latitude ? n : an.coordinate.latitude;
        s = s < an.coordinate.latitude ? s : an.coordinate.latitude;
        e = e > an.coordinate.longitude ? e : an.coordinate.longitude;
        w = w < an.coordinate.longitude ? w : an.coordinate.longitude;
    }
    
    if (!n || !s || !w || !e) {
        return [[self shareInstance] userLocation].coordinate;
    }
    return [self coordinateWith:(n + s)/2 longitude:(e + w)/2];
}
#pragma mark-
+ (BMKCoordinateSpan) spanWith:(CLLocationCoordinate2D)point distance:(CGFloat)distance
{
    BMKCoordinateSpan span ;
    span.latitudeDelta = distance / 6371004 * 180 / M_1_PI;
    span.longitudeDelta = distance / (6371004 * cosf(point.latitude * M_1_PI / 180)) * 180 / M_1_PI;
    
    return span;
}
#pragma mark-
+ (CGFloat)maxDistanceFor:(NSArray *)annotations
{
    CGFloat n,s,w,e;
    ECAnnotation* annotation = [annotations firstObject];
    n = s = annotation.coordinate.latitude;
    w = e = annotation.coordinate.longitude;
    
    for (ECAnnotation* an in annotations) {
        n = n > an.coordinate.latitude ? n : an.coordinate.latitude;
        s = s < an.coordinate.latitude ? s : an.coordinate.latitude;
        e = e > an.coordinate.longitude ? e : an.coordinate.longitude;
        w = w < an.coordinate.longitude ? w : an.coordinate.longitude;
    }
    CLLocationCoordinate2D centerPoint = [self centerPointWith:annotations];
    
    CGFloat distanceSN = 6371004 * fabsf(n - s) * M_1_PI / 180;
    CGFloat distanceEW = 6371004 * cosf(centerPoint.latitude * M_1_PI / 180) * fabsf(w - e) * M_1_PI / 180;
    
    return distanceEW > distanceSN ? distanceEW : distanceSN;
}

#pragma mark-
+ (NSString*)getMyBundlePath:(NSString *)filename
{
	
	NSBundle * libBundle = MYBUNDLE ;
	if ( libBundle && filename ){
		NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
		return s;
	}
	return nil ;
}

@end

@implementation ECAnnotation
- (instancetype) initWith:(NSDictionary *)config
{
    self = [super init];
    if (self) {
        self.config = config;
    }
    return self;
}

- (void) setConfig:(NSDictionary *)config
{
    _config = config;
    
    self.title = self.config[@"title"];
    self.subtitle = self.config[@"subtitle"];
    self.coordinate = [ECMapUtil coordinateWith:[config[@"latitude"] floatValue] longitude:[config[@"longitude"] floatValue]];
}
@end