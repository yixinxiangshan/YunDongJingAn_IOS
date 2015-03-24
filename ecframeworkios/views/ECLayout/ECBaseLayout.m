//
//  ECBaseLayout.m
//  IOSProjectTemplate
//
//  Created by 程巍巍 on 5/9/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import "ECBaseLayout.h"
#import "UIColorExtends.h"

@implementation ECBaseLayout

- (id)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithScript:self.kProperties[@"backgroundColor"]]];
    }
    return self;
}

#pragma mark- private properties

- (void)didAddSubview:(UIView *)subview
{
    [super didAddSubview:subview];
    [subview addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionOld context:(__bridge void *)(self)];
    [self sizeToFit];
    [self setNeedsLayout];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        CGRect newFrame = [(NSValue *)change[@"old"] CGRectValue];
        UIView *view = object;
        //如果frame大小发生变化，则重新布局
        if (fabs(newFrame.size.width - view.frame.size.width) < 0.01 && fabs(newFrame.size.height - view.frame.size.height) < 0.01) {
            
        }else{
            [self sizeToFit];
            [self setNeedsLayout];
        }
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsLayout];
}

#pragma mark- 自动布局触发
- (void)didMoveToWindow
{
    [self sizeToFit];
    [self setNeedsLayout];
}

- (void)willRemoveSubview:(UIView *)subview
{
    [subview removeObserver:self forKeyPath:@"frame"];
    [self sizeToFit];
    [self setNeedsLayout];
}

@end
