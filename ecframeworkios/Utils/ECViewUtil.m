//
//  ECViewUtil.m
//  ECDemoFrameWork
//
//  Created by cww on 13-8-28.
//  Copyright (c) 2013年 EC. All rights reserved.
//

#import "ECViewUtil.h"
#import "Toast+UIView.h"
#import "DejalActivityView.h"
#import "NSArrayExtends.h"
#import "Constants.h"
#import "ECAppUtil.h"
#import "NSStringExtends.h"
#import "ECJSUtil.h"
#import "ECImageUtil.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Resize.h"
#import "UIImage+Resource.h"
#import "UIColorExtends.h"

@implementation ECViewUtil



// 屏幕尺寸
CGRect screenBounds(){
    return [UIScreen mainScreen].bounds;
}
// 屏幕宽度
CGFloat validWidth(){
    return [UIScreen mainScreen].bounds.size.width;
}
// 去除statusBar的高度 或 及导航条的高度
CGFloat validHeight(){
    ECBaseViewController* ctrl = [[ECAppUtil shareInstance] getNowController];
    CGFloat height             = [UIScreen mainScreen].bounds.size.height;
    
    if(NO == ctrl.navigationController.navigationBarHidden){
        CGFloat navHeight          = ctrl.navigationController.navigationBar.frame.size.height;
        height                     -= navHeight;
    }
    
    if (NO == [UIApplication sharedApplication].statusBarHidden) {
        CGRect frame               = [UIApplication sharedApplication].statusBarFrame;
        
        height                     -= CGRectGetHeight(frame);
    }
    
    return height;
}

// 整个屏幕的高度
CGFloat totalHeight(){
    return [UIScreen mainScreen].bounds.size.height;
}

/**
 * 弹出 确认框
 *
 * @param message
 * @param okTag
 * @param cancelTag
 */
+ (void) showConfirm:(NSString *)message okTag:(NSString *)okTag cancelTag:(NSString *)cancelTag{
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:[UIAlertViewDelegate init:cancelTag okTag:okTag] cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

/**
 * Toast 接口
 *
 * @param msg
 */
+ (void) toast:(NSString *)msg{
    [[[[[[UIApplication sharedApplication] delegate] window] rootViewController] view] makeToast:msg];
}

/**
 * 显示加载等待对话框
 *
 * @param context
 * @param loadingTitle
 * @param loadingMessage
 * @param cancelable
 */
+ (void) showLoadingDialog:(NSString *)loadingTitle loadingMessage:(NSString *)loadingMessage cancelAble:(BOOL)cancelable{
    [self showLoadingDialog:[[[ECAppUtil shareInstance] nowPageContext] view] loadingTitle:loadingTitle loadingMessage:loadingMessage cancelAble:cancelable];
}
+ (void) showLoadingDialog:(UIView *)view loadingTitle:(NSString *)loadingTitle loadingMessage:(NSString *)loadingMessage cancelAble:(BOOL)cancelable
{
    [DejalBezelActivityView activityViewForView:view withLabel:loadingMessage];
}
+ (void) closeLoadingDialog{
    [self closeLoadingDialog:[[[ECAppUtil shareInstance] nowPageContext] view]];
}
+ (void) closeLoadingDialog:(UIView *)view
{
    [DejalBezelActivityView removeViewAnimated:YES];
}

+ (void)openImagePiker:(id<SystemImagePickerDelegate>) imagePickerDelegate{
    [[[ECAppUtil shareInstance] nowPageContext] openImagePiker:imagePickerDelegate];
}
#pragma mark -
+ (CGFloat)textViewHeightForAttributedText:(NSAttributedString*)text andWidth:(CGFloat)width
{
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setAttributedText:text];
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}

