//
//  ListViewCellColumn.m
//  IOSProjectTemplate
//
//  Created by ecloud_mbp on 15/2/28.
//  Copyright (c) 2015年 ECloud. All rights reserved.
//

#import "ListViewCellColumn.h"
#import "PureLayout.h"
#import "ECBaseViewController.h"
#import "UIColorExtends.h"
#import "ECViewUtil.h"

@implementation ListViewCellColumn


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
    return (int) (([data[@"items"] count] + 4)/5)*80+10;
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
    cell.backgroundColor = [UIColor colorWithHexString:@"FFFFFFFF"];
    
    //添加文字
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 52, 52, 15)];
    label.font = [UIFont fontWithName:@"Heiti SC" size:12];
    label.textColor = [UIColor blackColor];
    label.text =  self.data[@"items"][indexPath.row][@"text"];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor colorWithHexString:@"FFFFFFFF"];
    //添加图片
    UIButton *imageBtn = [[UIButton alloc] initWithFrame:CGRectMake(2, 0, 40, 40)];
    [ECViewUtil getImageButtonByConfig:imageBtn config:self.data[@"items"][indexPath.row][@"imageModel"]];
    
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    [cell.contentView addSubview:imageBtn];
    [cell.contentView addSubview:label];
    [imageBtn setTag:indexPath.row];
    [imageBtn addTarget:self action:@selector(buttonTaped:) forControlEvents:UIControlEventTouchUpInside ];
    return cell;
}


#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(52, 70);
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
 UICollectionViewCell *selectedCell =  [collectionView  cellForItemAtIndexPath:indexPath];
//    selectedCell.backgroundColor = [UIColor colorWithHexString:@"FFFFFF00"];
//    selectedCell.subviews;
    //    NSLog(@"item======%d",indexPath.item);
    //    NSLog(@"row=======%d",indexPath.row);
    //    NSLog(@"section===%d",indexPath.section);
    NSString *actionType = @"cloumnItem";
    [self.parent.pageContext dispatchJSEvetn:[NSString stringWithFormat:@"%@.%@",self.parent.controlId,@"onItemInnerClick"]
                                  withParams:@{@"position":[NSNumber numberWithInteger:self.position],@"target":actionType ,@"columnName":self.data[@"items"][indexPath.row][@"text"]}];
}

// 按钮被点击
-(void)buttonTaped:(id)sender
{
    NSString *actionType = @"cloumnItem";
    UIButton *button = (UIButton*) sender;
    [self.parent.pageContext dispatchJSEvetn:[NSString stringWithFormat:@"%@.%@",self.parent.controlId,@"onItemInnerClick"]
                                  withParams:@{@"position":[NSNumber numberWithInteger:self.position],@"target":actionType ,@"columnName":self.data[@"items"][button.tag][@"text"]}];
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
