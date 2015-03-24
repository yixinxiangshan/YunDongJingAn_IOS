//
//  ECSecondaryMenuWidget.m
//  ECDemoFrameWork
//
//  Created by cheng on 14-1-13.
//  Copyright (c) 2014年 EC. All rights reserved.
//

#import "ECSecondaryMenuWidget.h"
#import "NSStringExtends.h"
#import "ECBaseViewController.h"
#import "ECJSConstants.h"

#import "ECBaseMultilevelMenu.h"

@interface ECSecondaryMenuWidget ()

@property (nonatomic, strong) ECBaseMultilevelMenu *menuView;

@end

@implementation ECSecondaryMenuWidget

- (id)initWithConfigDic:(NSDictionary*)configDic pageContext:(ECBaseViewController*)pageContext{
    self = [super initWithConfigDic:configDic pageContext:pageContext];
    if ([self.controlId isEmpty]) {
        self.controlId = @"secondary_menu_widget";
    }
    if (self) {
        [self setViewId:@"secondary_menu_widget"];
        
    };
    [self parsingConfigDic];
    return self;
}

- (void)onItemClick:(NSDictionary *)option
{
    [self.pageContext dispatchJSEvetn:[NSString stringWithFormat:@"%@.%@",self.controlId,kOnItemClick] withParams:@{@"position": option[@"position"][0]}];
}


- (void)setDataDic:(NSDictionary *)dataDic
{
    [super setDataDic:dataDic];
    self.menuView = [ECBaseMultilevelMenu initWithOptions:dataDic[@"menuList"] resultHandler:^(NSDictionary *option) {
        [self onItemClick:option];
    }];
    [self addSubview:_menuView];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [_menuView setFrame:self.bounds];
}

- (void)willRemoveSubview:(UIView *)subview
{
    [subview willRemoveSubview:subview];
    [self removeFromSuperview];
}
@end


