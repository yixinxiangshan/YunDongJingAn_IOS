//
//  List.h
//  Litto Cats
//
//  Created by cheng on 13-12-31.
//  Copyright (c) 2013年 littocats. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface List : NSManagedObject

@property (nonatomic, retain) NSData * content;
@property (nonatomic, retain) NSDate * create_at;
@property (nonatomic, retain) NSNumber * iD;
@property (nonatomic, retain) NSString * sort1;
@property (nonatomic, retain) NSString * sort2;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSNumber * list_type;

@end
