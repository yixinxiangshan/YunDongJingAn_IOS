//
//  ECListViewCell.h
//  ECDemoFrameWork
//
//  Created by cww on 13-9-12.
//  Copyright (c) 2013年 EC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECListViewCell : UITableViewCell

/**
 * dataSource 为 listView 数据源中的一条
 * 包含的字段
 * @parm    iconName
 * @parm    title
 * @parm    subTitle
 * @parm    content
 * @parm    time
 * 
 * 适配器中设置的其它字段
 */
@property (strong, nonatomic) NSDictionary* dataSource;
@property (strong, nonatomic) NSString* ID;
-(void) setData:(NSDictionary *)data;

/**
 * 该方法设置Cell数据，子类需实现该方法
 */
- (void) setData;
@end
