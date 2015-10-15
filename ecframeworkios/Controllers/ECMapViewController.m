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

#import "ECMapViewController.h"
#import "ECEventRouter.h"

#define UserAnnotationTitle @"我的位置"

@interface ECMapViewController ()
@property (nonatomic, strong) MKUserLocation* userLocation;
@property CGFloat radius;
@property NSUInteger mkCircleColorHex;
@property (nonatomic, strong) NSDictionary* menuConfig;
@property (nonatomic, strong) UILabel* navigatorMenu;
@property (nonatomic, strong) NSArray* menuDataSource;

@property (strong, nonatomic) NSDictionary* netDataRelevant;
@property (strong, nonatomic) NSDictionary* annotationData;
@property (strong, nonatomic) NSMutableDictionary* annotationTitle;

@property BOOL isUserLocationEnable;
@property (strong, nonatomic) ECMapAnnotation*  userAnnotation;
@property BOOL isStart;
@end

@implementation ECMapViewController
@synthesize mapView;
@synthesize mapAnnotations;
@synthesize radius;
@synthesize mkCircleColorHex;

@synthesize navigatorMenu;
@synthesize menuDataSource;

@synthesize netDataRelevant;
@synthesize annotationData;
@synthesize annotationTitle;
//@synthesize locationManager;

@synthesize isStart;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"initalized...");
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"view did load...");
    
    //Current position
    NSLog(@"request location service. ");
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    
	// Do any additional setup after loading the view, typically from a nib.
    self.channelBarMenuConfig = [self.configs objectForKey:@"channelBar"];
    isStart = NO ;
    self.isUserLocationEnable = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMKCirle:) name:[NSString stringWithFormat:@"updateMKCirle"] object:nil];
    //监听 annotation 加载 动作
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadAnnotations:) name:@"loadAnnotations" object:nil];
    
    [self initMapView];
    [self initChannelBar];
    
    [self showNavigatorMenu:@"全部"];
    
    self.annotationTitle = [NSMutableDictionary new];
    if (self.isUserLocationEnable) {
        [self itemSelectableAtIndex:_channelBar.selectedItemIndex inMenuBar:_channelBar];
    }
}

