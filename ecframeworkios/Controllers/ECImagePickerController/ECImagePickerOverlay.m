//
//  ECImagePickerOverlay.m
//  ECIOSProject
//
//  Created by cheng on 14-1-23.
//  Copyright (c) 2014年 ecloud. All rights reserved.
//

#import "ECImagePickerOverlay.h"

#define IMAGEGELLAYRHEIGHT 88.0f

@class ImageItem;
typedef void(^ECImagePickerDidCancleImage)(ImageItem *item);

@interface ImageItem : UIView
@property (nonatomic, copy) ECImagePickerDidCancleImage cancelBlock;

- (id) initWithImageInfo:(NSMutableDictionary *)imageInfo;
@end

@interface ECImagePickerOverlay ()
@property (weak, nonatomic) IBOutlet UIView *buttonContainer;
@property (nonatomic) NSInteger imageCount;
@end

@implementation ECImagePickerOverlay

- (id) init
{
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil] lastObject];
    if (self) {
        [self setFrame:[UIScreen mainScreen].bounds];
        [self.buttonContainer setFrame:CGRectMake(0, 0, 320, 60)];
        self.imageCount = 0;
        //设置控制器在底部，预览矸控制器上面
        [self.buttonContainer setCenter:CGPointMake(160, self.bounds.size.height - self.buttonContainer.frame.size.height/2)];
        [self.imageGellary setCenter:CGPointMake(160, self.bounds.size.height - self.buttonContainer.frame.size.height - self.imageGellary.frame.size.height/2)];
        
        //设置按钮事件
        [self.shoot addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.useButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.cancleButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.mediaLibButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.flashButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.turnCameraButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void) buttonClick:(UIButton *)sender
{
    if (_buttonClickBlock) {
        _buttonClickBlock(sender);
    }
}

- (void) addImageToGellary:(NSMutableDictionary *)imageInfo cancelBlock:(void (^)(NSMutableDictionary *imageInfo))cancelBlock
{
    ImageItem *imageItem = [[ImageItem alloc] initWithImageInfo:imageInfo];
    imageItem.tag = _imageCount;
    imageItem.cancelBlock = ^(ImageItem *item){
        [self cancelImage:item];
        if (cancelBlock) {
            cancelBlock(imageInfo);
        }
    };
    
    //加入 imageGellary
    [imageItem setCenter:CGPointMake(IMAGEGELLAYRHEIGHT * (_imageCount + 0.5), IMAGEGELLAYRHEIGHT/2)];
    [_imageGellary addSubview:imageItem];
    
    _imageCount ++;
    [_imageGellary setContentSize:CGSizeMake(IMAGEGELLAYRHEIGHT * _imageCount, IMAGEGELLAYRHEIGHT)];
    [_imageGellary scrollRectToVisible:imageItem.frame animated:YES];
}

- (void) cancelImage:(ImageItem *)item
{
    [UIView animateWithDuration:0.13
                     animations:^{
                         [item setAlpha:0.0f];
                         for (UIView *view in _imageGellary.subviews) {
                             if ([view isKindOfClass:[ImageItem class]] && view.tag > item.tag) {
                                 view.tag -= 1;
                                 [view setCenter:CGPointMake(IMAGEGELLAYRHEIGHT * (view.tag + 0.5), IMAGEGELLAYRHEIGHT/2)];
                             }
                         }
                         _imageCount --;
                         [_imageGellary setContentSize:CGSizeMake(IMAGEGELLAYRHEIGHT * _imageCount, IMAGEGELLAYRHEIGHT)];
                     } completion:^(BOOL finished) {
                         [item removeFromSuperview];
                     }];
}
@end


@implementation ImageItem

- (id) initWithImageInfo:(NSMutableDictionary *)imageInfo
{
    self = [super initWithFrame:CGRectMake(0, 0, IMAGEGELLAYRHEIGHT, IMAGEGELLAYRHEIGHT)];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        //imageView
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[imageInfo objectForKey:@"image"]];
        [imageView setFrame:CGRectMake(5, 5, IMAGEGELLAYRHEIGHT - 10, IMAGEGELLAYRHEIGHT - 10)];
        imageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:imageView];
        
        //将imageView 加入 imageInfo (用于预处理，可能不存在，使用时，需判断）
        [imageInfo setObject:imageView forKey:@"imageView"];
        
        // cancel button
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, IMAGEGELLAYRHEIGHT/2, IMAGEGELLAYRHEIGHT/2)];
        [cancelButton setCenter:CGPointMake(IMAGEGELLAYRHEIGHT - 11, 11)];
        [cancelButton setImage:[UIImage imageNamed:@"ECImagePicker-cancel.png"] forState:UIControlStateNormal];
        [self addSubview:cancelButton];
        [cancelButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void) buttonClicked:(UIButton *)button
{
    if (self.cancelBlock) {
        self.cancelBlock(self);
    }
}
@end