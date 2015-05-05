//
//  UIAlertView+Block.h
//  ECDemoFrameWork
//
//  Created by cheng on 14-1-9.
//  Copyright (c) 2014年 EC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertViewDismissWithCancelBlock)();
typedef void(^AlertViewDismissWithAscertainBlock)();

@interface UIAlertView (Block)
/**
 *  类方法
// */
//+ (void) showAlert:(NSString *)message;
//+ (void) showAlert:(NSString *)title
//           message:(NSString *)message;
//+ (void) showAlert:(NSString *)title
//           message:(NSString *)message
//    ascertainBlock:(AlertViewDismissWithAscertainBlock)ascertainBlock
//       cancelBlock:(AlertViewDismissWithCancelBlock)cancelBlock;
@end