#pragma mark - 添加视图
+ (void)insertViewToView:(UIView *)view parentView:(UIView*)parentView insertType:(int) insertType position:(int)position{
    if([[parentView subviews] isEmpty])
        position  = 0;
    if([[parentView subviews] count]<=position)
        position = (int)[[parentView subviews] count];
    [parentView insertSubview:view atIndex:position];
    if (position>0) {
        CGRect frame = view.frame;
        UIView* preView = (UIView*)[[parentView subviews] objectAtIndex:position-1];
        frame.origin.y = preView.frame.origin.y + preView.frame.size.height + 10;
        view.frame = frame;
    }
}

+ (void)resetContainerFrame:(UIView*)container{
    if ([container isKindOfClass:[UIScrollView class]]) {
        UIScrollView* scrollContainer = (UIScrollView*)container;
        NSArray* views = [container subviews];
        UIView* view = nil;
        int i = 0;
        for (UIView* tempView in views) {
            ECLog(@"view = %@ -----------------------------------%d",tempView,i);
            i++;
            if (view == nil)
                view = tempView;
            if (tempView.frame.origin.y > view.frame.origin.y )
                view = tempView;
        }
        
        //        CGRect frame = container.frame;
        //        frame.size.height = self.frame.size.height;
        //        container.frame = frame;
        float height = view.frame.origin.y+view.frame.size.height+80;
        [scrollContainer setContentSize:CGSizeMake(scrollContainer.contentSize.width, height)];
    }
}

+ (UIView*)findViewById:(NSString*)viewId{
    UIView* view = [[ECAppUtil shareInstance] nowPageContext].view;
    return [self findViewById:viewId view:view];
}
+ (UIView*)findViewById:(NSString *)viewId view:(UIView*)view{
    if ([viewId isEmpty])
        return nil;
    //TODO: 兼容 android中 页面的双布局， 待android中改变后，删除
    if ([viewId isEqualToString:@"blank_llayout"]) {
        viewId = @"activity_item_container_llayout";
    }
    NSString* tempViewId;
    @try {
        tempViewId = [view valueForKey:@"viewId"];
    }
    @catch (NSException *exception) {
        return nil;
    }
    if (tempViewId != nil && [tempViewId isEqualToString:viewId]) {
        return view;
    }
    NSArray* views = [view subviews];
    if ([views isEmpty]) {
        return nil;
    }
    UIView* returnView = nil;
    for (UIView* tempView in views) {
        returnView = [self findViewById:viewId view:tempView];
        if (returnView != nil) {
            return returnView;
        }
    }
    return nil;
}

+ (void)setViewWidth:(UIView *)view container:(UIView *)container width:(NSString *)width{
    if (width == nil)
        return;
    [container addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:container
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:0.0
                                                           constant:(CGFloat)[width floatValue]]];
}

//设置设置view的一些相关工具
+ (void)setText:(UILabel *)label data:(NSString *)data{
    if (data == nil) {
        label.hidden = YES;
        return;
    }
    label.hidden = NO;
    NSString *str = data;
    label.text = str;
}
+ (void)setTextView:(UITextView *)label data:(NSString *)data{
    if (data == nil) {
        label.hidden = YES;
        return;
    }
    label.hidden = NO;
    NSString *str = data;
    label.text = str;
}

