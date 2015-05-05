//
//  Extends.h
//  Extends
//
//  Created by Alix on 9/24/12.
//  Copyright (c) 2012 ecloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSArrayExtends.h"
#import "NSDataExtends.h"
#import "NSDateExtends.h"
#import "NSDictionaryExtends.h"
#import "NSStringExtends.h"
#import "NSObjectExtends.h"
#import "NSMutableArrayExtends.h"
#import "NSMutableDictionaryExtends.h"
#import "NSNumber+Extends.h"


/**
 * 本地化的一些字符串"保存在ECloudIOT.bundle文件夹中"
 */
NSString* ECLocalizedString(NSString* key, NSString* comment);



@interface Extends : NSObject
+ (NSString*)version;
@end



