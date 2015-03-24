//
//  ECChannelWidget.m
//  ECIOSProject
//
//  Created by 程巍巍 on 3/12/14.
//  Copyright (c) 2014 ecloud. All rights reserved.
//

#import "ECChannelWidget.h"
#import "NSStringExtends.h"
#import "LightMenuBar.h"
#import "LightMenuBarDelegate.h"
#import "ECBaseViewController.h"
#import "ECPageUtil.h"

#import "ECChannelBar.h"

@interface ECChannelWidget () <UIScrollViewDelegate,ECChannelBarDelegate>
@property (nonatomic, strong) ECChannelBar *channelBar;

//@property (nonatomic, strong) UIView *channelContent;

//context 为 scrollview
@property (nonatomic, strong) UIScrollView *channelContent;

@property (nonatomic, strong) NSMutableArray *channelBarItems;
@property (nonatomic, strong) NSMutableArray *channelContentItems;

@property (nonatomic) NSInteger currentTag;

@end

@implementation ECChannelWidget

- (id) initWithConfigDic:(NSDictionary *)configDic pageContext:(ECBaseViewController *)pageContext
{
    self = [super initWithConfigDic:configDic pageContext:pageContext];
    if (self.layoutName == nil || [self.layoutName isEmpty]) {
        self.layoutName = @"ECChannelWidget";
    }
    if (self.controlId == nil || [self.controlId isEmpty]) {
        self.controlId = @"channel_widget";
    }
    if (self) {
        self.channelBar = [[ECChannelBar alloc] initWithFrame:CGRectMake(0, 0, 320, 36)];
        [_channelBar setBackgroundColor:[UIColor colorWithRed:0.89 green:0.91 blue:0.94 alpha:1.00]];
        _channelBar.delegate = self;
        
        self.channelContent = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 36, 320, 416)];
        _channelContent.pagingEnabled = YES;
        _channelContent.showsHorizontalScrollIndicator = NO;
        _channelContent.showsVerticalScrollIndicator = NO;
        _channelContent.delegate = self;
        
        [self addSubview:_channelBar];
        [self addSubview:_channelContent];
    }
    [self parsingConfigDic];
    self.insertType = 1;
    return self;
}

- (void) setdata
{
    [super setdata];
    _currentTag = NSIntegerMax;
    
    [_channelBar setConfig:self.dataDic[@"channelList"]];
    self.channelContentItems = [NSMutableArray new];
    [self.dataDic[@"channelList"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [_channelContentItems addObject:[NSNull null]];
    }];
    
    [self.channelContent setContentSize:CGSizeMake(_channelContent.frame.size.width*[self.dataDic[@"channelList"] count], _channelContent.frame.size.height)];
    
    [_channelBar selectChannelWithIndex:0 notifyDelegate:YES];
}

- (void) selectChannelWithTag:(NSInteger) tag animate:(BOOL)animate
{
    if (tag == _currentTag) {
        return;
    }
    _currentTag = tag;
    
    ECBaseViewController *currentPage = nil;
    ECBaseViewController *obj = _channelContentItems[tag];
    if ((NSNull *)obj != [NSNull null] && [[obj pageId] isEqualToString:self.dataDic[@"channelList"][tag][@"pageName"]]) {
        currentPage = (ECBaseViewController *)obj;
    }
    
    if (!currentPage) {
        UIView *viewContainer = [[UIView alloc] initWithFrame:CGRectMake(_channelContent.frame.size.width*tag, 0, _channelContent.frame.size.width, _channelContent.frame.size.height)];
        [_channelContent addSubview:viewContainer];
        
        currentPage = [ECPageUtil initPage:self.dataDic[@"channelList"][tag][@"pageName"] params:nil parentView:viewContainer];
        [_channelContentItems replaceObjectAtIndex:tag withObject:currentPage];
    }
    if (animate) {
        [_channelContent scrollRectToVisible:CGRectMake(_channelContent.frame.size.width*tag, 0, _channelContent.frame.size.width, _channelContent.frame.size.height) animated:YES];
    }
}

#pragma mark- init and layout channelBarItems

#pragma mark-
- (void) layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = _channelContent.frame;
    frame.size.height = self.frame.size.height - 36;
    [_channelContent setFrame:frame];
    frame.origin.y = 0;
    [[_channelContent.subviews firstObject] setFrame:frame];
}

#pragma mark-
- (void) didMoveToWindow
{
    if (self.frame.size.height != self.superview.frame.size.height) {
        [self setFrame:self.superview.frame];
        [self setNeedsLayout];
    }
}

#pragma mark
- (void)ecChannelBar:(ECChannelBar *)channelBar didSelectedItemAtIndex:(NSInteger)index
{
    [self selectChannelWithTag:index animate:YES];
}

#pragma mark- UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger tag = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self.channelBar selectChannelWithIndex:tag notifyDelegate:YES];
}
@end
