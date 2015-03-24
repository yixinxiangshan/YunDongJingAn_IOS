//
//  ListViewCellArticle.h
//  IOSProjectTemplate
//
//  Created by Zongzhan on 11/4/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import "ECListViewBaseCell.h"

@interface ListViewCellArticleTitle : ECListViewBaseCell<ECListViewCellProtocol>
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@end
