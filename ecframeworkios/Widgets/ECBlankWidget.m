//
//  ECBlankWidget.m
//  IOSProjectTemplate
//
//  Created by 程巍巍 on 4/23/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import "ECBlankWidget.h"
#import "NSStringExtends.h"
#import "ECJSUtil.h"
#import "ECBaseViewController.h"

#import "ECSelector.h"

#import "Constants.h"

#import "ECBaseView.h"
#import "ECLinearLayout.h"

#define kBlankWidgetDefaultWidth 320.0
#define kBlankWidgetDefaultHeight 44.0

@interface ECBlankWidget ()<ECAutoLayoutProtocol>

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic, strong) NSMutableDictionary *kProperties;

@property (nonatomic, strong) UIView *defaultLayout;

@end

@implementation ECBlankWidget
- (id)initWithConfigDic:(NSDictionary*)configDic pageContext:(ECBaseViewController*)pageContext
{
    self = [super initWithConfigDic:configDic pageContext:pageContext];
    if (self.controlId == nil || [self.controlId isEmpty]) {
        self.controlId  = @"blank_widget";
    }
    if (self) {
        //init default layout
        self.kProperties = [NSMutableDictionary new];
    }
    [self parsingConfigDic];
    
    //初始化默认界面
    NSString *JSONFile = [self getParam:@"_JSONFile"];
    if (JSONFile) {
        NSString *jsonFile = [[NSString appConfigPath] stringByAppendingString:JSONFile];
        NSMutableDictionary *defaultViewConfig = [[NSString stringWithContentsOfFile:jsonFile encoding:NSUTF8StringEncoding error:nil] JSONValue];
//        [self addSubview:[UIView initWithProperties:defaultViewConfig]];
        [self addSubviewWithProperties:defaultViewConfig];
    }
    
    //onBlankWidgetCreated
    [pageContext dispatchJSEvetn:[NSString stringWithFormat:@"%@.onCreated",self.controlId] withParams:nil];
    
//    ECSelector *selector = [[ECSelector selectorWithScript:@"ll TextView"] setObject:defaultViewConfig];
//    
//    NSLog(@"___ : %@",[selector evalute]);
    
//    [ECShareUtils share:@"share test message"];

//    [self setBackgroundColor:[UIColor whiteColor]];
    self.clipsToBounds = NO;
    return self;
}

#pragma mark- adapte autolayout
- (void)addSubview:(UIView *)view
{
    //观察是否需要重新布局
    [view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionOld context:nil];
    [super addSubview:view];
}
- (void)didAddSubview:(UIView *)subview
{
    [self sizeToFit];
}
#pragma mark- 观察是否需要重新布局
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"frame"]) {
        CGRect newFrame = [(NSValue *)change[@"old"] CGRectValue];
        UIView *view = object;
        
        if (newFrame.size.width == view.frame.size.width && newFrame.size.height == view.frame.size.height) {
            return;
        }
        [self sizeToFit];
    }
}

#pragma mark- sizeToFit
- (CGSize)sizeThatFits:(CGSize)size
{
    if (self.insertType<=0)
        self.insertType = 2;
    float w = 0;
    float h = 0;
    UIView *mainContentView = self.subviews.count ? self.subviews[0] : nil;
    // fit content
    // check fit father
    switch (self.insertType) {
        case 1: // (fillparent,fillparent) self.frame = parent.frame
            w = [self superview].frame.size.width;
            h = [self superview].frame.size.height;
            break;
        case 2: // (fillparent,wrapcontent) self.width = parent.width self.height = self.contentSize.height
            w = [self superview].frame.size.width;
            h = mainContentView ? [mainContentView marginFrame].size.height : kBlankWidgetDefaultHeight;
            break;
        case 3: // (wrapcontent,fillparent) self.width = parent.width self.height = parent.frame.size.height
            w = mainContentView ? [mainContentView marginFrame].size.width : kBlankWidgetDefaultWidth;
            h = [self superview].frame.size.height;
            break;
        case 4: // (wrapcontent,wrapcontent)
            w = mainContentView ? [mainContentView marginFrame].size.width : kBlankWidgetDefaultWidth;
            h = mainContentView ? [mainContentView marginFrame].size.height : kBlankWidgetDefaultHeight;
            break;
        default:
            break;
    }
    //ECLog(@"w = %f , h = %f",w,h);
    return CGSizeMake(w, h);
}
#pragma mark-
- (void)setWidthS:(NSString *)width
{
    self.width = [width floatValue];
}
- (void)setHeightS:(NSString *)height
{
    self.height = [height floatValue];
}
#pragma mark- ECBaseViewResizeDelegate
- (CGFloat)fillParentForHeight:(UIView *)subview
{
    return self.frame.size.height;
}
- (CGFloat)fillParentForWidth:(UIView *)subview
{
    return self.frame.size.width;
}
@end
