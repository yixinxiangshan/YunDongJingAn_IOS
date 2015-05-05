//
//  ECBasePullRefreshWidget.m
//  ECDemoFrameWork
//
//  Created by EC on 10/10/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECBasePullRefreshWidget.h"
#import "Constants.h"

@interface ECBasePullRefreshWidget ()

@property (nonatomic, assign)BOOL pullable;

@end

@implementation ECBasePullRefreshWidget


- (void) startRefresh{
    if (_refreshDelegate && [_refreshDelegate respondsToSelector:@selector(refresh)]) {
        [_refreshDelegate refresh];
    }else{
        [self refreshWidget];
    }

}
- (void) startLoadMore{
    //TODO: 在子类中实现
//    if (_loadMoreDelegate && [_loadMoreDelegate respondsToSelector:@selector(loadMore:)]) {
//        [_loadMoreDelegate loadMore:<#(NSString *)#>]
//    }else{
//        //TODO: 默认行为
//    }
}
#pragma mark - 上拉、下拉事件控制
- (void)setOnLoadMoreDelegate:(id<LoadMoreDelegate>)loadMoreDelegate
{
    [self setLoadMoreDelegate:loadMoreDelegate];
}
- (void)setOnRefreshDelegate:(id<RefreshDelegate>)refreshDelegate
{
    [self setRefreshDelegate:refreshDelegate];
}


- (void) setHeaderAndFooter:(UIScrollView*)scrollView
{
    _scrollView = scrollView;
    if (_pullable) {
        self.refreshHeaderView = [EGORefreshTableHeaderView initWithScrollView:scrollView delegate:self];
        self.refreshFooterView = [EGORefreshTableFooterView initWithScrollView:scrollView delegate:self];
    }
}
#pragma mark- EGORefreshTableDelegate
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    _isPullDown = !aRefreshPos;
    switch (aRefreshPos) {
        case 0:
            [self startRefresh];
            break;
        case 1:
            [self startLoadMore];
        default:
            break;
    }
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view
{
    return _isReloading;
}
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
    return [NSDate date];
}
#pragma mark- UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (_refreshHeaderView)
    {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    
	if (_refreshFooterView)
    {
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_refreshHeaderView)
    {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    
	if (_refreshFooterView)
    {
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark - 完成loading
-(void)doneLoadingTableViewData:(UIScrollView*) scrollView
{
    self.isReloading = NO;
    if (self.refreshHeaderView)
    {
        [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:scrollView];
    }
    
    if (self.refreshFooterView)
    {
        [self.refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:scrollView];
    }
    
}

# pragma - mark 设置frame
- (CGSize)sizeThatFits:(CGSize)size{
    if (self.insertType<=0)
        self.insertType = 2;
    float w = 0;
    float h = 0;
    // fit content
    UIScrollView* scrollView = [[self subviews] objectAtIndex:0];
    // check fit father
    switch (self.insertType) {
        case 1: // (fillparent,fillparent) self.frame = parent.frame
            w = [self superview].frame.size.width;
            h = [self superview].frame.size.height;
            break;
        case 2: // (fillparent,wrapcontent) self.width = parent.width self.height = self.contentSize.height
            w = [self superview].frame.size.width;
            h = scrollView.contentSize.height;
            break;
        case 3: // (wrapcontent,fillparent) self.width = parent.width self.height = parent.frame.size.height
            w = self.frame.size.width;
            h = [self superview].frame.size.height;
            break;
        case 4: // (wrapcontent,wrapcontent)
            w = self.frame.size.width;
            h = scrollView.contentSize.height;
            break;
        default:
            break;
    }
    [scrollView setFrame:CGRectMake(0, 0, w, h)];
//    ECLog(@"w = %f , h = %f",w,h);
    return CGSizeMake(w, h);
}

#pragma - mark getter & setter
- (void)setPullableS:(NSString*)pullable{
    [self setPullable:pullable.boolValue];
}

@end