+ (UIImageView *) getImageByConfig:(UIImageView *)image config:(NSDictionary *)data{
    if (data == nil) {
        image.hidden = YES;
        return nil;
    }
    image.hidden = NO;
    //ECLog(@"++++++++image data: %@, image size: %@", data[@"imageSrc"], [data objectForKey:@"imageSize"]);
    //    NSLog(@"ListViewCellICircleProgressBar setImageView imagewidth 1: %f ； src : %@" , image.frame.size.width ,data[@"imageSrc"]);
    // 尺寸设置
    CGSize imageSize = CGSizeMake(50.0 , 50.0);
    if ([[data objectForKey:@"imageSize"] isEqualToString:@"micro"]) {
        imageSize = CGSizeMake(20 , 20);
    }else if ([[data objectForKey:@"imageSize"] isEqualToString:@"mini"]){
        imageSize = CGSizeMake(35 , 35);
    }else if ([[data objectForKey:@"imageSize"] isEqualToString:@"small"]){
        imageSize = CGSizeMake(50 , 50);
    }else if ([[data objectForKey:@"imageSize"] isEqualToString:@"middle"]){
        imageSize = CGSizeMake(70 , 70);
    }else if ([[data objectForKey:@"imageSize"] isEqualToString:@"large"]){
        imageSize = CGSizeMake(200 , 150);
    }else if ([[data objectForKey:@"imageSize"] isEqualToString:@"full"]){
        imageSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width-20 , ([[UIScreen mainScreen] bounds].size.width-20)*3/4);
    }else if ([[data objectForKey:@"imageSize"] isEqualToString:@"fitSize"]){
        imageSize = CGSizeMake(0 , 0);
    }else
        imageSize = CGSizeMake(0 , 0);
    
    //    图片设置:不变形，大小为标准尺寸
    image.contentMode = UIViewContentModeScaleAspectFit;
    if (imageSize.width != 0.0)
        [image setFrame:CGRectMake(image.frame.origin.x, image.frame.origin.y, imageSize.width, imageSize.height)];
    
    //    图片内容设置
    if ([[data objectForKey:@"imageType"] isEqualToString:@"imageServer"] ) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
         NSString* imgUrl = @"";
        if ([[data objectForKey:@"imageSize"] isEqualToString:@"full"]) {
            imgUrl=[ECImageUtil getFitImageWholeUrl : data[@"imageSrc"]];
        }else{
            imgUrl=[ECImageUtil getSImageWholeUrl : data[@"imageSrc"]];
        }
        
        //ECLog(@"+++++++++ img Url is: %@", imgUrl);
        
        [manager downloadImageWithURL:[NSURL URLWithString:imgUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *_image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            //ECLog(@"++++++++ image width: %f", imageSize.width);
            if(_image)
            {
                ECLog(@"image size: %f, %f", _image.size,width, _image.size.height);
                if (imageSize.width != 0.0)
                    [image setImage:[_image fitToWidth:imageSize.width]];
                else
                    [image setImage:_image];
            }
            else
                ECLog(@"Failed to download image: %@", error);
        }];
        //        [manager downloadWithURL:[NSURL URLWithString:[ECImageUtil getSImageWholeUrl:data[@"imageSrc"]]]
        //                         options:0 progress:^(NSUInteger receivedSize, long long expectedSize) {
        //                             //                             loading...
        //                         } completed:^(UIImage *_image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        //                             if (imageSize.width != 0.0)
        //                                 [image setImage:[_image fitToWidth:imageSize.width]];
        //                             else
        //                                 [image setImage:_image];
        //                         }];
    }else if ([[data objectForKey:@"imageType"] isEqualToString:@"assets"] ) {
        if (imageSize.width != 0.0)
            [image setImage:[[UIImage imageWithPath:data[@"imageSrc"]] fitToWidth:imageSize.width]];
        else{
            [image setImage:[UIImage imageWithPath:data[@"imageSrc"]]];
        }
    }else if ([[data objectForKey:@"imageType"] isEqualToString:@"resource"] ) {
        ECLog(@"image width %f, name: %@", imageSize.width, data[@"imageSrc"]);
        if (imageSize.width != 0.0)
            [image setImage: [[UIImage imageNamed:[data[@"imageSrc"] stringByAppendingString:@".png"]]  fitToWidth:imageSize.width]];
        else
            [image setImage: [UIImage imageNamed:[data[@"imageSrc"] stringByAppendingString:@".png"]] ];
    }
    return image;
}

