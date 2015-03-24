//
//  ECFormWidgetCellUploads.m
//  ECDemoFrameWork
//
//  Created by cheng on 14-1-9.
//  Copyright (c) 2014年 EC. All rights reserved.
//

#import "ECFormWidgetCellUploads.h"
#import "UIImageView+WebCache.h"
#import "ECImageUtil.h"
#import "ECViewUtil.h"
//#import "UIAlertView+Block.h"
#import "ECImagePickerController.h"
#import "ECAppUtil.h"
#import "ECNetRequest.h"
#import "NSDictionaryExtends.h"
#import "UIImage+Resource.h"

#define Height 76
#define Width  300
#define SeperatorWidth 5

//#define IMAGESERVERURL [NSURL URLWithString:@"http://is.hudongka.com/saveimg.php"]
#define IMAGESERVERURL @"http://is.hudongka.com/saveimg.php"

@interface ECFormWidgetCellUploadsImageCell : UIView

@property (nonatomic, strong) UIImageView *imageView;

+ (UIView *) cellWithImageURL:(NSURL *)imageURL;

+ (UIView *) cellWithImage:(UIImage *)image;

- (void) glanceFullScreen;
@end

@interface ECFormWidgetCellUploads () <SystemImagePickerDelegate>
@property (copy, nonatomic  ) ECFormWidgetUploadsDoneBlock doneBlock;
@property (strong, nonatomic) UIButton               * selectButton;

@property (strong, nonatomic) NSMutableArray         * imageFiles;
@property (strong, nonatomic) NSArray                * defaultImages;

@end

@implementation ECFormWidgetCellUploads

- (instancetype) initWithDefault:(NSArray *)defaultImages DoneBlock:(ECFormWidgetUploadsDoneBlock)doneBlock
{
    self = [self initWithFrame:CGRectMake(0, 0, Width, Height)];
    if (self) {
        self.doneBlock = doneBlock;
        self.imageFiles = [NSMutableArray new];
        
        [self setContentSize:CGSizeMake(Height, Height)];
        self.selectButton = [self buttonWithImage:[UIImage imageWithPath:ECFormWidgetCellUploads_SelectButton_Image]];
        [self addSubview:self.selectButton];
        
        if ([defaultImages isKindOfClass:[NSArray class]]) {
            self.defaultImages = defaultImages;
            for (NSString* imageName in defaultImages) {
                if (!imageName || imageName.length == 0) {
                    continue;
                }
//                [self addImageView:[self imageViewWithImageURL:[NSURL URLWithString:[ECImageUtil getSImageWholeUrl:imageName]]]];
                [self addImageView:[ECFormWidgetCellUploadsImageCell cellWithImageURL:[NSURL URLWithString:[ECImageUtil getSImageWholeUrl:imageName]]]];
            }
        }
    }
    return self;
}

- (void) callDoneBlock
{
    if (self.doneBlock) {
        self.doneBlock(self.imageFiles);
    }
}

#pragma mark- system image picker delegate
- (void)getImageFile:(NSString*)filePath image:(UIImage*)image
{
    [self addImageView:[ECFormWidgetCellUploadsImageCell cellWithImage:image]];
    [self.imageFiles addObject:filePath];
    
    [self callDoneBlock];
}