- (void) defaultRequest{
    self.menuConfig = [self.configs objectForKey:@"menuConfig"];
    NSArray* menuConfigs = [self.menuConfig objectForKey:@"localMenu"];
    
    NSDictionary *defaultMenu = [menuConfigs objectAtIndex:[self.menuConfig[@"defaultMenu"] integerValue]];
    [self showNavigatorMenu:defaultMenu[@"title"]];
    
    NSString* action = [defaultMenu valueForKey:@"action"];
    
    if ([action rangeOfString:@"?"].location != NSNotFound) {
        action = [NSString stringWithFormat:@"%@&requestId=%@",[defaultMenu valueForKey:@"action"],[defaultMenu valueForKey:@"requestId"]];
    }else{
        action = [NSString stringWithFormat:@"%@?requestId=%@",[defaultMenu valueForKey:@"action"],[defaultMenu valueForKey:@"requestId"]];
    }
    NSLog(@"default Req: %@", action);
    [[ECEventRouter shareInstance] doAction:action];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //由于获取用户坐标后，对界面进行了操作，若在 viewdidload 中设置 showUserLocation = YES ,可能造成空指针异常
    mapView.showsUserLocation = YES;
    [mapView selectAnnotation:_userAnnotation animated:YES];
}
//菜单
-(void)showNavigatorMenu:(NSString *)titleString
{
    NSLog(@"Show nav menu...");
    navigatorMenu = [[UILabel alloc] init];
    [navigatorMenu setBackgroundColor:[UIColor clearColor]];
    navigatorMenu.textColor = [UIColor blackColor];
    navigatorMenu.text = titleString;
    [navigatorMenu sizeToFit];
    [navigatorMenu setFrame:CGRectMake(0, 0, navigatorMenu.frame.size.width, 44)];
    
    UIImageView* drop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drop.png"]];
    [drop setFrame:CGRectMake(navigatorMenu.frame.size.width+2, 15, 16, 16)];
    drop.contentMode = UIViewContentModeScaleAspectFit;
    
    UIControl* view = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, navigatorMenu.frame.size.width+16, 44)];
    UITapGestureRecognizer* singleGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navigatorMenuClicked)];
    [view addGestureRecognizer:singleGestureRecognizer];
    
    [view addSubview:navigatorMenu];
    [view addSubview:drop];
    
    self.navigationItem.titleView = view;
}
- (void) navigatorMenuClicked
{
    
    self.menuConfig = [self.configs objectForKey:@"menuConfig"];
    NSMutableArray* menuItems = [NSMutableArray new];
    NSArray* menuConfigs = [self.menuConfig objectForKey:@"localMenu"];
    
    
    for (NSDictionary* config in menuConfigs) {
        
        NSString* action = [config valueForKey:@"action"];
        
        if ([action rangeOfString:@"?"].location != NSNotFound) {
            action = [NSString stringWithFormat:@"%@&requestId=%@",[config valueForKey:@"action"],[config valueForKey:@"requestId"]];
        }else{
            action = [NSString stringWithFormat:@"%@?requestId=%@",[config valueForKey:@"action"],[config valueForKey:@"requestId"]];
        }
        
        [menuItems addObject:[KxMenuItem menuItem:[config valueForKey:@"title"]
                                                  image:nil
                                                 target:self
                                                  param:action
                                                 action:@selector(kxMenuItemClicked:)]];
        
    }
    
    if (menuItems.count == 0) {
        NSLog(@"menuItems's count is zero , reutrn ......");
        return;
    }
    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(0, 0, 320, 0)
                 menuItems:menuItems];
}
-(void)kxMenuItemClicked:(KxMenuItem *)sender
{
    if (!self.isUserLocationEnable) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"获取用户坐标失败，请稍后重试 ！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSLog(@"%@ : sender.params %@",self.class,sender.param);
    [self showNavigatorMenu:sender.title];
    
    [[ECEventRouter shareInstance] doAction:sender.param];
}
//显示 Annotations
-(void) showAnnotations{
    NSArray* annotations = self.mapView.annotations;
    for (id annotation in annotations) {
        if (![annotation isKindOfClass:[MKUserLocation class]]) {
            [self.mapView deselectAnnotation:annotation animated:NO];
            [self.mapView removeAnnotation:annotation];
        }
    }
    [self.mapView selectAnnotation:_userAnnotation animated:NO];
    [self.mapView addAnnotations:self.mapAnnotations];
}
-(void)showAnnotations:(NSDictionary *)params
{
    NSLog(@"%@ : showAnnotation params = %@",self.class,params);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadAnnotations" object:nil userInfo:[params objectForKey:@"urlParams"]];
}
-(void)loadAnnotations:(NSNotification*)noti
{
    NSLog(@"%@ : loadAnnotations params = %@",self.class,noti.userInfo);
    if ([[noti.userInfo valueForKey:@"isDefault"] boolValue]) {
        [self loadAnnotations:nil isDefault:YES];
        return;
    }
    [self loadAnnotations:[noti.userInfo valueForKey:@"requestId"] isDefault:NO];
    
}
-(void)loadAnnotations:(NSString *)requestId isDefault:(BOOL)isDefault
{
    if ((requestId == nil || requestId == NULL) && !isDefault) {
        NSLog(@"requestId is missed......");
        return;
    }
    
    annotationData = [self.configs objectForKey:@"annotationData"];
    //网络请求
    
    NSMutableDictionary* params = [NSMutableDictionary new];
    [params addEntriesFromDictionary:self.params];
    if (isDefault) {
        [params setObject:[annotationData valueForKey:@"id"] forKey:[annotationData valueForKey:@"defaultRequestIdKey"]];
        [params removeObjectForKey:[annotationData valueForKey:@"requestIdKey"]];
        //[params setObject:@"598" forKey:@"sort_ids"];
    }else{
        if (![requestId isEqualToString:@"default"]) {
            //[params setObject:requestId forKey:[annotationData valueForKey:@"requestIdKey"]];
            [params setValue:[requestId isEqualToString:@"0"]?@"":requestId forKey:@"sort_ids"];
        }
    }
    
    [params setObject:[annotationData valueForKey:@"method"] forKey:@"method"];
    [params setObject:[annotationData valueForKey:@"apiversion"] forKey:@"apiversion"];
    
    [params setObject:[NSNumber numberWithInt:0] forKey:@"cacheTime"];
    [params setObject:[NSString stringWithFormat:@"480"] forKey:@"sort_father_ids"];
    
    //[params setValue:[requestId isEqualToString:@"0"]?@"":requestId forKey:@"sort_ids"];
    
    //    [params setObject:[NSNumber numberWithFloat:radius] forKey:@"distance"];
    [params setObject:[NSString stringWithFormat:@"%0.0f",radius] forKey:@"distance"];
    
    [params setObject:[NSNumber numberWithFloat:mapView.userLocation.coordinate.latitude] forKey:@"lat"];
    [params setObject:[NSNumber numberWithFloat:mapView.userLocation.coordinate.longitude] forKey:@"lon"];
    
    [params setObject:[NSString stringWithFormat:@"google"] forKey:@"map_type"];
    [params setObject:[NSNumber numberWithInt:300] forKey:@"page_size"];
    
    NSLog(@"%@ : start load annotations\nparams : %@",self.class,params);
    
    //保存当次请求参数
    self.params = params;
    [[ECNetRequest newInstance] postNetRequest:[NSString stringWithFormat:@"%@.pageString",@"page_map"]
                                        params:params
                                      delegate:self
                              finishedSelector:@selector(requestFindished:)
                                  failSelector:@selector(webRequestFailed:)
                                      useCache:NO];
    [self showLoading:nil];
    
}

