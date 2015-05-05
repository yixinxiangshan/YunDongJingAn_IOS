//
//  ECBasePullRefreshWidget.h
//  ECDemoFrameWork
//
//  Created by EC on 10/10/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECBaseWidget.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "ECLoadMoreDelegate.h"
#import "ECRefreshDelegate.h"

@interface ECBasePullRefreshWidget : ECBaseWidget <EGORefreshTableDelegate>
@property UIScrollView* scrollView;
@property (strong, nonatomic) EGORefreshTableHeaderView *refreshHeaderView;
@property (strong, nonatomic) EGORefreshTableFooterView *refreshFooterView;
@property BOOL isReloading;
@property BOOL isPullDown;

@property (strong, nonatomic) id<LoadMoreDelegate> loadMoreDelegate;
@property (strong, nonatomic) id<RefreshDelegate> refreshDelegate;

- (void) startRefresh;
- (void) startLoadMore;

- (void) setHeaderAndFooter:(UIScrollView*)scrollView;

- (void)setOnLoadMoreDelegate:(id<LoadMoreDelegate>)loadMoreDelegate;
- (void)setOnRefreshDelegate:(id<RefreshDelegate>)refreshDelegate;

-(void)doneLoadingTableViewData:(UIScrollView*) scrollView;


@end
