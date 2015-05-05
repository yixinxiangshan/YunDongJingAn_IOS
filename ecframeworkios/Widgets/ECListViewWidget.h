//
//  ECListViewWidget.h
//  ECDemoFrameWork
//
//  Created by EC on 9/3/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECBaseWidget.h"
#import "ECItemClickDelegate.h"
#import "ECLoadMoreDelegate.h"
#import "ECRefreshDelegate.h"
#import "ECBasePullRefreshWidget.h"

@interface ECListViewWidget : ECBasePullRefreshWidget 

@property (weak, nonatomic) IBOutlet UITableView *listView;

- (id)initWithConfigDic:(NSDictionary*)configDic pageContext:(ECBaseViewController*)pageContext;

- (void)setOnItemClickDelegate:(id<OnItemClickDelegate>)itemClickDelegate;
@end
