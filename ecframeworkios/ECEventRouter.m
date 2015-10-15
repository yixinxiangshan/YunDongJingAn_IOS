//
//  ECEventRouter.m
//  DemoECEcloud
//
//  Created by EC on 3/5/13.
//  Copyright (c) 2013 ecloud. All rights reserved.
//

#import "ECEventRouter.h"
//#import "Utils.h"
#import "UMViewController.h"
#import "UMNavigationController.h"

@implementation ECEventRouter

#define EC_WINDOW ((UIWindow*)([UIApplication sharedApplication].keyWindow))


+ (ECEventRouter*)shareInstance{
    static ECEventRouter* eventRouter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        eventRouter = [[ECEventRouter alloc] init];
    });
    return eventRouter;
}

- (void)registerAllEvents{
    NSURL *routerConfigtURL = [[NSBundle mainBundle] URLForResource:@"ECEventRouterConfig" withExtension:@"plist"];
    _routerDic = [NSMutableDictionary dictionaryWithContentsOfURL:routerConfigtURL];
    NSEnumerator* enumerator = [_routerDic keyEnumerator];
    for (NSString *key in enumerator) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dispatchEvents:) name:key object:nil];
        //NSLog(@"Event : %@",key);
    }
    
    //
    NSURL *urlConfigtURL = [[NSBundle mainBundle] URLForResource:@"URLConfig" withExtension:@"plist"];
    NSDictionary* urlDic = [NSDictionary dictionaryWithContentsOfURL:urlConfigtURL];
    NSDictionary* ctrlUrlDic = [urlDic objectForKey:@"ctrl_url"];
    for (NSString* ukey in ctrlUrlDic) {
        [UMNavigationController setViewControllerName:ukey forURL:[ctrlUrlDic objectForKey:ukey]];
        //NSLog(@"regiter url key: %@",ukey);
    }
    
    _commamdUrlDic = [urlDic objectForKey:@"command_url"];
    
}

- (void)dispatchEvents:(NSNotification*)noti{
    //TODO: 分发事件 检测
    NSLog(@"event needed to dispatch: %@",noti.name);
    NSLog(@"event : %@",[NSURL URLWithString:[_routerDic objectForKey:noti.name]]);
    
    NSURL* goalUrl = [NSURL URLWithString:[_routerDic objectForKey:noti.name]];
    
    NSLog(@"event goal url: %@",goalUrl);
    
    if ([[goalUrl scheme] isEqualToString:@"ecct"]) {
        // 处理ctrl 的router
        UMViewController* originalCtrl = (UMViewController*)noti.object;
        
        if (originalCtrl != nil) {
            [originalCtrl.navigator openURL:[NSURL URLWithString:[_routerDic objectForKey:noti.name]] withQuery:noti.userInfo];
        }else{
            UMNavigationController* ctrl = (UMNavigationController*)EC_WINDOW.rootViewController;
            [ctrl openURL:[NSURL URLWithString:[_routerDic objectForKey:noti.name]] withQuery:noti.userInfo];
            [ctrl.navigationBar setBarStyle:UIBarStyleBlack];
        }
    }else
    if([[goalUrl scheme] isEqualToString:@"eccm"]){
        // 处理command 的router
        NSString* comUrl =[NSString stringWithFormat:@"eccm://%@",[goalUrl host]];
        NSString* goalCommadPath = nil;
        NSString* goalCtrl = @"";
        NSString* goalCom = @"";
        NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:[goalUrl params],@"urlParams",noti.userInfo,@"query", nil];
        for (NSString* ckey in _commamdUrlDic) {
            if ([[_commamdUrlDic objectForKey:ckey] isEqualToString:comUrl]) {
                goalCommadPath = ckey;
                NSLog(@"goalCommandPath : %@", ckey);
            }
        }
        if (nil != goalCommadPath) {
            NSArray* array = [goalCommadPath componentsSeparatedByString:@"."];
            goalCtrl = array[0];
            goalCom = [NSString stringWithFormat:@"%@:",array[1]] ;
            Class ctrlClass = NSClassFromString(goalCtrl);
            id ctrl = [ctrlClass new];
            SEL com = NSSelectorFromString(goalCom);
            
            if ([ctrl respondsToSelector:com]) {
                [ctrl performSelector:com withObject:params];
            }
        }
    }else
    if ([[goalUrl scheme] isEqualToString:@"http"]){
        // open safri
        [[UIApplication sharedApplication] openURL:goalUrl];
    }
    
}

- (void) doAction:(NSString *)action
{
    [self doAction:action userInfo:nil];
}
- (void) doAction:(NSString *)action userInfo:(NSDictionary *)userInfo
{
    NSLog(@"doAction : %@",action);
    [_routerDic setObject:action forKey:@"action"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"action" object:nil userInfo:userInfo];
}

@end
