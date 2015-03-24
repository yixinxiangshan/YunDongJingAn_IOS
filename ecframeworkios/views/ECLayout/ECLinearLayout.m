//
//  ECLinearLayout.m
//  IOSProjectTemplate
//
//  Created by 程巍巍 on 4/16/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import "ECLinearLayout.h"

@interface ECLinearLayout ()

/**
 *  布局subview时的可用区域
 */
@property (nonatomic) CGRect validFrame;

@end

@implementation ECLinearLayout

- (void)layoutSubviews
{
    self.validFrame = self.paddingFrame;
    
    switch (self.orientation) {
        case DQLinearLayoutOrientationVertical:
            [self layoutSubviews_ver];
            break;
        case DQLinearLayoutOrientationHorizontal:
            [self layoutSubviews_hor];
            break;
        default:
            break;
    }
}

- (void)layoutSubviews_ver
{
    for (UIView *subview in self.subviews) {
        [self layoutSubview:subview inRect:_validFrame];
        
        if (self.contentAlign >> 1 & 0x0001) {
            //从上到下排列
            _validFrame.origin.y += subview.marginFrame.size.height;
            _validFrame.size.height -= subview.marginFrame.size.height;
        }else{
            //从下到上排列
            _validFrame.size.height -= subview.marginFrame.size.height;
        }
    }
    //如果 content_align = top|bottom
    //则将布局好的subviews 整体下移至中心
    if ((self.contentAlign >> 1 & 0x0001) && (self.contentAlign & 0x0001)) {
        CGPoint currentCenter = CGPointZero;
        for (UIView *subview in self.subviews) {
            currentCenter.x = self.paddingFrame.size.width / 2;
            currentCenter.y += subview.marginFrame.size.height / 2;
        }
        [self layoutToCenter:currentCenter];
    }
}

- (void)layoutSubviews_hor
{
    for (UIView *subview in self.subviews) {
        [self layoutSubview:subview inRect:_validFrame];
        if (self.contentAlign >> 3 & 0x0001) {
            //从左到右排列
            _validFrame.origin.x += subview.marginFrame.size.width;
            _validFrame.size.width -= subview.marginFrame.size.width;
        }else{
            //从右到左排列
            _validFrame.size.width -= subview.marginFrame.size.width;
        }
    }
    //如果 content_align = left|right
    //则将布局好的subviews 整体右移至中心
    if ((self.contentAlign >> 3 & 0x0001) && (self.contentAlign >> 2 & 0x0001)) {
        CGPoint currentCenter = CGPointZero;
        for (UIView *subview in self.subviews) {
            currentCenter.x += subview.marginFrame.size.width / 2 ;
            currentCenter.y = self.paddingFrame.size.height / 2;
        }
        [self layoutToCenter:currentCenter];
    }
}

