//
//  ECButtonWidget.h
//  NowMarry
//
//  Created by cheng on 13-12-9.
//  Copyright (c) 2013年 ecloud. All rights reserved.
//

#import "ECBaseWidget.h"
#import "ECButton.h"
#import "ECButtonClickDelegate.h"

@interface ECButtonWidget : ECBaseWidget

@property (strong, nonatomic) IBOutlet ECButton *button;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* titleClicked;
@property (strong, nonatomic) UIImage* backgroundImage;
@property (strong, nonatomic) UIImage* backgroundImageClicked;

@property (strong, nonatomic) id<onButtonClickDelegate> buttonClickDelegate;


@end
