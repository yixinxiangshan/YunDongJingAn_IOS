//
//  Extends.m
//  Extends
//
//  Created by Alix on 9/24/12.
//  Copyright (c) 2012 ecloud. All rights reserved.
//

#import "Extends.h"


NSString* ECLocalizedString(NSString* key, NSString* comment) {
    NSBundle* bundle = nil;
    if (nil == bundle) {
        NSString* path = [[[NSBundle mainBundle] resourcePath]
                          stringByAppendingPathComponent:@"ECloudIOT.bundle"];
        bundle = [NSBundle bundleWithPath:path];
    }
    
    return [bundle localizedStringForKey:key value:comment table:nil];
}

static NSString* version = @"0.1.0";

@implementation Extends

+ (NSString*)version{
    return version;
}
@end





