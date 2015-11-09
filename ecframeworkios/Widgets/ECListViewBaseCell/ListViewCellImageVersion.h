//
//  ListViewCellImage.h
//  IOSProjectTemplate
//
//  Created by Zongzhan on 11/5/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import "ECListViewBaseCell.h"

@interface ListViewCellImageVersion : ECListViewBaseCell<ECListViewCellProtocol>
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *version;
@end