- (void)handleRequestData:(NSData*)data{
    [super handleRequestData:data];
    NSDictionary* dataDic = [[NSDictionary alloc] init];
    NSArray* dataArray = [[NSArray alloc] init];
    id tempData = nil;
    //处理数据
    id obj = [ECJsonUtil objectWithJsonData:data];

    NSLog(@"ResponseData : success ");
    NSDictionary* adapter = [annotationData objectForKey:@"dataAdapter"];

    if (obj && [obj isKindOfClass:[NSDictionary class]]) {
        tempData = [obj valueForKey:@"shops"];
    }
    if (tempData && [tempData isKindOfClass:[NSDictionary class]]) {
        dataArray = [self getValue:tempData forKey:[adapter objectForKey:@"listKey"]];

    }else if ([tempData isKindOfClass:[NSArray class]]){
        dataArray = tempData;
    }

    else{

        NSLog(@"数据出错！");
        return;
    }

    {
        if (nil == dataArray) {
            // TODO: 弹出数据出错！
            NSLog(@"数据出错！");
        }
        //        NSLog(@"%@ : 解析数据，获得 annotation from %@",self.class,dataArray);

        [mapAnnotations removeAllObjects];
        for (NSDictionary* dataItem in dataArray) {
            id mainValue = nil ;
            if ([[adapter valueForKey:@"itemKey"] isEqual:@""]) {
                mainValue = dataItem;
            }else{
                mainValue = [dataItem valueForKey:[adapter valueForKey:@"itemKey"]];
            }


            if (mainValue && [mainValue isKindOfClass:[NSArray class]]) {
                //遍历 mainValue 获得地点信息

                for (NSDictionary* value in mainValue) {


                    ECMapAnnotation *annotation = [[ECMapAnnotation alloc] init] ;
                    CLLocationCoordinate2D coords;
                    annotation.coordinate = coords;
                    annotation.title = [self getValue:dataItem forKey:[adapter valueForKey:@"titleKey"]];
                    annotation.subtitle =  [self getValue:value forKey:[adapter valueForKey:@"subTitleKey"]];
                    coords.latitude = [[self getValue:value forKey:[adapter valueForKey:@"latitudeKey"]] floatValue];
                    coords.longitude = [[self getValue:value forKey:[adapter valueForKey:@"longitudeKey"]] floatValue];
                    annotation.coordinate = coords;
                    annotation.tag = [[self getValue:dataItem forKey:[adapter valueForKey:@"tagKey"]] integerValue];
                    annotation.sorts = [self getValue:dataItem forKey:[adapter valueForKey:@"sortKey"]];
                    [self.annotationTitle setObject:annotation.title forKey:[NSString stringWithFormat:@"%i",annotation.tag]];
//                    NSLog(@"%@ Annotation : \ntitle = %@\nsubtitle=%@\nlat=%f\nlog=%f\ntag=%i",self.class,annotation.title,annotation.subtitle,coords.latitude,coords.longitude,annotation.tag);

                    [mapAnnotations addObject:annotation];


                }

            }else if (mainValue && [mainValue isKindOfClass:[NSDictionary class]]){

                NSDictionary* value = mainValue;

                ECMapAnnotation *annotation = [[ECMapAnnotation alloc] init] ;
                CLLocationCoordinate2D coords;
                annotation.coordinate = coords;
                annotation.title = [self getValue:dataItem forKey:[adapter valueForKey:@"titleKey"]];
                annotation.subtitle =  [self getValue:value forKey:[adapter valueForKey:@"subTitleKey"]];
                coords.latitude = [[self getValue:value forKey:[adapter valueForKey:@"latitudeKey"]] floatValue];
                coords.longitude = [[self getValue:value forKey:[adapter valueForKey:@"longitudeKey"]] floatValue];
                annotation.coordinate = coords;
                annotation.tag = [[self getValue:dataItem forKey:[adapter valueForKey:@"tagKey"]] integerValue];
                annotation.sorts = [self getValue:dataItem forKey:[adapter valueForKey:@"sortKey"]];
                [self.annotationTitle setObject:annotation.title forKey:[NSString stringWithFormat:@"%i",annotation.tag]];
//                NSLog(@"%@ Annotation : \ntitle = %@\nsubtitle=%@\nlat=%f\nlog=%f\ntag=%i",self.class,annotation.title,annotation.subtitle,coords.latitude,coords.longitude,annotation.tag);

                [mapAnnotations addObject:annotation];

            }
            else{
                if (nil == dataDic) {
                    // TODO: 弹出数据出错！
                }
            }
        }
        [self showAnnotations];

    }

}


