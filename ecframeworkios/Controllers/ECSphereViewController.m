//
//  ViewController.m
//  SphereMenu
//
//  Created by Theresa on 14-8-24.
//  Copyright (c) 2014年 TU YOU. All rights reserved.
//

#import "ECSphereViewController.h"
#import "SphereMenuWidget.h"
#import "Constants.h"
#import "ECPageUtil.h"
#import "ECBaseViewController.h"
#import "ECNewsViewController.h"
#import "ECAppUtil.h"

@interface ECSphereViewController () <SphereMenuDelegate>

@end

@implementation ECSphereViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *hFlag = @"";
    ECLog(@"screen height : %f",[UIScreen mainScreen].bounds.size.height);
    if ([UIScreen mainScreen].bounds.size.height == 568) {
        hFlag = @"-568h";
    }else if([UIScreen mainScreen].bounds.size.height == 667) {
        hFlag = @"-667h";
    }else if([UIScreen mainScreen].bounds.size.height == 736) {
        hFlag = @"-Portrait-736h";
    }else if([UIScreen mainScreen].bounds.size.height == 1024) {
        hFlag = @"-Portrait";
    }else if([UIScreen mainScreen].bounds.size.height == 480) {
        hFlag = @"";
    }
    
    NSString *name = [NSString stringWithFormat:@"background%@", hFlag];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    
    //self.view.backgroundColor = [UIColor colorWithRed:1 green:0.58 blue:0.27 alpha:1];

    UIImage *startImage = [UIImage imageNamed:@"JNAPP_START"];
    UIImage *image1 = [UIImage imageNamed:@"JNAPP_MAP"];
    UIImage *image2 = [UIImage imageNamed:@"JNAPP_COUPON"];
    UIImage *image3 = [UIImage imageNamed:@"JNAPP_SIGNIN"];
    UIImage *image4 = [UIImage imageNamed:@"JNAPP_SHIP"];
    UIImage *image5 = [UIImage imageNamed:@"JNAPP_ME"];
    NSArray *images = @[image1, image2, image3, image4, image5];
    //NSArray *images = @[image1];
    SphereMenu *sphereMenu = [[SphereMenu alloc] initWithStartPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-50)
                                                         startImage:startImage
                                                      submenuImages:images];
    sphereMenu.delegate = self;
    [self.view addSubview:sphereMenu];
}

- (void)viewWillAppear:(BOOL)animated
{
     [self setFullScreen:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self setFullScreen:NO];
}


- (void)setFullScreen:(BOOL)fullScreen
{
     // 状态条
      [UIApplication sharedApplication].statusBarHidden = fullScreen;
      // 导航条
     [self.navigationController setNavigationBarHidden:fullScreen];
      // tabBar的隐藏通过在初始化方法中设置hidesBottomBarWhenPushed属性来实现
}

- (void)sphereDidSelected:(int)index
{
    ECLog(@"sphere %d selected", index);
    //NSString* p = [NSString stringWithFormat:@"{\"id\": %d}", index+1];
    //[ECPageUtil openNewPage:@"page_index_tab" params:[NSString stringWithFormat:@"{\"id\": %d}", index+1]];
    //ECLog(@"sphere params %@", p);
    //[ECPageUtil openNewPage:@"page_index_tab" params:[NSString stringWithFormat:@"%d", index+1]];
    switch(index){
        case TAB_MAP:
            [ECPageUtil openNewPage:@"page_tab_map" params:nil];
            break;
        case TAB_COUPON:
            [ECPageUtil openNewPage:@"page_tab_cheerup" params:nil];
            break;
        case TAB_SIGNUP:
        {
            ECNewsViewController *news = [[ECNewsViewController alloc] init];
            //[ECPageUtil openNewPage:@"page_tab_news" params:nil];
            ECBaseViewController* nowController = [[ECAppUtil shareInstance]getNowController];
            [[nowController navigationController] pushViewController:news animated:YES];
            break;
        }
        case TAB_SHIP:
            [ECPageUtil openNewPage:@"page_tab_send" params:nil];
            break;
        case TAB_ME:
            [ECPageUtil openNewPage:@"page_tab_lesson_list" params:nil];
            break;
        default:
            [ECPageUtil openNewPage:@"page_empty" params:nil];
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
