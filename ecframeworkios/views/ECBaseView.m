//
//  UIView+ECCustomViewManager.m
//  IOSProjectTemplate
//
//  Created by 程巍巍 on 4/16/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import "ECBaseView.h"
#import <objc/runtime.h>

#import "NSStringExtends.h"
#import "NSObjectExtends.h"
#import "UIColorExtends.h"
#import "NSDeepCopy+DQ.h"
#import "NSDictionaryExtends.h"
#import "Constants.h"


#import "ECJSAPI.h"

#define kCustomPropertiesNullValue @"(null)"

static CGFloat value_px(CGFloat value);
static CGFloat value_px(CGFloat value)
{
    return value * (2.0/3.0);
}

@interface UIView (DQProperties)
@property (strong, nonatomic) NSMutableDictionary *kProperties;

@property (nonatomic, assign) DQAlign align;
@property (nonatomic, assign) DQAlign contentAlign;

@property (nonatomic, assign) DQEdgeSets margin;
@property (nonatomic, assign) DQEdgeSets padding;
@end

@implementation UIView (DQProperties)

#pragma mark- kProperties
@dynamic kProperties;
static const char kDQPropertiesKey;
- (void)setKProperties:(NSMutableDictionary *)kProperties
{
    objc_setAssociatedObject(self, &kDQPropertiesKey, kProperties, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableDictionary *)kProperties
{
    return objc_getAssociatedObject(self, &kDQPropertiesKey);
}

#pragma mark- align
@dynamic align;
static const char kDQAlignKey;
- (void)setAlign:(DQAlign)align
{
    objc_setAssociatedObject(self, &kDQAlignKey, [NSValue value:&align withObjCType:@encode(DQAlign)], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (DQAlign)align
{
    DQAlign align;
    [objc_getAssociatedObject(self, &kDQAlignKey) getValue:&align];
    return align;
}

#pragma mark- contentAlign
@dynamic contentAlign;
static const char kDQContentAlignKey;
- (void)setContentAlign:(DQAlign)contentAlign
{
    objc_setAssociatedObject(self, &kDQContentAlignKey, [NSValue value:&contentAlign withObjCType:@encode(DQAlign)], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (DQAlign)contentAlign
{
    DQAlign contentAlign;
    [objc_getAssociatedObject(self, &kDQContentAlignKey) getValue:&contentAlign];
    return contentAlign;
}

#pragma mark- margin
@dynamic margin;
static const char kDQMarginKey;
- (void)setMargin:(DQEdgeSets)margin
{
    objc_setAssociatedObject(self, &kDQMarginKey, [NSValue value:&margin withObjCType:@encode(DQEdgeSets)], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (DQEdgeSets)margin
{
    DQEdgeSets margin;
    [objc_getAssociatedObject(self, &kDQMarginKey) getValue:&margin];
    return margin;
}

#pragma mark- padding
@dynamic padding;
static const char kDQPaddingKey;
- (void)setPadding:(DQEdgeSets)padding
{
    objc_setAssociatedObject(self, &kDQPaddingKey, [NSValue value:&padding withObjCType:@encode(DQEdgeSets)], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (DQEdgeSets)padding
{
    DQEdgeSets padding;
    [objc_getAssociatedObject(self, &kDQPaddingKey) getValue:&padding];
    return padding;
}

#pragma mark- kPrivatePropertiesDefaultValue
- (NSDictionary *)kPrivatePropertiesDefaultValue
{
//    static NSDictionary *propertiesMap = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        propertiesMap = [DQRES loadJSON:[[NSBundle mainBundle] pathForResource:@"ECBaseViewPropertiesDefaultValue" ofType:@"json"] option:NSJSONReadingMutableContainers];
//    });
//    return propertiesMap;
    static NSDictionary *propertiesMap = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *mapSource = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ECBaseViewPropertiesDefaultValue" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
        mapSource = [mapSource stringByReplacingOccurrencesOfString:@"/\\*([\\u0000-\\uFFFF]+?)\\*/|//[^\\n]+" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, mapSource.length)];
        propertiesMap = [mapSource JSONValue];
    });
    return propertiesMap;
}

+ (NSDictionary *)kCustomViewClassMap
{
    static NSDictionary *viewMap = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *mapSource = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ECBaseViewMap" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
        mapSource = [mapSource stringByReplacingOccurrencesOfString:@"/\\*([\\u0000-\\uFFFF]+?)\\*/|//[^\\n]+" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, mapSource.length)];
        viewMap = [mapSource JSONValue];
    });
    return viewMap;
}
@end

@implementation UIView (DQBaseView)
@dynamic align;
@dynamic contentAlign;
@dynamic margin;
@dynamic padding;

+ (id)initWithProperties:(NSMutableDictionary *)properties
{
    if (!properties) {
        return nil;
    }
    NSString *viewType = [self kCustomViewClassMap][properties[@"type"]];
    if ([self isPropertyUndefined:viewType]) {
        viewType = @"ECLinearLayout"; 
    }
    [properties setObject:viewType forKey:@"type"];
    Class viewClass = NSClassFromString(viewType);
    if (!viewClass) {
        ECLog(@"UIView(ECBaseView) error : class named %@ is not exist .",viewType);
    }
    UIView *view = [[viewClass alloc] initWithProperties:properties];
    for (NSMutableDictionary *subProperties in properties[@"subviews"]) {
        [view addSubviewWithProperties:subProperties];
    }
    
    return view;
}
- (id)initWithProperties:(NSMutableDictionary *)properties
{
    self.kProperties = properties;
    [self parseProperties];
    [self.kProperties setObject:self._id forKey:@"_id"];
    
    NSString *viewId = self.kProperties[@"id"];
    viewId = viewId ? viewId : self._id;
    [self.kProperties setObject:viewId forKey:@"id"];
    self.id = viewId;
    
    self = [self init];
    [self sizeToFit];
    return self;
}

- (void)addSubviewWithProperties:(NSMutableDictionary *)properties
{
    [properties setObject:self.kProperties._id forKey:@"_parentId"];
    if (![self.kProperties[@"subviews"] containsObject:properties]) {
        if (!self.kProperties[@"subviews"]) {
            [self.kProperties setObject:[NSMutableArray new] forKey:@"subviews"];
        }
        [self.kProperties[@"subviews"] addObject:properties];
    }
    UIView *subview = [UIView initWithProperties:properties];
    [self addSubview:subview];
}

#pragma mark-
- (void)parseProperties
{
    [self parsePrivateProperties];
    
    //通用属性解析
    [self parseWidth];
    [self parseHeight];
    [self parseAlign];
    [self parseContentAlign];
    [self parseMargin];
    [self parsePadding];
}

- (void)parsePrivateProperties
{
    NSDictionary *privateProperties = [self kPrivatePropertiesDefaultValue][NSStringFromClass(self.class)];
    [privateProperties enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *propertyValue = [NSString stringWithFormat:@"%@",self.kProperties[key]];
        if ([self isPropertyUndefined:propertyValue]) {
            if ([self isPropertyUndefined:obj]) {
                ECLog(@"ECBaseView property default value undefined : %@",key);
                return;
            }
            [self.kProperties setObject:[obj mutableDeepCopy] forKey:key];
        }
    }];
}
#pragma mark-
- (void)parseWidth
{
    NSString *width = [NSString stringWithFormat:@"%@",self.kProperties[@"width"]];
    if ([self isPropertyUndefined:width]) width = @"fill_parent";//默认值
    [self.kProperties setObject:width forKey:@"width"];
}
- (void)parseHeight
{
    NSString *width = [NSString stringWithFormat:@"%@",self.kProperties[@"height"]];
    if ([self isPropertyUndefined:width]) width = @"wrap_content";//默认值
    [self.kProperties setObject:width forKey:@"height"];
}
- (void)parseAlign
{
    NSString *alignValue = self.kProperties[@"align"];
    if ([self isPropertyUndefined:alignValue]) {
        [self.kProperties setObject:@"left|top" forKey:@"align"];
    }else
        if ([alignValue isEqualToString:@"center"]) {
            [self.kProperties setObject:@"left|top|right|bottom" forKey:@"align"];
        }else if ([alignValue isEqualToString:@"vertical_center"]){
            [self.kProperties setObject:@"top|bottom" forKey:@"align"];
        }else if ([alignValue isEqualToString:@"horizontal_center"]){
            [self.kProperties setObject:@"top|right" forKey:@"align"];
        }
    
    DQAlign align = [self parseDQAlign:nil];
    NSArray *alignArr = [self.kProperties[@"align"] componentsSeparatedByString:@"|"];
    for (NSString *alignScript in alignArr) {
        align = align | [self parseDQAlign:(NSString *)alignScript];
    }
    //容错处理
    //left right 都不存在
    if (!(align >> 3 & 0x0001) && !(align >> 2 & 0x0001)) {
        align = align | DQAlignLeft;
    }
    //top bottom 都不存在
    if (!(align >> 1 & 0x0001) && !(align & 0x0001)) {
        align = align | DQAlignTop;
    }
    
    self.align = align;
    
}
- (void)parseContentAlign
{
    NSString *alignValue = self.kProperties[@"contentAlign"];
    if ([self isPropertyUndefined:alignValue]) {
        [self.kProperties setObject:@"left|top" forKey:@"contentAlign"];
    }else
        if ([alignValue isEqualToString:@"center"]) {
            [self.kProperties setObject:@"left|top|right|bottom" forKey:@"contentAlign"];
        }else if ([alignValue isEqualToString:@"vertical_center"]){
            [self.kProperties setObject:@"top|bottom" forKey:@"contentAlign"];
        }else if ([alignValue isEqualToString:@"horizontal_center"]){
            [self.kProperties setObject:@"top|right" forKey:@"contentAlign"];
        }
    
    DQAlign align = [self parseDQAlign:nil];
    NSArray *alignArr = [[self.kProperties[@"contentAlign"] stringByReplacingOccurrencesOfString:@" " withString:@""] componentsSeparatedByString:@"|"];
    for (NSString *alignScript in alignArr) {
        align = align | [self parseDQAlign:(NSString *)alignScript];
    }
    
    //容错处理
    //left right 都不存在
    if (!(align >> 3 & 0x0001) && !(align >> 2 & 0x0001)) {
        align = align | DQAlignLeft;
    }
    //top bottom 都不存在
    if (!(align >> 1 & 0x0001) && !(align & 0x0001)) {
        align = align | DQAlignTop;
    }
    self.contentAlign = align;
}
- (void)parseMargin
{
    NSString *marginValue = [NSString stringWithFormat:@"%@",self.kProperties[@"margin"]];
    if ([self isPropertyUndefined:marginValue]) {
        marginValue = @"2";
    }
    
    NSString *marginLeftValue = [NSString stringWithFormat:@"%@",self.kProperties[@"marginLeft"]];
    NSString *marginRightValue = [NSString stringWithFormat:@"%@",self.kProperties[@"marginRight"]];
    NSString *marginTopValue = [NSString stringWithFormat:@"%@",self.kProperties[@"marginTop"]];
    NSString *marginBottomValue = [NSString stringWithFormat:@"%@",self.kProperties[@"marginBottom"]];
    
    if ([self isPropertyUndefined:marginLeftValue]) {
        [self.kProperties setObject:marginValue forKey:@"marginLeft"];
    }
    if ([self isPropertyUndefined:marginRightValue]) {
        [self.kProperties setObject:marginValue forKey:@"marginRight"];
    }
    if ([self isPropertyUndefined:marginTopValue]) {
        [self.kProperties setObject:marginValue forKey:@"marginTop"];
    }
    if ([self isPropertyUndefined:marginBottomValue]) {
        [self.kProperties setObject:marginValue forKey:@"marginBottom"];
    }
    
    DQEdgeSets margin;
    margin.left = [self.kProperties[@"marginLeft"] floatValue];
    margin.right = [self.kProperties[@"marginRight"] floatValue];
    margin.top = [self.kProperties[@"marginTop"] floatValue];
    margin.bottom = [self.kProperties[@"marginBottom"] floatValue];
    
    self.margin = margin;
}
- (void)parsePadding
{
    NSString *paddingValue = [NSString stringWithFormat:@"%@",self.kProperties[@"padding"]];
    if ([self isPropertyUndefined:paddingValue]) {
        paddingValue = @"2";
    }
    
    NSString *marginLeftValue = [NSString stringWithFormat:@"%@",self.kProperties[@"paddingLeft"]];
    NSString *marginRightValue = [NSString stringWithFormat:@"%@",self.kProperties[@"paddingRight"]];
    NSString *marginTopValue = [NSString stringWithFormat:@"%@",self.kProperties[@"paddingTop"]];
    NSString *marginBottomValue = [NSString stringWithFormat:@"%@",self.kProperties[@"paddingBottom"]];
    
    if ([self isPropertyUndefined:marginLeftValue]) {
        [self.kProperties setObject:paddingValue forKey:@"paddingLeft"];
    }
    if ([self isPropertyUndefined:marginRightValue]) {
        [self.kProperties setObject:paddingValue forKey:@"paddingRight"];
    }
    if ([self isPropertyUndefined:marginTopValue]) {
        [self.kProperties setObject:paddingValue forKey:@"paddingTop"];
    }
    if ([self isPropertyUndefined:marginBottomValue]) {
        [self.kProperties setObject:paddingValue forKey:@"paddingBottom"];
    }
    
    DQEdgeSets padding;
    padding.left = [self.kProperties[@"paddingLeft"] floatValue];
    padding.right = [self.kProperties[@"paddingRight"] floatValue];
    padding.top = [self.kProperties[@"paddingTop"] floatValue];
    padding.bottom = [self.kProperties[@"paddingBottom"] floatValue];
    
    self.padding = padding;
}


#pragma mark-
- (DQAlign)parseDQAlign:(NSString *)alignScript
{
    NSString *align = [alignScript lowercaseString];
    if ([align isEqualToString:@"left"]) {
        return DQAlignLeft;
    }
    if ([align isEqualToString:@"right"]) {
        return DQAlignRight;
    }
    if ([align isEqualToString:@"top"]) {
        return DQAlignTop;
    }
    if ([align isEqualToString:@"bottom"]) {
        return DQAlignBottom;
    }
    return 0x0000;
}
- (BOOL)isPropertyUndefined:(NSString *)property
{
    return [UIView isPropertyUndefined:property];
}
+ (BOOL)isPropertyUndefined:(NSString *)property
{
    if (!property) {
        return YES;
    }
    if ([property isEqualToString:kCustomPropertiesNullValue]) {
        return YES;
    }
    if ([property isEqualToString:@""]) {
        return YES;
    }
    return NO;
}
@end

@implementation UIView (DQViewSizeToFit)

@dynamic width;
- (CGFloat)width
{
    NSString *widthValue = self.kProperties[@"width"];
    if ([widthValue isEqualToString:@"fill_parent"]) {
        UIView *parent = self.superview;
        if ([parent respondsToSelector:@selector(validWidth)]) {
            return [(id<ECAutoLayoutProtocol>)parent validWidth] - self.margin.left - self.margin.right;
        }
        return parent.frame.size.width - self.margin.left - self.margin.right;
    }else if ([widthValue isEqualToString:@"wrap_content"]){
        if ([self respondsToSelector:@selector(contentWidth)]) {
            return [(id<ECAutoLayoutProtocol>)self contentWidth];
        }
        return self.frame.size.width;
    }else if ([widthValue hasSuffix:@"%"]){
        //父view宽度的百分比
        CGFloat widthRate = [widthValue floatValue] / 100.0;
        return self.superview.paddingFrame.size.width * widthRate;
    }else{
        return value_px([widthValue floatValue]);
    }
    return self.frame.size.width;
}

@dynamic height;
- (CGFloat)height
{
    NSString *heightValue = self.kProperties[@"height"];
    if ([heightValue isEqualToString:@"fill_parent"]) {
        UIView *parent = self.superview;
        if ([parent respondsToSelector:@selector(validHeight)]) {
            return [(id<ECAutoLayoutProtocol>)parent validHeight] - self.margin.top - self.margin.bottom;
        }
        return parent.frame.size.height - self.margin.top - self.margin.bottom;
    }else if ([heightValue isEqualToString:@"wrap_content"]){
        if ([self respondsToSelector:@selector(contentHeight)]) {
            return [(id<ECAutoLayoutProtocol>)self contentHeight];
        }
        return self.frame.size.height;
    }else if ([heightValue hasSuffix:@"%"]){
        //父view宽度的百分比
        CGFloat widthRate = [heightValue floatValue] / 100.0;
        return self.superview.paddingFrame.size.width * widthRate;
    }else{
        return value_px([heightValue floatValue]);
    }
    
    return self.frame.size.height;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize reSize;
    reSize.width = [self width];
    reSize.height = [self height];
    return reSize;
}

@dynamic marginFrame;
- (CGRect)marginFrame
{
    CGRect marginFrame = self.frame;
    marginFrame.size.width += self.margin.left + self.margin.right;
    marginFrame.size.height += self.margin.top + self.margin.bottom;
    
    return marginFrame;
}
@dynamic paddingFrame;
- (CGRect)paddingFrame
{
    CGRect paddingFrame = self.bounds;
    paddingFrame.origin.x = self.padding.left;
    paddingFrame.origin.y = self.padding.top;
    paddingFrame.size.width -= self.padding.left + self.padding.right;
    paddingFrame.size.height -= self.padding.top + self.padding.bottom;
    
    return paddingFrame;
}
@end

static const char  kECBaseViewTouchEventKey;
@implementation UIView (ECBaseViewTouchEvent)

- (void)setOnClickEvent:(NSDictionary *)event
{
    [[self touchEventMap] setObject:event[@"event"] forKey:event[@"eventId"]];
    if ([self hasTapGestureRecognizer])
        return;
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(kTouchEvent:)]];
    
}

