//
//  ListViewCellFixedTitle.h
//  IOSProjectTemplate
//
//  Created by Zongzhan on 11/25/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import "ECListViewBaseCell.h"
#import "ECListViewBase.h"
@interface ListViewCellArticle : ECListViewBaseCell<ECListViewCellProtocol>
@property (weak, nonatomic) IBOutlet UILabel *title;

@end


