//
//  ListViewCellDatePicker.h
//  IOSProjectTemplate
//
//  Created by Zongzhan on 11/5/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import "ECListViewBaseCell.h"

@interface ListViewCellDatePicker : ECListViewBaseCell<ECListViewCellProtocol>
@property (weak, nonatomic) IBOutlet UIDatePicker *picker;
@end