+ (UIButton *) getImageButtonByConfig:(UIButton *)button config:(NSDictionary *)data{
    if (data == nil) {
        button.hidden = YES;
        return nil;
    }
    button.hidden = NO;
    //    NSLog(@"ListViewCellICircleProgressBar setImageView imagewidth 1: %f ； src : %@" , image.frame.size.width ,data[@"imageSrc"]);
    // 尺寸设置
    CGSize imageSize = CGSizeMake(50.0 , 50.0);
    if ([[data objectForKey:@"imageSize"] isEqualToString:@"micro"]) {
        imageSize = CGSizeMake(20 , 20);
    }else if ([[data objectForKey:@"imageSize"] isEqualToString:@"mini"]){
        imageSize = CGSizeMake(35 , 35);
    }else if ([[data objectForKey:@"imageSize"] isEqualToString:@"small"]){
        imageSize = CGSizeMake(50 , 50);
    }else if ([[data objectForKey:@"imageSize"] isEqualToString:@"middle"]){
        imageSize = CGSizeMake(70 , 70);
    }else if ([[data objectForKey:@"imageSize"] isEqualToString:@"large"]){
        imageSize = CGSizeMake(200 , 150);
    }else if ([[data objectForKey:@"imageSize"] isEqualToString:@"fitSize"]){
        imageSize = CGSizeMake(0 , 0);
    }
    //    图片设置:不变形，大小为标准尺寸
    button.contentMode = UIViewContentModeScaleAspectFit;
    if (imageSize.width != 0.0)
        [button setFrame:CGRectMake(button.frame.origin.x, button.frame.origin.y, imageSize.width, imageSize.height)];
    
    //    图片内容设置
    if ([[data objectForKey:@"imageType"] isEqualToString:@"imageServer"] ) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:[ECImageUtil getSImageWholeUrl:data[@"imageSrc"]]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *_image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (imageSize.width != 0.0)
                [button setBackgroundImage:[_image fitToWidth:imageSize.width] forState:UIControlStateNormal];
            else
                [button setBackgroundImage:_image forState:UIControlStateNormal];
            
        }];
        //        [manager downloadWithURL:[NSURL URLWithString:[ECImageUtil getSImageWholeUrl:data[@"imageSrc"]]]
        //                         options:0 progress:^(NSUInteger receivedSize, long long expectedSize) {
        //                             //                             loading...
        //                         } completed:^(UIImage *_image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        //                             if (imageSize.width != 0.0)
        //                                 [button setBackgroundImage:[_image fitToWidth:imageSize.width] forState:UIControlStateNormal];
        //                             else
        //                                 [button setBackgroundImage:_image forState:UIControlStateNormal];
        //                         }];
    }else if ([[data objectForKey:@"imageType"] isEqualToString:@"assets"] ) {
        if (imageSize.width != 0.0){
            [button setImage:[[UIImage imageWithPath:data[@"imageSrc"]] fitToWidth:imageSize.width] forState:UIControlStateNormal];
            
          [data[@"imageSrc"] stringByReplacingOccurrencesOfString:@".png" withString:@"_pressed.png"];
            [button setImage:[[UIImage imageWithPath: [data[@"imageSrc"] stringByReplacingOccurrencesOfString:@".png" withString:@"_pressed.png"]] fitToWidth:imageSize.width] forState:UIControlEventTouchDown];
        }
        else{
            [button setImage:[UIImage imageWithPath:data[@"imageSrc"]] forState:UIControlStateNormal];
            
        }
    }else if ([[data objectForKey:@"imageType"] isEqualToString:@"resource"] ) {
        if (imageSize.width != 0.0)
            [button setBackgroundImage: [[UIImage imageNamed:[data[@"imageSrc"] stringByAppendingString:@".png"]]  fitToWidth:imageSize.width] forState:UIControlStateNormal];
        else
            [button setBackgroundImage: [UIImage imageNamed:[data[@"imageSrc"] stringByAppendingString:@".png"]]  forState:UIControlStateNormal];
    }
    
    return button;
}

