//
//  ECFormWidgetCellSelect.h
//  ECDemoFrameWork
//
//  Created by cheng on 14-1-9.
//  Copyright (c) 2014年 EC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ECFormWidgetCellSelectDoneBlock)(NSDictionary* dataSource, NSArray* position);

@interface ECFormWidgetCellSelect : UIView

@property (strong, nonatomic) NSString * dataKey;
@property (strong, nonatomic) NSString * titleKey;
@property (strong, nonatomic) NSString * valueKey;

- (instancetype) initWith:(NSDictionary *)dataSource selectDoneBlock:(ECFormWidgetCellSelectDoneBlock)doneBlock;

- (void) setDataKey:(NSString *)dataKey titleKey:(NSString *)titleKey valueKey:(NSString *)valueKey;
- (void) resetKeys;

- (void) setTitle:(NSString *)title;
- (void) show;
@end