-(void) commandReceiver:(NSDictionary  *)params
{
    NSLog(@"%@ : %@",self.class,params);
    NSString* method = [[params objectForKey:@"urlParams"] valueForKey:@"method"];
    
    if ([method isEqualToString:@"updateMKCirle"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMKCirle" object:nil userInfo:params];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initMapView
{
    NSLog(@"init MapView...，w: %f, h: %f", validWidth(), totalHeight());

    //THERESA: remove action bar
    //mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0,44, validWidth(), validHeight()-49-44)];
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0,44, validWidth(), validHeight()-44)];

    mapView.delegate = self;
    mapView.showsUserLocation = YES ;
    mapAnnotations = [[NSMutableArray alloc] initWithCapacity:10];
    
    [self.view addSubview:mapView];
    
}

-(void)initChannelBar
{
    NSLog(@"init ChannelBar...");

    _channelBar = [[LightMenuBar alloc] initWithFrame:CGRectMake(0, 0, validWidth(), 44) andStyle:LightMenuBarStyleItem];
    
    _channelBar.delegate = self;
    _channelBar.bounces = YES;
    _channelBar.selectedItemIndex = 0;
    
    _channelBar.backgroundColor = [UIColor colorWithRed:0.91 green:0.96 blue:0.91 alpha:1.00];
    [self.view addSubview:_channelBar];
}
-(void)updateMKCirle:(NSNotification *)noti
{
    NSLog(@"%@ : %@",self.class,noti.userInfo);

    NSDictionary* params = [noti.userInfo objectForKey:@"query"];

    radius = [[params valueForKey:@"radius"] floatValue];
    mkCircleColorHex = [[params valueForKey:@"circleColor"] floatValue];


    if (self.userLocation == nil) {
        return;
    }

    [self loadAnnotations:@"default" isDefault:NO];
//    [self loadAnnotations:nil isDefault:YES];

    [self.mapView removeOverlays:[self.mapView overlays]];

    MKCoordinateRegion userRegion = MKCoordinateRegionMakeWithDistance(self.userLocation.coordinate, 2*radius, 2*radius);
//

//    float zoomLevel = 0.1;
//    MKCoordinateRegion userRegion = MKCoordinateRegionMake(self.userLocation.coordinate, MKCoordinateSpanMake(zoomLevel, zoomLevel));

    [self.mapView setRegion:userRegion animated:YES];

    MKCircle *circleTargePlace=[MKCircle circleWithCenterCoordinate:self.userLocation.coordinate radius:radius];

    [self.mapView addOverlay:circleTargePlace];
}

#pragma mapview control method
-(void) gotoPosition:(CLLocationCoordinate2D) centerPosition
{
    float zoomLevel = 0.1;
    MKCoordinateRegion region = MKCoordinateRegionMake(centerPosition, MKCoordinateSpanMake(zoomLevel, zoomLevel));
    //    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.userLocation.coordinate, 2*radius, 2*radius);
    [mapView setRegion:[mapView regionThatFits:region] animated:YES];
}

#pragma mark LightMenuBarDelegate
- (NSUInteger)itemCountInMenuBar:(LightMenuBar *)menuBar {
    return self.channelBarMenuConfig.count;
}

- (NSString *)itemTitleAtIndex:(NSUInteger)index inMenuBar:(LightMenuBar *)menuBar {
    
    return [[self.channelBarMenuConfig objectAtIndex:index] valueForKey:@"title"];
}

- (void)itemSelectedAtIndex:(NSUInteger)index inMenuBar:(LightMenuBar *)menuBar {
    NSLog(@"%@",[NSString stringWithFormat:@"%@ : channel %d Selected", self.class,index]);
    
    NSString* action = [[self.channelBarMenuConfig objectAtIndex:index] valueForKey:@"action"];
    NSLog(@"%@ action : %@",self.class,action);
    [[ECEventRouter shareInstance] doAction:action userInfo:[self.channelBarMenuConfig objectAtIndex:index]];
    
}

//< Optional
- (CGFloat)itemWidthAtIndex:(NSUInteger)index inMenuBar:(LightMenuBar *)menuBar {
    if (self.channelBarMenuConfig.count<=5) {
        //NSLog(@"width: %d", validWidth());
        return (validWidth())/self.channelBarMenuConfig.count;
        
    }else{
        return 64.0;
    }
}
- (UIColor *)colorOfButtonHighlightInMenuBar:(LightMenuBar *)menuBar
{
    return [UIColor colorWithHex:mkCircleColorHex];
}
- (UIColor *)colorOfBackgroundInMenuBar:(LightMenuBar *)menuBar
{
    return [[UIColor colorWithHex:mkCircleColorHex] colorWithAlphaComponent:0.2];
}
#pragma mark Map View Delegate Methods
- (void)showDetails:(UIButton*)sender
{
    //Annotation 按钮事件
    NSLog(@"做你点击时想做的事情 : sender ");
    
    [ECPageUtil openNewPage:@"page_cheerup_info" params:[NSString stringWithFormat:@"{\"info\": %i}", sender.tag]];
//    NSMutableDictionary* params = [NSMutableDictionary new];
//    [params setObject:[NSString stringWithFormat:@"%i" ,sender.tag] forKey:@"requestId"];
//    
//    if (nil == [annotationTitle objectForKey:[NSString stringWithFormat:@"%i",sender.tag]]) {
//        NSLog(@"annotationTitle is nil , return ......\n annotationTitle : %@",annotationTitle);
//        return;
//    }
//    [params setObject:[annotationTitle objectForKey:[NSString stringWithFormat:@"%i",sender.tag]] forKey:@"navTitle"];
//    
//    
//    [[ECEventRouter shareInstance] doAction:[annotationData valueForKey:@"action"] userInfo:params];
}
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    if([overlay isKindOfClass:[MKCircle class]]) {
        // Create the view for the radius overlay.
        MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
        circleView.strokeColor = [UIColor colorWithHex:mkCircleColorHex];
        circleView.fillColor = [[UIColor colorWithHex:mkCircleColorHex] colorWithAlphaComponent:0.2];
        circleView.lineWidth = 1;
        
        
        return circleView;
    }
    
    return nil;
}

