//
//  ListViewCellDateSelect.h
//  IOSProjectTemplate
//
//  Created by ecloud_mbp on 15/3/9.
//  Copyright (c) 2015年 ECloud. All rights reserved.
//
#import "ECListViewBaseCell.h"

@interface ListViewCellDateSelect:ECListViewBaseCell<ECListViewCellProtocol,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end
