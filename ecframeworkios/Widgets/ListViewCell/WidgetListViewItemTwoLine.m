//
//  ECNewsTwoLineCell.m
//  JingAnWeekly
//
//  Created by EC on 3/18/13.
//  Copyright (c) 2013 ecloud. All rights reserved.
//

#import "WidgetListViewItemTwoLine.h"
#import "NSStringExtends.h"
#import "ECImageUtil.h"

@implementation WidgetListViewItemTwoLine

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
    self.titleLabel.text = [self.dataSource objectForKey:@"title"];
    self.contentLabel.text = [self.dataSource objectForKey:@"abstracts"];
    
    NSString *titmeString = [self.dataSource objectForKey:@"time"];
    if (!titmeString) {
        self.timeLabel = nil;
    }else{
        self.timeLabel.text = [self.dataSource objectForKey:@"time"];
    }
    
    NSString* imageName = [self.dataSource objectForKey:@"image_cover"];
    if (!imageName) {
        [_titleLabel setFrame:CGRectMake(_titleLabel.frame.origin.x - _image.frame.size.width, _titleLabel.frame.origin.y, self.frame.size.width - 20.0 - _timeLabel.frame.size.width, _titleLabel.frame.size.height)];
        [_contentLabel setFrame:CGRectMake(_contentLabel.frame.origin.x - _image.frame.size.width, _contentLabel.frame.origin.y, self.frame.size.width - 20.0, _contentLabel.frame.size.height)];
    }else{
        if (![imageName isEmpty]) {
            if (![_image isDescendantOfView:self])
                [self addSubview:_image];
            NSString* imageUrl = [ECImageUtil getFitImageWholeUrl:imageName];
            if (![imageUrl isEmpty]) {
                [self.image setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"general_default_image.png"] fitHeight:NO];
            }
        }
    }
}
@end
