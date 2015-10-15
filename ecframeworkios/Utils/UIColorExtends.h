//
//  UIColorExtends.h
//  ECViews
//
//  Created by Alix on 9/28/12.
//  Copyright (c) 2012 ecloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extends)
/**
 * 16进制 : 如 0xFFFFFF 为白色
 */
+ (UIColor*)colorWithHex:(NSUInteger)hex;
+ (UIColor*)colorWithHex:(NSUInteger)hex alpha:(CGFloat)alpha;


/**
 * 随机颜色
 */
+ (UIColor*)randomColor;
/**
 *  
 */
+ (UIColor *) colorWithName:(NSString *)colorName;
/**
 * 随便颜色
 * @param alpha : 透明度 (0.0~~1.0)
 */
+ (UIColor*)randomColorWithAlpha:(CGFloat)alpha;

/**
 * 字符串 : 如 #FFFFFF 或 #00FFFFFF #RGB #ARGB
 */
+ (UIColor*)colorWithHexString:(NSString*)hexString;
/**
 * 字符串 : 如 #FFFFFF 或 #00FFFFFF #RGB #ARGB 或 图片文件
 */
+ (UIColor*)colorWithString:(NSString*)colorString;
@end
