//
//  ECTabWidget.m
//  ECDemoFrameWork
//
//  Created by EC on 9/12/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECTabWidget.h"
#import "NSDictionaryExtends.h"
#import "NSStringExtends.h"
#import "Constants.h"
#import "UIView+Size.h"
#import "NSArrayExtends.h"
#import "ECTabBarItem.h"
#import "ECBaseViewController.h"
#import "ECPageUtil.h"
#import <Foundation/Foundation.h>
#import "ECViewUtil.h"
#import "UIColorExtends.h"
#import "UIImage+Color.h"
#import "UIImage+Resource.h"
//#import "ECHostViewController.h"

@implementation ECTabWidget

- (id)initWithConfigDic:(NSDictionary*)configDic pageContext:(ECBaseViewController*)pageContext{
    self = [super initWithConfigDic:configDic pageContext:pageContext];
    if (self.layoutName == nil || [self.layoutName isEmpty]) {
        self.layoutName = @"ECTabWidget";
    }
    if (self.controlId == nil || [self.controlId isEmpty]) {
        self.controlId = @"tab_widget";
    }
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:self.layoutName owner:self options:nil];
        [self setViewId:@"tab_widget"];
        [self addSubview:_containerView];
        [self checkLayout];
        [self addSubview:_tabBar];
        //        ECHostViewController *cvc =  [[ECHostViewController alloc] init];
        //        [self.pageContext addChildViewController:cvc];
        //        for (UIView* tempView in [self views]) {
        //            [tempView addObserver:self forKeyPath:@"frame" options:0 context:NULL];
        //        }
        
    }
    [self parsingConfigDic];
    self.insertType = 1;
    return self;
}

- (void) setdata{
    [super setdata];
    if ([self.dataDic isEmpty]) {
        ECLog(@"error : no data pass to tab widget");
        [self removeFromSuperview];
        return;
    }
    _itemConfigs = [self.dataDic objectForKey:@"tabDataList"];
    
    if([_itemConfigs isEmpty])
        return;
    _viewControllers = [NSMutableArray new];
    for (int i = 0; i<[_itemConfigs count]; i++) {
        [_viewControllers addObject:[NSDictionary new]];
    }
    _items = [NSMutableArray new];
    int i = 0;
    for (NSDictionary* itemDic in _itemConfigs) {
        // item
        ECTabBarItem *item = [[ECTabBarItem alloc] init];
        //title_color 必须为  hex 值：#FFFFFFFF
        UIColor *tabItemTitleColor = itemDic[@"titleColor"] ? [UIColor colorWithHexString:itemDic[@"titleColor"]] : [UIColor blueColor];
        [item setTitleTextAttributes:@{UITextAttributeTextColor:tabItemTitleColor} forState:UIControlStateSelected];
        
        item.title = [itemDic objectForKey:@"title"];
        NSString *iconName = itemDic[@"icon"];
        NSArray *iconNameArr = [iconName componentsSeparatedByString:@"."];
        if (iconNameArr.count >=2) {
            [item setFinishedSelectedImage:[UIImage imageWithPath:[NSString stringWithFormat:@"%@_selected.%@",[iconName substringToIndex:(iconName.length - 1 - [[iconNameArr lastObject] length])],[iconNameArr lastObject]]] withFinishedUnselectedImage:[UIImage imageWithPath:iconName]];
        }
        [item setValue:[itemDic objectForKey:@"tag"] forKey:@"viewId"];
        [item setTag:i];
        [_items addObject:item];
        i++;
    }
    
    // Tab bar
    [_tabBar initWithItems:_items];
    
    UIImage *barBackGroundImage = [self.dataDic[@"barBackgroundImage"] length] ? [UIImage imageWithPath:self.dataDic[@"barBackgroundImage"]] : nil;
    //bar_background_color 必须为  hex 值：#FFFFFFFF
    UIColor *barBackGroundColor = [self.dataDic[@"barBackgroundColor"] length] ? [UIColor colorWithHexString:self.dataDic[@"barBackgroundColor"]] : nil;
    if (barBackGroundColor && !barBackGroundImage) {
        barBackGroundImage = [UIImage imageWithColor:barBackGroundColor size:CGSizeMake(1, 49)];
        
    }else if (!barBackGroundColor && !barBackGroundImage){
        barBackGroundImage = [UIImage imageWithColor:[UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.00] size:CGSizeMake(1, 49)];
    }
    
    if (barBackGroundImage) {
        [_tabBar.tabBar setBackgroundImage:barBackGroundImage];
    }
    // Don't show scroll indicator
    _tabBar.showsHorizontalScrollIndicator = NO;
    _tabBar.infiniTabBarDelegate = self;
    _tabBar.bounces = NO;
    //init with select first item
    [self selectItemWithTag:0];
}

