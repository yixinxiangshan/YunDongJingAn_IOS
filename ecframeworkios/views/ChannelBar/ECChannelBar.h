//
//  ECChannelBar.h
//  IOSProjectTemplate
//
//  Created by 程巍巍 on 4/14/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ECChannelBarDelegate;

@interface ECChannelBar : UIView

@property (nonatomic, weak) id<ECChannelBarDelegate> delegate;
/**
 *  初始化
 *  @param config 
 *  config exam : [
        {
            "title":"one"
        }
    ]
 */
- (id)initWithConfig:(NSArray *)config;
- (void)setConfig:(NSMutableArray *)config;

/**
 *  选重channel
 */
- (void)selectChannelWithIndex:(NSInteger)index notifyDelegate:(BOOL)notifyDelegate;
@end

@protocol ECChannelBarDelegate <NSObject>

@optional
- (void)ecChannelBar:(ECChannelBar *)channelBar didSelectedItemAtIndex:(NSInteger)index;

@end