-(void)kTouchEvent:(UITapGestureRecognizer *)tapGestureRecognizer
{
    NSString *eventId = [NSString stringWithFormat:@"%@_onClick-%i",self.id,tapGestureRecognizer.numberOfTapsRequired];
    NSDictionary *event = [[self touchEventMap] objectForKey:eventId];
    
    [ECJSAPI dispatch_page_on_event:event withParams:@{@"_id": self.kProperties[@"_id"]}];
}
#pragma mark- click event map

- (NSMutableDictionary *)touchEventMap
{
    NSMutableDictionary *eventMap = objc_getAssociatedObject(self, &kECBaseViewTouchEventKey);
    if (!eventMap) {
        eventMap = [NSMutableDictionary new];
        objc_setAssociatedObject(self, &kECBaseViewTouchEventKey, eventMap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return eventMap ;
}

#pragma mark-
- (BOOL)hasTapGestureRecognizer
{
    for (UIGestureRecognizer *gestureRecognizer in self.gestureRecognizers) {
        if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            return YES;
        }
    }
    return NO;
}
@end


//static const char kECCustomProperties;
//static const char kECCustomViewAlignKey;
//static const char kECCustomViewContentAlignKey;
/**
 *  dp -> px
 */
//static CGFloat value_px(CGFloat value);
//static CGFloat value_px(CGFloat value)
//{
//    return value * (2.0/3.0);
//}
//
//@interface ECBaseView () <ECBaseViewResizeDelegate>
//
//@end
//
//
//
//#define kCustomPropertiesNullValue @"(null)"
//
//
//@implementation UIView (ECBaseView)
//
//+ (id)initWithProperties:(NSDictionary *)properties
//{
//    NSString *viewType = properties[@"type"];
//    viewType = [self isPropertyUndefined:viewType] ? @"ECLinearLayout" : viewType;
//    Class viewClass = NSClassFromString([self kCustomViewClassMap][viewType]);
//    if (!viewClass) {
//        ECLog(@"UIView(ECBaseView) error : class named %@ is not exist .",viewType);
//    }
//    UIView *view = [viewClass alloc];
//    view.kCustomProperties = [NSMutableDictionary dictionaryWithDictionary:properties];
//    
//    //
//    [view parseProperties];
//    [view kDefaultInit];
//    view = [view init];
//    
//    [view setBackgroundColor:[UIColor colorWithHexString:view.kCustomProperties[@"backgroundColor"]]];
//    
//    return view;
//}
//
//- (void) kDefaultInit
//{
//    if (self) {
//        //
//        self.clipsToBounds = NO;
//        if (![self.kCustomProperties isEmpty]) {
//            NSString *viewId = self.kCustomProperties[@"id"];
//            viewId = viewId ? viewId : [NSStringFromClass(self.class) stringByAppendingString:[NSString randomString]];
//            [self.kCustomProperties setObject:viewId forKey:@"id"];
//            self.id = viewId;
//        }
//    }
//}
//
//- (void)parseProperties
//{
//    [self parsePrivateProperties];
//    //检查是否有宽度、高度属性
//    [self parseWidthAndHeight];
//    
//    //margin,在父view中布局时的边距,left/right/top/bottom
//    [self parseMargin];
//    
//    [self parseAlign];
//    [self parseContentAlign];
//    [self parseBackgroundColor];
//    
//    //padding,布局子view 时，子view到父view边界的最小距离
//    [self parsePadding];
//}
//- (void)parsePrivateProperties
//{
//    NSDictionary *privateProperties = self.kCustomPrivatePropertiesDefaultValue[NSStringFromClass(self.class)];
//    [privateProperties enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        NSString *propertyValue = [NSString stringWithFormat:@"%@",self.kCustomProperties[key]];
//        if ([self isPropertyUndefined:propertyValue]) {
//            if ([self isPropertyUndefined:obj]) {
//                ECLog(@"ECBaseView property default value undefined : %@",key);
//                return;
//            }
//            [self.kCustomProperties setObject:obj forKey:key];
//        }
//    }];
//}
//
//- (void)parseWidthAndHeight
//{
//    NSString *width = [NSString stringWithFormat:@"%@",self.kCustomProperties[@"width"]];
//    NSString *height = [NSString stringWithFormat:@"%@",self.kCustomProperties[@"height"]];
//    if ([self isPropertyUndefined:width]) width = @"fill_parent";//默认值
//    if ([self isPropertyUndefined:height]) height = @"wrap_content";//默认值
//    [self.kCustomProperties setObject:width forKey:@"width"];
//    [self.kCustomProperties setObject:height forKey:@"height"];
//}
//
//- (void)parseMargin
//{
//    NSString *marginValue = [NSString stringWithFormat:@"%@",self.kCustomProperties[@"margin"]];
//    if (![self isPropertyUndefined:marginValue]) {
//        [self.kCustomProperties setObject:marginValue forKey:@"marginLeft"];
//        [self.kCustomProperties setObject:marginValue forKey:@"marginRight"];
//        [self.kCustomProperties setObject:marginValue forKey:@"marginTop"];
//        [self.kCustomProperties setObject:marginValue forKey:@"marginBottom"];
//    }else{
//        NSString *marginLeftValue = [NSString stringWithFormat:@"%@",self.kCustomProperties[@"marginLeft"]];
//        NSString *marginRightValue = [NSString stringWithFormat:@"%@",self.kCustomProperties[@"marginRight"]];
//        NSString *marginTopValue = [NSString stringWithFormat:@"%@",self.kCustomProperties[@"marginTop"]];
//        NSString *marginBottomValue = [NSString stringWithFormat:@"%@",self.kCustomProperties[@"marginBottom"]];
//        
//        if ([self isPropertyUndefined:marginLeftValue]) {
//            [self.kCustomProperties setObject:@"2dp" forKey:@"marginLeft"];
//        }
//        if ([self isPropertyUndefined:marginRightValue]) {
//            [self.kCustomProperties setObject:@"2dp" forKey:@"marginRight"];
//        }
//        if ([self isPropertyUndefined:marginTopValue]) {
//            [self.kCustomProperties setObject:@"2dp" forKey:@"marginTop"];
//        }
//        if ([self isPropertyUndefined:marginBottomValue]) {
//            [self.kCustomProperties setObject:@"2dp" forKey:@"marginBottom"];
//        }
//    }
//
//}
//
//- (void)parseAlign
//{
//    NSString *alignValue = self.kCustomProperties[@"align"];
//    if ([self isPropertyUndefined:alignValue]) {
//        [self.kCustomProperties setObject:@"left|top" forKey:@"align"];
//    }else
//    if ([alignValue isEqualToString:@"center"]) {
//        [self.kCustomProperties setObject:@"left|top|right|bottom" forKey:@"align"];
//    }else if ([alignValue isEqualToString:@"vertical_center"]){
//        [self.kCustomProperties setObject:@"top|bottom" forKey:@"align"];
//    }else if ([alignValue isEqualToString:@"horizontal_center"]){
//        [self.kCustomProperties setObject:@"top|right" forKey:@"align"];
//    }
//    
//    ECAlign align = [self parseECAlign:nil];
//    NSArray *alignArr = [self.kCustomProperties[@"align"] componentsSeparatedByString:@"|"];
//    for (NSString *alignScript in alignArr) {
//        align = align | [self parseECAlign:(NSString *)alignScript];
//    }
//    //容错处理
//    //left right 都不存在
//    if (!(align >> 3 & 0x0001) && !(align >> 2 & 0x0001)) {
//        align = align | ECAlignLeft;
//    }
//    //top bottom 都不存在
//    if (!(align >> 1 & 0x0001) && !(align & 0x0001)) {
//        align = align | ECAlignTop;
//    }
//    
//    self.align = align;
//}
//- (void)parseContentAlign
//{
//    NSString *alignValue = self.kCustomProperties[@"contentAlign"];
//    if ([self isPropertyUndefined:alignValue]) {
//        [self.kCustomProperties setObject:@"left|top" forKey:@"contentAlign"];
//    }else
//    if ([alignValue isEqualToString:@"center"]) {
//        [self.kCustomProperties setObject:@"left|top|right|bottom" forKey:@"contentAlign"];
//    }else if ([alignValue isEqualToString:@"vertical_center"]){
//        [self.kCustomProperties setObject:@"top|bottom" forKey:@"contentAlign"];
//    }else if ([alignValue isEqualToString:@"horizontal_center"]){
//        [self.kCustomProperties setObject:@"top|right" forKey:@"contentAlign"];
//    }
//    
//    ECAlign align = [self parseECAlign:nil];
//    NSArray *alignArr = [self.kCustomProperties[@"contentAlign"] componentsSeparatedByString:@"|"];
//    for (NSString *alignScript in alignArr) {
//        align = align | [self parseECAlign:(NSString *)alignScript];
//    }
//    
//    //容错处理
//    //left right 都不存在
//    if (!(align >> 3 & 0x0001) && !(align >> 2 & 0x0001)) {
//        align = align | ECAlignLeft;
//    }
//    //top bottom 都不存在
//    if (!(align >> 1 & 0x0001) && !(align & 0x0001)) {
//        align = align | ECAlignTop;
//    }
//    self.contentAlign = align;
//}
//
//- (void)parsePadding
//{
//    NSString *paddingValue = [NSString stringWithFormat:@"%@",self.kCustomProperties[@"padding"]];
//    if (![self isPropertyUndefined:paddingValue]) {
//        [self.kCustomProperties setObject:paddingValue forKey:@"paddingLeft"];
//        [self.kCustomProperties setObject:paddingValue forKey:@"paddingRight"];
//        [self.kCustomProperties setObject:paddingValue forKey:@"paddingTop"];
//        [self.kCustomProperties setObject:paddingValue forKey:@"paddingBottom"];
//    }else{
//        NSString *paddingLeftValue = [NSString stringWithFormat:@"%@",self.kCustomProperties[@"paddingLeft"]];
//        NSString *paddingRightValue = [NSString stringWithFormat:@"%@",self.kCustomProperties[@"paddingRight"]];
//        NSString *paddingTopValue = [NSString stringWithFormat:@"%@",self.kCustomProperties[@"paddingTop"]];
//        NSString *paddingBottomValue = [NSString stringWithFormat:@"%@",self.kCustomProperties[@"paddingBottom"]];
//        
//        if ([self isPropertyUndefined:paddingLeftValue]) {
//            [self.kCustomProperties setObject:@"2dp" forKey:@"paddingLeft"];
//        }
//        if ([self isPropertyUndefined:paddingRightValue]) {
//            [self.kCustomProperties setObject:@"2dp" forKey:@"paddingRight"];
//        }
//        if ([self isPropertyUndefined:paddingTopValue]) {
//            [self.kCustomProperties setObject:@"2dp" forKey:@"paddingTop"];
//        }
//        if ([self isPropertyUndefined:paddingBottomValue]) {
//            [self.kCustomProperties setObject:@"2dp" forKey:@"paddingBottom"];
//        }
//    }
//}
//
//- (void)parseBackgroundColor
//{
//    NSString *backgroundColorValue = self.kCustomProperties[@"backgroundColor"];
//    if ([self isPropertyUndefined:backgroundColorValue]) {
//        [self.kCustomProperties setObject:@"#00ffffff" forKey:@"backgroundColor"];
//    }
//}
//- (void)setCustomProperty:(NSString *)propertyName value:(id)value
//{
//    [self.kCustomProperties setObject:value forKey:propertyName];
//    [self layoutIfNeeded];
//}
//
//
//#pragma mark- mFrame pFrame
//@dynamic mFrame;
//- (CGRect)mFrame
//{
//    CGRect mf = self.frame;
//    ECEdgeSets margin = self.margin;
//    mf.size.width += margin.left + margin.right;
//    mf.size.height += margin.top + margin.bottom;
//    return mf;
//}
//- (CGRect)pFrame
//{
//    CGRect frame = self.frame;
//    ECEdgeSets padding = self.padding;
//    frame.origin.x = padding.left;
//    frame.origin.y = padding.top;
//    frame.size.width = frame.size.width - padding.left - padding.right;
//    frame.size.height = frame.size.height - padding.top - padding.bottom;
//    return frame;
//}
//
//#pragma mark- margin
//@dynamic margin;
//- (ECEdgeSets)margin
//{
//    ECEdgeSets edgeSets;
//    edgeSets.left = value_px([self.kCustomProperties[@"marginLeft"] floatValue]);
//    edgeSets.right = value_px([self.kCustomProperties[@"marginRight"] floatValue]);
//    edgeSets.top = value_px([self.kCustomProperties[@"marginTop"] floatValue]);
//    edgeSets.bottom = value_px([self.kCustomProperties[@"marginBottom"] floatValue]);
//    
//    return edgeSets;
//}
//
//#pragma mrk- padding
//- (ECEdgeSets)padding
//{
//    ECEdgeSets edgeSets;
//    edgeSets.left = value_px([self.kCustomProperties[@"paddingLeft"] floatValue]);
//    edgeSets.right = value_px([self.kCustomProperties[@"paddingRight"] floatValue]);
//    edgeSets.top = value_px([self.kCustomProperties[@"paddingTop"] floatValue]);
//    edgeSets.bottom = value_px([self.kCustomProperties[@"paddingBottom"] floatValue]);
//    
//    return edgeSets;
//}
//
//#pragma mark- align contentAlign
//@dynamic align;
//- (void)setAlign:(ECAlign)align
//{
//    objc_setAssociatedObject(self, &kECCustomViewAlignKey, [NSNumber numberWithInteger:align], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//- (ECAlign)align
//{
//    return [objc_getAssociatedObject(self, &kECCustomViewAlignKey) integerValue];
//}
//@dynamic contentAlign;
//- (void)setContentAlign:(ECAlign)contentAlign
//{
//    objc_setAssociatedObject(self, &kECCustomViewContentAlignKey, [NSNumber numberWithInteger:contentAlign], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//- (ECAlign)contentAlign
//{
//    return [objc_getAssociatedObject(self, &kECCustomViewContentAlignKey) integerValue];
//}
//
//#pragma mark- kCustomProperties
//@dynamic kCustomProperties;
//- (void)setKCustomProperties:(NSMutableDictionary *)kCustomProperties
//{
//    objc_setAssociatedObject(self, &kECCustomProperties, kCustomProperties, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//- (NSMutableDictionary *)kCustomProperties
//{
//    NSMutableDictionary *properties = objc_getAssociatedObject(self, &kECCustomProperties);
//    return properties ? properties : [NSMutableDictionary new];
//}
//
//- (NSDictionary *)kCustomPrivatePropertiesDefaultValue
//{
//    static NSDictionary *propertiesMap = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        NSString *mapSource = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ECBaseViewPropertiesDefaultValue" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
//        mapSource = [mapSource stringByReplacingOccurrencesOfString:@"/\\*([\\u0000-\\uFFFF]+?)\\*/|//[^\\n]+" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, mapSource.length)];
//        propertiesMap = [mapSource JSONValue];
//    });
//    return propertiesMap;
//}
//
//#pragma mark- ECCustomViewMap
//+ (NSDictionary *)kCustomViewClassMap
//{
//    static NSDictionary *viewMap = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        NSString *mapSource = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ECBaseViewMap" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
//        mapSource = [mapSource stringByReplacingOccurrencesOfString:@"/\\*([\\u0000-\\uFFFF]+?)\\*/|//[^\\n]+" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, mapSource.length)];
//        viewMap = [mapSource JSONValue];
//    });
//    return viewMap;
//}
//
//#pragma mark- privatemethod
//- (ECAlign)parseECAlign:(NSString *)alignScript
//{
//    NSString *align = [alignScript lowercaseString];
//    if ([align isEqualToString:@"left"]) {
//        return ECAlignLeft;
//    }
//    if ([align isEqualToString:@"right"]) {
//        return ECAlignRight;
//    }
//    if ([align isEqualToString:@"top"]) {
//        return ECAlignTop;
//    }
//    if ([align isEqualToString:@"bottom"]) {
//        return ECAlignBottom;
//    }
//    return 0x0000;
//}
//- (BOOL)isPropertyUndefined:(NSString *)property
//{
//    return [UIView isPropertyUndefined:property];
//}
//+ (BOOL)isPropertyUndefined:(NSString *)property
//{
//    if (!property) {
//        return YES;
//    }
//    if ([property isEqualToString:kCustomPropertiesNullValue]) {
//        return YES;
//    }
//    if ([property isEqualToString:@""]) {
//        return YES;
//    }
//    return NO;
//}
//@end
//
//@implementation UIView (ECCustomViewSizeToFit)
//#pragma mark- width height
//- (CGFloat)kECWidth
//{
//    ECEdgeSets margin = self.margin;
//    ECEdgeSets padding = self.padding;
//    NSString *value = self.kCustomProperties[@"width"];
//    if ([value isEqualToString:@"fill_parent"] && [self superview]) {
//        if ([self.superview respondsToSelector:@selector(fillParentForWidth:)]) {
//            CGFloat parentWidth = [(id<ECBaseViewResizeDelegate>)self.superview fillParentForWidth:self];
//            return parentWidth - margin.left - margin.right;
//        }
//        return self.superview.pFrame.size.width - margin.left - margin.right;
//    }else if ([value isEqualToString:@"wrap_content"]){
//        if ([self respondsToSelector:@selector(wrapContentForWidth)]) {
//            return [(id<ECBaseViewResizeDelegate>)self wrapContentForWidth]  + padding.left + padding.right;
//        }
//        return self.frame.size.width;
//    }else if ([value hasSuffix:@"%"]){
//        //父view宽度的百分比
//        CGFloat widthRate = [value floatValue] / 100.0;
//        return self.superview.pFrame.size.width * widthRate;
//    }
//    
//    return value_px([value floatValue]) ;
//}
//- (CGFloat)kECHeight
//{
//    ECEdgeSets margin = self.margin;
//    ECEdgeSets padding = self.padding;
//    NSString *value = self.kCustomProperties[@"height"];
//    if ([value isEqualToString:@"fill_parent"] && [self superview]) {
//        if ([self.superview respondsToSelector:@selector(fillParentForHeight:)]) {
//            CGFloat height = [(id<ECBaseViewResizeDelegate>)self.superview fillParentForHeight:self];
//            return height - margin.top - margin.bottom;
//        }
//        return self.superview.pFrame.size.height - margin.top - margin.bottom;
//    }else if ([value isEqualToString:@"wrap_content"]){
//        if ([self respondsToSelector:@selector(wrapContentForHeight)]) {
//            return [(id<ECBaseViewResizeDelegate>)self wrapContentForHeight]  + padding.top + padding.bottom;
//        }
//        return self.frame.size.height;
//    }else if ([value hasSuffix:@"%"]){
//        //父view宽度的百分比
//        CGFloat heightRate = [value floatValue] / 100.0;
//        return self.superview.pFrame.size.height * heightRate;
//    }
//    
//    return value_px([value floatValue]);
//}
//- (CGSize)sizeThatFits:(CGSize)size
//{
//    CGSize reSize;
//    
//    reSize.width = self.kECWidth;
//    reSize.height = self.kECHeight;
//    return reSize;
//}
//@end
//
//
//static const char kECViewCustomPropertyViewNameKey;
//@implementation UIView (ECViewCustomProperties)
//
//@dynamic viewName;
//- (void)setViewName:(NSString *)viewName
//{
//    objc_setAssociatedObject(self, &kECViewCustomPropertyViewNameKey, viewName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//- (NSString *)viewName
//{
//    NSString *name = objc_getAssociatedObject(self, &kECViewCustomPropertyViewNameKey);
//    return name ? name : NSStringFromClass(self.class);
//}
//
//@end
//
//
//static const char  kECBaseViewTouchEventKey;
//@implementation UIView (ECBaseViewTouchEvent)
//
//- (void)setOnClickEvent:(NSDictionary *)event
//{
//    [[self touchEventMap] setObject:event[@"event"] forKey:event[@"eventId"]];
//    if ([self hasTapGestureRecognizer])
//        return;
//    
//    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(kTouchEvent:)]];
//    
//}
//
//-(void)kTouchEvent:(UITapGestureRecognizer *)tapGestureRecognizer
//{
//    NSString *eventId = [NSString stringWithFormat:@"%@_onClick-%i",self.id,tapGestureRecognizer.numberOfTapsRequired];
//    NSDictionary *event = [[self touchEventMap] objectForKey:eventId];
//    
//    [ECJSAPI dispatch_page_on_event:event withParams:@{@"view_memeryId": [NSString stringWithFormat:@"%p",self]}];
//}
//#pragma mark- click event map
//
//- (NSMutableDictionary *)touchEventMap
//{
//    NSMutableDictionary *eventMap = objc_getAssociatedObject(self, &kECBaseViewTouchEventKey);
//    if (!eventMap) {
//        eventMap = [NSMutableDictionary new];
//        objc_setAssociatedObject(self, &kECBaseViewTouchEventKey, eventMap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    }
//    return eventMap ;
//}
//
//#pragma mark-
//- (BOOL)hasTapGestureRecognizer
//{
//    for (UIGestureRecognizer *gestureRecognizer in self.gestureRecognizers) {
//        if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
//            return YES;
//        }
//    }
//    return NO;
//}
//@end
//
//
//
//#pragma mark- ECBaseView
//
//
//@implementation ECBaseView
//
//- (id)init
//{
//    self = [super init];
//    if (self) {
//        self.clipsToBounds = YES;
//    }
//    return self;
//}
//
//@end
//
//@implementation ECBaseView (ECSubview)
//
//- (void)addSubview:(ECBaseView *)view
//{
//    //观察是否需要重新布局
//    [view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionOld context:nil];
//     [super addSubview:view];
//    
//}
//- (void)didAddSubview:(UIView *)subview
//{
//    [self sizeToFit];
//    [self layoutSubviews];
//}
//#pragma mark- 观察是否需要重新布局
//- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//    if ([keyPath isEqualToString:@"frame"]) {
//        CGRect newFrame = [(NSValue *)change[@"old"] CGRectValue];
//        UIView *view = object;
//        //如果frame大小发生变化，则重新布局
//        if (fabs(newFrame.size.width - view.frame.size.width) < 0.01 && fabs(newFrame.size.height - view.frame.size.height) < 0.01) {
//            
//        }else{
//            [self sizeToFit];
//            [self setNeedsLayout];
//        }
//        
//    }
//}
//@end
//
//@implementation ECBaseView (ECLayout)
//
//@end
//
//@implementation ECBaseView (ECViewLifeCircleEvent)
//
//

//@end