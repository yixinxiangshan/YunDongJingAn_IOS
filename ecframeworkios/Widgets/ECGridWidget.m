//
//  ECGridWidget.m
//  ECDemoFrameWork
//
//  Created by EC on 9/16/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECGridWidget.h"
#import "NSDictionaryExtends.h"
#import "NSStringExtends.h"
#import "Constants.h"
#import "ECListViewCell.h"
#import "ECReflectionUtil.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "WidgetGridItem.h"
#import "ECViewUtil.h"
#import "ECWidgetUtil.h"
#import "ECDataUtil.h"
#import "NSArrayExtends.h"
#import "ECItemClickDelegate.h"
#import "UIColorExtends.h"
#import "ECJSUtil.h"

@interface ECGridWidget () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, assign) int cellColumn;
@property (nonatomic, assign) float cellPadding;
@property (nonatomic, assign) float ratioHToW;
@property (nonatomic, assign) CellStyle cellStyle;
@property (strong, nonatomic) NSMutableArray* dataList;
@property (nonatomic, strong) id<OnItemClickDelegate> itemClickDelegate;
@end

@implementation ECGridWidget

- (id)initWithConfigDic:(NSDictionary*)configDic pageContext:(ECBaseViewController*)pageContext{
    self = [super initWithConfigDic:configDic pageContext:pageContext];
    [self parsingLayoutName];
    if (self.layoutName == nil || [self.layoutName isEmpty]) {
        self.layoutName = @"ECGridWidget";
    }
    if (self.cellLayoutName == nil || [self.cellLayoutName isEmpty]) {
        self.cellLayoutName = @"WidgetGridItem";
    }
    if ([self.controlId isEmpty]) {
        self.controlId = @"grid_widget";
    }
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:self.layoutName owner:self options:nil];
        [self setViewId:@"gird_widget"];
        [self addSubview:_gridview];
        
        [_gridview setAutoresizingMask:UIViewAutoresizingNone];
        _gridview.dataSource = self;
        _gridview.delegate = self;
        [_gridview registerClass:[WidgetGridItem class] forCellWithReuseIdentifier:self.cellLayoutName];
        [_gridview setBackgroundColor:[UIColor colorWithHexString:@"#F2F3F3"]];
//        [_gridview registerNib:[UINib nibWithNibName:@"WidgetGridItem" bundle:nil] forCellWithReuseIdentifier:@"WidgetGridItem"];
//        [self createHeaderView];
//        [self setFooterView];
//        
//        [_gridview addObserver:self forKeyPath:@"frame" options:0 context:NULL];
        _cellColumn = 3;
        _cellPadding = 10.0f;
        _ratioHToW = 1.0;
        _cellStyle = Text_Connect;
    }
    [self parsingConfigDic];
    [self setHeaderAndFooter:_gridview];
    return self;
}

- (void) setdata{
    [super setdata];
    _dataList = [NSMutableArray arrayWithArray:[self.dataDic objectForKey:@"ListByType"]];
    [_gridview reloadData];
    [self sizeToFit];
}

- (void) refreshWidgetData:(NSDictionary*)dataDic{
    [super refreshWidgetData:dataDic];
    [self doneLoadingTableViewData:_gridview];
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
    [self doneLoadingTableViewData:_gridview];
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
    [_gridview reloadData];
    [self sizeToFit];
}

- (void)setOnItemClickDelegate:(id<OnItemClickDelegate>)itemClickDelegate{
    if (itemClickDelegate!= nil)
        _itemClickDelegate = itemClickDelegate;
}


#pragma mark collectionView datasource delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_dataList count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WidgetGridItem* cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellLayoutName forIndexPath:indexPath];
    NSDictionary* dic = [_dataList objectAtIndex:indexPath.row];
    [cell setData:dic];
    [cell setRatioHToW:_ratioHToW cellColumn:_cellColumn cellPadding:_cellPadding];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* dic = [_dataList objectAtIndex:indexPath.row];
    if (indexPath.row == 11) {
        ECLog(@"item data : %@",dic);
    }
    return [self calCellSize:dic];
}

#pragma mark - collectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* jsString = [NSString stringWithFormat:@"%@.onItemClick(\"{'controlId':'%@','position':'%ld'}\")",self.controlId,self.controlId,(long)indexPath.row];
    NSLog(@"ECButtonWidget onButtonClick : %@",jsString);
    NSString* result = [[ECJSUtil shareInstance] runJS:jsString];
    NSLog(@"ECButtonWidget onButtonClick : %@",result);
    
    if (![result boolValue]) {
        //执行委托
        if (_itemClickDelegate != nil) {
            [_itemClickDelegate onItemClick:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        }
    }
}


- (CGSize)calCellSize:(NSDictionary*)dic{
    float cellWidth = (validWidth()-_cellPadding*(_cellColumn+1))/_cellColumn;
    float cellHeight = cellWidth*_ratioHToW;
    NSString* title = [dic objectForKey:@"title"];
//    NSString* subTitle = [dic objectForKey:@"abstracts"];
    if (title && ![title isEmpty]) {
        cellHeight += 30;
    }
//    ECLog(@"calCellSize w = %f , h = %f",cellWidth,cellHeight);
    return CGSizeMake(cellWidth, cellHeight);
}

#pragma - mark getter & setter
- (void)setCellColumnS:(NSString*)cellColumnString{
    [self setCellColumn:cellColumnString.intValue];
}
@end
