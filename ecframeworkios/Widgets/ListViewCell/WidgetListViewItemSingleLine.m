//
//  WidgetListViewItemSingleLine.m
//  IOSProjectTemplate
//
//  Created by 程巍巍 on 4/29/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import "WidgetListViewItemSingleLine.h"
#import "UIImage+Resource.h"

@implementation WidgetListViewItemSingleLine

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
- (void)setData
{
    self.textLabel.text = self.dataSource[@"title"];
    self.imageView.image = [UIImage imageWithPath:self.dataSource[@"leftIcon"]];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}


@end
