//
//  ListViewCellLine.m
//  IOSProjectTemplate
//
//  Created by Zongzhan on 9/11/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//
#import "ECViewUtil.h"
#import "ListViewCellLine.h"
#import "ECImageUtil.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Resize.h"
#import "UIImage+Resource.h"
#import "NSStringExtends.h"
#import "PureLayout.h"
#import "UIColorExtends.h"
#import "SJAvatarBrowser.h"

@implementation ListViewCellLine

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
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
//    [_rightImage setUserInteractionEnabled:YES];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
//    [tap setNumberOfTapsRequired:1];
//    [tap setNumberOfTouchesRequired:1];
//    [_rightImage addGestureRecognizer:tap];
}

- (void)setData:(NSDictionary *)data
{

    [super setData:data];
    // 设置内容
    [ECViewUtil setText:self.centerTitle data:data[@"centerTitle"]];
    [ECViewUtil setText:self.centerBottomdes data:data[@"centerBottomdes"]];
    [ECViewUtil setText:self.centerBottomdes2 data:data[@"centerBottomdes2"]];
    [ECViewUtil setText:self.centerRighttopdes data:data[@"centerRighttopdes"]];
    [ECViewUtil setText:self.centerRightdes data:data[@"centerRightdes"]];
    //[ECViewUtil setText:self.centerRightdes data:data[@"rightDes"]];
    [ECViewUtil getImageByConfig:self.leftImage config:data[@"leftImage"]];
    [ECViewUtil getImageByConfig:self.rightImage config:data[@"rightImage"]];
    [ECViewUtil getImageByConfig:self._bottomDivider config:data[@"_bottomDivider"]];

    // 设置文字颜色
    if ( ![data[@"_centerTitleColor"] isEmpty] && data[@"_centerTitleColor"][@"normal"] != nil ) {
        [self.centerTitle setTextColor: [UIColor colorWithHexString:data[@"_centerTitleColor"][@"normal"]]];
    }else{
        [self.centerTitle setTextColor: [UIColor colorWithHexString:@"000000"]];
    }

    if ( ![data[@"_centerBottomdesColor"] isEmpty] && data[@"_centerBottomdesColor"][@"normal"] != nil ) {
        [self.centerBottomdes setTextColor: [UIColor colorWithHexString:data[@"_centerBottomdesColor"][@"normal"]]];
    }else{
        [self.centerBottomdes setTextColor: [UIColor colorWithHexString:@"AAAAAA"]];
    }

    if ( ![data[@"_centerBottomdes2Color"] isEmpty] && data[@"_centerBottomdes2Color"][@"normal"] != nil ) {
        [self.centerBottomdes2 setTextColor: [UIColor colorWithHexString:data[@"_centerBottomdes2Color"][@"normal"]]];
    }else{
        [self.centerBottomdes2 setTextColor: [UIColor colorWithHexString:@"333333"]];
    }

    // 设置左右间距
    int leftSpace = 0;
    int rightSpace = 0;
    if(![data[@"_leftLayoutSize"] isEmpty] && [data[@"_leftLayoutSize"] intValue] > 0)
        leftSpace = [data[@"_leftLayoutSize"] intValue] * 1.3;
    else
        leftSpace = 10;
    if(![data[@"_rightLayoutSize"] isEmpty] && [data[@"_rightLayoutSize"] intValue] > 0)
        rightSpace = [data[@"_rightLayoutSize"] intValue] * 1.3;
    else
        rightSpace = 10;
    if ([data[@"centerTitle"] length] > 0){
        [self.centerTitle autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:leftSpace];
        [self.centerTitle autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:rightSpace];
    }
    if ([data[@"centerBottomdes"] length] > 0){
        [self.centerBottomdes autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:leftSpace];
        [self.centerBottomdes autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:rightSpace];
    }
    if ([data[@"centerBottomdes2"] length] > 0){
        [self.centerBottomdes2 autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:leftSpace];
        [self.centerBottomdes2 autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:rightSpace];
        // 有多行des的时候，左右图片pin到顶部
        [self.leftImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:24];
        [self.rightImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:27];
    }else{
        [self.leftImage autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.rightImage autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    }
    if ([data[@"rightDes"] length] > 0|| [data[@"centerRightdes"] length] > 0)
        [self.centerRightdes autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.rightImage withOffset:-5];

    // 只有一条文字的时候垂直居中
    if (([self.data[@"centerBottomdes"] length]  == 0) && ([self.data[@"centerBottomdes2"] length]  == 0) && [data[@"centerTitle"] length] > 0){
        [self.centerTitle autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    }else{
        [self.centerTitle autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:13];
    }
    if (([self.data[@"centerTitle"] length]  == 0) && ([self.data[@"centerBottomdes2"] length]  == 0) && [data[@"centerBottomdes"] length] > 0)
        [self.centerBottomdes autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:6];


    if (([self.data[@"centerBottomdes"] length]  == 0) && ([self.data[@"centerTitle"] length]  == 0) && [data[@"centerBottomdes2"] length] > 0){
        [self.centerBottomdes2 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
    }
    // [self.centerBottomdes2 autoAlignAxisToSuperviewAxis:ALAxisHorizontal];

    //背景
    if (data[@"_backgroundColor"] != nil && [data[@"_backgroundColor"][@"normal"] length]> 0) {
        UIView *backgrdView = [[UIView alloc] initWithFrame:self.frame];
        backgrdView.backgroundColor =[UIColor colorWithHexString:data[@"_backgroundColor"][@"normal"]];
        self.backgroundView = backgrdView;
    }else{
        self.backgroundView = nil;
    }
}

+ (CGFloat)heightForData:(NSDictionary *)data {
    CGRect frm =[ UIScreen mainScreen ].applicationFrame;
    // 计算textview宽度用到的数字
    NSInteger space = 0;
    if (![data[@"_leftLayoutSize"] isEmpty] && [data[@"_leftLayoutSize"] intValue] > 0)
        space = space + [data[@"_leftLayoutSize"] intValue] * 1.3;
    else
        space = space + 15;
    if (![data[@"_rightLayoutSize"] isEmpty] && [data[@"_rightLayoutSize"] intValue] > 0)
        space = space + [data[@"_rightLayoutSize"] intValue] * 1.3;
    else
        space = space + 15;
    float ctHeight = [ECViewUtil getTextHeight:data[@"centerTitle"] width:frm.size.width - space fontSize:18.f];
    float cdHeight = [ECViewUtil getTextHeight:data[@"centerBottomdes"] width:frm.size.width - space fontSize:15.f];
    float cd2Height = [ECViewUtil getTextHeight:data[@"centerBottomdes2"] width:frm.size.width - space fontSize:15.1f];
    int hasCt = 0;
    int hasCd = 0;
    int hasCd2 = 0;
    if (ctHeight > 0) hasCt = 1;
    if (ctHeight > 0) hasCd = 1;
    if (ctHeight > 0) hasCd2 = 1;
    // centerBottomdes不换行，所以高度固定
    if (cdHeight > 0) cdHeight = 18;
    if (([data[@"centerTitle"] length]  == 0) && ([data[@"centerBottomdes"] length]  == 0) && [data[@"centerBottomdes2"] length] > 0)
        return cd2Height + 25;  // 大篇文章的情况
    else if (([data[@"centerTitle"] length]  == 0) && ([data[@"centerBottomdes2"] length]  == 0) && [data[@"centerBottomdes"] length] > 0)
        return 33;              // 变色的小标题
    else
        return ctHeight + cdHeight + cd2Height + (hasCt + hasCd + hasCd2 -1) * 10 + 15.f;
    
    // NSLog(@"heightForData: %f , %f , %f" , ctHeight , cdHeight, cd2Height);
    // NSLog(@"heightForData end: %f" , ctHeight + cdHeight + cd2Height + (hasCt + hasCd + hasCd2 -1) * 10 + 20.f);
}

//分割线
- (void)drawRect:(CGRect)rect
{
    if ((![self.data[@"hasFooterDivider"] isEmpty]) && [self.data[@"hasFooterDivider"] isEqualToString:@"true"]) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
        CGContextFillRect(context, rect);
        //        下分割线
        //    下分割线
        CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:@"#EAEAEA"].CGColor);
        CGContextFillRect(context, CGRectMake(0, rect.size.height-1, rect.size.width, 1));
    }
}
@end
