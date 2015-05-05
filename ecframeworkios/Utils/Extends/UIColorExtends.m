//
//  UIColorExtends.m
//  ECViews
//
//  Created by Alix on 9/28/12.
//  Copyright (c) 2012 ecloud. All rights reserved.
//

#import "UIColorExtends.h"
#import "UIImage+Resource.h"
#import <objc/message.h>

@implementation UIColor (Extends)
#pragma mark -
+ (UIColor*)colorWithHex:(NSUInteger)hex{
    return [self colorWithHex:hex alpha:1.0f];
}
#pragma mark - 
+ (UIColor*)colorWithHex:(NSUInteger)hex alpha:(CGFloat)alpha{
    
    if (alpha < 0) {
        alpha = .0f;
    } else if(alpha > 1.){
        alpha = 1.f;
    }
    
    int red = (hex&0xFF0000) >> 16;
    int green = (hex&0xFF00) >> 8;
    int blue = hex & 0xFF;
    
    return [self colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:alpha];
}

#pragma mark - 
+ (UIColor*)randomColor{
    return [self randomColorWithAlpha:1.0f];
}

#pragma mark - 
+ (UIColor*)randomColorWithAlpha:(CGFloat)alpha{
    if (alpha < 0) {
        alpha = .0f;
    } else if(alpha > 1.){
        alpha = 1.f;
    }
    CGFloat randomRed = ((CGFloat)(arc4random_uniform(UINT32_MAX) / UINT32_MAX));
    CGFloat randomGreen = ((CGFloat)(arc4random_uniform(UINT32_MAX) / UINT32_MAX));
    CGFloat randomBlue = ((CGFloat)(arc4random_uniform(UINT32_MAX) / UINT32_MAX));
    
    return [UIColor colorWithRed:randomRed green:randomBlue blue:randomGreen alpha:alpha];
}

+ (UIColor*)colorWithHexString:(NSString*)hexString{
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start:0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}
+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

+ (UIColor*)colorWithString:(NSString*)colorString{
    
    if ([colorString hasPrefix:@"#"]) {
        return [UIColor colorWithHexString:colorString];
    }else if([colorString hasSuffix:@"png"] || [colorString hasSuffix:@"jpg"] ){
        return [UIColor colorWithPatternImage:[UIImage imageWithPath:colorString]];
    }
    return [UIColor whiteColor];
}

+ (UIColor *) colorWithScript:(NSString *)script
{
    if (!script) {
        return [UIColor whiteColor];
    }
    SEL selector = NSSelectorFromString([script stringByAppendingString:@"Color"]);
    if ([UIColor respondsToSelector:selector]) {
        return  objc_msgSend([UIColor class], selector);
    }
    
    return [UIColor colorWithString:script];
}
@end
