//
//  UIColorExtends.m
//  ECViews
//
//  Created by Alix on 9/28/12.
//  Copyright (c) 2012 ecloud. All rights reserved.
//

#import "UIColorExtends.h"

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
    char *p;
    NSUInteger hexValue = strtoul([colorString cStringUsingEncoding:NSUTF8StringEncoding], &p, 16);
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
//            red   = [self colorComponentFrom: colorString start:0 length: 1];
//            green = [self colorComponentFrom: colorString start: 1 length: 1];
//            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            red = ((hexValue & 0xf00) >> 8) / 255.0;
            green = ((hexValue & 0xf0) >> 4) / 255.0;
            blue = (hexValue & 0xf) / 255.0;
            break;
        case 4: // #ARGB
//            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
//            red   = [self colorComponentFrom: colorString start: 1 length: 1];
//            green = [self colorComponentFrom: colorString start: 2 length: 1];
//            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            alpha = ((hexValue & 0xf000) >> 12) / 255.0;
            red = ((hexValue & 0xf00) >> 8) / 255.0;
            green = ((hexValue & 0xf0) >> 4) / 255.0;
            blue = (hexValue & 0xf) / 255.0;
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
//            red   = [self colorComponentFrom: colorString start: 0 length: 2];
//            green = [self colorComponentFrom: colorString start: 2 length: 2];
//            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            red = ((hexValue & 0xff0000) >> 16) / 255.0;
            green = ((hexValue & 0xff00) >> 8) / 255.0;
            blue = (hexValue & 0xff) / 255.0;
            break;
        case 8: // #AARRGGBB
//            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
//            red   = [self colorComponentFrom: colorString start: 2 length: 2];
//            green = [self colorComponentFrom: colorString start: 4 length: 2];
//            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            alpha = ((hexValue & 0xff000000) >> 24) / 255.0;
            red = ((hexValue & 0xff0000) >> 16) / 255.0;
            green = ((hexValue & 0xff00) >> 8) / 255.0;
            blue = (hexValue & 0xff) / 255.0;
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
        return [UIColor colorWithPatternImage:[UIImage imageNamed:colorString]];
    }
    return [UIColor whiteColor];
}

+ (UIColor *) colorWithName:(NSString *)colorName
{
    if ([colorName isEqualToString:@"red"]) return [UIColor redColor];
    if ([colorName isEqualToString:@"blue"]) return [UIColor blueColor];
    if ([colorName isEqualToString:@"yellow"]) return [UIColor yellowColor];
    if ([colorName isEqualToString:@"darkgray"]) return [UIColor darkGrayColor];
    if ([colorName isEqualToString:@"lightgray"]) return [UIColor lightGrayColor];
    if ([colorName isEqualToString:@"white"]) return [UIColor whiteColor];
    if ([colorName isEqualToString:@"gray"]) return [UIColor grayColor];
    if ([colorName isEqualToString:@"cyan"]) return [UIColor cyanColor];
    if ([colorName isEqualToString:@"magenta"]) return [UIColor magentaColor];
    if ([colorName isEqualToString:@"orange"]) return [UIColor orangeColor];
    if ([colorName isEqualToString:@"purple"]) return [UIColor purpleColor];
    if ([colorName isEqualToString:@"brown"]) return [UIColor brownColor];
    if ([colorName isEqualToString:@"green"]) return [UIColor greenColor];
    if ([colorName isEqualToString:@"clear"]) return [UIColor clearColor];
    if ([colorName isEqualToString:@"black"]) return [UIColor blackColor];
    
    return [UIColor colorWithString:colorName];
}
@end
