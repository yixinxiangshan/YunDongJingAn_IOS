//
//  WidgetGridItem.h
//  ECDemoFrameWork
//
//  Created by EC on 9/17/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECImageView.h"
#import "UIImageView+Size.h"

@interface WidgetGridItem : UICollectionViewCell

@property (nonatomic, strong) NSString* viewId;
@property (nonatomic, weak) IBOutlet UILabel* title;
@property (nonatomic, weak) IBOutlet ECImageView* image;
@property (nonatomic, strong) NSDictionary* dataDic;

- (void) setData:(NSDictionary*)dataDic;
- (void) setRatioHToW:(float)ratioHToW;
//use when use register identifier with class
- (void) setRatioHToW:(float)ratioHToW cellColumn:(int)cellColumn cellPadding:(float)cellPadding;

@end
