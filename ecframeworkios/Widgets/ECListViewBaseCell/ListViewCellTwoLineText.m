//
//  ECNewsTwoLineCell.m
//  JingAnWeekly
//
//  Created by EC on 3/18/13.
//  Copyright (c) 2013 ecloud. All rights reserved.
//

#import "ListViewCellTwoLineText.h"
#import "ECViewUtil.h"
#import "UIColorExtends.h"

@implementation ListViewCellTwoLineText

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    NSLog(@"reuseIdentifier: %@", reuseIdentifier);
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];
    }
    // NSLog(@"listviewcellline centerTitle initWithStyle");
    return self;
}

- (void)awakeFromNib
{
    // NSLog(@"listviewcellline centerTitle awakeFromNib");
    
}

- (void)setData:(NSDictionary *)data
{
    [super setData:data];
    // 设置内容
    [ECViewUtil setText:self.titleLabel data:data[@"subTitle"]];
    [ECViewUtil setText:self.timeLabel data:data[@"headTime"]];
    [ECViewUtil setText:self.contentLabel data:data[@"headTitle"]];
    [ECViewUtil setText:self.replyLabel data:data[@"expandTitle"]];
 
    //[self.image setImage:[UIImage imageNamed:@"defaultImage"]];
    //NSLog(@"data: %@", data);
 }

+ (CGFloat)heightForData:(NSDictionary *)data {
    
    if(!data[@"expandTitle"] || [data[@"expandTitle"] isEmpty])
    {
        return 66.0;
    }
    else
    {
        return 99.0;
    }
}

@end