- (void)layoutSubview:(UIView *)subview inRect:(CGRect)rect
{
    [subview sizeToFit];
    
    CGRect subFrame = subview.marginFrame;
    /**
     *  linearlayout 布局时，实际上是子view的（纵、横）顺序排列，
     *  contentAlign 实际上是subview中心相对剩余空间（rect）中心的偏移
     */
    
    //跟据content_algin计算中心位置
    CGPoint center = CGPointMake(rect.origin.x + rect.size.width/2.0, rect.origin.y + rect.size.height/2.0);
    
    if ((self.contentAlign >> 3 & 0x0001) && (self.contentAlign >> 2 & 0x0001) && self.orientation == DQLinearLayoutOrientationVertical) {
        //纵向布局时，左右居中，则不需要处理
    }else
        if (self.contentAlign >> 3 & 0x0001) {//left
            center.x -= (rect.size.width - subFrame.size.width)/2.0;
        }else
            if (self.contentAlign >> 2 & 0x0001) {//right
                center.x += (rect.size.width - subFrame.size.width)/2.0;
            }
    
    if ((self.contentAlign >> 1 & 0x0001) && (self.contentAlign & 0x0001) && self.orientation == DQLinearLayoutOrientationHorizontal) {
        //横向布局时，上下居中，则不需要处理
    }else
        if (self.contentAlign >> 1 & 0x0001) {//top
            center.y -= (rect.size.height - subFrame.size.height)/2.0;
        }else
            if (self.contentAlign & 0x0001) {//bottm
                center.y += (rect.size.height - subFrame.size.height)/2.0;
            }
    [subview setCenter:center];
    
    /**
     *  子view的align 属性,只能影响到在分配到的条状空间中心的位置偏移
     *  会覆盖contentAlign
     */
    //跟据subview.algin调整中心位置
    CGRect subRect = subview.marginFrame;
    switch (self.orientation) {
        case DQLinearLayoutOrientationVertical:
            subRect.origin.x = rect.origin.x;
            subRect.size.width = rect.size.width;
            center.x = subRect.origin.x + subRect.size.width / 2;
            
            //纵向排列，只需调整横向相对位置
            if (1 == (subview.align >> 3 & 0x0001)) {//left
                center.x -= (subRect.size.width - subFrame.size.width)/2.0;
            }
            if (1 == (subview.align >> 2 & 0x0001)) {//right
                center.x += (subRect.size.width - subFrame.size.width)/2.0;
            }
            break;
        case DQLinearLayoutOrientationHorizontal:
            subRect.origin.y = rect.origin.y;
            subRect.size.height = rect.size.height;
            center.y = subRect.origin.y + subRect.size.height/2;
            
            //横向排列，只需调整纵向相对位置
            if (1 == (subview.align >> 1 & 0x0001)) {//top
                center.y -= (subRect.size.height - subFrame.size.height)/2.0;
            }
            if (1 == (subview.align & 0x0001)) {//bottom
                center.y += (subRect.size.height - subFrame.size.height)/2.0;
            }
        default:
            break;
    }
    
    [subview setCenter:center];
}

- (void)layoutToCenter:(CGPoint)currentCenter
{
    CGPoint layoutCenter = CGPointMake(self.paddingFrame.size.width/2, self.paddingFrame.size.height/2);
    CGFloat dx = layoutCenter.x - currentCenter.x;
    CGFloat dy = layoutCenter.y - currentCenter.y;
    
    for (UIView *subview in self.subviews) {
        currentCenter = subview.center;
        currentCenter.x += dx;
        currentCenter.y += dy;
        [subview setCenter:currentCenter];
    }
}

#pragma mark- private properties
- (DQLinearLayoutOrientation)orientation
{
    return [self.kProperties[@"orientation"] UTF8String][0];
}

#pragma mark- DQAutoLayoutProtocol
/**
 *  wrap_content 需实现
 *  若未实现,则取当前值
 */
- (CGFloat)contentWidth
{
    CGFloat contentWidth = 0.0;
    for (UIView *subview in self.subviews) {
        contentWidth = contentWidth >= subview.marginFrame.size.width ? contentWidth : subview.marginFrame.size.width;
    }
    return contentWidth += self.padding.left + self.padding.right;
}
- (CGFloat)contentHeight
{
    CGFloat contentHeight = 0.0;
    for (UIView *subview in self.subviews) {
        contentHeight = contentHeight >= subview.marginFrame.size.height ? contentHeight : subview.marginFrame.size.height;
    }
    return contentHeight += self.padding.top + self.padding.bottom;
}

/**
 *  fill_parent 时,父view 需实现
 *  若未实现，则取当前父view的值
 */
- (CGFloat)validWidth
{
    return _validFrame.size.width;
}
- (CGFloat)validHeight
{
    return _validFrame.size.height;
}
@end