//@class SecondaryMenuTable;
//
//#define LeftAlgin 5
//
//typedef void(^TableDidSelectBlock)(SecondaryMenuTable* table ,NSDictionary* dataSource, NSInteger position);
//
//@interface SecondaryMenuTable : UITableView <UITableViewDataSource, UITableViewDelegate>
//
//@property (copy, nonatomic  ) TableDidSelectBlock didSelectBlock;
//@property (strong, nonatomic) NSArray             * data;
//
//- (instancetype) initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource didSelectBlock:(TableDidSelectBlock)didSelectBlock;
//
//@end
//
//@interface ECSecondaryMenuWidget ()
//
//@property (strong, nonatomic) NSDictionary* dataSource;
//@property (strong, nonatomic) NSMutableArray* sequence;
//
//@property (nonatomic, strong) UILabel*     titleView;
//@property (nonatomic, strong) UIControl*   overlayView;
//
//@property (nonatomic, strong) NSMutableArray* tables;
//
//@property (copy, nonatomic) TableDidSelectBlock didSelectBlock;
//
//@property (nonatomic) BOOL haveSubmenu;
//@end
//
//@implementation ECSecondaryMenuWidget
//
//- (id)initWithConfigDic:(NSDictionary*)configDic pageContext:(ECBaseViewController*)pageContext{
//    self = [super initWithConfigDic:configDic pageContext:pageContext];
//    if ([self.controlId isEmpty]) {
//        self.controlId = @"form_widget";
//    }
//    if (self) {
//        [self setViewId:@"form_widget"];
//        
//        self.tables = [NSMutableArray new];
//        self.sequence = [NSMutableArray new];
//        
//        // 初始化 block
//        __weak ECSecondaryMenuWidget *SELF = self;
//        self.didSelectBlock = ^(SecondaryMenuTable* table ,id dataSource, NSInteger position) {
//            //如果没有下一级菜单，则通过block 返回选择结果
//            NSArray* options = [dataSource objectForKey:dataKey];
//            if (!options || ![options isKindOfClass:[NSArray class]] || [options count] == 0) {
//                [SELF pullToTable:table animate:YES];
//                return ;
//            }
//            //弹出到当前 table
//            for (SecondaryMenuTable* t in SELF.tables) {
//                if ([t isEqual:table]) {
//                    [SELF pullToTable:table animate:YES];
//                    break;
//                }
//            }
//            //弹出新的 table
//            SecondaryMenuTable* newTable = [[SecondaryMenuTable alloc] initWithFrame:CGRectMake(0, 32.0f, SELF.frame.size.width, SELF.frame.size.width-32.0f)
//                                                            dataSource:[dataSource objectForKey:dataKey]
//                                                        didSelectBlock:SELF.didSelectBlock];
//            newTable.tag = (table.tag + 1) & 0x1111;
//            [SELF pushTable:newTable animate:YES];
//        };
//    }
//    [self parsingConfigDic];
//    
//    return self;
//}
//
//- (void) setdata{
//    [super setdata];
//    self.dataSource = [self.dataSource objectForKey:@"selectlist"];
//    [self.tables removeAllObjects];
//    UITableView* table = [[SecondaryMenuTable alloc] initWithFrame:CGRectMake(0, 32.0f, self.frame.size.width, self.frame.size.width-32.0f)
//                                                 dataSource:[self.dataSource objectForKey:dataKey]
//                                             didSelectBlock:self.didSelectBlock];
//    table.tag = 0;
//    [self pushTable:table animate:NO];
//}
//
//
//#pragma mark- 获取选择结果
//- (void)callDoneBlock
//{
//    NSArray* tables = [self.tables sortedArrayWithOptions:NSSortConcurrent
//                                          usingComparator:^NSComparisonResult(id obj1, id obj2) {
//                                              SecondaryMenuTable* tableOne = obj1;
//                                              SecondaryMenuTable* tableTwo = obj2;
//                                              return (tableOne.tag & 0x1111) < (tableTwo.tag & 0x1111) ? NSOrderedAscending : NSOrderedDescending; // 升序
//                                          }];
//    [self.sequence removeAllObjects];
//    for (SecondaryMenuTable* tabl in tables) {
//        [self.sequence addObject:[NSNumber numberWithInteger:tabl.tag>>5]];
//    }
//    
//    //TODO: 完成结果回调，根据要求的格式，从dataSource中按 sequence 的顺序取出数据，生成结果。
//}
//
//#pragma mark- 处理selectTable的布局
//- (void) pushTable:(UITableView *)tableView animate:(BOOL)animate
//{
////    NSInteger tablesCount = self.tables.count;
//    [self.tables addObject:tableView];
//    [self addSubview:tableView];
//    
//    [self layoutSubviews];
//    
////    UITableView* lastTable;
////    switch (tablesCount) {
////        case 0:
////            break;
////        case 1:
////            lastTable = [self.tables objectAtIndex:tablesCount-1];
////            [tableView setCenter:CGPointMake(self.frame.size.width - (self.frame.size.width-lastTable.frame.origin.x)/4, tableView.frame.size.height/2 + 32.0)];
////            break;
////        default:
////            lastTable = [self.tables objectAtIndex:tablesCount-1];
////            [lastTable setCenter:CGPointMake((self.frame.size.width-tablesCount*LeftAlgin)/2, tableView.frame.size.height/2 + 32.0)];
////            [tableView setCenter:CGPointMake(self.frame.size.width - (self.frame.size.width-lastTable.frame.origin.x)/4, tableView.frame.size.height/2 + 32.0)];
////            break;
////    }
//}
//- (void) pullTableWithAnimate:(BOOL)animate
//{
//    [[self.tables lastObject] removeFromSuperview];
//    [self.tables removeLastObject];
//    [self.sequence removeLastObject];
//    
//    [self layoutSubviews];
//    
////    NSInteger tablesCount = self.tables.count;
////    UITableView* lastTable;
////    UITableView* table = [self.tables lastObject];
////    
////    switch (tablesCount) {
////        case 1:
////            break;
////        default:
////            lastTable = [self.tables objectAtIndex:tablesCount-2];
////            [table setCenter:CGPointMake((self.frame.size.width-lastTable.frame.origin.x)/2, table.frame.size.height/2)];
////            break;
////    }
//}
//- (void) pullToTable:(UITableView *)tableView animate:(BOOL)animate
//{
//    if ([[self.tables lastObject] isEqual:tableView]) {
//        return;
//    }
//    [self pullTableWithAnimate:animate];
//    [self pullToTable:tableView animate:animate];
//}
//- (void) pullAllTables
//{
//    for (SecondaryMenuTable* table in self.subviews) {
//        if ([table isKindOfClass:[SecondaryMenuTable class]]) {
//            [table removeFromSuperview];
//        }
//    }
//}
//
//#pragma mark-
//- (void) layoutSubviews
//{
//    [super layoutSubviews];
//    for (int i = self.tables.count - 1; i >= 0; i --) {
//        CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
//        SecondaryMenuTable* table = [self.tables objectAtIndex:i];
//        table.frame = self.frame;
//        if (i > 0 && i != self.tables.count - 1) {
//            center.x += LeftAlgin * (i - 1) + (self.frame.size.width - LeftAlgin * (i - 1))/2;
//        }
//        center.x += LeftAlgin * (i - 1);
//        [table setCenter:center];
//    }
//}
//- (void) setFrame:(CGRect)frame
//{
//    [super setFrame:frame];
//    [self layoutSubviews];
//}
//
//
//#pragma mark- 
//- (void)setHaveSubMenuS:(NSString *)haveSubmenu
//{
//    self.haveSubmenu = [haveSubmenu boolValue];
//}
//@end
//
//
//@implementation SecondaryMenuTable
//
//- (instancetype) initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource didSelectBlock:(TableDidSelectBlock)didSelectBlock
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.data           = dataSource;
//        self.didSelectBlock = didSelectBlock;
//        self.dataSource     = self;
//        self.delegate       = self;
//    }
//    return self;
//}
//
//#pragma mark- delegate
//- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    self.tag = (self.tag & 0x1111) + (indexPath.row << 5);
//    if (self.didSelectBlock) {
//        self.didSelectBlock(self, [self.data objectAtIndex:indexPath.row], indexPath.row);
//    }
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 33.0;
//}
//
//- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.data.count;
//}
//- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell* cell;
//    NSString* indentifer = @"TableViewCell";
//    cell = [tableView dequeueReusableCellWithIdentifier:indentifer];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifer];
//    }
//    cell.textLabel.text = [[self.data objectAtIndex:indexPath.row] objectForKey:titleKey];
//    
//    return cell;
//}
//@end
