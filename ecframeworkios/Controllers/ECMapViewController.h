/*
 Copyright 2012 Yick-Hong Lam
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License. 
 */

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LightMenuBar.h"
#import "LightMenuBarDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "ECMapAnnotation.h"
#import "KxMenu.h"
#import "UIColorExtends.h"
#import "ECBaseViewExtendController.h"
//#import "DisplayUtil.h"
#import "ECViewUtil.h"
#import "Constants.h"
#import "ECJsonUtil.h"
#import "ECPageUtil.h"

@interface ECMapViewController : ECBaseViewExtendController <LightMenuBarDelegate, MKMapViewDelegate, CLLocationManagerDelegate>

//navigatorBar menu
@property (nonatomic, strong) NSArray* navigatorBarMenuConfig;
//channelbar
@property (nonatomic, strong) LightMenuBar* channelBar;
@property (nonatomic, strong) NSArray* channelBarMenuConfig;

//mapview
@property (nonatomic) NSMutableArray *mapAnnotations;

@property (strong, nonatomic)  MKMapView *mapView;

@property (strong, nonatomic)  CLLocationManager *locationManager;

-(void) commandReceiver:(NSDictionary  *)params;


@end
