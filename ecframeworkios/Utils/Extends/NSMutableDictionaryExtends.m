//
//  NSMutableDictionaryExtends.m
//  Extends
//
//  Created by Alix on 9/25/12.
//  Copyright (c) 2012 ecloud. All rights reserved.
//

#import "NSMutableDictionaryExtends.h"
#import "NSStringExtends.h"
#import "NSObjectExtends.h"

@implementation NSMutableDictionary (Extends)

#pragma mark - 
- (void)setNotNilObject:(id)obj forKey:(NSString *)key{
    if (obj && NO == [obj isEmpty] && key && [key isEmpty]) {
        [self setValue:obj forKey:key];
    }
}

#pragma mark - 
- (void)setNotNilString:(NSString *)str forKey:(NSString *)key{
    if (str && NO == [str isEmpty] && key && [key isEmpty]) {
        [self setValue:str forKey:key];
    }
}
@end

