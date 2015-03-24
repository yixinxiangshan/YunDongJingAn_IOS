//
//  NSDeepCopy+DQ.m
//  DQApp
//
//  Created by 程巍巍 on 5/22/14.
//  Copyright (c) 2014 littocats. All rights reserved.
//

#import "NSDeepCopy+DQ.h"

@implementation NSObject (DQDeepCopy)

- (id)mutableDeepCopy
{
    if ([self respondsToSelector:@selector(mutableCopyWithZone:)] == YES)
        return [self mutableCopy];
    else if ([self respondsToSelector:@selector(copyWithZone:)] == YES)
        return [self copy];
    else
        return self;
}

@end

@implementation NSDictionary (DQDeepCopy)

- (id)mutableDeepCopy
{
    NSMutableDictionary *newDictionary = [[NSMutableDictionary alloc] init];
    NSEnumerator        *enumerator = [self keyEnumerator];
    id                  key;
    
    
    while ((key = [enumerator nextObject]) != nil) {
        id obj = [[self objectForKey:key] mutableDeepCopy];
        [newDictionary setObject:obj forKey:key];
    }
    
    return newDictionary;
}

@end



@implementation NSArray (DQDeepCopy)

- (id)mutableDeepCopy
{
    NSMutableArray  *newArray = [[NSMutableArray alloc] init];
    NSEnumerator    *enumerator = [self objectEnumerator];
    id              obj;
    
    
    while ((obj = [enumerator nextObject]) != nil) {
        obj = [obj mutableDeepCopy];
        [newArray addObject:obj];
    }
    
    return newArray;
}

@end



@implementation NSSet (DQDeepCopy)

- (id)mutableDeepCopy
{
    NSMutableSet    *newSet = [[NSMutableSet alloc] init];
    NSEnumerator    *enumerator = [self objectEnumerator];
    id              obj;
    
    
    while ((obj = [enumerator nextObject]) != nil) {
        obj = [obj mutableDeepCopy];
        [newSet addObject:obj];
    }
    
    return newSet;
}

@end