//
//@interface ECLinearLayout ()<ECBaseViewResizeDelegate>
//
//@property (nonatomic) CGRect lastSpace;
//
//@end
//
//@implementation ECLinearLayout
//
//- (void)parseProperties
//{
//    [super parseProperties];
//    
//    NSString *orientationValue = [NSString stringWithFormat:@"%@",self.kCustomProperties[@"orientation"]];
//    if ([self isPropertyUndefined:orientationValue]) {
//        [self.kCustomProperties setObject:@"vertical" forKey:@"orientation"];
//    }
//}
//- (void)layoutSubviews
//{
//    _lastSpace = self.pFrame;
//    
//    if (self.orientation == 'v') {
//        [self layoutSubviews_ver];
//    }if (self.orientation == 'h') {
//        [self layoutSubviews_hor];
//    }
//}
//- (void)layoutSubviews_ver
//{
//    for (ECBaseView *subview in self.subviews) {
//        [self layoutSubview:subview inRect:_lastSpace];
//        
//        if (self.contentAlign >> 1 & 0x0001) {
//            //从上到下排列
//            _lastSpace.origin.y += subview.mFrame.size.height;
//            _lastSpace.size.height -= subview.mFrame.size.height;
//        }else{
//            //从下到上排列
//            _lastSpace.size.height -= subview.mFrame.size.height;
//        }
//    }
//    //如果 content_align = top|bottom
//    //则将布局好的subviews 整体下移至中心
//    if ((self.contentAlign >> 1 & 0x0001) && (self.contentAlign & 0x0001)) {
//        CGPoint currentCenter = CGPointZero;
//        for (UIView *subview in self.subviews) {
//            currentCenter.x = self.pFrame.size.width / 2;
//            currentCenter.y += subview.mFrame.size.height / 2;
//        }
//        [self layoutToCenter:currentCenter];
//    }
//}
//
//- (void)layoutSubviews_hor
//{
//    for (ECBaseView *subview in self.subviews) {
//        [self layoutSubview:subview inRect:_lastSpace];
//        if (self.contentAlign >> 3 & 0x0001) {
//            //从左到右排列
//            _lastSpace.origin.x += subview.mFrame.size.width;
//            _lastSpace.size.width -= subview.mFrame.size.width;
//        }else{
//            //从右到左排列
//            _lastSpace.size.width -= subview.mFrame.size.width;
//        }
//    }
//    //如果 content_align = top|bottom
//    //则将布局好的subviews 整体右移至中心
//    if ((self.contentAlign >> 3 & 0x0001) && (self.contentAlign >> 2 & 0x0001)) {
//        CGPoint currentCenter = CGPointZero;
//        for (UIView *subview in self.subviews) {
//            currentCenter.x += subview.mFrame.size.width / 2 ;
//            currentCenter.y = self.pFrame.size.height / 2;
//        }
//        [self layoutToCenter:currentCenter];
//    }
//}
//
//- (void)layoutToCenter:(CGPoint)currentCenter
//{
//    CGPoint layoutCenter = CGPointMake(self.pFrame.size.width/2, self.pFrame.size.height/2);
//    CGFloat dx = layoutCenter.x - currentCenter.x;
//    CGFloat dy = layoutCenter.y - currentCenter.y;
//    
//    for (UIView *subview in self.subviews) {
//        currentCenter = subview.center;
//        currentCenter.x += dx;
//        currentCenter.y += dy;
//        [subview setCenter:currentCenter];
//    }
//}
//- (void)layoutSubview:(ECBaseView *)subview inRect:(CGRect)rect
//{
//    [subview sizeToFit];
//    
//    CGRect subFrame = subview.mFrame;
//    /**
//     *  linearlayout 布局时，实际上是子view的（纵、横）顺序排列，
//     *  contentAlign 实际上是subview中心相对剩余空间（rect）中心的偏移
//     */
//
//    CGPoint center = CGPointMake(rect.origin.x + rect.size.width/2.0, rect.origin.y + rect.size.height/2.0);
//    //跟据content_algin计算中心位置
//    if ((self.contentAlign >> 3 & 0x0001) && (self.contentAlign >> 2 & 0x0001) && self.orientation == 'v') {
//        //纵向布局时，左右居中，则不需要处理
//    }else
//    if (self.contentAlign >> 3 & 0x0001) {//left
//        center.x -= (rect.size.width - subFrame.size.width)/2.0;
//    }else
//    if (self.contentAlign >> 2 & 0x0001) {//right
//        center.x += (rect.size.width - subFrame.size.width)/2.0;
//    }
//    
//    if ((self.contentAlign >> 1 & 0x0001) && (self.contentAlign & 0x0001) && self.orientation == 'h') {
//        //横向布局时，上下居中，则不需要处理
//    }else
//    if (self.contentAlign >> 1 & 0x0001) {//top
//        center.y -= (rect.size.height - subFrame.size.height)/2.0;
//    }else
//        if (self.contentAlign & 0x0001) {//bottm
//        center.y += (rect.size.height - subFrame.size.height)/2.0;
//    }
//    
//    ECAlign currentAlign = [subview respondsToSelector:@selector(align)] ? [subview align] : ECAlignNull;
//    /**
//     *  子view的align 属性,只能影响到在分配到的条状空间中心的位置偏移
//     *  会覆盖contentAlign
//     */
//    if (currentAlign != ECAlignNull) {
//        CGRect activeRect = CGRectMake(center.x - subFrame.size.width/2, center.y - subFrame.size.height/2, subFrame.size.width, subFrame.size.height);
//        
//        if (self.orientation == 'v') {
//            activeRect.origin.x = rect.origin.x;
//            activeRect.size.width = rect.size.width;
//        }else if (self.orientation == 'h') {
//            activeRect.origin.y = rect.origin.y;
//            activeRect.size.height = rect.size.height;
//        }
//        center.x = activeRect.origin.x + activeRect.size.width / 2;
//        center.y = activeRect.origin.y + activeRect.size.height/2;
//        //跟据subview.algin调整中心位置
//        if (1 == (currentAlign >> 3 & 0x0001)) {//left
//            center.x -= (activeRect.size.width - subFrame.size.width)/2.0;
//        }
//        if (1 == (currentAlign >> 2 & 0x0001)) {//right
//            center.x += (activeRect.size.width - subFrame.size.width)/2.0;
//        }
//        if (1 == (currentAlign >> 1 & 0x0001)) {//top
//            center.y -= (activeRect.size.height - subFrame.size.height)/2.0;
//        }
//        if (1 == (currentAlign & 0x0001)) {//bottom
//            center.y += (activeRect.size.height - subFrame.size.height)/2.0;
//        }
//    }
//    ECEdgeSets margin = subview.margin;
//    center.x += margin.left;
//    center.y += margin.top;
//    [subview setCenter:center];
//}
//#pragma mark- private properties
//- (char)orientation
//{
//    return [self.kCustomProperties[@"orientation"] UTF8String][0];
//}
//#pragma mark- ECBaseViewResizeDelegate
//- (CGFloat)fillParentForWidth:(ECBaseView *)subview
//{
//    return _lastSpace.size.width;
//}
//- (CGFloat)fillParentForHeight:(ECBaseView *)subview
//{
//    return _lastSpace.size.height;
//}
//- (CGFloat)wrapContentForWidth
//{
//    ECEdgeSets padding = self.padding;
//    CGFloat width = 0.0;
//    if (self.orientation == 'v') {
//        for (UIView *subview in self.subviews) {
//            [subview sizeToFit];
//            width = subview.mFrame.size.width > width ? subview.mFrame.size.width : width;
//        }
//    }else if (self.orientation == 'h'){
//        for (UIView *subview in self.subviews) {
//            [subview sizeToFit];
//            width += subview.mFrame.size.width;
//        }
//    }
//    return width + padding.left + padding.right;
//}
//- (CGFloat)wrapContentForHeight
//{
//    CGFloat height = 0.0;
//    if (self.orientation == 'v') {
//        for (UIView *subview in self.subviews) {
//            [subview sizeToFit];
//            height += subview.mFrame.size.height;
//        }
//    }else if (self.orientation == 'h'){
//        for (UIView *subview in self.subviews) {
//            [subview sizeToFit];
//            height = subview.mFrame.size.height > height ? subview.mFrame.size.height : height;
//        }
//    }
//    return height;
//}
//@end
