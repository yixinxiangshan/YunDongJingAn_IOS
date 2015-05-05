//
//  UIAlertView+Block.m
//  ECDemoFrameWork
//
//  Created by cheng on 14-1-9.
//  Copyright (c) 2014年 EC. All rights reserved.
//

#import "UIAlertView+Block.h"

@interface Alert : NSOperation
@property (strong, nonatomic) NSString                           * title;
@property (strong, nonatomic) NSString                           * message;
@property (nonatomic, copy  ) AlertViewDismissWithCancelBlock    cancelBlock;
@property (nonatomic, copy  ) AlertViewDismissWithAscertainBlock ascertainBlock;
@end

@interface AlertView : UIAlertView
@property (strong, nonatomic) Alert* alert;
@end

@interface AlertUtil : NSObject <UIAlertViewDelegate>

@property (strong, nonatomic) AlertView        * alertView;
@property (strong, nonatomic) NSOperationQueue * alertQueue;
/**
 *  类方法
 */
//+ (void) showAlert:(NSString *)title
//           message:(NSString *)message
//    ascertainBlock:(AlertViewDismissWithAscertainBlock)ascertainBlock
//       cancelBlock:(AlertViewDismissWithCancelBlock)cancelBlock;
@end

@implementation UIAlertView (Block)
//+ (void) showAlert:(NSString *)message
//{
//    [self showAlert:nil message:message];
//}
//+ (void) showAlert:(NSString *)title
//           message:(NSString *)message
//{
//    [self showAlert:title message:message];
//}
//+ (void) showAlert:(NSString *)title
//           message:(NSString *)message
//    ascertainBlock:(AlertViewDismissWithAscertainBlock)ascertainBlock
//       cancelBlock:(AlertViewDismissWithCancelBlock)cancelBlock
//{
//    [AlertUtil showAlert:title message:message ascertainBlock:ascertainBlock cancelBlock:cancelBlock];
//}
@end


@implementation AlertUtil
+ (instancetype) shareInstance
{
    static AlertUtil* instance = nil;
    static dispatch_once_t onceTonken;
    dispatch_once(&onceTonken, ^(){
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (id) init
{
    self = [super init];
    if (self) {
        self.alertView = [[AlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        self.alertQueue = [[NSOperationQueue alloc] init];
        self.alertQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

#pragma mark-
//+ (void) showAlert:(NSString *)message
//{
//    Alert* alert = [[Alert alloc] init];
//    alert.message = message;
//    
//    [[[self shareInstance] alertQueue] addOperation:alert];
//}
//+ (void) showAlert:(NSString *)title
//           message:(NSString *)message
//{
//    Alert* alert = [[Alert alloc] init];
//    alert.title = title;
//    alert.message = message;
//    
//    [[[self shareInstance] alertQueue] addOperation:alert];
//}
//+ (void) showAlert:(NSString *)title
//           message:(NSString *)message
//    ascertainBlock:(AlertViewDismissWithAscertainBlock)ascertainBlock
//       cancelBlock:(AlertViewDismissWithCancelBlock)cancelBlock
//{
//    Alert* alert = [[Alert alloc] init];
//    alert.title = title;
//    alert.message = message;
//    alert.ascertainBlock = ascertainBlock;
//    alert.cancelBlock = cancelBlock;
//    
//    [[[self shareInstance] alertQueue] addOperation:alert];
//}

#pragma mark- UIAlertViewDelegate
- (void)alertView:(AlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            if (alertView.alert.cancelBlock) {
                alertView.alert.cancelBlock();
            }
            break;
        case 1:
            if (alertView.alert.ascertainBlock) {
                alertView.alert.ascertainBlock();
            }
            break;
        default:
            break;
    }
}
@end

@implementation Alert

- (void) main
{
    AlertView* alertView = [[AlertUtil shareInstance] alertView];
    
    [alertView setTitle:_title];
    [alertView setMessage:_message];
    alertView.alert = self;
    [alertView show];
}
@end

@implementation AlertView

@end