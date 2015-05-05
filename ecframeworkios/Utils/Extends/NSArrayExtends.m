//
//  NSArrayExtends.m
//  IOSExtends
//
//  Created by Alix on 9/24/12.
//  Copyright (c) 2012 ecloud. All rights reserved.
//

#import "NSArrayExtends.h"

@implementation NSArray (Extends)

#pragma mark -
- (id)firstObjectWithClass:(Class)cls{
    for (id obj in self) {
        if ([obj isMemberOfClass:cls]) {
            return obj;
        }
    }
    return nil;
}
#pragma mark - 
- (id)valueAtIndex:(NSUInteger)index{
    if (index >= self.count) {
        return nil;
    }
    return [self objectAtIndex:index];
}
#pragma mark - 
- (BOOL)isEmpty{
    return ([self count] < 1);
}
#pragma mark - 
//- (id)firstObject{
//    if (self.count) {
//        return [self objectAtIndex:0];
//    }
//    return nil;
//}
#pragma mark -
- (NSArray*)sortedArray{
    return [self sortedArrayUsingSelector:@selector(compare:)];
}
#pragma mark - 
- (NSArray*)reversedArray{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:[self count]];
    for (id obj in [self reverseObjectEnumerator]) {
        [array addObject:obj];
    }
    return [NSArray arrayWithArray:array];
}
@end

@implementation NSArray (JSON)
//将NSArray转化为NSData
-(NSData*)JSONData
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self
                                                options:kNilOptions
                                                  error:&error];
    if (error != nil) return nil;
    return result;
}

//将NSArray转化为NSString
- (NSString *) JSONString
{
    return [[NSString alloc] initWithData:[self JSONData] encoding:NSUTF8StringEncoding];
}
@end