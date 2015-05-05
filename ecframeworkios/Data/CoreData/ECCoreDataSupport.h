//
//  ECCoreDataSupport.h
//  ECMuse
//
//  Created by Alix on 10/18/12.
//  Copyright (c) 2012 ECloudSuperman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
/**
 * coreData支持
 * @notice core data model 文件名在.m文件里用宏提供
 * @notice 只支持单一的 core data model,
 * 不支持多core data model
 */
@interface ECCoreDataSupport : NSObject{
    
}
/**
 * core data 3个常用对象
 */
@property (nonatomic, retain, readonly) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel*   managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator* persistentStoreCoordinator;
// coreData文件保存路径, 如果不指定
@property (nonatomic, retain, readwrite) NSString* savedPath;

+ (id)sharedInstance;
/**
 * 保存到文件
 */
- (BOOL)saveContext;

/**
 * 清除全部
 * 实现方式 : 直接从hd上删除
 */
- (void)clearAll;


@end
