//
//  ECListDataSupport.h
//  NowMarry
//
//  Created by cheng on 13-12-30.
//  Copyright (c) 2013年 ecloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ECListDataSupport : NSObject

//数据模型对象
@property(strong,nonatomic) NSManagedObjectModel *managedObjectModel;
//上下文对象
@property(strong,nonatomic) NSManagedObjectContext *managedObjectContext;
//持久性存储区
@property(strong,nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// coreData文件保存路径
@property (nonatomic, retain, readwrite) NSString* savedPath;


+ (id)sharedInstance;
/**
 * 保存到文件
 */
- (BOOL)saveContext;
@end
