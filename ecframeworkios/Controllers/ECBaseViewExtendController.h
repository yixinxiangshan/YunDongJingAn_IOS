//
//  ECBaseViewExtendController.h
//  XuHuiTiYuShengHuo
//
//  Created by cww on 13-7-3.
//  Copyright (c) 2013年 EC. All rights reserved.
//

#import "BaseViewController.h"
#import "ECEventRouter.h"
#import "KxMenu.h"

@interface ECBaseViewExtendController : BaseViewController

@property BOOL buttonEnable;

- (void)setNavigatorMenu;
-(void) setNavigatorMenu:(NSArray *)menuDataFromServer;
-(void) doAction:(NSString *)action;
-(id)getValue:(NSDictionary *)data forKey:(NSString *)key;
@end
