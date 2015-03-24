//
//  ECListViewWidget.m
//  ECDemoFrameWork
//
//  Created by EC on 9/3/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECListViewWidget.h"
#import "NSDictionaryExtends.h"
#import "NSStringExtends.h"
#import "Constants.h"
#import "ECWidgetUtil.h"
#import "ECNetUtil.h"
#import "ECListViewCell.h"
#import "ECReflectionUtil.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "ECViewUtil.h"
#import "Toast+UIView.h"
#import "NSArrayExtends.h"

@interface ECListViewWidget () <UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) id<OnItemClickDelegate> itemClickDelegate;
@property (strong, nonatomic) NSDictionary* listViewCellHeight;

@property (strong, nonatomic) NSMutableArray* dataList;

@property (nonatomic, strong) NSString *cellName;

@end

@implementation ECListViewWidget

- (id)initWithConfigDic:(NSDictionary*)configDic pageContext:(ECBaseViewController*)pageContext{
    self = [super initWithConfigDic:configDic pageContext:pageContext];
    [self parsingLayoutName];
    if (self.layoutName ==nil || [self.layoutName isEmpty]) {
        self.layoutName = @"ECListViewWidget";
    }
    if (self.cellLayoutName== nil || [self.cellLayoutName isEmpty]) {
        self.cellLayoutName = @"WidgetListViewItemTwoLine";
    }
    if ([self.controlId isEmpty]) {
        self.controlId = @"list_view_widget";
    }
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:self.layoutName owner:self options:nil];
        [self setViewId:@"list_view_widget"];
        [self addSubview:_listView];

        [_listView setAutoresizingMask:UIViewAutoresizingNone];
        _listView.dataSource = self;
        _listView.delegate = self;
        [self isCellExistForName:self.cellLayoutName];
    }
    [self parsingConfigDic];
    [self setHeaderAndFooter:_listView];
    
    return self;
}

- (void) setdata{
    [super setdata];
    _dataList = [NSMutableArray arrayWithArray:[self.dataDic objectForKey:@"ListByType"]];
    [_listView reloadData];
    [self sizeToFit];
}

- (void) refreshWidgetData:(id)dataDic{
    NSDictionary *newDataDic = [dataDic isKindOfClass:[NSString class]] ? [dataDic JSONValue] : dataDic;
    [super refreshWidgetData:newDataDic];
    [self doneLoadingTableViewData:_listView];
}

- (void) startLoadMore{
    if (self.loadMoreDelegate && [self.loadMoreDelegate respondsToSelector:@selector(loadMore:)]) {
        [self.loadMoreDelegate loadMore:[NSString stringWithFormat:@"%ld",(long)([_dataList count]-1)]];
    }else{
        //默认行为
        [ECWidgetUtil addWidgetData:self.pageContext widget:self dataSourceDic:[self.configDic objectForKey:@"datasource"] lastId:[[_dataList lastObject] objectForKey:@"id"]];
    }
}

- (void) addWidgetData:(NSDictionary*)dataDic{
    [self doneLoadingTableViewData:_listView];
    if (dataDic==nil || [dataDic isEmpty]) {
        [ECViewUtil toast:@"没有更多了..."];
        return;
    }
    dataDic = [ECDataUtil adapterDataFree:self.pageContext widget:self adapters:self.dataAdapter resData:dataDic];
    
    NSArray* moreDataList = [dataDic objectForKey:@"ListByType"];
    if (moreDataList == nil || [moreDataList isEmpty]) {
        // show no more
        [ECViewUtil toast:@"没有更多了..."];
        return;
    }
    [self.dataList addObjectsFromArray:moreDataList];
    [_listView reloadData];
    [self sizeToFit];
}


//------------- handle event  ------------------
- (void)setOnItemClickDelegate:(id<OnItemClickDelegate>)itemClickDelegate
{
    [self setItemClickDelegate:itemClickDelegate];
}

#pragma mark-
- (void)setCellNameS:(NSString *)cellName
{
    self.cellName = cellName;
    self.cellLayoutName = cellName;
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ECListViewCell *cell = (ECListViewCell *)[[[NSBundle mainBundle] loadNibNamed:self.cellLayoutName owner:self options:nil] lastObject];
    [cell setData:[_dataList objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!_listViewCellHeight) {
        _listViewCellHeight = [NSMutableDictionary new];
    }
    if (![_listViewCellHeight valueForKey:self.cellLayoutName]) {
        ECListViewCell *cell = (ECListViewCell *)[[[NSBundle mainBundle] loadNibNamed:self.cellLayoutName owner:self options:nil] lastObject];
        [_listViewCellHeight setValue:[NSString stringWithFormat:@"%f",cell.frame.size.height] forKey:self.cellLayoutName];
    }
    
    
    return [[_listViewCellHeight valueForKey:self.cellLayoutName] integerValue];
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_itemClickDelegate != nil) {
        [_itemClickDelegate onItemClick:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    }
    
    //
    [self.pageContext dispatchJSEvetn:[NSString stringWithFormat:@"%@.%@",self.controlId,kOnItemClick] withParams:@{@"position":[NSNumber numberWithInteger:indexPath.row]}];
}
#pragma judge TableCell named self.cellLayoutName isExist
- (BOOL) isCellExistForName:(NSString *)cellname
{
    if (!cellname) {
        ECLog(@"Cell' name is nil , set default cell ... (WidgetListViewItemTwoLine)");
        self.cellLayoutName = @"WidgetListViewItemTwoLine";
    }
    @try {
        [[[NSBundle mainBundle] loadNibNamed:self.cellLayoutName owner:self options:nil] lastObject];
        return true;
    }
    @catch (NSException *exception) {
        ECLog(@"Cell named %@ is not found ...",self.cellLayoutName);
        self.cellLayoutName = @"WidgetListViewItemTwoLine";
        ECLog(@"Set default cell ... (WidgetListViewItemTwoLine)");
        return false;
    }
}

@end
