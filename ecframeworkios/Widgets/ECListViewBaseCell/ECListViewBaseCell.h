//
//  ECSTableViewCell.h
//  ECS DevelopKit
//
//  Created by LittoCats on 9/3/14.
//  Copyright (c) 2014 Littocats. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECListViewBase.h"


@interface ECListViewBaseCell : UITableViewCell
/**
 *  @ tableView refresh data 时传给 cell 的需要更新的数据
 */
@property (nonatomic, strong) NSDictionary *data;
@property (strong, nonatomic) ECListViewBase* parent;
@property (readwrite, assign) NSInteger position;
@end
