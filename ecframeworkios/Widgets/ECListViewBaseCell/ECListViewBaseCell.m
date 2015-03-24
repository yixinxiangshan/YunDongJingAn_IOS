//
//  ECSTableViewCell.m
//  ECS DevelopKit
//
//  Created by LittoCats on 9/3/14.
//  Copyright (c) 2014 Littocats. All rights reserved.
//

#import "ECListViewBaseCell.h"
#import "ECListViewBase.h"
#import "ECListViewBase.h"
#import "UIColorExtends.h"

@interface ECListViewBaseCell ()

@property (nonatomic, strong) NSDictionary *contentData;

@end

@implementation ECListViewBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSAssert([self conformsToProtocol:@protocol(ECListViewCellProtocol)], @"[%@] error , ECSTableViewCell 的子类必须实现 ECSTableSubview 协议。",self.class);
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)setFrame:(CGRect)frame {
//    
//    frame.origin.x += 10;
//    
//    frame.size.width -= 2 * 10;
//    
//    [super setFrame:frame];
//    
//}

//分割线  默认添加下分割线。
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    //        上分割线
    //    下分割线
    CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:@"#EAEAEA"].CGColor);
    CGContextFillRect(context, CGRectMake(0, rect.size.height-.5, rect.size.width, .5));
}

@end
