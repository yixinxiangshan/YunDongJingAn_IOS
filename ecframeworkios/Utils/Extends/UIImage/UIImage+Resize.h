//
//  UIImage+Resize.h
//  jinganledongtiyu
//
//  Created by cheng on 13-11-21.
//  Copyright (c) 2013年 eCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (Resize)

/**
 *  缩放至指定宽高
 */
- (UIImage *) fitToSize:(CGSize)size;

/**
 *  按比例缩放至宽度
 */
- (UIImage *) fitToWidth:(float)width;
/**
 *  按比例缩放至高度
 */
- (UIImage *) fitToHeight:(float)height;
@end
