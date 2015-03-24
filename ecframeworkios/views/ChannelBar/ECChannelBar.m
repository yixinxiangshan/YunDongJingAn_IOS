//
//  ECChannelBar.m
//  IOSProjectTemplate
//
//  Created by 程巍巍 on 4/14/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import "ECChannelBar.h"

@interface ECChannelBar ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *config;

@property (nonatomic, strong) UIScrollView *containerView;

@property (nonatomic, strong) UIView *slideView;

@property (nonatomic) NSInteger itemWidth;
@end

@implementation ECChannelBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 36)];
    if (self) {
        self.containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 3, 320, 30)];
        [_containerView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_containerView];
        
        self.slideView = [[UIView alloc] init];
        [_slideView setBackgroundColor:[UIColor blueColor]];
        [self addSubview:self.slideView];
    }
    return self;
}
- (id)init
{
    self = [self initWithFrame:CGRectZero];
    return self;
}
- (id)initWithConfig:(NSArray *)config
{
    self = [self init];
    if (self) {
        self.config = [NSMutableArray arrayWithArray:config];
    }
    return self;
}

- (void)setConfig:(NSMutableArray *)config
{
    _config = [NSMutableArray arrayWithArray:config];
    [self defaultInit];
}
- (void)defaultInit
{
    for (UIView *subView in _containerView.subviews) {
        [subView removeFromSuperview];
    }
    
    _itemWidth = _config.count > 4 ? self.frame.size.width/4 : self.frame.size.width/_config.count;
    [_slideView setFrame:CGRectMake(0, 33, _itemWidth, 3)];
    
    for (int i = 0; i < _config.count; i ++) {
        if (i > 0) {
            UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(_itemWidth * i - 0.25, 3, 0.5, 24)];
            [seperator setBackgroundColor:[UIColor grayColor]];
            [_containerView addSubview:seperator];
        }
        NSDictionary *itemConfig = _config[i];
        UIButton *item = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _itemWidth-1, 30)];
        item.tag = i;
        [item addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
        [item setCenter:CGPointMake(_itemWidth*(i + 0.5), 15)];
        [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [item.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [item setTitle:itemConfig[@"title"] forState:UIControlStateNormal];
        
        [_containerView addSubview:item];
    }
    [_containerView setContentSize:CGSizeMake(_config.count * _itemWidth, 30)];
}
- (void)selectChannelWithIndex:(NSInteger)index notifyDelegate:(BOOL)notifyDelegate
{
    [_slideView setCenter:CGPointMake(_itemWidth*(index + 0.5), 34.5)];
    
    if (notifyDelegate && [self.delegate respondsToSelector:@selector(ecChannelBar:didSelectedItemAtIndex:)]) {
        [self.delegate ecChannelBar:self didSelectedItemAtIndex:index];
    }
}

#pragma mark- action
- (void)itemSelected:(UIButton *)sender
{
    [self selectChannelWithIndex:sender.tag notifyDelegate:YES];
}
@end
