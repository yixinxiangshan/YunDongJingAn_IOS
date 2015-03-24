//
//  ListViewCellLine.h
//  IOSProjectTemplate
//
//  Created by Zongzhan on 9/11/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import "ECListViewBaseCell.h"
#import "ECListViewBase.h"
#import "UIImageView+Size.h"

@interface ListViewCellLine : ECListViewBaseCell<ECListViewCellProtocol>

@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UILabel *centerTitle;
@property (weak, nonatomic) IBOutlet UILabel *centerRightdes;
@property (weak, nonatomic) IBOutlet UILabel *centerBottomdes;
@property (weak, nonatomic) IBOutlet UILabel *centerBottomdes2;
@property (weak, nonatomic) IBOutlet UILabel *centerRighttopdes;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;

@property (weak, nonatomic) IBOutlet UIImageView *_bottomDivider;

@end
