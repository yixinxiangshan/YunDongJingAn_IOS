//
//  ECPopupSelView.h
//  JingAnWeekly
//
//  Created by EC on 3/22/13.
//  Copyright (c) 2013 ecloud. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ECECPopupSelectedDelegate <NSObject>

@required
- (void)selectedItemValue:(NSDictionary*)dic;
@end

@interface ECPopupSelView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSDictionary* dataSource;
@property (nonatomic, strong) NSMutableArray* dataList;
@property (nonatomic, strong) UILabel*     titleView;
@property (nonatomic, strong) UIControl*   overlayView;
@property (nonatomic, strong) UILabel* showView;
@property (nonatomic, strong) id <ECECPopupSelectedDelegate> selectedDelegate;

- (id)initWithData:(NSDictionary*)dataSource;
- (void)show;
- (void)dismiss;
- (void)setTitle:(NSString *)title;

@end