#pragma mark- private method
- (void) openImagePicker:(UIButton *)sender
{
//    [ECViewUtil openImagePiker:self];
    ECImagePickerController* imagePicker = [[ECImagePickerController alloc] initWithImageInfo:nil];
    
    if (imagePicker) {
        [[[ECAppUtil shareInstance] getNowController] presentViewController:imagePicker animated:YES completion:^{
            NSLog(@"imagePicker has pushed to front .");
            //完成选择后调用
            imagePicker.didDoneSelect = ^(NSMutableArray *imageInfos){
                for (NSMutableDictionary *imageInfo in imageInfos) {
                    if (![imageInfo objectForKey:@"imageName"]) {
                        continue;
                    }
                    [self addImageView:[ECFormWidgetCellUploadsImageCell cellWithImage:[imageInfo objectForKey:@"image"]]];
                    [self.imageFiles addObject:[imageInfo objectForKey:@"imageName"]];
                }
                [self callDoneBlock];
            };
            //选择某张照片后调用
            imagePicker.didSelect = ^(NSMutableDictionary* imageInfo){
                //预处理照片，上传至服务器
                NSLog(@"imageInfo : %@",imageInfo);
                NSString *imageLocalPath = [imageInfo objectForKey:@"imageFile"];
                
                UIImageView *imageView = [imageInfo objectForKey:@"imageView"];
                
                NSDictionary *params = @{@"image": [NSString stringWithFormat:@"file://%@",imageLocalPath], @"method": @"upload"};
                params = [params newParams];
                
                ECNetRequest *request = [ECNetRequest newInstance:IMAGESERVERURL];
                
                [request setMd5Hash:[request MD5HashWithParams:params]];
                //处理文件
                for (NSString* key in [params allKeys]) {
                    NSString* value = [params objectForKey:key];
                    if ([value hasPrefix:@"file://"]) {
                        ECLog(@"%@",[value substringFromIndex:7]);
                        [request addFile:[value substringFromIndex:7]  forKey:key];
                    }else{
                        [request addPostValue:[params objectForKey:key] forKey:key];
                    }
                    
                }

                //发送请求
                [request postWithFinishedBlock:^(id data) {
                    //上传成功，则将返回的远程图版地址加入 imageInfo
                    [imageInfo setObject:data forKey:@"imageName"];
                    
                    [imageView cancelActivity];
                } faildBlock:^(id data) {
                    [imageView setImage:[UIImage imageWithPath:@"ECInagePicker-faild.png"]];
                    [imageView cancelActivity];
                }];
                [imageView showActivity];
            };
        }];
    }

}

- (void) tapImage:(UIGestureRecognizer *)recognizer
{
    [(UIImageView *)recognizer.view glanceFullScreen];
}
#pragma mark-
- (UIButton *) buttonWithImage:(UIImage *)image
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, Height - SeperatorWidth*2, Height - SeperatorWidth*2)];
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
    }else{
        [button setBackgroundColor:ECFormWidgetCell_Background];
    }
    [button setCenter:CGPointMake(Height / 2, Height / 2 )];
    [button addTarget:self  action:@selector(openImagePicker:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark-
- (void) addImageView:(UIView *)imageView
{
    [self addSubview:imageView];
    [imageView setCenter:CGPointMake(self.contentSize.width - Height/2, Height/2)];
    [imageView setAlpha:0.0];
    [UIView animateWithDuration:0.15
                     animations:^{
                         self.userInteractionEnabled = NO;
                         [imageView setAlpha:1.0];
                         [self setContentSize:CGSizeMake(self.contentSize.width + Height, Height)];
                         [self.selectButton setCenter:CGPointMake(self.contentSize.width - Height/2, Height/2)];
                         self.selectButton.tag = self.contentSize.width / Height;
                         imageView.tag = self.selectButton.tag - 1;
                     }
                     completion:^(BOOL finished) {
                         if (self.contentSize.width > Width) {
                             [self scrollRectToVisible:CGRectMake(self.contentSize.width - Width, 0, Width, Height) animated:YES];
                         }
                         self.userInteractionEnabled = YES;
                     }];
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
}
- (void) deleteSubview:(UIView *)view
{
    if (![[view superview] isEqual:self]) {
        return;
    }
   [view removeFromSuperview];
}

#pragma mark- override
// 重载移除 subview 的方法
- (void) willRemoveSubview:(UIView *)subview
{
    if ([subview isKindOfClass:[ECFormWidgetCellUploadsImageCell class]]) {
        [UIView animateWithDuration:0.15
                         animations:^{
                             self.userInteractionEnabled = NO;
                             NSInteger tag = subview.tag;
                             [subview setAlpha:0.0];
                             for (UIView* view in self.subviews) {
                                 if (view.tag > tag) {
                                     view.tag -= 1;
                                     [view setCenter:CGPointMake(view.center.x - Height, view.center.y)];
                                 }
                             }
                             [self setContentSize:CGSizeMake(self.contentSize.width - Height, Height)];
                             [super willRemoveSubview:subview];
                         }
                         completion:^(BOOL finished) {
                             self.userInteractionEnabled = YES;
                         }];
        return;
    }
    
    [super willRemoveSubview:subview];
}
@end

@implementation ECFormWidgetCellUploadsImageCell

+ (UIView *)cellWithImageURL:(NSURL *)imageURL
{
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithPath:@"general_default_image.png"]];
    
    //显示默认图片
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:imageURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (image) {
            [imageView setImage:image];
        }
    }];
    

    ECFormWidgetCellUploadsImageCell *cell = [[self alloc] initWithImageView:imageView];
    return cell;
}

