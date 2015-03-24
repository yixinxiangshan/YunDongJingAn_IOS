//
//  ECSelector.h
//  IOSProjectTemplate
//
//  Created by 程巍巍 on 5/12/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECSelector : NSObject

+ (ECSelector *)selectorWithScript:(NSString *)script;

- (ECSelector *)setScript:(NSString *)script;

- (ECSelector *)setObject:(NSDictionary *)objJSON;

- (NSMutableArray *)evalute;
@end
