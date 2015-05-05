//
//  ECReflectionUtil.m
//  ECDemoFrameWork
//
//  Created by EC on 9/4/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECReflectionUtil.h"
#import "NSArrayExtends.h"
#import <objc/runtime.h>
#import "Constants.h"
#import "NSStringExtends.h"
#import "NSObjectExtends.h"

#import <objc/runtime.h>
#import <objc/message.h>

@implementation ECReflectionUtil

#pragma mark - 初始化类
+ (id)initClass:(NSString*)className selectName:(NSString*)selectName objectOne:(id) objectOne objectTwo:(id)objectTwo{
    Class class = NSClassFromString(className);
    id instance = [class alloc];
    return [self performSelectorWithInvoker:instance selectName:selectName objectOne:objectOne objectTwo:objectTwo];
}

+ (id)initClass:(NSString*)className selectName:(NSString*)selectName multiObjects:(NSArray*)objects{
    Class class = NSClassFromString(className);
    id instance = [class alloc];
    return [self performSelectorWithInvoker:instance selectName:selectName multiObjects:objects];
}

#pragma mark - 执行方法
+ (id)performSelector:(NSString*)className selectName:(NSString*)selectName object:(id) object{
    return [self performSelector:className selectName:selectName objectOne:object objectTwo:nil];
}

+ (id)performSelector:(NSString*)className selectName:(NSString*)selectName{
    return [self performSelector:className selectName:selectName objectOne:nil objectTwo:nil];
}

+ (id)performSelector:(NSString*)className selectName:(NSString*)selectName objectOne:(id) objectOne objectTwo:(id)objectTwo{
    Class class = NSClassFromString(className);
    id instance = [[class alloc] init];
    id ret = [self performSelectorWithInvoker:instance selectName:selectName objectOne:objectOne objectTwo:objectTwo];
    return ret;
}

+ (id)performSelectorWithInvoker:(id)instance selectName:(NSString*)selectName objectOne:(id) objectOne objectTwo:(id)objectTwo{
    id returnValue = nil;
    SEL selector = NSSelectorFromString(selectName);
    Method method = class_getInstanceMethod([instance class], selector);
    char type[128];
    method_getReturnType(method, type, sizeof(type));
    NSString* returnType = [NSString stringWithFormat:@"%s",type];
    if (![instance respondsToSelector:selector]) {
        ECLog(@"performSelector error : class<%@> not respondsToSelector <%@>",instance,selectName);
        return nil;
    }
    
    NSArray* selectorDes = [selectName componentsSeparatedByString:@":"];
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    @try {
//        if (objectTwo!=nil) {
//            if (selectorDes.count != 3) {
//                ECLog(@"Not enough params for selector : %@",selectName);
//                return nil;
//            }
//            if ([returnType isEqualToString:@"v"])
//                [instance performSelector:selector withObject:objectOne withObject:objectTwo];
//            else
//                returnValue = [instance performSelector:selector withObject:objectOne withObject:objectTwo];
//        }
//        else if (objectOne != nil) {
//            if (selectorDes.count != 2) {
//                ECLog(@"Not enough params for selector : %@",selectName);
//                return nil;
//            }
//            if ([returnType isEqualToString:@"v"])
//                [instance performSelector:selector withObject:objectOne];
//            else
//                returnValue = [instance performSelector:selector withObject:objectOne];
//        }else {
//            if (selectorDes.count != 1) {
//                ECLog(@"Not enough params for selector : %@",selectName);
//                return nil;
//            }
//            if ([returnType isEqualToString:@"v"])
//                [instance performSelector:selector];
//            else
//                returnValue = [instance performSelector:selector];
//        }
        
        switch (selectorDes.count) {
            case 1:
                if ([returnType isEqualToString:@"v"])
                    [instance performSelector:selector];
                else
                    returnValue = [instance performSelector:selector];
                break;
            case 2:
                if (objectOne == nil) {
                    ECLog(@"Not enough params for selector : %@",selectName);
                    return nil;
                }
                if ([returnType isEqualToString:@"v"])
                    [instance performSelector:selector withObject:objectOne];
                else
                    returnValue = [instance performSelector:selector withObject:objectOne];
                break;
            case 3:
                if (objectOne == nil || objectTwo == nil) {
                    ECLog(@"Not enough params for selector : %@",selectName);
                    return nil;
                }
                if ([returnType isEqualToString:@"v"])
                    [instance performSelector:selector withObject:objectOne withObject:objectTwo];
                else
//                    returnValue = [instance performSelector:selector withObject:objectOne withObject:objectTwo];
//                    returnValue = objc_msgSend(instance, selector, objectOne, objectTwo);
                {
                    @autoreleasepool {
                        NSMethodSignature *sig = [instance methodSignatureForSelector:selector];
                        NSInvocation *invo = [NSInvocation invocationWithMethodSignature:sig];
                        [invo setArgument:&objectOne atIndex:2];
                        [invo setArgument:&objectTwo atIndex:3];
                        [invo retainArguments];
                        [invo setTarget:instance];
                        [invo setSelector:selector];
                        [invo invoke];
                        [invo getReturnValue:&returnValue];
                        
                    }
                }
                break;
            default:
                break;
        }
    }
    @catch (NSException *exception) {
        return nil;
    }
    return returnValue;
   
}


