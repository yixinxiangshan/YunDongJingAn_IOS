//
//  ListViewCellImage.m
//  IOSProjectTemplate
//
//  Created by Zongzhan on 11/5/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import "ListViewCellImage.h"
#import "ECViewUtil.h"
#import "UIColorExtends.h"

@implementation ListViewCellImage


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
    [ECViewUtil getImageByConfig:self.image config:self.data[@"image"]];
    NSString *name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.version.text = [[name stringByAppendingString:@" "] stringByAppendingString:version];
    NSLog(@"version: %@", self.version.text);
}


+ (CGFloat)heightForData:(NSDictionary *)data
{
    if ([data[@"image"][@"imageSize"] isEqualToString:@"full"]) {
        return  ([[UIScreen mainScreen] bounds].size.width-20)*4/3;
    }
    //    使用xib的时候尽量用 autolayout
    return 160;
}

//分割线  根据需要添加分割线。
- (void)drawRect:(CGRect)rect
{
    if ((![self.data[@"hasFooterDivider"] isEmpty]) && [self.data[@"hasFooterDivider"] isEqualToString:@"true"]) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
        CGContextFillRect(context, rect);
        //        下分割线
        //    下分割线
        CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:@"#CACACA"].CGColor);
        CGContextFillRect(context, CGRectMake(0, rect.size.height-.5, rect.size.width-.5, .5));
    }
}

@end