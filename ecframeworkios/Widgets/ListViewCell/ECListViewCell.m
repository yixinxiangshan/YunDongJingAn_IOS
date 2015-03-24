//
//  ECListViewCell.m
//  ECDemoFrameWork
//
//  Created by cww on 13-9-12.
//  Copyright (c) 2013年 EC. All rights reserved.
//

#import "ECListViewCell.h"

@implementation ECListViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void) setData:(NSDictionary *)data
{
    self.dataSource = data;
    self.ID = [self.dataSource valueForKey:@"id"];
    [self setData];
}

/**
 * 该方法设置Cell数据，子类需重载该方法
 */
- (void)setData{

}
@end
