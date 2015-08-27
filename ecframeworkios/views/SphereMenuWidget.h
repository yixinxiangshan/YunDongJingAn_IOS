//
//  SphereMenu.h
//  SphereMenu
//
//  Created by Theresa on 14-8-24.
//  Copyright (c) 2014年 TU YOU. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ECBaseWidget.h"
#import "Constants.h"

@protocol SphereMenuDelegate <NSObject>

- (void)sphereDidSelected:(int)index;

@end

@interface SphereMenu : ECBaseWidget

@property (weak, nonatomic) id<SphereMenuDelegate> delegate;

- (instancetype)initWithStartPoint:(CGPoint)startPoint
                        startImage:(UIImage *)startImage
                     submenuImages:(NSArray *)images;

@end