+(id)performSelector:(NSString*)className selectName:(NSString*)selectName objects:(NSArray*)objects{
    if ([objects isEmpty]) {
        return [self performSelector:className selectName:selectName];
    }
    switch ([objects count]) {
        case 1:
            return [self performSelector:className selectName:selectName object:[objects objectAtIndex:0]];
            break;
        case 2:
            return [self performSelector:className selectName:selectName objectOne:[objects objectAtIndex:0] objectTwo:[objects objectAtIndex:1]];
            break;
            
        default:
            return [self performSelector:className selectName:selectName multiObjects:objects];
            break;
    }
}
// 私有方法 
+(id)performSelector:(NSString*)className selectName:(NSString*)selectName multiObjects:(NSArray*)objects{
    Class class = NSClassFromString(className);
    id instance = [[class alloc] init];
    return [self performSelectorWithInvoker:instance selectName:selectName multiObjects:objects];
}
+(id)performSelectorWithInvoker:(id)instance selectName:(NSString*)selectName multiObjects:(NSArray*)objects{
    SEL selector = NSSelectorFromString(selectName);
    Method method =  class_getInstanceMethod([instance class], selector);
    int argumentCount = method_getNumberOfArguments(method);
    if(argumentCount > [objects count]+2)
        return nil; // Not enough arguments in the array
    NSMethodSignature *signature = [instance methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:instance];
    [invocation setSelector:selector];

    for(int i=0; i<[objects count]; i++)
    {
        id arg = [objects objectAtIndex:i];
        [invocation setArgument:&arg atIndex:i+2]; // The first two arguments are the hidden arguments self and _cmd
    }
    CFTypeRef result;
    [invocation invoke];
    [invocation getReturnValue:&result];
    if (result) {
        return (__bridge NSObject*)result;
    }
    return  nil;
}

#pragma mark-
+ (NSObject *) callMethod:(NSObject *)object method:(NSString *)methodName arguments:(NSArray *)arg
{
    id instance = [NSObject findObjectWithId:object];
    if (!instance) {
        ECLog(@"ECReflectionUtil : error , object with id %@ is not exist .",object);
        return nil;
    }
    SEL selector = NSSelectorFromString(methodName);
    NSMethodSignature *signature = [instance methodSignatureForSelector:selector];
    if (!signature) {
        ECLog(@"ECReflectionUtil : error , method named %@ is not exist .",methodName);
        return nil;
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:instance];
    [invocation setSelector:selector];
    
    // The first two arguments are the hidden arguments self and _cmd
    if ([[invocation methodSignature] numberOfArguments]-2 != arg.count) {
        ECLog(@"ECReflectionUtil : error , number of params is not enough or too more <object: %@ ; method : %@ ; params : %@>",object,methodName,arg);
        return nil;
    }
    for (int i = 0; i < arg.count; i ++) {
        //所有方法需经过封装，参数全部为NSString
        id param = arg[i];
        [invocation setArgument:&param atIndex:i+2];
    }
    
    
    [invocation invoke];
    
    NSObject *result;
    if ([signature methodReturnType][0] != 'v') {
        void* buffer;
        [invocation getReturnValue:&buffer];
        result = (__bridge NSObject *)(buffer);
    }else{
        result = nil;
    }
    
    return result;
}

+ (NSObject *) callNSObject:(NSString *)object method:(NSString *)methodName arguments:(NSArray *)arg
{
    id instance = [NSObject findObjectWithId:object];
    if (!instance) {
        ECLog(@"ECReflectionUtil : error , object with id %@ is not exist .",object);
        return nil;
    }
    SEL selector = NSSelectorFromString(methodName);
    NSMethodSignature *signature = [instance methodSignatureForSelector:selector];
    if (!signature) {
        ECLog(@"ECReflectionUtil : error , method named %@ is not exist .",methodName);
        return nil;
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:instance];
    [invocation setSelector:selector];
    
    // The first two arguments are the hidden arguments self and _cmd
    if ([[invocation methodSignature] numberOfArguments]-2 != arg.count) {
        ECLog(@"ECReflectionUtil : error , number of params is not enough or too more <object: %@ ; method : %@ ; params : %@>",object,methodName,arg);
        return nil;
    }
    for (int i = 0; i < arg.count; i ++) {
        //所有方法需经过封装，参数全部为NSString
        id param = arg[i];
        [invocation setArgument:&param atIndex:i+2];
    }
    
    
    [invocation invoke];
    
    NSObject *result;
    if ([signature methodReturnType][0] != 'v') {
        void* buffer;
        [invocation getReturnValue:&buffer];
        result = (__bridge NSObject *)(buffer);
    }else{
        result = nil;
    }
    
    return result;
}
@end

@implementation NSObject (ECReflectionUtil)

- (id)callMethod:(NSString *)methodName withArguments:(NSArray *)arg
{
    //NSLog(@"callMethod methodName: %@ , arg : %@" , methodName , arg);
    return [ECReflectionUtil callNSObject:self.id method:methodName arguments:arg];
}
@end
