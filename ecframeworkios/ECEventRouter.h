//
//  ECEventRouter.h
//  DemoECEcloud
//
//  Created by EC on 3/5/13.
//  Copyright (c) 2013 ecloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECEventRouter : NSObject

@property (nonatomic, strong) NSMutableDictionary* routerDic;
@property (nonatomic, strong) NSDictionary* commamdUrlDic;

+ (ECEventRouter*)shareInstance;

- (void)registerAllEvents;
- (void)doAction:(NSString *)action;
- (void) doAction:(NSString *)action userInfo:(NSDictionary *)userInfo;

@end
