//
//  ECNewsTwoLineCell.h
//  JingAnWeekly
//
//  Created by EC on 3/18/13.
//  Copyright (c) 2013 ecloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECListViewCell.h"
#import "UIImageView+Size.h"

@interface WidgetListViewItemTwoLine : ECListViewCell
/**
 *  WidgetListViewItemTwoLine
 *  @image
 *  @title
 *  @content
 *  @time
 */
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@end
