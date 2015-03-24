//
//  ListViewCellTextWithButton.h
//  IOSProjectTemplate
//
//  Created by Zongzhan on 1/21/15.
//  Copyright (c) 2015 ECloud. All rights reserved.
//

#import "ECListViewBaseCell.h"
#import "ECListViewBase.h"

@interface ListViewCellTextWithButton : ECListViewBaseCell<ECListViewCellProtocol>

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIButton *button1;

@end
