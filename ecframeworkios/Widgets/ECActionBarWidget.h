//
//  ECActionBarWidget.h
//  ECDemoFrameWork
//
//  Created by EC on 9/17/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECBaseWidget.h"
#import "ECButton.h"
#import "ECOptionItemClick.h"
#import "ECNavItemClickDelegate.h"
#import "ECCustomItemClickDelegate.h"
#import "KxMenu.h"


#define NOTI_UPDATEACTIONBAR @"updateactionBarfghjklfghjkl5678ikmn"

@interface ECActionBarWidget : ECBaseWidget
/**
 *  homeIcon is  png image with piex 33*33
 */
@property (strong, nonatomic) ECButton* homeButton;
@property (strong, nonatomic) UIView* rightItemView;

/**
 * 设置 ActionBar
 */
- (void) updateActionBar;

/**
 *  delegate
 */
@property (strong, nonatomic) id<OptionItemClickDelegate> optionItemClickDelegate;
@property (strong, nonatomic) id<NavItemClickDelegate> navItemClickDelegate;
@property (strong, nonatomic) id<CustomItemClickDelegate> customItemClickDelegate;

@property (strong, nonatomic) NSMutableDictionary* speEventDelegate;

- (void)setOnOptionItemClickDelegate:(id<OptionItemClickDelegate>)optionItemClickDelegate;
- (void)setOnNavItemClickDelegate:(id<NavItemClickDelegate>)navItemClickDelegate;
- (void)setOnCustomItemClickDelegate:(id<CustomItemClickDelegate>)customItemClickDelegate;


- (void)setOnOptionItemClickDelegate:(id<OptionItemClickDelegate>)optionItemClickDelegate viewId:(NSString *)viewId;
- (void)setOnNavItemClickDelegate:(id<NavItemClickDelegate>)navItemClickDelegate viewId:(NSString *)viewId;
- (void)setOnCustomItemClickDelegate:(id<CustomItemClickDelegate>)customItemClickDelegate viewId:(NSString *)viewId;
@end

