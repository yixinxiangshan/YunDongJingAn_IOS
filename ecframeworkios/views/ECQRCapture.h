//
//  ECQRCapture.h
//  NowMarry
//
//  Created by cheng on 13-12-6.
//  Copyright (c) 2013年 ecloud. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^QRCaptureBlock)(NSString* resultString);

@interface ECQRCapture : NSObject
/**
 *  QRCodeScanner 单例，
 */
+ (id) shareInstance;

/**
 *  启动扫描器
 */
+ (void) start;
+ (void) start:(QRCaptureBlock)block;

/**
 *  block,用于返回扫描结果
 */
@end