- (void) selectItemWithTag:(NSInteger)tag
{
    [self.tabBar selectItemWithTag:tag];
}

- (void)infiniTabBar:(InfiniTabBar *)tabBar didScrollToTabBarWithTag:(int)tag{
    
}
- (void)infiniTabBar:(InfiniTabBar *)tabBar didSelectItemWithTag:(int)tag{
    id obj = [_viewControllers objectAtIndex:tag];
    ECBaseViewController* ctrl = nil;
    if (![obj isKindOfClass:[NSDictionary class]]) {
        ctrl = (ECBaseViewController*)obj;
        NSArray* viewsToRemove = [_containerView subviews];
        for (UIView *v in viewsToRemove) {
            [v removeFromSuperview];
        }
        [self.pageContext addChildViewController:ctrl];
        [_containerView addSubview:ctrl.view];
    }else{
        NSDictionary* itemDic = [_itemConfigs objectAtIndex:tag];
        NSString* pageName = [itemDic objectForKey:@"fragmentString"];
        ctrl = [ECPageUtil initPage:pageName params:nil parentView:_containerView];
        [_viewControllers insertObject:ctrl atIndex:tag];
    }
    [self checkLayout];
    [ctrl.view setFrame:CGRectMake(0, 0, 320, _containerView.frame.size.height)];
    
}

#pragma mark-
- (void) pageEventWith:(NSString *)eventName
{
    if ([eventName isEqualToString:@"viewDidApper"]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_UPDATEACTIONBAR object:self.pageContext];
    }else if ([eventName isEqualToString:@"viewWillDisappear"]){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateActionBar:) name:NOTI_UPDATEACTIONBAR object:self.pageContext];
    }
}

#pragma mark-
- (void) updateActionBar:(NSNotification *)noti
{
    id obj = [_viewControllers objectAtIndex:self.tabBar.currentTabBarTag];
    ECBaseViewController* ctrl = nil;
    if (![obj isKindOfClass:[NSDictionary class]]) {
        ctrl = (ECBaseViewController*)obj;
        [ctrl updateActionBar];
    }
}
#pragma mark- layout
- (void) checkLayout
{
    CGRect frame = self.pageContext.view.frame;
    if (self.pageContext.navigationController.navigationBarHidden){
        frame.size.height = validHeight() + 20;
    }else{
        frame.size.height = validHeight();
    }
    
    [self.pageContext.view setFrame:frame];
    
    frame = self.frame;
    if (self.pageContext.navigationController.navigationBarHidden) {
        [self setFrame:CGRectMake(0, !ISIOS7 ? 0 : 20, 320, validHeight())];
    }else{
        [self setFrame:CGRectMake(0, 0, 320, validHeight())];
    }
    [_containerView setFrame:CGRectMake(0, 0, 320, validHeight()-49)];
    [_tabBar setFrame:CGRectMake(0.0, validHeight()-49, 320.0, 49.0)];
}

#pragma mark- JSAPI
- (void)itemClick:(NSNumber *)index
{
    [self selectItemWithTag:[index integerValue]];
}
@end
