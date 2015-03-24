//
//  ECListViewBase.h
//  IOSProjectTemplate
//
//  Created by Zongzhan on 9/11/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECBasePullRefreshWidget.h"

@interface ECListViewBase : ECBasePullRefreshWidget
- (id)initWithConfigDic:(NSDictionary*)configDic pageContext:(ECBaseViewController*)pageContext;
- (void)setFormInput:(NSString*)key NSString:(NSString*)value;
- (NSDictionary *)getFormData;
@end



@protocol ECListViewCellProtocol <NSObject>

@required
+ (CGFloat)heightForData:(NSDictionary *)data;

- (void)setData:(NSDictionary *)data;
- (void)setParent:(ECListViewBase *)parent;
- (void)setPosition:(NSInteger )position;
//- (NSArray *)contentViews;

//- (NSArray *)contentConstraints;

@end