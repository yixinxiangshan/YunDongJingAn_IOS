//
//  ECBaseWidget.m
//  ECDemoFrameWork
//
//  Created by EC on 9/2/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECBaseWidget.h"
#import "NSStringExtends.h"
#import "ECJsonUtil.h"
#import "NSDictionaryExtends.h"
#import "Constants.h"
#import "NSArrayExtends.h"
#import "UIView+Size.h"
#import "ECViewUtil.h"
#import "ECWidgetUtil.h"
#import "ECDataUtil.h"
#import "ECAppUtil.h"
#import "UIColorExtends.h"
#import "ECReflectionUtil.h"
#import "NSObjectExtends.h"
#import "ECFormWidget.h"

#import "ECbaseView.h"

@interface ECBaseWidget ()

@end

@implementation ECBaseWidget

- (id)initWithConfigData:(NSString*)configData pageContext:(ECBaseViewController*)pageContext{
    if ([configData isEmpty]) {
        return nil;
    }
    NSLog(@"ECBaseWidget initWithConfigData");
    //    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
    _configDic = [ECJsonUtil objectWithJsonString:configData];
    
    return [self initWithConfigDic:_configDic pageContext:pageContext];
}

- (id)initWithConfigDic:(NSDictionary*)configDic pageContext:(ECBaseViewController*)pageContext{
    _configDic = configDic;
    _pageContext = pageContext;
    _layoutName = [[_configDic objectForKey:@"layout"] toCamelCase:YES];
    self.controlId = [_configDic objectForKey:@"control_id"];
    [_pageContext putWidget:_controlId widget:self];
    self = [self init];
    //    [self setBackgroundColor:[UIColor colorWithHexString:@"#F2F3F3"]];
    //    [self.pageContext.view setBackgroundColor:[UIColor blackColor]];
    //    CGRect frame = self.pageContext.view.frame;
    //    frame.size.width = 320;
    //    [self.pageContext.view setFrame:frame];
    
    return self;
}

//- (void)setFrame:(CGRect)frame {
//    frame.size.width = 320;
//    [super setFrame:frame];
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    return self;
}
# pragma - mark 解析控件配置文件
- (void) parsingConfigDic{
    if ([_configDic isEmpty]) {
        return;
    }
    // save widget-level params
    NSArray* configs = [_configDic objectForKey:@"configs"];
    if (![configs isEmpty]) {
        for (NSDictionary* dic in configs) {
            [self putParam:[dic objectForKey:@"key"] value:[dic objectForKey:@"value"]];
        }
    }
    // put widget into parent-view
    NSArray* positions = [_configDic objectForKey:@"position"];
    //    if ([positions isEmpty]) {
    //        ECLog(@"widget : '%@' position info is empty ...",_controlId);
    //        return;
    //    }
    NSString* parentViewId = nil;
    for (NSDictionary* positionDic in positions) {
        if ([[positionDic valueForKey:@"key"] isEqualToString:@"parent"]) {
            parentViewId = [positionDic valueForKey:@"value"];
        }
        if ([[positionDic valueForKey:@"key"] isEqualToString:@"location"]) {
            _position =[[positionDic valueForKey:@"value"] intValue];
        }
        if ([[positionDic valueForKey:@"key"] isEqualToString:@"insertType"]) {
            _insertType =[[positionDic valueForKey:@"value"] intValue];
        }
    }
    UIView* parentView = [ECViewUtil findViewById:parentViewId];
    if (parentView!=nil) {
        [parentView insertViewToView:self insertType:_insertType position:_position];
    }else{
        //ECLog(@"no find parentView...");
    }
    [self sizeToFit];
    // set attributes for widget
    [self setAttrsDic:_configDic];
    // bundling data-adapter for widget
    NSDictionary* dataSourceDic = [_configDic valueForKey:@"datasource"];
    if (![dataSourceDic isEmpty]) {
        _dataAdapter = [dataSourceDic objectForKey:@"adapter"];
    }
    // get data for widget
    [ECWidgetUtil getWidgetData:_pageContext widget:self dataSourceDic:dataSourceDic status:InitWidgetData];
    // set events
    NSArray* eventConfigs = [_configDic objectForKey:@"setEvent"];
    if (![eventConfigs isEmpty]) {
        for (NSDictionary* eventDic in eventConfigs) {
            [ECWidgetUtil setEventDelegate:eventDic pageContext:_pageContext widget:self];
        }
    }
}

- (void) parsingLayoutName
{
    NSArray* names = [self.layoutName componentsSeparatedByString:@":"];
    switch (names.count) {
        case 0:
            break;
        case 1:
            self.cellLayoutName = [self.layoutName toCamelCase:YES];
            self.layoutName = @"";
            break;
        case 2:
            self.cellLayoutName = [[names objectAtIndex:0] toCamelCase:YES];
            self.layoutName = [[names objectAtIndex:1] toCamelCase:YES];
            break;
        default:
            break;
    }
    
    //    ECLog(@"layout name : %@",self.layoutName);
    //    ECLog(@"cell name : %@",self.cellLayoutName);
}

