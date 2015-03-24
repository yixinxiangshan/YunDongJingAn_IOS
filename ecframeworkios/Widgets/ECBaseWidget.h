//
//  ECBaseWidget.h
//  ECDemoFrameWork
//
//  Created by EC on 9/2/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECBaseView.h"
@class ECBaseViewController;
@class WidgetNetData;

@interface ECBaseWidget : UIView

@property (nonatomic, strong) NSString* configString;
@property (nonatomic, strong) NSDictionary* configDic; //控件配置
@property (nonatomic, strong) NSMutableDictionary* mMap;
@property (nonatomic, strong) ECBaseViewController* pageContext;
@property (nonatomic, strong) NSString* layoutName;
@property (nonatomic, strong) NSString* cellLayoutName;
@property (nonatomic, strong) NSString* controlId;
@property (nonatomic, strong) NSString* viewId;
@property (nonatomic, assign) int insertType;
@property (nonatomic, assign) int position;
@property (nonatomic, strong) NSArray* dataAdapter;
@property (nonatomic, strong) WidgetNetData* widgetNetData;
@property (nonatomic, strong) NSDictionary* dataDic; //控件数据

- (id)initWithConfigData:(NSString*)configData pageContext:(ECBaseViewController*)pageContext;
- (id)initWithConfigDic:(NSDictionary*)configDic pageContext:(ECBaseViewController*)pageContext;

- (void) parsingConfigDic;
/**
 sava widget-level params
 */
-(void) putParam:(NSString*)key value:(NSString*)value;
/**
 get widget-level params
 */
- (NSString*)getParam:(NSString*)key;
/**
  use for the one who have sun_layout
 */
- (void) parsingLayoutName;
/**
 控件数据
 */
- (void) putWidgetData:(NSDictionary*)dataDic;
- (void) setdata;
- (void) refreshWidgetData:(NSDictionary*)dataDic;
-(void) refreshWidget;
- (void) addWidgetData:(NSDictionary*)dataDic;
/**
 设置控件属性
 */
- (void)setAttr:(NSString*)attr value:(NSString*)value;
- (void)setAttrs:(NSString*)attrString;

/**
 *  响应面页事件，viewWillAppear、viewDidAppear、viewWillDisApper
 */
- (void) pageEventWith:(NSString *)eventName;

/**
 *  根据viewName 找到widget中对应的view
 */
- (UIView *)findViewWithName:(NSString *)viewName;
@end
