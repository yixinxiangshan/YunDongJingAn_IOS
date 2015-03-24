//
//  ListViewCellColumn.h
//  IOSProjectTemplate
//
//  Created by ecloud_mbp on 15/2/28.
//  Copyright (c) 2015年 ECloud. All rights reserved.
//

#import "ECListViewBaseCell.h"

@interface ListViewCellColumn:ECListViewBaseCell<ECListViewCellProtocol,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end
