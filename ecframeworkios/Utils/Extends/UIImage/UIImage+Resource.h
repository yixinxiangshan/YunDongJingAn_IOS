//
//  UIImage+Resource.h
//  ECIOSProject
//
//  Created by 程巍巍 on 3/18/14.
//  Copyright (c) 2014 ecloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resource)
/**
 *  @param path 相对路径，优先搜索mainbundle,若不存在，则读取 用户资源文件夹
 */
+ (UIImage *) imageWithPath:(NSString *)path;
@end
