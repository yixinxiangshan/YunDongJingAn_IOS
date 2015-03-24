//
//  NSObjectExtends.m
//  Extends
//
//  Created by Alix on 9/24/12.
//  Copyright (c) 2012 ecloud. All rights reserved.
//

#import "NSObjectExtends.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static char kECNSObjectIdKey;

@implementation NSObject (Extends)

@dynamic id;
- (void) setId:(NSString *)id
{
    objc_setAssociatedObject(self, &kECNSObjectIdKey, id, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // id不能重复，所以新的object会覆盖老的
    if ([[NSObject objectMap] objectForKey:id] != nil){
        [[NSObject objectMap] removeObjectForKey:id];
    }
    [[NSObject objectMap] setObject:self forKey:id];
}
- (NSString *)id
{
    return objc_getAssociatedObject(self, &kECNSObjectIdKey);
}

@dynamic _id;
static const char kECNSObjectIdKey_sys;
- (NSString *)_id
{
    NSString *_id = objc_getAssociatedObject(self, &kECNSObjectIdKey_sys);
    if (!_id) {
        _id = [NSString stringWithFormat:@"%@_%f_%p",self.class,[NSDate timeIntervalSinceReferenceDate],self];
        objc_setAssociatedObject(self, &kECNSObjectIdKey_sys, _id, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [[NSObject objectMap] setObject:self forKey:_id];
    }
    return _id;
}

+ (NSMapTable *)objectMap
{
    static NSMapTable *map = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        map = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsWeakMemory valueOptions:NSPointerFunctionsStrongMemory capacity:128];
    });
    return map;
}

+ (id)findObjectWithId:(NSObject *)id
{
   return [[self objectMap] objectForKey:id];
}
#pragma mark - 
- (id)performSelector:(SEL)aSelector
           withObject:(id)object1
           withObject:(id)object2
           withObject:(id)object3{
    
    NSMethodSignature *sig = [self methodSignatureForSelector:aSelector];
    if (sig) {
        NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
        [invo setTarget:self];
        [invo setSelector:aSelector];
        [invo setArgument:&object1 atIndex:2];
        [invo setArgument:&object2 atIndex:3];
        [invo setArgument:&object3 atIndex:4];
        [invo invoke];
        if (sig.methodReturnLength) {
            id anObject;
            [invo getReturnValue:&anObject];
            return anObject;
            
        } else {
            return nil;
        }
        
    } else {
        return nil;
    }

}
#pragma mark - 
- (id)performSelector:(SEL)aSelector
           withObject:(id)object1
           withObject:(id)object2
           withObject:(id)object3
           withObject:(id)object4{
    
    NSMethodSignature *sig = [self methodSignatureForSelector:aSelector];
    if (sig) {
        NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
        [invo setTarget:self];
        [invo setSelector:aSelector];
        [invo setArgument:&object1 atIndex:2];
        [invo setArgument:&object2 atIndex:3];
        [invo setArgument:&object3 atIndex:4];
        [invo setArgument:&object4 atIndex:5];
        [invo invoke];
        if (sig.methodReturnLength) {
            id anObject;
            [invo getReturnValue:&anObject];
            return anObject;
            
        } else {
            return nil;
        }
        
    } else {
        return nil;
    }
}

#pragma mark - 
- (BOOL)isEmpty{
    if (self && NO == [self isMemberOfClass:[NSNull class]]) {
        return NO;
    }
    return YES;
}

#pragma mark - 
- (void)performBlockAfterDelay:(NSTimeInterval)delay block:(void (^)(void))block{
    [self performBlockAfterDelay:delay inQueue:dispatch_get_main_queue() block:block];
}
- (void)performBlockAfterDelay:(NSTimeInterval)delay inQueue:(dispatch_queue_t)queue block:(void(^)(void))block{
    dispatch_time_t poptime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay*NSEC_PER_SEC));
    dispatch_after(poptime, queue, block);
}

#pragma mark - 
- (void)performSelector:(SEL)selector returnTo:(void *)returnData withArguments:(void **)args{
    NSMethodSignature* methodSignature = [self methodSignatureForSelector:selector];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [invocation setSelector:selector];
    
    NSUInteger argsCount = [methodSignature numberOfArguments];
    for (int i=2; i<argsCount; i++) {
        void* arg = args[i-2];
        [invocation setArgument:arg atIndex:i];
    }
    
    [invocation invokeWithTarget:self];
    
    if (NULL != returnData) {
        [invocation getReturnValue:returnData];
    }
}
- (void)performSelector:(SEL)selector withArguments:(void **)args{
    [self performSelector:selector returnTo:NULL withArguments:args];
}

- (void)performSelectorIfSelectorWasExist:(SEL)selector returnTo:(void *)returnData withArguments:(void **)args{
    if ([self respondsToSelector:selector]) {
        [self performSelector:selector returnTo:returnData withArguments:args];
    }
}
- (void)performSelectorIfSelectorWasExist:(SEL)selector withArguments:(void **)args{
    if ([self respondsToSelector:selector]) {
        [self performSelector:selector returnTo:NULL withArguments:args];
    }
}
- (BOOL)isNSxxxClass:(Class)className{
    NSString* str = NSStringFromClass([self class]);
    NSString* classStr = NSStringFromClass(className);
    if (([str hasPrefix:@"NS"]||[str hasPrefix:@"__NS"]) && [classStr hasPrefix:@"NS"] && [str hasSuffix:[classStr substringWithRange:NSMakeRange(2, [classStr length]-2)]]) {
        return YES;
    }
    return NO;
}
@end