- (MKAnnotationView *) mapView:(MKMapView *)theMapView viewForAnnotation:(ECMapAnnotation*) annotation {
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        [annotation setTitle:UserAnnotationTitle];
        _userAnnotation = annotation;
        return nil;
    }
    
    // try to dequeue an existing pin view first
    static NSString* placeAnnotationIdentifier = @"placeAnnotationIdentifier";
    MKPinAnnotationView* pinView ;
    //    = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:placeAnnotationIdentifier];
    if (!pinView)
    {
        // if an existing pin view was not available, create one
        MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc]
                                              initWithAnnotation:annotation reuseIdentifier:placeAnnotationIdentifier];
        customPinView.pinColor = [annotation.sorts containsString:@"985"] ? MKPinAnnotationColorGreen : MKPinAnnotationColorPurple;
        //        customPinView.pinColor = MKPinAnnotationColorGreen;
        customPinView.animatesDrop = YES;
        customPinView.canShowCallout = YES;
        
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        rightButton.tag =  annotation.tag;
        [rightButton addTarget:self
                        action:@selector(showDetails:)
              forControlEvents:UIControlEventTouchUpInside];
        customPinView.rightCalloutAccessoryView = rightButton;
        
        
        return customPinView;
    }
    
    pinView.annotation = annotation;
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    rightButton.tag =  annotation.tag;
    //        NSLog(@"+++++++++ title %@",annotation.title);
    [rightButton addTarget:self
                    action:@selector(showDetails:)
          forControlEvents:UIControlEventTouchUpInside];
    pinView.rightCalloutAccessoryView = rightButton;
    
    return pinView;
    
}
- (void)mapViewDidFailLoadingMap:(MKMapView *)theMapView withError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"地图加载错误"
                          message:[error localizedDescription]
                          delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil];
    [alert show];
}
- (void) mapView:(MKMapView *) mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //NSLog(@"didUpdateUserLocation: lat: %f, lon:%f", self.userLocation.coordinate.latitude, self.userLocation.coordinate.longitude);
    self.userLocation = userLocation;
    
    if (!self.isUserLocationEnable) {
        //        [self loadAnnotations:nil isDefault:YES];
        //加载默认项
        [self defaultRequest];
        self.isUserLocationEnable = !self.isUserLocationEnable;
    }
    
    [self.mapView removeOverlays:[self.mapView overlays]];
    
    MKCoordinateRegion userRegion;
    if (!isStart) {
        userRegion = MKCoordinateRegionMakeWithDistance(self.userLocation.coordinate, 2*radius, 2*radius);
        isStart = !isStart;
    }else{
        userRegion = MKCoordinateRegionMake(self.mapView.region.center, self.mapView.region.span);
    }
    
    [self.mapView setRegion:userRegion animated:YES];
    
    MKCircle *circleTargePlace=[MKCircle circleWithCenterCoordinate:self.userLocation.coordinate radius:radius];
    [self.mapView addOverlay:circleTargePlace];
}
- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"获取用户坐标失败 ！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
