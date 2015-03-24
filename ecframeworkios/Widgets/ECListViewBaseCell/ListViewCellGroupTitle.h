//
//  ListViewCellGroupTitle.h
//  IOSProjectTemplate
//
//  Created by Zongzhan on 9/19/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import "ECListViewBaseCell.h"
#import "ECListViewBase.h"

@interface ListViewCellGroupTitle : ECListViewBaseCell<ECListViewCellProtocol>

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIView *cellContent;

@end
