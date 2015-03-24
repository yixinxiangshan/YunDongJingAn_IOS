//
//  ListViewCellDatePicker.m
//  IOSProjectTemplate
//
//  Created by Zongzhan on 11/5/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import "ListViewCellDatePicker.h"
#import "ECBaseViewController.h"

@implementation ListViewCellDatePicker

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];
    }
    return self;
}

- (void)awakeFromNib
{
    
}

- (void)setData:(NSDictionary *)data
{
    [super setData:data];
    
    // 当前时间
    NSDate *dateNow =  [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *comps  = [calendar components:unitFlags fromDate:dateNow];
    int year = [comps year];
    int month = [comps month];
    int day = [comps day];
    
    // 计算初始化时间
    NSDateFormatter *mmddccyy = [[NSDateFormatter alloc] init];
    mmddccyy.timeStyle = NSDateFormatterNoStyle;
    mmddccyy.dateFormat = @"MM/dd/yyyy";
    if ([self.data[@"year"] length] > 0)
        year = [self.data[@"year"] intValue];
    if ([self.data[@"month"] length] > 0)
        month = [self.data[@"month"] intValue];
    if ([self.data[@"day"] length] > 0)
        day = [self.data[@"day"] intValue];

    NSDate *setDate = [mmddccyy dateFromString:[NSString stringWithFormat:@"%i/%i/%i" , month ,day,year] ];
    [self.picker setDate:setDate];
    [self.picker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    // 设置默认值
    [self.parent.pageContext dispatchJSEvetn:[NSString stringWithFormat:@"%@.%@",self.parent.controlId,@"onChange"]
                                  withParams:@{@"position":[NSNumber numberWithInteger:self.position],@"target":@"datePicker" , @"value":[NSString stringWithFormat:@"%i-%i-%i" ,year , month , day ]}];
}



+ (CGFloat)heightForData:(NSDictionary *)data
{
    //    使用xib的时候尽量用 autolayout
    return 180;
}

// 右边按钮被点击
-(void)onDatePickerValueChanged:(id)sender
{
    NSString *actionType = @"datePicker";
    NSDate *select = [sender date];
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    selectDateFormatter.dateFormat = @"YYYY-MM-dd"; // 设置时间和日期的格式
    NSString *dateAndTime = [selectDateFormatter stringFromDate:select];
    [self.parent.pageContext dispatchJSEvetn:[NSString stringWithFormat:@"%@.%@",self.parent.controlId,@"onChange"]
                                  withParams:@{@"position":[NSNumber numberWithInteger:self.position],@"target":actionType , @"value":dateAndTime}];
    
}

@end
