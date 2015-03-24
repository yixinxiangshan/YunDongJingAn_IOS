//
//  ListViewCellInputTextWithButton.h
//  IOSProjectTemplate
//
//  Created by ecloud_mbp on 15/2/4.
//  Copyright (c) 2015年 ECloud. All rights reserved.
//

#import "ECListViewBaseCell.h"

@interface ListViewCellSetting : ECListViewBaseCell<ECListViewCellProtocol>
//editText
@property (weak, nonatomic) IBOutlet  UILabel *title;
@property (weak, nonatomic) IBOutlet  UILabel *description1;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
@end