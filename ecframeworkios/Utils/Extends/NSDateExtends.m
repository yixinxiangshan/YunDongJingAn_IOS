//
//  NSDateExtends.m
//  IOSExtends
//
//  Created by Alix on 9/24/12.
//  Copyright (c) 2012 ecloud. All rights reserved.
//

#import "NSDateExtends.h"

@implementation NSDate (Extends)
#pragma mark -
- (NSString*)stringWithFormat:(NSString *)fmt{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    if (fmt && [fmt length] < 1) {
        fmt = @"yyyy-MM-dd-HH-mm";
    }
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:fmt];
    return [dateFormatter stringFromDate:self];
}

#pragma mark -
+ (NSDate*)dateFromString:(NSString *)dateDesc formate:(NSString *)fmt{
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    if (fmt == nil || [fmt isEqualToString:@""]) {
        fmt = @"yyyy-MM-dd HH:mm";
    }
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:fmt];
    return [dateFormatter dateFromString:dateDesc];
}

#pragma mark - 
+ (NSDate*)dateWithToday{
    return [[NSDate date] dateAtMidnight];
}

#pragma mark - 
- (NSDate*)dateAtMidnight{
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* dateComponents = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    
    NSDate* midnight = [calendar dateFromComponents:dateComponents];
    return midnight;
}

#pragma mark -
- (NSUInteger)getDate{
    return [[self stringWithFormat:@"yyyyMMdd"] integerValue];
}

#pragma mark -
- (NSUInteger)getYear{
    return [[self stringWithFormat:@"yyyy"] integerValue];
}

#pragma mark - 
- (NSUInteger)getMonth{
    return [[self stringWithFormat:@"MM"] integerValue];
}

#pragma mark - 
- (NSUInteger)getDay{
    return [[self stringWithFormat:@"dd"]integerValue];;
}

#pragma mark - 
- (NSUInteger)getHours{
   return [[self stringWithFormat:@"HH"] integerValue];;
}

#pragma mark - 
- (NSUInteger)getMinutes{
    return [[self stringWithFormat:@"mm"]  integerValue];;
}

#pragma mark - 
- (NSUInteger)getSeconds{
    return [[self stringWithFormat:@"ss"] integerValue];;
}


#pragma mark - 获取分段时间

- (NSString *) sectionTime:(int)section
{
    NSUInteger date = [self getDate];
    NSUInteger hour = [self getHours];
    NSUInteger minute = [self getMinutes];
    
    int timePiece = 60 % section == 0 ? 60/section : 60/section+1;
    minute = (minute/timePiece + 1) * timePiece;
    
    if (minute == 60) {
        minute = 0;
        hour += 1;
    }
    if (hour == 24) {
        hour = 0;
        date += 1;
    }
    
    return  [NSString stringWithFormat:@"%i%@%@",date,hour == 0 ? @"00" : [NSString stringWithFormat:@"%lu",(unsigned long)hour],minute == 0 ? @"00" : [NSString stringWithFormat:@"%lu",(unsigned long)minute]];
}
@end
