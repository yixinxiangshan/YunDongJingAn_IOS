//
//  WidgetListviewItemSj.m
//  IOSProjectTemplate
//
//  Created by 程巍巍 on 4/14/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import "WidgetListviewItemSj.h"
#import "UIImage+Resource.h"

@interface WidgetListviewItemSj ()

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UIImageView *star;
@end

@implementation WidgetListviewItemSj

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark-
- (void)setData
{
    _title.text = self.dataSource[@"title"];
    _subTitle.text = self.dataSource[@"abstracts"];
    _distance.text = self.dataSource[@"timeString"];
    
    _star.image = [UIImage imageWithPath:self.dataSource[@"icon"]];
    [_star setFrame:CGRectMake(_star.frame.origin.x, _star.frame.origin.y, _star.image.size.width, _star.image.size.height)];
}
@end
