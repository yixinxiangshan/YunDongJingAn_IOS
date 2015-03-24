//
//  ECButtonWidget.m
//  NowMarry
//
//  Created by cheng on 13-12-9.
//  Copyright (c) 2013年 ecloud. All rights reserved.
//

#import "ECButtonWidget.h"
#import "NSStringExtends.h"
#import "ECJSUtil.h"
#import "Constants.h"
#import "UIColorExtends.h"
#import "UIImage+Resource.h"
#import "ECBaseViewController.h"

@interface ECButtonWidget ()


@end

@implementation ECButtonWidget

- (id)initWithConfigDic:(NSDictionary*)configDic pageContext:(ECBaseViewController*)pageContext{
    self = [super initWithConfigDic:configDic pageContext:pageContext];
    [self parsingLayoutName];
    if (self.layoutName ==nil || [self.layoutName isEmpty]) {
        self.layoutName = @"ECButtonWidget";
    }
    if ([self.controlId isEmpty]) {
        self.controlId = @"button_widget";
    }
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:self.layoutName owner:self options:nil];
        [self setViewId:@"button_widget"];
        [_button setViewId:self.viewId];
        [self addSubview:_button];
        [self setFrame:self.button.frame];
        self.button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        //        [_button setBackgroundColor:[UIColor colorWithHexString:@"#F2F3F3"]];
        [self.button addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self parsingConfigDic];
    
    [self setBackgroundColor:[UIColor clearColor]];
    return self;
}

- (void) parsingConfigDic
{
    [super parsingConfigDic];
}
- (void) setdata{
    [super setdata];
    
    _title = [self.dataDic objectForKey:@"text"];
    _titleClicked = [self.dataDic objectForKey:@"text_clicked"];
    _backgroundImage = [UIImage imageWithPath:[NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"background"]]];
    _backgroundImageClicked = [UIImage imageWithPath:[NSString stringWithFormat:@"%@_clicked",[self.dataDic objectForKey:@"background_clicked"]]];
    
    if (!_backgroundImage) {
        _backgroundImage = [UIImage imageWithPath:@"button_widget_background_default.png"];
    }
    if (!_backgroundImageClicked) {
        _backgroundImageClicked = [UIImage imageWithPath:@"button_widget_background_clicked_default.png"];
    }
    
    if (_backgroundImage) {
        [_button setBackgroundImage:_backgroundImage forState:UIControlStateNormal];
        //        if (_backgroundImageClicked) {
        //            [_button setImage:_backgroundImageClicked forState:UIControlStateHighlighted];
        //        }
    }
    
    if (_title) {
        [_button setTitle:_title forState:UIControlStateNormal];
        //        if (_titleClicked) {
        //            [_button setTitle:_titleClicked forState:UIControlStateHighlighted];
        //        }
    }
    
    [self.button setFrame:CGRectMake(0, 0, _backgroundImage.size.width, _backgroundImage.size.height)];
    [self.button setCenter:CGPointMake(160, 22)];
    [self sizeToFit];
}

- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    //    [_button setFrame:self.bounds];
}
#pragma mark- button clicked
- (void) onButtonClick:(ECButton *)button
{
    //    NSString* jsString = [NSString stringWithFormat:@"%@.onButtonClick(\"{\\\"controlId\\\":\\\"%@\\\",\\\"viewId\\\":\\\"%@\\\"}\")",self.controlId,self.controlId,self.viewId];
    //
    //    NSString* result = [[ECJSUtil shareInstance] runJS:jsString];
    
    //    NSLog(@"ECButtonWidget onButtonClick : %@",result);
    
    //    if (![result boolValue]) {
    //        //执行委托
    //        if (_buttonClickDelegate && [_buttonClickDelegate respondsToSelector:@selector(onButtonClick:)]) {
    //            [_buttonClickDelegate onButtonClick:_button];
    //        }
    //    }
    
}

#pragma handle event delegate
- (void)setOnButtonClickDelegate:(id<onButtonClickDelegate>)buttonClickDelegate
{
    [self setButtonClickDelegate:buttonClickDelegate];
}

# pragma - mark 设置frame
- (CGSize)sizeThatFits:(CGSize)size{
    if (self.insertType<=0)
        self.insertType = 2;
    float w = 0;
    float h = 0;
    // fit content
    for (UIView *v in [self subviews]) {
        float fw = v.frame.origin.x + v.frame.size.width;
        float fh = v.frame.origin.y + v.frame.size.height;
        w = MAX(fw, w);
        h = MAX(fh, h);
    }
    float imageW = 0;
    float imageH = 0;
    if (_backgroundImage != nil) {
        imageW = [_backgroundImage size].width;
        imageH = _backgroundImage.size.height;
    }else{
        imageH = h;
        imageW = w;
    }
    // check fit father
    switch (self.insertType) {
        case 1:
            w = [self superview].frame.size.width;
            h = [self superview].frame.size.height;
            break;
        case 2:
            w = [self superview].frame.size.width;
            h = imageH;
            break;
        case 3:
            w = imageW;
            h = [self superview].frame.size.height;
            break;
        case 4:
            w = self.frame.size.width;
            h = self.frame.size.height;
            
            break;
            
        default:
            break;
    }
    //ECLog(@"w = %f , h = %f",w,h);
    
    return CGSizeMake(w, h);
}

@end
