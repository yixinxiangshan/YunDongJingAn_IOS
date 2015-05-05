//
//  ECImagePickerController.m
//  ECIOSProject
//
//  Created by cheng on 14-1-23.
//  Copyright (c) 2014年 ecloud. All rights reserved.
//

#import "ECImagePickerController.h"
#import "ECImagePickerOverlay.h"
#import "UIImage+Resize.h"

@interface ECImagePickerController () <UIImagePickerControllerDelegate, UINavigationBarDelegate>
@property (nonatomic, strong) ECImagePickerOverlay *overlay;

@property (nonatomic, strong) NSMutableArray* imageInfo;
@end

@implementation ECImagePickerController

- (id) init
{
    return [self initWithImageInfo:nil];
}
- (id) initWithImageInfo:(NSMutableArray *)imageInfo
{
    //检测摄像头是否可用,不可用，则返回空对像
    if (![self.class isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return nil;
    }
    //初始化
    self = [super init];
    self.imageInfo = [NSMutableArray new];
    [self.imageInfo addObjectsFromArray:imageInfo];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //设置初始状态
    self.sourceType          = UIImagePickerControllerSourceTypeCamera;
    self.showsCameraControls = NO;
    self.cameraFlashMode     = UIImagePickerControllerCameraFlashModeAuto;
    self.allowsEditing       = NO;
    self.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    self.delegate = self;
    
    //初始化 overlay
    __weak id SELF = self;
    _overlay = [[ECImagePickerOverlay alloc] init];
    _overlay.buttonClickBlock = ^(UIButton *button){
        switch (button.tag) {
            case 101:
                [SELF shoot:button];
                break;
            case 102:
                [SELF useImage:button];
                break;
            case 103:
                [SELF cancel:button];
                break;
            case 104:
                [SELF changeSourceType:button];
                break;
            case 105:
                [SELF turnFlash:button];
                break;
            case 106:
                [SELF turnCamera:button];
                break;
                
            default:
                break;
        }
    };
    self.cameraOverlayView = _overlay;
    
    //预览画面位置调整
//    self.cameraViewTransform = CGAffineTransformMakeTranslation(0.0, 568-480);
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        CGFloat scaleRate = 568.0/400.0;
        self.cameraViewTransform = CGAffineTransformMakeScale(scaleRate, scaleRate);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UIImagePickerControllerDelegate
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSMutableDictionary* imageInfo = [self tempImage:info];
    if (imageInfo) {
        [self.imageInfo addObject:imageInfo];
    }
    
    __weak id SELF = self;
    [_overlay addImageToGellary:imageInfo cancelBlock:^(NSMutableDictionary *imageInfo) {
        [[SELF imageInfo] removeObject:imageInfo];
    }];
    
    // 调用 didSelect block
    if (self.didSelect) {
        self.didSelect(imageInfo);
    }
    //未定制从相同一中先择的界面，暂时，一次只能先一张，选完之后返回camera界面
    if (self.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum) {
        [self changeSourceType:nil];
    }
    [self.view cancelActivity];
}
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self changeSourceType:nil];
}

#pragma mark- overlay 控制事件处理
- (void) shoot:(UIButton *)sender
{
    [self.view showActivity];
    [self takePicture];
}
- (void) useImage:(UIButton *)sender
{
    if (self.didDoneSelect && _imageInfo.count) {
        self.didDoneSelect(_imageInfo);
    }
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
- (void) cancel:(UIButton *)sender
{
    if (self.didCancel) {
        self.didCancel();
    }
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}
- (void) changeSourceType:(UIButton *)sender
{
    switch (self.sourceType) {
        case UIImagePickerControllerSourceTypeCamera:
            self.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            break;
        case UIImagePickerControllerSourceTypeSavedPhotosAlbum:
            self.sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        default:
            break;
    }
}
- (void) turnFlash:(UIButton *)sender
{
    switch (self.cameraFlashMode) {
        case UIImagePickerControllerCameraFlashModeOff:
            self.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
            [sender setTitle:@"打开" forState:UIControlStateNormal];
            break;
        case UIImagePickerControllerCameraFlashModeAuto:
            self.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
            [sender setTitle:@"关闭" forState:UIControlStateNormal];
            break;
        case UIImagePickerControllerCameraFlashModeOn:
            self.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
            [sender setTitle:@"自动" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}
- (void) turnCamera:(UIButton *)sender
{
    switch (self.cameraDevice) {
        case UIImagePickerControllerCameraDeviceRear:
            self.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            break;
        case UIImagePickerControllerCameraDeviceFront:
            self.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            break;
        default:
            break;
    }
}

#pragma mark- 缓存图像，并返回地址
- (NSMutableDictionary *) tempImage:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        image = [image fitToWidth:640.0f];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        //图片保存的路径
        //这里将图片放在沙盒的tmp文件夹中
        NSString * tmpPath = NSTemporaryDirectory();
        
        //文件管理器
        NSString* imageName = [NSString stringWithFormat:@"%@.png",[self randomString]];
        NSString* filePath = [NSString stringWithFormat:@"%@%@",tmpPath,  imageName];
        [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
        //得到选择后沙盒中图片的完整路径
        
        NSMutableDictionary* imageInfo = [NSMutableDictionary new];
        [imageInfo setObject:filePath forKey:@"imageFile"];
        [imageInfo setObject:image forKey:@"image"];
        return imageInfo;
    }
    return nil;
}
- (NSString*)randomString{
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"ssyyyyMMmmHHdd"];
    return [NSString stringWithFormat:@"%@%u",[format stringFromDate:[NSDate date]], arc4random() & 0xFFFF];
}
@end



#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
//static const CGFloat ECImagePickerActivityWidth       = 100.0;
//static const CGFloat ECImagePickerActivityHeight      = 100.0;
static const NSString * ECImagePickerActivityViewKey  = @"ECImagePickerActivityViewKey";

@implementation UIView (ECImagePickerActivity)

- (void) showActivity
{
    // sanity
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &ECImagePickerActivityViewKey);
    if (existingActivityView != nil) return;
    
//    CGFloat activityWidth = self.frame.size.width/2 < ECImagePickerActivityWidth ? self.frame.size.width/2 : ECImagePickerActivityWidth;
//    CGFloat activityHeight = self.frame.size.height/2 < ECImagePickerActivityHeight ? self.frame.size.height/2 : ECImagePickerActivityHeight;
    
    UIView *activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)] ;
    activityView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    activityView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.2];
    activityView.alpha = 0.0;
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.center = CGPointMake(activityView.bounds.size.width / 2, activityView.bounds.size.height / 2);
    [activityView addSubview:activityIndicatorView];
    [activityIndicatorView setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.6]];
    activityIndicatorView.layer.cornerRadius = 3;
    [activityIndicatorView startAnimating];
    
    // associate ourselves with the activity view
    objc_setAssociatedObject (self, &ECImagePickerActivityViewKey, activityView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addSubview:activityView];
    
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         activityView.alpha = 1.0;
                     } completion:nil];

}

- (void) cancelActivity
{
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &ECImagePickerActivityViewKey);
    if (existingActivityView != nil) {
        [UIView animateWithDuration:0.1
                              delay:0.0
                            options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                         animations:^{
                             existingActivityView.alpha = 0.0;
                         } completion:^(BOOL finished) {
                             [existingActivityView removeFromSuperview];
                             objc_setAssociatedObject (self, &ECImagePickerActivityViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         }];
    }

}

@end
