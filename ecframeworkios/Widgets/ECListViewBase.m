//
//  ECListViewBase.m
//  IOSProjectTemplate
//
//  Created by Zongzhan on 9/11/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import "ECListViewBase.h"
#import "ECJSConstants.h"
#import "ECBaseViewController.h"
#import "NSStringExtends.h"
#import "UIColorExtends.h"
#import "ECViewUtil.h"
#import "UITableViewCell+DelaysContentTouches.h"
#import "Constants.h"

@interface ECListViewBase ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) NSDictionary* formContent;

@end

@implementation ECListViewBase

- (id)initWithConfigDic:(NSDictionary*)configDic pageContext:(ECBaseViewController*)pageContext{
    //    ECLog(@"initWithConfigDic......... %@",configDic);
    self = [super initWithConfigDic:configDic pageContext:pageContext];
    if (!self.formContent) {
        self.formContent = [NSMutableDictionary new];
    }
    if (self) {
        //        [[NSBundle mainBundle] loadNibNamed:self.layoutName owner:self options:nil];
        self.listView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.listView setSeparatorInset:UIEdgeInsetsZero];
        self.listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.listView setSeparatorInset:UIEdgeInsetsZero];
        //        // 设置去掉separator左边默认的空间
        //        if ([self.listView respondsToSelector:@selector(setSeparatorInset:)])
        //            [self.listView setSeparatorInset:UIEdgeInsetsZero];
        //        if ([self.listView respondsToSelector:@selector(setLayoutMargins:)])
        //            [self.listView setLayoutMargins:UIEdgeInsetsZero];
        
        // 解决IOS8下按钮状态响应慢的问题
        self.listView.delaysContentTouches = NO;
        if ([UIDevice currentDevice].systemVersion.intValue >= 8) {
            for (UIView *currentView in self.listView.subviews) {
                if ([currentView isKindOfClass:[UIScrollView class]]) {
                    ((UIScrollView *)currentView).delaysContentTouches = NO;
                    // ((UIScrollView *)currentView).panGestureRecognizer.delaysTouchesBegan = NO;
                    break;
                }
            }
        }
        
        [self addSubview:_listView];
        
        
        // [self.listView setBackgroundColor:[UIColor colorWithHexString:@"#f5f5f5"]];
        _listView.translatesAutoresizingMaskIntoConstraints = NO;
        
        //        self.frame.size.width = 100.0;
        //        CGRect tableViewFrame = self.listView.frame;
        //        tableViewFrame.size.width = 20;
        //        self.frame = tableViewFrame;
        
        //        CGRect frame = ctrl.view.frame;
        //        frame.size.width = 320;
        //        [ctrl.view setFrame:frame];
        //        _listView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.85];
        
        //        CGRect tableViewFrame = self.listView.frame;
        //        NSLog(@"ECListViewBase tableViewFrame.size.width: %f" , tableViewFrame.size.width);
        //        tableViewFrame.size.width = 200;
        //        self.listView.frame = tableViewFrame;
        //        NSLog(@"ECListViewBase tableViewFrame.size.width: %f" , tableViewFrame.size.width);
        //        [self setBackgroundColor:[UIColor blackColor]];
        
        //让 tableview 大小跟随 self 大小
        //        origin
        //        [self addConstraint:[NSLayoutConstraint constraintWithItem:_listView
        //                                                         attribute:NSLayoutAttributeLeft
        //                                                         relatedBy:NSLayoutRelationEqual
        //                                                            toItem:self
        //                                                         attribute:NSLayoutAttributeLeft
        //                                                        multiplier:1
        //                                                          constant:0]];
        //        [self addConstraint:[NSLayoutConstraint constraintWithItem:_listView
        //                                                         attribute:NSLayoutAttributeTop
        //                                                         relatedBy:NSLayoutRelationEqual
        //                                                            toItem:self
        //                                                         attribute:NSLayoutAttributeTop
        //                                                        multiplier:1
        //                                                          constant:0]];
        
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_listView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_listView)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_listView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_listView)]];
        
        
        [_listView setAutoresizingMask:UIViewAutoresizingNone];
        _listView.dataSource = self;
        _listView.delegate = self;
        
    }
    
    [self parsingConfigDic];
    
    // ECLog(@"initWithConfigDic dataDic : %@" , self.dataDic[@"data"]);
    self.insertType = 1;
    [self setHeaderAndFooter:_listView];
    // 设置tableview的高度，避免超出屏幕范围
    CGRect frm =[ UIScreen mainScreen ].applicationFrame;
    CGRect listFrame = self.frame;
    // NSLog(@"listViewBase: setHeight self.frame.size.height : %f" , self.frame.size.height);
    // NSLog(@"listViewBase: setHeight frm.origin.y : %f" , frm.origin.y);
    // NSLog(@"listViewBase: setHeight frm.size.height : %f" , frm.size.height);
    
    //    ECLog(@"data_bottom %@",self.dataDic[@"data"][@"hasFooterDivider"]);
    if (self.frame.size.height > frm.size.height - 44){
        listFrame.size.height = frm.size.height - 44;
        self.frame = listFrame;
    }
    
    //    NSLog(@"%@",configDic[@"datasource"][@"bottom_data"]);
