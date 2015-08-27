//
//  ECAppDelegate.m
//  ECDemoFrameWork
//
//  Created by EC on 8/27/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECAppDelegate.h"
#import "Constants.h"
//#import "ECViewController.h"
#import "ECDownloadRequest.h"
#import "NSStringExtends.h"
#import "ZipArchive.h"
#import "ECJSUtil.h"
#import "ECJsonUtil.h"
#import "ECPageUtil.h"
#import "ECViewUtil.h"
#import "ECNetUtil.h"
#import "ECAppUtil.h"
#import "ECDebugViewController.h"
#import "CoreData+MagicalRecord.h"
#import "APService.h"
#import  <TestinAgent/TestinAgent.h>
#import <PgySDK/PgyManager.h>
#import "ECSphereViewController.h"

@interface ECAppDelegate ()
@property (nonatomic, strong) NSString* appConfig;
@end

@implementation ECAppDelegate

//- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
//{
//    [MagicalRecord setupCoreDataStackWithStoreNamed:@"DataCache.sqlite"];
//}
- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    [MagicalRecord cleanUp];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[PgyManager sharedPgyManager] startManagerWithAppId:@"f6b8259acd094e1fc1ca2a995a52cc4c"];//蒲公英
    [TestinAgent init:@"a5bab9a07e9f73ff28d50db79a6d3e50" channel:@"test20150320"];
    //    ECLog(@"TestinAgent init");
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"DataCache.sqlite"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _jsUtil = [ECJSUtil shareInstance];
    // Override point for customization after application launch.
    if (EC_DEBUG_ON) {
        if (!CONFIG_URL) {
            _window.rootViewController = [[ECDebugViewController alloc] init];
        }else{
            [self downloadConfig];
        }
    }else{
        [self startApp];
    }
    //    self.viewController = [[ECViewController alloc] initWithNibName:@"ECViewController" bundle:nil];
    //    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    //极光推送 Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    [    APService setTags:nil alias:@"test" callbackSelector:nil object:nil];//测试
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
    
    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //    return [ShareSDK handleOpenURL:url
    //                 sourceApplication:sourceApplication
    //                        annotation:annotation
    //                        wxDelegate:self];
    //    return [ShareSDK handleOpenURL:url
    //                        wxDelegate:self];
    return YES;
}

- (void)downloadConfig{
    ECLog(@"config url : %@",CONFIG_URL);
    [[ECDownloadRequest newInstance:CONFIG_URL] postDownloadRequest:@"test.download"
                                                           delegate:self
                                                      startSelector:@selector(downloadstarted:)
                                                    processSelector:@selector(downloadProcess:)
                                                   finishedSelector:@selector(downloadFinished:)
                                                       failSelecotr:@selector(downloadFailed:)
                                                           fileName:@"config.zip" ];
}
-(void)downloadstarted:(NSNotification*) noti{
    ECLog(@"downloadstarted ");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:noti.name object:nil];
}
-(void)downloadProcess:(NSNotification*) noti{
    //float process = [(NSNumber*)[noti.userInfo objectForKey:@"process"] floatValue];
    //ECLog(@"downloadProcess : %f" , process);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:noti.name object:nil];
}
-(void)downloadFinished:(NSNotification*) noti{
    ECLog(@"downloadFinished : %@",[noti.userInfo objectForKey:@"filePath"]);
    NSString *filepath = [noti.userInfo objectForKey:@"filePath"];
    ZipArchive* zipArchive = [[ZipArchive alloc] init];
    if ([zipArchive UnzipOpenFile:filepath]) {
        BOOL ret = [zipArchive UnzipFileTo:[NSString stringWithFormat:@"%@",[NSString appLibraryPath]] overWrite: YES];
        if (YES == ret) {
            [zipArchive UnzipCloseFile];
            [self startApp];
        }else{
            NSLog(@"can not unarchive zip ");
        }
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:noti.name object:nil];
}
-(void)downloadFailed:(NSNotification*) noti{
    ECLog(@"downloadFailed XXXX ");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:noti.name object:nil];
}

