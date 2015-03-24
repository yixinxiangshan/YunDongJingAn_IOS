//
//  ListViewCellFixedTitle.m
//  IOSProjectTemplate
//
//  Created by Zongzhan on 11/25/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import "ListViewCellFixedTitle.h"
#import "ECBaseViewController.h"

@implementation ListViewCellFixedTitle

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
    if ([self.data[@"title"] isEmpty] || [self.data[@"title"] length] == 0) {
        [self.title removeFromSuperview];
        //        [self.title setHidden:YES];
    }else{
        [self.title setText:self.data[@"title"]];
    }
    
    [self.parent.pageContext dispatchJSEvetn:[NSString stringWithFormat:@"%@.%@",self.parent.controlId,@"onFixedItemDisplay"]
                                  withParams:@{@"position":[NSNumber numberWithInteger:self.position],@"target":@""}];
}

+ (CGFloat)heightForData:(NSDictionary *)data
{
    // 屏幕
    CGRect frm =[ UIScreen mainScreen ].applicationFrame;
    // 计算text高度
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
    [label setNumberOfLines:0];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:18.f];
    label.font = font;
    CGSize size = CGSizeMake( frm.size.width - 30.f , CGFLOAT_MAX );  //LableWight标签宽度，固定的
    CGSize labelsize = [data[@"title"] sizeWithFont:font constrainedToSize:size lineBreakMode:label.lineBreakMode];
    return labelsize.height + 20.f;

}


@end
