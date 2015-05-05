//
//  ECCacheDataSupport.m
//  NowMarry
//
//  Created by cheng on 13-12-31.
//  Copyright (c) 2013年 ecloud. All rights reserved.
//

#import "ECCacheDataSupport.h"
#import "NSStringExtends.h"

// core data 存储的文件格式为.sqlite方式 可以追加上扩展名
#define kCoreDataFileName   @"com.ecloud.ios.coredata.coredatacachefilename"
#define kCoreDataModelFileName  @"Cache"

@implementation ECCacheDataSupport

#pragma mark - 单例
+ (id)sharedInstance{
    static ECCacheDataSupport* object = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [[ECCacheDataSupport alloc] init];
    });
    return object;
}
#pragma mark -
- (id)init{
    self = [super init];
    if (self) {
        _savedPath = [[NSString appCachesPath] stringByAppendingPathComponent:[kCoreDataFileName md5Hash]];
        // 退到后台时保存一下
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveContext) name:UIApplicationDidEnterBackgroundNotification object:nil];
        return self;
    }
    return nil;
}
#pragma mark - 保存
- (BOOL)saveContext{
    NSError* error;
    if (nil != _managedObjectContext) {
        if ([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error]) {
            // 保存失败
            //            abort();
            return NO;
        }
        return YES;
    }
    return NO;
}
#pragma mark - 清除
- (void)clearAll{
    // 保存一下
    [self saveContext];
    // 删除
    if (_savedPath && [[NSFileManager defaultManager] fileExistsAtPath:_savedPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:_savedPath error:NULL];
    }
}


#pragma mark - dealloc
- (void)dealloc{
    _savedPath = nil;
    _managedObjectContext = nil;
    _managedObjectModel = nil;
    _persistentStoreCoordinator = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark -
-(NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL* modelURL = [[NSBundle mainBundle] URLForResource:kCoreDataModelFileName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    NSURL* url = [NSURL fileURLWithPath:self.savedPath];
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSError* error = nil;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}

-(NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator* coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        return _managedObjectContext;
    }
    return nil;
}

@end
