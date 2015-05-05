//
//  ECReflectionUtil.h
//  ECDemoFrameWork
//
//  Created by EC on 9/4/13.
//  Copyright (c) 2013 EC. All rights reserved.
//


@interface ECReflectionUtil : NSObject


+ (id)initClass:(NSString*)className selectName:(NSString*)selectName objectOne:(id) objectOne objectTwo:(id)objectTwo;

+ (id)initClass:(NSString*)className selectName:(NSString*)selectName multiObjects:(NSArray*)objects;

+ (id)performSelector:(NSString*)className selectName:(NSString*)selectName objectOne:(id) objectOne objectTwo:(id)objectTwo;

+ (id)performSelectorWithInvoker:(id)instance selectName:(NSString*)selectName objectOne:(id) objectOne objectTwo:(id)objectTwo;

+ (id)performSelector:(NSString*)className selectName:(NSString*)selectName object:(id) object;

+ (id)performSelector:(NSString*)className selectName:(NSString*)selectName;

+ (id)performSelector:(NSString*)className selectName:(NSString*)selectName objects:(NSArray*)objects;

+(id)performSelectorWithInvoker:(id)instance selectName:(NSString*)selectName multiObjects:(NSArray*)objects;


/**
 *  根据对像id methodName 执行对应方法
 */
+ (id) callNSObject:(NSString *)object method:(NSString *)methodName arguments:(NSArray *)arg;
@end

@interface NSObject (ECReflectionUtil)
- (id)callMethod:(NSString *)methodName withArguments:(NSArray *)arg;
@end