//设置按钮文字、颜色、背景颜色、高亮
+ (void)setTextButtonWithConfig:(UIButton *)button data:(NSDictionary *)data{
    [button.layer setMasksToBounds:YES];
    // 设置圆角大小
    if (![data[@"cornerRadius"] isEmpty]) {
        [button.layer setCornerRadius:[data[@"cornerRadius"] floatValue]];
    }else{
        [button.layer setCornerRadius:5.0];
    }
    // 设置边框颜色
    if (![data[@"borderColor"] isEmpty]) {
        [button.layer setBorderWidth:1.0];
        [button.layer setBorderColor:[UIColor colorWithHexString:data[@"borderColor"]].CGColor];
    }
    
    // 设置背景颜色
    if (![data[@"backgroundColor"] isEmpty])
        [button setBackgroundImage:[self buttonImageWithColor:button color:[UIColor colorWithHexString:data[@"backgroundColor"]]] forState:UIControlStateNormal];
    if (![data[@"hlBackgroundColor"] isEmpty])
        [button setBackgroundImage:[self buttonImageWithColor:button color:[UIColor colorWithHexString:data[@"hlBackgroundColor"]]] forState:(UIControlStateHighlighted)];
    
    //    [self.button addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchDown];
    //    [self.button addTarget:self action:@selector(buttonTaped:) forControlEvents:UIControlEventTouchUpInside ];
    
    // 文字颜色
    if (![data[@"titleColor"] isEmpty])
        [button setTitleColor:[UIColor colorWithHexString:data[@"titleColor"]] forState:UIControlStateNormal];
    if (![data[@"hlTitleColor"] isEmpty])
        [button setTitleColor:[UIColor colorWithHexString:data[@"hlTitleColor"]] forState:UIControlStateHighlighted];
    
}
// 获取按钮大小的图片
+ (UIImage *)buttonImageWithColor:(UIButton *)button color:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f,0.0f, button.frame.size.width, button.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
//通过获取lavelview高度
+ (float)getTextHeight:(NSString *)text width:(CGFloat)width fontSize:(CGFloat)fontSize{
    if ([text length] == 0)
        return 0.0f;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
    [label setNumberOfLines:0];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size: fontSize];
    label.font = font;
    CGSize size = CGSizeMake( width , CGFLOAT_MAX );  //LableWight标签宽度，固定的
    CGSize labelsize = [text sizeWithFont:font constrainedToSize:size lineBreakMode:label.lineBreakMode];
    return labelsize.height;
}

@end

@implementation UIAlertViewDelegate

+ (UIAlertViewDelegate *) init:(NSString *)cancelTag okTag:(NSString *)okTag;
{
    static UIAlertViewDelegate* delegate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        delegate = [[UIAlertViewDelegate alloc] init];
    });
    delegate.cancelTag = cancelTag;
    delegate.okTag = okTag;
    
    return delegate;
    
}

#pragma UIAlertView Delegate
- (void)alertView:(UIAlertView *)confirm clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString* jsStringConfirm = [NSString stringWithFormat:@"%@.confirm()",[[ECAppUtil shareInstance] getNowController].pageId];
    NSString* jsStringCancel = [NSString stringWithFormat:@"%@.cancel()",[[ECAppUtil shareInstance] getNowController].pageId];
    
    switch (buttonIndex) {
        case 0:
            [[NSNotificationCenter defaultCenter] postNotificationName:self.cancelTag object:nil];
            NSLog(@"%@",self.cancelTag);
            [[ECJSUtil shareInstance] runJS:jsStringCancel];
            break;
        case 1:
            [[NSNotificationCenter defaultCenter] postNotificationName:self.okTag object:nil];
            NSLog(@"%@",self.okTag);
            [[ECJSUtil shareInstance] runJS:jsStringConfirm];
            break;
        default:
            break;
    }
}
@end