//    if(configDic[@"datasource"][@"bottom_data"] != nil ){
//        if (self.frame.size.height > frm.size.height - 44-50){
//            listFrame.size.height = frm.size.height - 44-50;
//            self.frame = listFrame;
//        }
//        
//        // 添加button；
//        _button = [[UIButton alloc] initWithFrame:CGRectMake(10, listFrame.size.height, [[UIScreen mainScreen] bounds].size.width-20, 44)];
//        //        button.backgroundColor =[UIColor blueColor];
//        [ECViewUtil setTextButtonWithConfig:_button
//                                       data:@{@"backgroundColor": @"#6Ba0ff" , @"hlBackgroundColor": @"#6Ba0ff", @"borderColor": @"#6Ba0ff" , @"titleColor": @"#ffffff" , @"hlTitleColor": @"#000000" , @"cornerRadius": @"5" }];
//        //        button.tintColor = [UIColor whiteColor];
//        [_button setTitle:configDic[@"datasource"][@"bottom_data"][@"btnTitle"] forState:UIControlStateNormal];
//        //        [button setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
//        
//        //    [button addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchDown];
//        [_button setTag:1];
//        [_button addTarget:self action:@selector(buttonTaped:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_button];
//        
//    }
    return self;
}

- (void) setdata{
    //    ECLog(@"data");
    [super setdata];
    [_listView reloadData];
   
}

- (void) refreshWidgetData:(id)dataDic{
    NSDictionary *newDataDic = [dataDic isKindOfClass:[NSString class]] ? [dataDic JSONValue] : dataDic;
    
    //    ECLog(@"refreshWidgetData configDic:%@" , newDataDic);
    //    ECLog(@"refreshWidgetData dividerHeight:%@" , newDataDic[@"dividerHeight"]);
    //    设置listview separator
    //    if ([[newDataDic[@"dividerHeight"] stringValue] isEqual:@"0"]) {
    //        self.listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    }else{
    //        self.listView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //    }
    
    [super refreshWidgetData:newDataDic];
    [self doneLoadingTableViewData:_listView];
    [_button addTarget:self action:@selector(buttonTaped:) forControlEvents:UIControlEventTouchDown];
}

//刷新某个cell
- (void) refreshWidgetItem:(id)dataDic{
    NSDictionary *newDataDic = [dataDic isKindOfClass:[NSString class]] ? [dataDic JSONValue] : dataDic;
    [self.dataDic[@"data"] setObject:newDataDic[@"data"] atIndex:[newDataDic[@"position"] intValue]];
    [self.listView beginUpdates];
    NSIndexPath* indexPath1 = [NSIndexPath indexPathForRow:[newDataDic[@"position"] intValue] inSection:0];
    [self.listView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath1, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.listView endUpdates];
}

