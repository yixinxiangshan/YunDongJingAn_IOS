//
//  ECNewsTwoLineCell.h
//  JingAnWeekly
//
//  Created by EC on 3/18/13.
//  Copyright (c) 2013 ecloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECListViewBaseCell.h"

@interface ListViewCellTwoLineText : ECListViewBaseCell<ECListViewCellProtocol>

@property (weak, nonatomic) IBOutlet UILabel *replyLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
