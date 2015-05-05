//
//  ECImagePickerController.h
//  ECIOSProject
//
//  Created by cheng on 14-1-23.
//  Copyright (c) 2014年 ecloud. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  imageInfo:  [
 *                  {
 *                      "imageFile":"",
 *                      "imageRemotePath":"",
 *                      "image":"",
 *                      "imageView":""
 *                  },
 *                  {
 *                  }
 *              ]
 *  imageInfo 为 NSMutableArray，内容为 NSMutableDictionary,可在委托或block中操作
 */
typedef void(^ECImagePickDidSelect)(NSMutableDictionary* imageInfo);
typedef void(^ECImagePickerDidDoneSelect)(NSMutableArray *imageInfos);
typedef void(^ECImagePickDidCancel)();

@interface ECImagePickerController : UIImagePickerController

/**
 *  选择或拍下一张照片时
 */
@property (nonatomic, copy) ECImagePickDidSelect       didSelect;

/**
 *  按下完成（对号、使用）按钮时
 */
@property (nonatomic, copy) ECImagePickerDidDoneSelect didDoneSelect;

/**
 *  按下返回（取消）按钮时
 */
@property (nonatomic, copy) ECImagePickDidCancel       didCancel;

- (id) initWithImageInfo:(NSMutableArray *)imageInfo;
@end

@interface UIView (ECImagePickerActivity)
- (void) showActivity;
- (void) cancelActivity;
@end