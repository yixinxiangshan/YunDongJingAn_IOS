//
//  NSObjectExtends.h
//  Extends
//
//  Created by Alix on 9/24/12.
//  Copyright (c) 2012 ecloud. All rights reserved.
//  参考three20

#import <Foundation/Foundation.h>

@interface NSObject (Extends)

/**
 *  对像 id
 */
@property (nonatomic, strong) NSString *id;

@property (nonatomic, readonly) NSString *_id;

/**
 *  根据对像获取 对像
 */
+ (id)findObjectWithId:(NSObject *)id;

/**
 * 扩展方法传多参数支持
 */
- (id)performSelector:(SEL)aSelector
           withObject:(id)object1
           withObject:(id)object2
           withObject:(id)object3;

- (id)performSelector:(SEL)aSelector
           withObject:(id)object1
           withObject:(id)object2
           withObject:(id)object3
           withObject:(id)object4;


/**
 * @return 是否为空 (nil or NSNull instance)
 */
- (BOOL)isEmpty;

/**
 * 采用block实现performSelector
 */
- (void)performBlockAfterDelay:(NSTimeInterval)delay block:(void(^)(void))block;
- (void)performBlockAfterDelay:(NSTimeInterval)delay inQueue:(dispatch_queue_t)queue block:(void(^)(void))block;
/**
 * 更多的参数
 * @note 参数以数组的形式出现
 */
- (void)performSelector:(SEL)selector returnTo:(void*)returnData withArguments:(void **)args;
- (void)performSelector:(SEL)selector withArguments:(void **)args;
- (void)performSelectorIfSelectorWasExist:(SEL)selector withArguments:(void**)args;
- (void)performSelectorIfSelectorWasExist:(SEL)selector returnTo:(void *)returnData withArguments:(void **)args;

/**
 * 判断某个实例是否为NSxxx类
 * @param className 类名  比如: NSDictionary
 */
- (BOOL)isNSxxxClass:(Class)className;

@end
