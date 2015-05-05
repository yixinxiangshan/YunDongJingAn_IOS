//
//  ECGroupWidgetCell.h
//  NowMarry
//
//  Created by EC on 12/16/13.
//  Copyright (c) 2013 ecloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECImageView.h"

@interface ECGroupWidgetCell : UITableViewCell

@property (nonatomic, strong) NSString* viewId;
@property (nonatomic, weak) IBOutlet UILabel* title;
@property (nonatomic, weak) IBOutlet UILabel* subTitle;
@property (nonatomic, weak) IBOutlet UILabel* expand;
@property (nonatomic, weak) IBOutlet ECImageView* image;
@property (nonatomic, weak) IBOutlet ECImageView* arrow;
@property (nonatomic, strong) NSDictionary* dataDic;

-(void) setData:(NSDictionary *)data;

@end
