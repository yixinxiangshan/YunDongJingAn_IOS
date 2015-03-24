//
//  ListViewCellButton.h
//  IOSProjectTemplate
//
//  Created by Zongzhan on 11/4/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import "ECListViewBaseCell.h"

@interface ListViewCellButton : ECListViewBaseCell<ECListViewCellProtocol>
@property (weak, nonatomic) IBOutlet UIButton *button;
@end
