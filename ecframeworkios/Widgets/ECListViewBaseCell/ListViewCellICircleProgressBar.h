//
//  ListViewCellICircleProgressBar.h
//  IOSProjectTemplate
//
//  Created by Zongzhan on 10/31/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import "UIImageView+Size.h"
#import "ECListViewBaseCell.h"
#import "EFCircularSlider.h"
#import "ECListViewBase.h"

@interface ListViewCellICircleProgressBar : ECListViewBaseCell<ECListViewCellProtocol>

@property (nonatomic, strong) EFCircularSlider *progressBar;
@property (weak, nonatomic) IBOutlet UIButton *imageLeftBtn;
@property (weak, nonatomic) IBOutlet UIButton *imageRightBtn;
@property (weak, nonatomic) IBOutlet UIImageView *rightText_notice;
@property (weak, nonatomic) IBOutlet UILabel *progressBarTitleText;
@property (weak, nonatomic) IBOutlet UILabel *progressBarInnerText;
@property (weak, nonatomic) IBOutlet UIButton *rightText;

@property (weak, nonatomic) IBOutlet UIImageView *_bottomDivider;
@end
