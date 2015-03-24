//
//  UIView+Size.m
//  ECDemoFrameWork
//
//  Created by EC on 9/6/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "UIView+Size.h"
#import "NSArrayExtends.h"
#import "Constants.h"
#import "ECBaseWidget.h"

#import "ECActionBarWidget.h"
@implementation UIView (Size);

- (NSMutableArray*)views{
    NSMutableArray* sViews = [NSMutableArray arrayWithArray:[self subviews]];
    if ([self isKindOfClass:[UIScrollView class]]) {
        [sViews removeObjectAtIndex:([sViews count]-1)];
        [sViews removeObjectAtIndex:([sViews count]-1)];
    }
    return sViews;
}

- (void)insertViewToView:(UIView *)view insertType:(int) insertType position:(int)position{
    if([[self views] isEmpty]){
        position  = 0;
    }
    if([[self views] count]<=position)
        position = (int)[[self views] count];
    [self insertSubview:view atIndex:position];
    if (position>0) {
        CGRect frame = view.frame;
        UIView* preView = (UIView*)[[self subviews] objectAtIndex:position-1];
        frame.origin.y = preView.frame.origin.y + preView.frame.size.height + 10;
        view.frame = frame;
    }
    if ([view isKindOfClass:[ECBaseWidget class]]) {
        [((ECBaseWidget*)view) setInsertType:insertType];
    }
    
    [view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    CGRect newFrame = [(NSValue *)change[@"new"] CGRectValue];
    UIView *view = object;
    if (newFrame.origin.x == view.frame.origin.x && newFrame.origin.y == view.frame.origin.y && newFrame.size.width == view.frame.size.width && newFrame.size.height == view.frame.size.height) {
        return;
    }
    if ([keyPath isEqualToString:@"frame"]) {
        [self reFrameNext:object];
    }
}

- (void) reFrameNext:(UIView*)view{
    UIView* nextView = nil;
    NSArray* views = [self views];
    for (UIView* tempView in views) {
        if (tempView.frame.origin.y > view.frame.origin.y){
            nextView = tempView;
            break;
        }
    }
    if (nextView != nil) {
        CGRect frame = nextView.frame;
        frame.origin.y = view.frame.origin.y + view.frame.size.height+8;
        nextView.frame = frame;
        return;
    }
    [self resetContainerFrame];
}


- (void)resetContainerFrame{
    UIView* view = nil;
    for (UIView* tempView in [self views]) {
        ECLog(@"view = %@",tempView);
        if (view == nil)
            view = tempView;
        if (tempView.frame.origin.y > view.frame.origin.y )
            view = tempView;
    }
    
    float height = view.frame.origin.y+view.frame.size.height;
    if ([self isKindOfClass:[UIScrollView class]]) {
        UIScrollView* scrollContainer = (UIScrollView*)self;
        [scrollContainer setContentSize:CGSizeMake(scrollContainer.contentSize.width, height)];
        return;
    }
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}


@end
