//
//  ECBaseMultilevelMenu.m
//  ECPopViewTest
//
//  Created by 程巍巍 on 4/29/14.
//  Copyright (c) 2014 Littocats. All rights reserved.
//

#import "ECBaseMultilevelMenu.h"

@interface ECBaseMultilevelMenu () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *options;

@property (nonatomic, strong) NSString *tableCellIdentifier;

@property (nonatomic, strong) UIView *overlay;

@property (nonatomic, copy) void (^resultHandler)(NSDictionary *option);

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ECBaseMultilevelMenu

+ (ECBaseMultilevelMenu *)initWithOptions:(NSArray *)options resultHandler:(void (^)(NSDictionary *))resultHandler
{
    ECBaseMultilevelMenu *menu = [[ECBaseMultilevelMenu alloc] init];
    menu.options = options;
    menu.resultHandler = resultHandler;
    return menu;
}

#pragma mark- init
- (id)init
{
    self = [super init];
    if (self) {
        self.tableView = [[UITableView alloc] init];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableCellIdentifier = [NSString stringWithFormat:@"ECBaseMultilevelMenuTableCell_%i",arc4random()];
        
        [self addSubview:_tableView];
        self.overlay = [[UIView alloc] init];
        [_overlay setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.7]];
    }
    return self;
}

- (void)setOptions:(NSArray *)options
{
    _options = options;
    [_tableView reloadData];
}

#pragma mark-
- (void)pushNextLevel:(NSArray *)options
{
    //先移除现在的下级菜单
    for (UIView *subview in _overlay.subviews) {
        [subview removeFromSuperview];
    }
    //显示下级菜单
    ECBaseMultilevelMenu *menu = [ECBaseMultilevelMenu initWithOptions:options resultHandler:^(NSDictionary *option) {
        [self popAndCallBack:option];
    }];
    [_overlay setFrame:CGRectMake(64, 0, self.frame.size.width - 64, self.frame.size.height)];
    [_overlay setCenter:CGPointMake(_overlay.center.x + _overlay.frame.size.width, _overlay.center.y)];
    [menu setFrame:_overlay.bounds];
    
    [_overlay addSubview:menu];
    [self addSubview:_overlay];
    
    [UIView animateWithDuration:0.2
                     animations:^{
                        [_overlay setCenter:CGPointMake(_overlay.center.x - _overlay.frame.size.width, _overlay.center.y)];
                     } completion:^(BOOL finished) {
                         _overlay.alpha = 1.0;
                     }];
}

- (void)popAndCallBack:(NSDictionary *)option
{
    if (_resultHandler) {
        NSMutableArray *position = option[@"position"];
        if (!position) {
            position = [NSMutableArray new];
            [position addObject:[NSNumber numberWithInteger:_tableView.indexPathForSelectedRow.row]];
            option = @{@"position": position,@"option":option};
        }else{
            [position insertObject:[NSNumber numberWithInteger:_tableView.indexPathForSelectedRow.row] atIndex:0];
        }
        _resultHandler(option);
    }
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark-UITableViewDelegate , UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _options.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_tableCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_tableCellIdentifier];
    }
    
    NSDictionary *option = _options[indexPath.row];
    cell.textLabel.text = option[@"title"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *option = _options[indexPath.row];
    if (![option[@"options"] count]) {
        //没有下一级菜单，则返回结果
        [self popAndCallBack:option];
    }else{
        [self pushNextLevel:option[@"options"]];
    }
    
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [_tableView setFrame:self.bounds];
}
@end
