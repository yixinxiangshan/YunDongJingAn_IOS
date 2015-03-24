//
//  BlockAlertDateView.h
//  IOSProjectTemplate
//
//  Created by Zongzhan on 12/3/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import "BlockAlertView.h"
@class BlockAlertDateView;


@interface BlockAlertDateView : BlockAlertView
@property (nonatomic, retain) NSString *dateString;
@property (nonatomic, retain) UIDatePicker *datePicker;
+ (BlockAlertDateView *)promptWithDate:(NSString *)date title:(NSString *)title dateString:(out NSString**)dateString;
- (id)initWithDate:(NSString *)date title:(NSString *)title ;

@end
