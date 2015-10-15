//
//  DisplayUtil.h
//  ECFramework
//
//  Created by EC on 2/27/13.
//  Copyright (c) 2013 ecloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
typedef NS_ENUM(NSInteger, UISlippingType) {
    UIEventslippingUp               = 1,
    UIEventslippingDown             = 2,
    UIEventslippingLeft             = 3,
    UIEventslippingRight            = 4,
    
    UIEventslippingLeftUp           = 5,
    UIEventslippingLeftDown         = 6,
    UIEventslippingRightUp          = 7,
    UIEventslippingRightDown        = 8,
};

@interface DisplayUtil : NSObject

CGRect screenBounds();  // 屏幕尺寸
CGFloat validWidth();   // 屏幕宽度
CGFloat validHeight();  // 去除statusBar的高度
CGFloat totalHeight();  // 全部的高度

+ (void)setShadowAndCorlor:(UIView*)view;
+ (NSString *) slippingName:(NSInteger)slippingType;


@end
