//
//  ECGroupWidget.h
//  ECDemoFrameWork
//
//  Created by EC on 10/24/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECBasePullRefreshWidget.h"

@interface ECGroupWidget : ECBasePullRefreshWidget <UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *groupView;

- (id)initWithConfigDic:(NSDictionary*)configDic pageContext:(ECBaseViewController*)pageContext;

@end
