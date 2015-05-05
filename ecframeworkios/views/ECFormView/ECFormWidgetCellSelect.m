//
//  ECFormWidgetCellSelect.m
//  ECDemoFrameWork
//
//  Created by cheng on 14-1-9.
//  Copyright (c) 2014年 EC. All rights reserved.
//

#import "ECFormWidgetCellSelect.h"
#import "Utils.h"
#import "ECViewUtil.h"
#import <QuartzCore/QuartzCore.h>

@class SelectTable;

#define LeftAlgin 5


typedef void(^TableDidSelectBlock)(SelectTable* table ,NSDictionary* dataSource, NSInteger position);

@interface SelectTable : UITableView <UITableViewDataSource, UITableViewDelegate>

@property (copy, nonatomic  ) TableDidSelectBlock didSelectBlock;
@property (strong, nonatomic) NSArray             * data;

- (instancetype) initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource didSelectBlock:(TableDidSelectBlock)didSelectBlock;

@end

@interface ECFormWidgetCellSelect ()
@property (copy, nonatomic) ECFormWidgetCellSelectDoneBlock doneBlock;
@property (strong, nonatomic) NSDictionary* dataSource;
@property (strong, nonatomic) NSMutableArray* sequence;

@property (nonatomic, strong) UILabel*     titleView;
@property (nonatomic, strong) UIControl*   overlayView;

@property (nonatomic, strong) NSMutableArray* tables;

@property (copy, nonatomic) TableDidSelectBlock didSelectBlock;
@end

@implementation ECFormWidgetCellSelect
- (instancetype) initWith:(NSDictionary *)dataSource selectDoneBlock:(ECFormWidgetCellSelectDoneBlock)doneBlock
{
    self = [[self class] shareInstance];
    if (self) {
        self.doneBlock = doneBlock;
        self.dataSource = [dataSource objectForKey:@"selectlist"];
        
        self.tables = [NSMutableArray new];
        self.sequence = [NSMutableArray new];
        
        [self setTitle:[dataSource objectForKey:@"text"]];
    }
    return self;
}
- (void) setDataKey:(NSString *)dataKey titleKey:(NSString *)titleKey valueKey:(NSString *)valueKey
{
    self.dataKey  = dataKey;
    self.titleKey = titleKey;
    self.valueKey = valueKey;
}
- (void) resetKeys
{
    self.dataKey = self.titleKey = self.valueKey = nil;
}
#pragma mark- 获取选择结果
- (void)callDoneBlock
{
    NSArray* tables = [self.tables sortedArrayWithOptions:NSSortConcurrent
                                      usingComparator:^NSComparisonResult(id obj1, id obj2) {
                                          SelectTable* tableOne = obj1;
                                          SelectTable* tableTwo = obj2;
                                          return (tableOne.tag & 0x1111) < (tableTwo.tag & 0x1111) ? NSOrderedAscending : NSOrderedDescending; // 升序
                                      }];
    [self.sequence removeAllObjects];
    for (SelectTable* tabl in tables) {
        [self.sequence addObject:[NSNumber numberWithInteger:tabl.tag>>5]];
    }
    
    if (self.doneBlock) {
        self.doneBlock(self.dataSource,self.sequence);
    }
}