- (void)loadJSLibrary{
    NSString* js = nil;
    [_jsUtil runJS:[NSString stringWithFormat:@"var _lang='%@';",[[NSLocale preferredLanguages] objectAtIndex:0]]];
    
    js = [[NSString alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/javascript/all_ios.js",[NSString appConfigPath]] encoding:NSUTF8StringEncoding error:NULL];
    
    //NSLog(@"app config path %@", [NSString appConfigPath]);
    
    _appConfig = [[NSString alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/javascript/appconfig.json",[NSString appConfigPath]] encoding:NSUTF8StringEncoding error:NULL];
    
    [_jsUtil runJS:js];
}

-(void) genInit{
    //if (EC_DEBUG_ON) {
    if(YES){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"showGuidanceView"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSString *showGuidanceView = [[NSUserDefaults standardUserDefaults] objectForKey:@"showGuidanceView"];
    
    if (![showGuidanceView isEqualToString:@"showGuidanceView"]) {
        //欢迎界面
        [[NSUserDefaults standardUserDefaults] setObject:@"showGuidanceView" forKey:@"showGuidanceView"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [scrollView setContentSize:scrollView.frame.size];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        //[self.view addSubview:scrollView];
        
        NSString *hFlag = @"";
        ECLog(@"screen height : %f",[UIScreen mainScreen].bounds.size.height);
        if ([UIScreen mainScreen].bounds.size.height == 568) {
            hFlag = @"-568h";
        }
        if ([UIScreen mainScreen].bounds.size.height == 736) {
            hFlag = @"-736h";
        }
        
        int imageCount = 0;
        while (YES) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Default%i%@",imageCount,hFlag]];
            if (!image) {
                break;
            }
            imageCount ++;
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            [imageView setCenter:CGPointMake(scrollView.frame.size.width * ((float)imageCount - 0.5), scrollView.frame.size.height/2)];
            
            [scrollView addSubview:imageView];
        }
        [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width * imageCount, scrollView.frame.size.height)];
        
        UIButton *button = [[UIButton alloc] init];
        [button.titleLabel setFont:[UIFont systemFontOfSize:19]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(0, 0, 300, 44)];
        [button setCenter:CGPointMake(scrollView.frame.size.width * ((float)imageCount - 0.5), scrollView.frame.size.height - 44)];
        
        [button setTitle:@"开始使用" forState:UIControlStateNormal];
        UIImage *rightArrowImage = [UIImage imageNamed:@"right_arrow.png"];
        [button setImage:rightArrowImage forState:UIControlStateNormal];
        
        if (ISIOS7) {
            [button setTintColor:[UIColor whiteColor]];
        }
        //布局 title image
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, - rightArrowImage.size.width, 0, rightArrowImage.size.width + 5 )];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, button.titleLabel.frame.size.width, 0, - button.titleLabel.frame.size.width - 5)];
        
        //[button setBackgroundColor:[UIColor redColor]];
        
        [scrollView addSubview:button];
        
        [button addTarget:self action:@selector(startApp1) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self startApp];
    }
}

-(void) startApp1{
    //初始化 shareSDK
    //    [ECShareUtils initializeShareSDK];
    
    //启动程序
    [self loadJSLibrary];
    if (!_appConfig) {
        ECLog(@"下载配置文件失败");
        exit(0);
    }
    NSDictionary* appConfigDic = [ECJsonUtil objectWithJsonString:_appConfig];
    //NSLog(@"_appConfig : \n%@",_appConfig);
    //TODO:获取Token
    //TODO:检测更新
    //TODO:开启推送
    //开启引导界面
    
    
    NSString* indexPage = [appConfigDic objectForKey:@"start_controller"];
    NSLog(@"indexPage : \n%@",indexPage);
    if ([indexPage isEmpty]) {
        ECLog(@"配置文件没有指定引导界面");
        exit(0);
    }
    [ECPageUtil openNewPage:indexPage params:nil];
    //[ECPageUtil openNewPageWithFinishedOthers:indexPage params:nil];
}


-(void) startApp{
    //初始化 shareSDK
    //    [ECShareUtils initializeShareSDK];
    
    //启动程序
    [self loadJSLibrary];
    if (!_appConfig) {
        ECLog(@"下载配置文件失败");
        exit(0);
    }
    NSDictionary* appConfigDic = [ECJsonUtil objectWithJsonString:_appConfig];
    //NSLog(@"_appConfig : \n%@",_appConfig);
    //TODO:获取Token
    //TODO:检测更新
    //TODO:开启推送
    //开启引导界面
    
    
    NSString* indexPage = [appConfigDic objectForKey:@"start_controller"];
    NSLog(@"indexPage : \n%@",indexPage);
    if ([indexPage isEmpty]) {
        ECLog(@"配置文件没有指定引导界面");
        exit(0);
    }
    //[ECPageUtil openNewPage:indexPage params:nil];
    [[[ECAppUtil shareInstance] controllers] removeAllObjects];
    
    ECSphereViewController* rootViewController = [[ECSphereViewController alloc] init];
    
    //设置为启动界面
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [ECAppDelegate appDelegate].window.rootViewController = navController;
    [[ECAppDelegate appDelegate].window makeKeyAndVisible];
    
    //[ECPageUtil openNewPageWithFinishedOthers:indexPage params:nil];
}

// 激光推送方法 start
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    ECLog(@"didRegisterForRemoteNotificationsWithDeviceToken : %@",deviceToken);
    // Required
    [APService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required
    [APService handleRemoteNotification:userInfo];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
// 激光推送方法 end

+ (ECAppDelegate*) appDelegate{
    return (ECAppDelegate*)[[UIApplication sharedApplication] delegate];
}

@end
