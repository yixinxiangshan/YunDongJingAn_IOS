//
//  ECItemNewsWidget.h
//  ECDemoFrameWork
//
//  Created by EC on 9/3/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECBaseWidget.h"
#import "ECClickDelegate.h"

@interface ECItemNewsWidget : ECBaseWidget

@property (strong, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (strong, nonatomic) id<OnClickDelegate> clickDelegate;

- (void)setOnClickDelegate:(id<OnClickDelegate>)clickDelegate;

@end