+ (UIView *)cellWithImage:(UIImage *)image
{
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    
    ECFormWidgetCellUploadsImageCell *cell = [[self alloc] initWithImageView:imageView];
    return cell;
}


#pragma mark-
- (id) initWithImageView:(UIImageView *)imageView
{
    self = [super initWithFrame:CGRectMake(0, 0, Height - SeperatorWidth*2, Height - SeperatorWidth*2)];
    
    if (self) {
        _imageView = imageView;
        [_imageView setFrame:self.frame];
        [self addSubview:_imageView];
        
        //添加删除按钮
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 30, SeperatorWidth - 22, 44, 44)];
        [cancelButton setImage:[UIImage imageWithPath:@"ECFormWidgetCellUploadsImageCell-cancel.png"] forState:UIControlStateNormal];
        [self addSubview:cancelButton];
        
        [cancelButton addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void) glanceFullScreen
{
    [_imageView glanceFullScreen];
}
@end

@implementation UIImageView (Browser)

- (void) glanceFullScreen
{
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    self.tag = NSIntegerMax;
    
    CGFloat scalMateWith = self.image.size.width < [UIScreen mainScreen].bounds.size.width ? [UIScreen mainScreen].bounds.size.width/self.image.size.width : 1.0;
    CGFloat scalMateHeight = self.image.size.height < [UIScreen mainScreen].bounds.size.height ? [UIScreen mainScreen].bounds.size.height/self.image.size.height : 1.0;
    
    CGFloat scalMate = scalMateWith > scalMateHeight ? scalMateWith : scalMateHeight;
    
    CGSize size = CGSizeMake(self.image.size.width * scalMate, self.image.size.height * scalMate);
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:[self convertRect:CGRectMake(0, 0, 0, 0) toView:window]];
    [imageView setImage:self.image];
    imageView.userInteractionEnabled = YES;
    imageView.contentMode            = UIViewContentModeScaleAspectFill;
    imageView.tag                    = NSIntegerMax;
    
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:window.bounds];
    [scrollView addSubview:imageView];
    [scrollView setContentSize:size];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    scrollView.delegate                       = self;
    scrollView.minimumZoomScale               = 1.0;
    scrollView.maximumZoomScale               = 3.0;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator   = NO;
    [window addSubview:scrollView];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    [UIView animateWithDuration:0.15
                     animations:^{
                         [imageView setFrame:CGRectMake(0, 0, size.width, size.height)];
                     }
                     completion:^(BOOL finished) {
                         [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
                     }];
    
    
}

- (void) tap:(UITapGestureRecognizer *)tap
{
    UIView* imageView = tap.view;
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    
    [UIView animateWithDuration:0.15
                     animations:^{
                         [imageView setFrame:[self convertRect:CGRectMake(0, 0, 0, 0) toView:window]];
                     }
                     completion:^(BOOL finished) {
                         [[[window subviews] lastObject] removeFromSuperview];
                     }];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [scrollView subviews][0];
}
@end