//刷新某组cell
- (void) refreshWidgetItems:(id)dataDic{
    // NSLog(@"refreshWidgetItems : %@" , self);
    NSMutableArray *newDataDic = [dataDic isKindOfClass:[NSString class]] ? [dataDic JSONValue] : dataDic;
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    
    for (NSDictionary* item in newDataDic) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:[item[@"position"] intValue] inSection:0]];
        [self.dataDic[@"data"] setObject:item[@"data"] atIndex:[item[@"position"] intValue]];
    }
    
    [self.listView beginUpdates];
    [self.listView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    //[self.listView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath1, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.listView endUpdates];
}
- (void)setFormInput:(NSString*)key NSString:(NSString*)value{
    [self.formContent setValue:value forKey:key];
}
- (NSDictionary *)getFormData{
    return self.formContent;
}

#pragma mark- delegate datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataDic[@"data"] count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *cellData = self.dataDic[@"data"][indexPath.row];
    NSString *cellType = cellData[@"viewType"];
    
    Class cellClass = NSClassFromString(cellType);
    UITableViewCell *cell = [_listView dequeueReusableCellWithIdentifier:cellType];
    if (!cell) {
        if ([[NSBundle mainBundle] pathForResource:cellType ofType:@"nib"]) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(cellClass)
                                                  owner:nil options:nil] lastObject];
        }else
            cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellType];
    }
    [cell setDelaysContentTouches:NO]; // 解决IOS7下按钮状态响应慢的问题
    
    //    NSLog(@"ECListViewBase cellForRowAtIndexPath %@:" , self.controlId);
    //    设置父控件，当前位置，然后启动cell
    [(id<ECListViewCellProtocol>)cell setParent:self];
    [(id<ECListViewCellProtocol>)cell setPosition:indexPath.row];
    [(id<ECListViewCellProtocol>)cell setData:cellData];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    // 设置去掉separator左边默认的空间
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        [cell setSeparatorInset:UIEdgeInsetsZero];
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        [cell setLayoutMargins:UIEdgeInsetsZero];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    return 60;
    NSDictionary *cellData = self.dataDic[@"data"][indexPath.row];
    NSString *cellType = cellData[@"viewType"];
    
    Class cellClass = NSClassFromString(cellType);
    // ECLog(@"tableView cellData : %@" , cellData);
    if (![cellClass conformsToProtocol:@protocol(ECListViewCellProtocol)]) {
        ECLog(@"cell for type : %@ not exist." , cellType);
        //        @throw [[NSException alloc] initWithName:@"ECListViewBase"
        //                                          reason:[[NSString alloc] initWithFormat:@"cell for type : %@ not exist.",cellType]
        //                                        userInfo:nil];
    }
    
    UITableViewCell *cell = [_listView dequeueReusableCellWithIdentifier:cellType];
    if (!cell) {
        if ([[NSBundle mainBundle] pathForResource:cellType ofType:@"nib"]) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(cellClass) owner:nil options:nil] lastObject];
        }else
            cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:cellType];
    }
    //    - (void)setParent:(ECListViewBase *)parent;
    //    计算高度
    CGFloat height = [(id<ECListViewCellProtocol>)cellClass heightForData:cellData];
    if(height > 0){
        return height;
    }
    if ([[NSBundle mainBundle] pathForResource:cellType ofType:@"nib"]) {
        [(id<ECListViewCellProtocol>)cell setData:cellData];
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        //        NSLog(@"ECListViewBase heightForRowAtIndexPath %f:" , size.height);
        return size.height;
    }else{
        return height;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.pageContext dispatchJSEvetn:[NSString stringWithFormat:@"%@.%@",self.controlId,kOnItemClick]
                           withParams:@{@"position":[NSNumber numberWithInteger:indexPath.row]}];
}

// 按钮被点击
//-(void)buttonTaped:(id)sender
//{
//    NSLog(@"buttonTaped");
//    NSString *actionType = @"";
//    UIButton *button = (UIButton*) sender;
//    switch (button.tag) {
//        case 1:
//            actionType = @"button1";
//            break;
//        default:
//            actionType = @"button1";
//            break;
//    }
//    [self.pageContext dispatchJSEvetn:[NSString stringWithFormat:@"%@.%@",self.controlId,@"onItemInnerClick"]
//                           withParams:@{@"position":[NSNumber numberWithInteger:self.position],@"target":actionType ,@"_form":[self getFormData]}];
//}

@end
