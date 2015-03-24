//
//  NSMutableArrayExtends.m
//  Extends
//
//  Created by Alix on 9/25/12.
//  Copyright (c) 2012 ecloud. All rights reserved.
//

#import "NSMutableArrayExtends.h"
#import "NSObjectExtends.h"
#import "NSStringExtends.h"

@implementation NSMutableArray (Extends)
#pragma mark - 
- (void)addNotNilString:(NSString *)str{
    if (str && NO == [str isEmpty]) {
        [self addObject:str];
    }
}

#pragma mark - 
- (void)addNotNilObject:(id)obj{
    if (obj && NO == [obj isEmpty]) {
        [self addObject:obj];
    }
}

#pragma mark - 
- (void)reverse{
    NSUInteger i= 0;
    NSUInteger j = self.count -1;
    while (i<j) {
        [self exchangeObjectAtIndex:i++ withObjectAtIndex:j--];
    }
}

#pragma mark - 
- (NSArray*)reverseArray{
    if (0 == self.count) {
        return nil;
    }
    
    NSMutableArray* array = [NSMutableArray arrayWithArray:self];
    NSUInteger i= 0;
    NSUInteger j = self.count -1;
    while (i<j) {
        [array exchangeObjectAtIndex:i++ withObjectAtIndex:j--];
    }
    return [NSArray arrayWithArray:array];
}
@end
