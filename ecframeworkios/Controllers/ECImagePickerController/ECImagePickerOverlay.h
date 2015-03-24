//
//  ECImagePickerOverlay.h
//  ECIOSProject
//
//  Created by cheng on 14-1-23.
//  Copyright (c) 2014年 ecloud. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^ECImagePickerOverlayButtonClick)(UIButton* button);


@interface ECImagePickerOverlay : UIView
@property (weak, nonatomic) IBOutlet UIScrollView *imageGellary;

@property (weak, nonatomic) IBOutlet UIButton *shoot;               //tab = 101
@property (weak, nonatomic) IBOutlet UIButton *useButton;           //tag = 102
@property (weak, nonatomic) IBOutlet UIButton *cancleButton;        //tag = 103
@property (weak, nonatomic) IBOutlet UIButton *mediaLibButton;      //tag = 104

@property (weak, nonatomic) IBOutlet UIButton *flashButton;         //tag = 105
//state : 1 自动  2   关闭      3   打开
@property (weak, nonatomic) IBOutlet UIButton *turnCameraButton;    //tag = 106

@property (copy, nonatomic) ECImagePickerOverlayButtonClick buttonClickBlock;

- (void) addImageToGellary:(NSMutableDictionary *)imageInfo cancelBlock:(void (^)(NSMutableDictionary *imageInfo)) cancelBlock;
@end
