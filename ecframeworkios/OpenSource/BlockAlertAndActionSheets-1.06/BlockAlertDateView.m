//
//  BlockAlertDateView.m
//  IOSProjectTemplate
//
//  Created by Zongzhan on 12/3/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import "BlockAlertDateView.h"
#import "ECAppUtil.h"


@interface BlockAlertDateView()
@property (nonatomic, strong) NSString *inputDate;
@end

@implementation BlockAlertDateView
@synthesize datePicker;

+ (BlockAlertDateView *)promptWithDate:(NSString *)date title:(NSString *)title dateString:(out NSString**)dateString{
    BlockAlertDateView *prompt = [[BlockAlertDateView alloc] initWithDate:date title:title];
    *dateString = prompt.dateString;
    return prompt;
}

- (void)addComponents:(CGRect)frame {
    [super addComponents:frame];
    CGRect parentFrame = _view.frame;
    if (!self.datePicker) {
        // 当前时间
        NSDate *dateNow =  [NSDate date];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
        NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *comps  = [calendar components:unitFlags fromDate:dateNow];
        NSInteger year = [comps year];
        NSInteger month = [comps month];
        NSInteger day = [comps day];
        
        // 计算初始化时间
        NSDateFormatter *mmddccyy = [[NSDateFormatter alloc] init];
        mmddccyy.timeStyle = NSDateFormatterNoStyle;
        mmddccyy.dateFormat = @"MM/dd/yyyy";
        NSArray* dateFoo = [self.inputDate componentsSeparatedByString: @"-"];
        NSString* dYear = [dateFoo objectAtIndex:0];
        NSString* dMonth = [dateFoo objectAtIndex:1];
        NSString* dDay = [dateFoo objectAtIndex:2];
        if ([dYear length] > 0)
            year = [dYear intValue];
        if ([dMonth length] > 0)
            month = [dMonth intValue];
        if ([dDay length] > 0)
            day = [dDay intValue];
        
        NSDate *setDate = [mmddccyy dateFromString:[NSString stringWithFormat:@"%li/%li/%li" , (long)month ,(long)day, (long)year] ];
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(5, _height - 50, parentFrame.size.width - 5 * 2 ,  200)];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        [self.datePicker setDate:setDate];
        [self.datePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        self.dateString = [NSString stringWithFormat:@"%li-%li-%li" ,(long)year, (long)month ,(long)day];
        [ECAppUtil setPreference:[NSString stringWithFormat:@"%li-%li-%li" ,(long)year, (long)month ,(long)day] forKey:@"_popDatePickerViewValue"];
    }else {
        self.datePicker.frame = CGRectMake(5, _height - 50, parentFrame.size.width - 5 * 2 ,  200);
        [self.datePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    CGRect frames = self.datePicker.frame;
    frames.size.width = _view.frame.size.width;
    [self.datePicker setFrame: frames];
    [_view addSubview:self.datePicker];
    _height += 200 + 10 - 50 ;
}
-(void)onDatePickerValueChanged:(id)sender
{
    NSDate *select = [sender date];
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    selectDateFormatter.dateFormat = @"YYYY-MM-dd"; // 设置时间和日期的格式
    NSString *dateAndTime = [selectDateFormatter stringFromDate:select];
    self.dateString = dateAndTime;
    //TODO 上面的对象引用有问题，所以暂时使用全局的设置传值，后面需要修改的
    [ECAppUtil setPreference:dateAndTime forKey:@"_popDatePickerViewValue"];
    //    NSLog(@"onDatePickerValueChanged : %@" , self.dateString);
}

- (id)initWithDate:(NSString *)date title:(NSString *)title {
    self.inputDate = date;
    // title message
    self = [super initWithTitle:title message:@""];
    if (self) {
        if ([self class] == [BlockAlertDateView class])
            [self setupDisplay];
    }
    return self;
}


@end
