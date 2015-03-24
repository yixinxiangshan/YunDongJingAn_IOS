//
//  ListViewCellGroupTitle.m
//  IOSProjectTemplate
//
//  Created by Zongzhan on 9/19/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import "ListViewCellGroupTitle.h"

@implementation ListViewCellGroupTitle

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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self.data[@"textTitle"] isEmpty] || [self.data[@"textTitle"] length] == 0) {
        [self.title removeFromSuperview];
        //        [self.title setHidden:YES];
    }else{
        [self.title setText:self.data[@"textTitle"]];
    }
}

+ (CGFloat)heightForData:(NSDictionary *)data
{
    return 0;
}
@end
