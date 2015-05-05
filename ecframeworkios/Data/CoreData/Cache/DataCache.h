//
//  DataCache.h
//  NowMarry
//
//  Created by cheng on 13-12-31.
//  Copyright (c) 2013年 ecloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DataCache : NSManagedObject

@property (nonatomic, retain) NSData * content;
@property (nonatomic, retain) NSString * md5;
@property (nonatomic, retain) NSNumber * iD;
@property (nonatomic, retain) NSString * sort1;
@property (nonatomic, retain) NSString * sort2;
@property (nonatomic, retain) NSDate * cache_time;
@property (nonatomic, retain) NSString * state;

@end
