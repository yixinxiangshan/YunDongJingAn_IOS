//
//  UIView+ECCustomViewManager.h
//  IOSProjectTemplate
//
//  Created by 程巍巍 on 4/16/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//


/**
 *  已重载 willMoveToSuperview、willRemoveSubview 、observeValueForKeyPath方法
 *  子类若要重载，需调用［super method］方法
 */

#import <UIKit/UIKit.h>

typedef struct{
    CGFloat left;
    CGFloat right;
    CGFloat top;
    CGFloat bottom;
} DQEdgeSets;

typedef NS_ENUM(NSInteger, DQAlign) {
    DQAlignNull        = 0x000,
    DQAlignLeft        = 1 << 3,
    DQAlignRight       = 1 << 2,
    DQAlignTop         = 1 << 1,
    DQAlignBottom      = 1
};


@interface UIView (DQBaseView)
/**
 *  properties 包含view的所有可配置信息
 *
 *  所有添加的对像,必须具有 mutable 属性
 */
@property (nonatomic, readonly) NSMutableDictionary *kProperties;

/**
 *  align
 */
@property (nonatomic, readonly) DQAlign align;

/**
 *  contentAlign
 */
@property (nonatomic, readonly) DQAlign contentAlign;

/**
 *  margin
 */
@property (nonatomic, readonly) DQEdgeSets margin;

/**
 *  padding
 */
@property (nonatomic, readonly) DQEdgeSets padding;
+ (id)initWithProperties:(NSMutableDictionary *)properties;
- (id)initWithProperties:(NSMutableDictionary *)properties;

/**
 *  如果要改变添加行为，可重载
 *  重载时，不可调用super方法
 */
- (void)addSubviewWithProperties:(NSMutableDictionary *)properties;

/**
 *
 */
+ (NSDictionary *)kCustomViewClassMap;
@end

@interface UIView (DQViewSizeToFit)

@property (nonatomic, readonly) CGFloat width;
@property (nonatomic, readonly) CGFloat height;
///**
// *  实现wrap content (需实现DQAutoLayoutProtocol）与fill parent 功能
// *  若子类实现了 sizeThatFit 方法，则该功能失效
// */

/**
 *  marginFrame
 *  frame after adding margin
 */
@property (nonatomic, readonly) CGRect marginFrame;

/**
 *  layout 可用区域
 */
@property (nonatomic, readonly) CGRect paddingFrame;
@end

@protocol ECAutoLayoutProtocol <NSObject>

@optional
/**
 *  wrap_content 需实现
 *  若未实现,则取当前值
 */
- (CGFloat)contentWidth;
- (CGFloat)contentHeight;

/**
 *  fill_parent 时,父view 需实现
 *  若未实现，则取当前父view的值
 */
- (CGFloat)validWidth;
- (CGFloat)validHeight;
@end

@interface UIView (ECBaseViewTouchEvent)

/**
 *  view onClick 事件
 *  用UIGestureRecognizer 实现
 */
- (void)setOnClickEvent:(id)event;
@end

//typedef struct{
//    CGFloat left;
//    CGFloat right;
//    CGFloat top;
//    CGFloat bottom;
//} ECEdgeSets;
//
//typedef NS_ENUM(char, ECGravity) {
//    ECGravityUp    = 'l',
//    ECGravityDown   = 'r',
//};
//
//typedef NS_ENUM(NSInteger, ECAlign) {
//    ECAlignNull        = 0x000,
//    ECAlignLeft        = 1 << 3,
//    ECAlignRight       = 1 << 2,
//    ECAlignTop         = 1 << 1,
//    ECAlignBottom      = 1
//};
//
//@interface UIView (ECBaseView)
//
///**
// *  初始化方法
// */
//+ (id)initWithProperties:(NSDictionary *)properties;
//
///**
// *  解析参数，
// *  需要时，可重载，但不建议显式调用
// *  重载时，需调用 super 方法
// */
//- (void)parseProperties;
//- (void)parseWidthAndHeight;
//- (void)parseMargin;
//- (void)parseAlign;
//- (void)parseContentAlign;
//- (void)parsePadding;
//- (void)parseBackgroundColor;
//
///**
// *  set custom property
// *  属性发生变化后，会重新布局
// */
//- (void)setCustomProperty:(NSString *)propertyName value:(id)value;
//
///**
// *
// */
//@property (nonatomic, strong) NSMutableDictionary *kCustomProperties;
//
///**
// *  align, affect layout in parentview
// *  只读属性
// *  value : left right top down ; left|right,top|down, left|top ......
// */
//@property (nonatomic, readonly) ECAlign align;
//
///**
// *  contentAlign  影响所有子view的总体位置
// *  只读属性
// *  value : left right top down ; left|right,top|down, left|top ......
// */
//@property (nonatomic, readonly) ECAlign contentAlign;
//
///**
// *  view 包含margin时占用的空间，用于layout自动布局
// */
//@property (nonatomic, readonly) CGRect mFrame;
//
///**
// *  margin, affect layout in parentview
// *  只读属性
// */
//@property (nonatomic, readonly) ECEdgeSets margin;
//
///**
// *  padding , affect layout subview
// *  只读属性
// */
//@property (nonatomic, readonly) ECEdgeSets padding;
//
///**
// *  view 去除padding时subviews的可用空间，用于layout自动布局
// */
//@property (nonatomic, readonly) CGRect pFrame;
//
///**
// *  判断kCustomProperties中的属性值是否存在
// */
//- (BOOL)isPropertyUndefined:(NSString *)property;
//+ (BOOL)isPropertyUndefined:(NSString *)property;
//@end
//
//@interface UIView (ECCustomViewSizeToFit)
///**
// *  width / height
// *  只读属性
// *  子类需重载
// *  返回在父view上的可视高度，不包含margin
// *  与frame中的宽高不同，frame中的宽高为在父view上的实际高度，包含margin
// */
//@property (nonatomic, readonly) CGFloat kECWidth;
//@property (nonatomic, readonly) CGFloat kECHeight;
//
//@end
//
//@interface UIView (ECViewCustomProperties)
//
///**
// *  viewName 如果为空，则返回className
// */
//@property (nonatomic, strong) NSString *viewName;
//@end
//
//@interface UIView (ECBaseViewTouchEvent)
//
///**
// *  view onClick 事件
// *  用UIGestureRecognizer 实现
// */
//- (void)setOnClickEvent:(id)event;
//@end
//
//
//
//
//
//
//
//
//
//@interface ECBaseView :UIView
//
//@end
//
//@interface ECBaseView (ECLayout)
//
////- (CGSize)sizeThatFits:(CGSize)size;
//@end
//
//@interface ECBaseView (ECViewLifeCircleEvent)
//
////- (void)didMoveToSuperview
//
//@end
//
//@protocol ECBaseViewResizeDelegate <NSObject>
//
//@optional
///**
// *  当width/height为fill_parent时，计算相应的宽/高
// *  如果没有实现，现直接返回superview的宽/高
// */
//- (CGFloat)fillParentForWidth:(UIView *)subview;
//- (CGFloat)fillParentForHeight:(UIView *)subview;
//
///**
// *  当width/height为wrap_content时，计算相应的宽高
// *  如果没有实现，则返回当前的宽/高
// */
//- (CGFloat)wrapContentForWidth;
//- (CGFloat)wrapContentForHeight;
//@end