# pragma - mark 给控件设置数据
- (void) putWidgetData:(NSDictionary*)dataDic{
    _dataDic = [ECDataUtil adapterDataFree:_pageContext widget:self adapters:_dataAdapter resData:dataDic];
    [self setdata];
}
- (void) setdata{
    if (!_dataDic || [_dataDic isEmpty]) {
        //dataSourceDic 是否有效（能否获取到数据）
        _dataDic = [[self.pageContext getWidgetData:self.controlId] JSONValue];
    }
    if (!_dataDic || [_dataDic isEmpty]) {
        _dataDic = @{};
    }
}

-(void) refreshWidget{
    [ECWidgetUtil getWidgetData:_pageContext widget:self dataSourceDic:[_configDic valueForKey:@"datasource"] status:RefreshWidgetData];
}

- (void) refreshWidgetData:(NSDictionary*)dataDic{
    [self putWidgetData:dataDic];
}

- (void) addWidgetData:(NSDictionary*)dataDic{
    //TODO: in the sunclass
}
# pragma - mark 保存传参
-(void) putParam:(NSString*)key value:(NSString*)value{
    if (!_mMap) {
        _mMap = [NSMutableDictionary new];
    }
    if (key && value) {
        ECLog(@"BaseWidget putParam : key = %@ , value = %@",key,value);
        [_mMap setObject:value forKey:key];
    }
}

- (NSString*)getParam:(NSString*)key{
    if (!_mMap) {
        return nil;
    }
    return [_mMap objectForKey:key];
}

# pragma - mark 设置属性
- (void)setAttr:(NSString*)attr value:(NSString*)value{
    if (attr != nil && value!= nil && ![attr isEmpty] && ![value isEmpty] ) {
        NSString* setAttrMethod = [NSString stringWithFormat:@"set%@S:",[attr featureString]];
        [ECReflectionUtil performSelectorWithInvoker:self selectName:setAttrMethod objectOne:value objectTwo:nil];
    }
}

- (void)setAttrs:(NSString*)attrString{
    NSDictionary* attrDic = [ECJsonUtil objectWithJsonString:attrString];
    [self setAttrsDic:attrDic];
}
- (void)setAttrsDic:(NSDictionary*)attrDic{
    id attrs = [attrDic objectForKey:@"attr"];
    if (attrs == nil || [attrs isEmpty]) {
        return ;
    }
    if ([attrs isKindOfClass:[NSArray class]]) {
        for (NSDictionary* dic in attrs) {
            if ([dic objectForKey:@"key"] && [dic objectForKey:@"value"]) {
                [self setAttr:[dic objectForKey:@"key"] value:[dic objectForKey:@"value"]];
            }
        }
    }
}

# pragma - mark 设置frame
- (CGSize)sizeThatFits:(CGSize)size{
    if (_insertType<=0) {
        _insertType = 2;
    }
    
    float w = 0;
    float h = 0;
    // fit content
    for (UIView *v in [self subviews]) {
        float fw = v.frame.origin.x + v.frame.size.width;
        float fh = v.frame.origin.y + v.frame.size.height+10;
        w = MAX(fw, w);
        h = MAX(fh, h);
    }
    // check fit father
    switch (_insertType) {
        case 1:
            w = [self superview].frame.size.width;
            h = [self superview].frame.size.height;
            break;
        case 2:
            w = [self superview].frame.size.width;
            break;
        case 3:
            h = [self superview].frame.size.height;
            break;
        default:
            break;
    }
    //ECLog(@"w = %f , h = %f",w,h);
    return CGSizeMake(w, h);
}

#pragma mark-
- (void) pageEventWith:(NSString *)eventName
{
    
}

#pragma mark-
- (void)setControlId:(NSString *)controlId
{
    NSString* pageid =self.pageContext.id;
    _controlId = [[NSString alloc] initWithFormat:@"%@_%@" , pageid,controlId ];
    self.id = _controlId;
}

- (UIView *)findViewWithName:(NSString *)viewName
{
    //    for (UIView *subview in self.subviews) {
    //        if ([viewName isEqualToString:subview.id]) {
    //            return subview;
    //        }
    //    }
    //    return nil;
    return [self findViewWithName:viewName inView:self];
}

- (UIView *)findViewWithName:(NSString *)viewName inView:(UIView *)view
{
    for (UIView *subview in view.subviews) {
        if ([viewName isEqualToString:subview.id]) {
            return subview;
        }
        UIView *resultView = [self findViewWithName:viewName inView:subview];
        if (resultView) {
            return resultView;
        }
    }
    return nil;
}
@end
