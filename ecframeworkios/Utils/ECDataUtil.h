//
//  ECDataUtil.h
//  ECDemoFrameWork
//
//  Created by EC on 9/2/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECBaseViewController.h"
#import "ECBaseWidget.h"

@interface ECDataUtil : NSObject

/**
 * 更加强大的数据适配，支持数组list[]、表达式"{#***}"、指定值"{$***}"
 *
 * @param pageContext
 * @param widget
 * @param adapters
 * @param resString
 * @return
 */
+ (NSDictionary *) adapterDataFree:(ECBaseViewController*)pageContext widget:(ECBaseWidget*)widget adapters:(NSArray *)adapters resData:(NSDictionary *)resData;
+(NSString*) getValuePurpose:(NSString*)des  controlId:(NSString*)controlId bundleData:(NSString*)bundleString;
+(NSString*) getValuePurpose:(NSString*)des pageContext:(ECBaseViewController*)pageContext widget:(ECBaseWidget*)widget bundleData:(NSDictionary*)bundleData;
/**
 *
 */
+ (id) getData:(NSDictionary *)data forKey:(NSString *)key;
+ (id) setData:(id)data forKey:(NSString *)key;
/**
 * sourceDic and dataDic is NSDictionary or NSArray
 */
+ (id) merge:(id)sourceDic with:(id)dataDic;
/**
 * 判断两个NSObject (NSDictionary or NSArray)是否一样,即所有的key都一样,最外一层,数组的话，则所有的成员符合该规则
 *
 * @param object1
 * @param object2
 * @return
 */
+ (BOOL) isLikeSuperficial:(id)object1 with:(id)object2;

@end

/**
 *  新的数据适配器
 */
@interface ECDataAdapter : NSObject

/**
 *  数据源，NSArray  NSDictionary
 */
@property (nonatomic, strong) id                   dataSource;
@property (nonatomic, strong) ECBaseViewController *pageContext;
@property (nonatomic, strong) ECBaseWidget         *widget;

/**
 *  结果
 */
@property (nonatomic, strong) id resultData;

/**
 * 适配器，NSArray
 */
@property (nonatomic, strong) NSMutableDictionary *adapter;
@property (nonatomic, strong) NSMutableArray      *lastAdapters;

- (id) initWith:(NSArray *)adapterSource dataSource:(id)dataSource;
@end