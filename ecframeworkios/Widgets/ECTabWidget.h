//
//  ECTabWidget.h
//  ECDemoFrameWork
//
//  Created by EC on 9/12/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECBaseWidget.h"
#import "InfiniTabBar.h"

@interface ECTabWidget : ECBaseWidget <InfiniTabBarDelegate>

@property (nonatomic, strong)IBOutlet InfiniTabBar *tabBar;
@property (nonatomic, strong)IBOutlet UIView* containerView;
@property (nonatomic, strong) NSMutableArray* viewControllers;
@property (nonatomic, strong) NSMutableArray* items;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSArray* itemConfigs;

- (id)initWithConfigDic:(NSDictionary*)configDic pageContext:(ECBaseViewController*)pageContext;

- (void) selectItemWithTag:(NSInteger)tag;
@end
