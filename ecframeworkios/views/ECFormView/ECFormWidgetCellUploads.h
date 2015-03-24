//
//  ECFormWidgetCellUploads.h
//  ECDemoFrameWork
//
//  Created by cheng on 14-1-9.
//  Copyright (c) 2014年 EC. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ECFormWidgetCellUploads_SelectButton_Image @"ECFormWidgetCellUploads_SelectButton_Image.png"
#define ECFormWidgetCell_Background [UIColor colorWithRed:1.00 green:1.00 blue:0.96 alpha:1.00]

typedef void(^ECFormWidgetUploadsDoneBlock)(NSArray* imageFiles);

@interface ECFormWidgetCellUploads : UIScrollView

- (instancetype) initWithDefault:(NSArray *)defaults DoneBlock:(ECFormWidgetUploadsDoneBlock)doneBlock;
@end

@interface UIImageView (Browser) <UIScrollViewDelegate>

- (void) glanceFullScreen;
@end