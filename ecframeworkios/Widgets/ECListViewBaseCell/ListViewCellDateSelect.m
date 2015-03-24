//
//  ListViewCellColumn.m
//  IOSProjectTemplate
//
//  Created by ecloud_mbp on 15/2/28.
//  Copyright (c) 2015年 ECloud. All rights reserved.
//

#import "ListViewCellDateSelect.h"
#import "PureLayout.h"
#import "ECBaseViewController.h"
#import "UIColorExtends.h"
#import "ECViewUtil.h"

@implementation ListViewCellDateSelect


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];
    }
    
    return self;
}

- (void)awakeFromNib
{
    
}

- (void)setData:(NSDictionary *)data
{
    [super setData:data];
    [self.collectionView setBackgroundColor:[UIColor colorWithHexString:@"FFFFFFFF"]];
    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    //注册Cell，必须要有
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    
}
+ (CGFloat)heightForData:(NSDictionary *)data
{
    // 使用xib的时候尽量用 autolayout
//    return (int) (([data[@"items"] count] + 4)/5)*80+10;
    return  50;
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.data[@"items"] count];
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"UICollectionViewCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFFFF"];
    
//    NSLog(@"%@",self.data[@"items"][indexPath.row][@"date"][@"dateTime"]);
    //添加文字
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, 36, 15)];
    label.font = [UIFont fontWithName:@"Heiti SC" size:12];
    label.textColor = [UIColor blackColor];
    label.text =  self.data[@"items"][indexPath.row][@"date"][@"week"];//week
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor colorWithHexString:@"FFFFFFFF"];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 17, 36, 15)];
    label2.font = [UIFont fontWithName:@"Heiti SC" size:12];
    label2.textColor = [UIColor blackColor];
    label2.text =  self.data[@"items"][indexPath.row][@"date"][@"dateTime"];//week
    label2.textAlignment = NSTextAlignmentCenter;
    label2.backgroundColor = [UIColor colorWithHexString:@"FFFFFFFF"];

    [cell.contentView addSubview:label];
    [cell.contentView addSubview:label2];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(36, 35);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    NSLog(@"item======%d",indexPath.item);
    //    NSLog(@"row=======%d",indexPath.row);
    //    NSLog(@"section===%d",indexPath.section);
    NSString *actionType = @"dateSelect";
    [self.parent.pageContext dispatchJSEvetn:[NSString stringWithFormat:@"%@.%@",self.parent.controlId,@"onItemInnerClick"]
                                  withParams:@{@"offset":[NSNumber numberWithInteger:indexPath.row-3],@"target":actionType}];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//分割线  默认添加下分割线。
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    //上分割线，
    CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:@"#EAEAEA"].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, rect.size.width, 1));
    
    //    下分割线
    CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:@"#EAEAEA"].CGColor);
    CGContextFillRect(context, CGRectMake(0, rect.size.height-1, rect.size.width, 1));
}
@end