#pragma mark- 处理selectTable的布局
- (void) pushTable:(UITableView *)tableView animate:(BOOL)animate
{
    NSInteger tablesCount = self.tables.count;
    [self.tables addObject:tableView];
    [self addSubview:tableView];
    
    UITableView* lastTable;
    switch (tablesCount) {
        case 0:
            break;
        case 1:
            lastTable = [self.tables objectAtIndex:tablesCount-1];
            [tableView setCenter:CGPointMake(self.frame.size.width - (self.frame.size.width-lastTable.frame.origin.x)/4, tableView.frame.size.height/2 + 32.0)];
            break;
        default:
            lastTable = [self.tables objectAtIndex:tablesCount-1];
            [lastTable setCenter:CGPointMake((self.frame.size.width-tablesCount*LeftAlgin)/2, tableView.frame.size.height/2 + 32.0)];
            [tableView setCenter:CGPointMake(self.frame.size.width - (self.frame.size.width-lastTable.frame.origin.x)/4, tableView.frame.size.height/2 + 32.0)];
            break;
    }
}
- (void) pullTableWithAnimate:(BOOL)animate
{
    [[self.tables lastObject] removeFromSuperview];
    [self.tables removeLastObject];
    [self.sequence removeLastObject];
    
    NSInteger tablesCount = self.tables.count;
    UITableView* lastTable;
    UITableView* table = [self.tables lastObject];
    
    switch (tablesCount) {
        case 1:
            break;
        default:
            lastTable = [self.tables objectAtIndex:tablesCount-2];
            [table setCenter:CGPointMake((self.frame.size.width-lastTable.frame.origin.x)/2, table.frame.size.height/2)];
            break;
    }
}
- (void) pullToTable:(UITableView *)tableView animate:(BOOL)animate
{
    if ([[self.tables lastObject] isEqual:tableView]) {
        return;
    }
    [self pullTableWithAnimate:animate];
    [self pullToTable:tableView animate:animate];
}
- (void) pullAllTables
{
    for (SelectTable* table in self.subviews) {
        if ([table isKindOfClass:[SelectTable class]]) {
            [table removeFromSuperview];
        }
    }
}
#pragma mark- private
+ (instancetype) shareInstance
{
    static ECFormWidgetCellSelect* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(){
        instance = [[[self class] alloc] init];
    });
    return instance;
}
- (id) init
{
    self = [super initWithFrame:CGRectMake(10, (validHeight()-272.0)/2.0f, validWidth()-40.0f, 272.0f)];
    if (self) {
        [self defalutInit];
    }
    return self;
}
- (void)defalutInit
{
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 10.0f;
    self.clipsToBounds = TRUE;
    
    _titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleView.font = [UIFont systemFontOfSize:17.0f];
    _titleView.backgroundColor = [UIColor colorWithRed:59./255.
                                                 green:89./255.
                                                  blue:152./255.
                                                 alpha:1.0f];
    
    _titleView.textAlignment = NSTextAlignmentCenter;
    _titleView.textColor = [UIColor whiteColor];
    CGFloat xWidth = self.bounds.size.width;
    _titleView.lineBreakMode = NSLineBreakByTruncatingTail;
    _titleView.frame = CGRectMake(0, 0, xWidth, 32.0f);
    [self addSubview:_titleView];
    
    _overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _overlayView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
    
    [_overlayView addTarget:self
                     action:@selector(dismiss)
           forControlEvents:UIControlEventTouchUpInside];
    
    
    __weak ECFormWidgetCellSelect *SELF = self;
    self.didSelectBlock = ^(SelectTable* table ,id dataSource, NSInteger position) {
        //如果没有下一级菜单，则通过block 返回选择结果
        if (![dataSource isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        NSArray* options = [dataSource objectForKey:[SELF dataKey]];
        if (!options || ![options isKindOfClass:[NSArray class]] || [options count] == 0) {
            [SELF pullToTable:table animate:YES];
            [SELF fadeOut];
            return ;
        }
        //弹出到当前 table
        for (SelectTable* t in SELF.tables) {
            if ([t isEqual:table]) {
                [SELF pullToTable:table animate:YES];
                break;
            }
        }
        //弹出新的 table
        SelectTable* newTable = [[SelectTable alloc] initWithFrame:CGRectMake(0, 32.0f, SELF.frame.size.width, SELF.frame.size.width-32.0f)
                                                        dataSource:[dataSource objectForKey:SELF.dataKey]
                                                    didSelectBlock:SELF.didSelectBlock];
        newTable.tag = (table.tag + 1) & 0x1111;
        [SELF pushTable:newTable animate:YES];
    };
}
#pragma mark - show and dismiss
- (void)show
{
    !self.dataKey || !self.titleKey || !self.valueKey ? NSLog(@"%@ dataKey : %@ , titleKey : %@, valueKey : %@",self.class, self.dataKey, self.titleKey, self.valueKey) : nil;
    UITableView* table = [[SelectTable alloc] initWithFrame:CGRectMake(0, 32.0f, self.frame.size.width, self.frame.size.height-32.0f)
                                                 dataSource:[self.dataSource objectForKey:_dataKey]
                                             didSelectBlock:self.didSelectBlock];
    table.tag = 0;
    [self pushTable:table animate:NO];

    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:_overlayView];
    [keywindow addSubview:self];
    
    self.center = CGPointMake(keywindow.bounds.size.width/2.0f,
                              keywindow.bounds.size.height/2.0f);
    [self fadeIn];
}

- (void)dismiss
{
    [self fadeOut];
}

#pragma mark - animations

- (void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}
- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [_overlayView removeFromSuperview];
            [self removeFromSuperview];
            [self resetKeys];
            [self pullAllTables];
            [self callDoneBlock];
        }
    }];
}

- (void)setTitle:(NSString *)title
{
    _titleView.text = title;
}
@end

@implementation SelectTable

- (instancetype) initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource didSelectBlock:(TableDidSelectBlock)didSelectBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        self.data           = dataSource;
        self.didSelectBlock = didSelectBlock;
        self.dataSource     = self;
        self.delegate       = self;
    }
    return self;
}

#pragma mark- delegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tag = (self.tag & 0x1111) + (indexPath.row << 5);
    if (self.didSelectBlock) {
        self.didSelectBlock(self, [self.data objectAtIndex:indexPath.row], indexPath.row);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 33.0;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell;
    NSString* indentifer = @"TableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier:indentifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifer];
    }
    NSDictionary *cellDataSource = [self.data objectAtIndex:indexPath.row];
    cellDataSource = [cellDataSource isKindOfClass:[NSDictionary class]] ? cellDataSource : nil;
    cell.textLabel.text = [cellDataSource objectForKey:[[ECFormWidgetCellSelect shareInstance] titleKey]];
    
    return cell;
}
@end
