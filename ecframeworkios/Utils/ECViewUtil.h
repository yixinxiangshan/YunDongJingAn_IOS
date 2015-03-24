//
//  ECViewUtil.h
//  ECDemoFrameWork
//
//  Created by cww on 13-8-28.
//  Copyright (c) 2013年 EC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SystemImagePickerDelegate <NSObject>

@optional
- (void)getImageFile:(NSString*)filePath image:(UIImage*)image;

@end

@interface ECViewUtil : NSObject

CGRect screenBounds();  // 屏幕尺寸
CGFloat validWidth();   // 屏幕宽度
CGFloat validHeight();  // 去除statusBar的高度
CGFloat totalHeight();  // 全部的高度

/**
 * 弹出 确认框
 *
 * @param message
 * @param okTag
 * @param cancelTag
 */
+ (void) showConfirm:(NSString *)message okTag:(NSString *)okTag cancelTag:(NSString *)cancelTag;

/**
 * Toast 接口
 *
 * @param msg
 */
+ (void) toast:(NSString *)msg;

/**
 * 显示加载等待对话框
 *
 * @param context
 * @param loadingTitle
 * @param loadingMessage
 * @param cancelable
 */
+ (void) showLoadingDialog:(NSString *)loadingTitle loadingMessage:(NSString *)loadingMessage cancelAble:(BOOL)cancelable;
+ (void) showLoadingDialog:(UIView *)view loadingTitle:(NSString *)loadingTitle loadingMessage:(NSString *)loadingMessage cancelAble:(BOOL)cancelable;
+ (void) closeLoadingDialog:(UIView *)view;
+ (void) closeLoadingDialog;

+ (void)openImagePiker:(id<SystemImagePickerDelegate>) imagePickerDelegate;
/**
 * 将试图放入另外一个试图
 * @param insertType 放入试图的方式，自适应大小、自适应大小改变父控件大小、适应父控件的大小
 */
+ (void)insertViewToView:(UIView *)view parentView:(UIView*)parentView insertType:(int) insertType position:(int)position;


+ (CGFloat)textViewHeightForAttributedText:(NSAttributedString*)text andWidth:(CGFloat)width;
/**
 * 根据viewID 获取试图
 */
+ (UIView*)findViewById:(NSString*)viewId;
+ (UIView*)findViewById:(NSString *)viewId view:(UIView*)view;


//设置设置view的一些相关工具
+ (void)setViewWidth:(UIView *)view container:(UIView *)container width:(NSString *)width;
+ (void)setText:(UILabel *)label data:(NSString *)data;
+ (void)setTextView:(UITextView *)label data:(NSString *)data;
+ (void)setTextButtonWithConfig:(UIButton *)button data:(NSDictionary *)data;
+ (UIImageView *) getImageByConfig:(UIImageView *)image config:(NSDictionary *)config;
+ (UIButton *) getImageButtonByConfig:(UIButton *)button config:(NSDictionary *)config;
+ (float)getTextHeight:(NSString *)text width:(CGFloat)width fontSize:(CGFloat)fontSize;
@end

/**
 * Delegate for ECViewUtil 
 */
@interface UIAlertViewDelegate : NSObject <UIAlertViewDelegate>

@property (strong, nonatomic) NSString* cancelTag;
@property (strong, nonatomic) NSString* okTag;

+ (UIAlertViewDelegate *) init:(NSString *)cancelTag okTag:(NSString *)okTag;

@end

