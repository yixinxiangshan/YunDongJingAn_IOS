//
//  Caches.h
//  ECIOSProject
//
//  Created by 程巍巍 on 3/13/14.
//  Copyright (c) 2014 ecloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Caches : NSManagedObject

@property (nonatomic, retain) NSData * content;
@property (nonatomic, retain) NSString * md5;
@property (nonatomic, retain) NSDate * create_at;
@property (nonatomic, retain) NSString * sort1;
@property (nonatomic, retain) NSString * sort2;
@property (nonatomic, retain) NSNumber * timeout;

@end
