//
//  ECAppUtil.m
//  ECDemoFrameWork
//
//  Created by EC on 8/28/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECAppUtil.h"
#import "ECAppDelegate.h"
#import "ECJsonUtil.h"
#import "NSDictionaryExtends.h"
#import "ECNetUtil.h"
#import "ECJSUtil.h"
#import "NSStringExtends.h"

@implementation ECAppUtil

+(ECAppUtil*)shareInstance{
    static ECAppUtil* singleInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleInstance = [ECAppUtil new];
    });
    return singleInstance;
}
-(void)setOnPageStarted:(ECBaseViewController*) controller{
    if (!_controllers) {
        _controllers = [NSMutableArray new];
    }
    UINavigationController* navCtrl = (UINavigationController*)[[[ECAppDelegate appDelegate] window] rootViewController];
    if(![_controllers containsObject:controller] && [[navCtrl viewControllers] containsObject:controller]){
        [_controllers addObject:controller];
    }
    _nowPageContext = controller;
}
-(void)setOnPageDestroyed:(ECBaseViewController*) controller{
    if([_controllers containsObject:controller]){
        [_controllers removeObject:controller];
    }
}

- (ECBaseViewController*)getNowController{
    UINavigationController* navCtrl = (UINavigationController*)[[[ECAppDelegate appDelegate] window] rootViewController];
    ECBaseViewController* nowController = (ECBaseViewController*)[navCtrl topViewController];
    return nowController;
}

+ (ECBaseViewController *) getPageContextWithId:(NSString *)pageId
{
    NSArray *pages = [[self shareInstance] controllers];
    __block ECBaseViewController *result;
    [pages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([[(ECBaseViewController *)obj pageId] isEqualToString:pageId]) {
            result = obj;
        };
    }];
    return result;
}

- (NSString *) infalateSon
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"infalateSon"] boolValue]) {
        return @"true";
    }
    return @"false";
}

- (void) putParam:(NSString*)key value:(NSString *)value {
    if (_appMap == nil) {
        _appMap = [NSMutableDictionary new];
    }
    if (!key) {
        return;
    }
    if (!value) {
        [_appMap removeObjectForKey:key];
        return;
    }
    [_appMap setObject:value forKey:key];
}
- (NSString* )getParam:(NSString*)key{
    if (_appMap == nil) {
        return nil;
    }
    return [_appMap objectForKey:key];
}

#pragma mark- share
+ (void) shareString:(NSString *)shareString
{
    NSArray *items = @[shareString];
    UIActivityViewController *shareController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    shareController.excludedActivityTypes = @[UIActivityTypeAssignToContact,
                                              UIActivityTypeSaveToCameraRoll, UIActivityTypePrint,
                                              UIActivityTypeCopyToPasteboard];
    [[[self shareInstance] nowPageContext] presentViewController:shareController animated:YES completion:nil];
}
#pragma mark - 清空token/enterpriseid/apikey/sonSortList
+ (void)clearApp{
    //TODO: 清理app
}

#pragma mark - 清空缓存
+ (void)clearCache:(BOOL)isAlert{
    //TODO: 清除缓存    
}
#pragma mark - 获取系统版本信息
+(NSString*) getSystemInfo{
    //TODO: 获取系统版本
    return nil;
}
#pragma mark- 获取软件版本
+ (NSString *) getAppVersion
{
     return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
}
+ (BOOL) checkNewVersion
{
    NSString *newVersion = [self getPreference:@"LatestAppVersion"];
    
    return newVersion.length ? YES : NO;
}
#pragma mark- 获取项目配制及网络资源的本地路径
+ (NSString *) getDecoratePath:(id)data
{
    return [[Decorate shareInstance] getDecoratePath];
}
#pragma mark- 获取项目配制
+ (NSDictionary *) getDecorateConfig
{
    // decorateConfig.json.txt --------- UTF-8
    NSString* decorateDirectory = [[[self class] getDecoratePath:nil] stringByAppendingString:@"decorateConfig.json.txt"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir;
    if ([fileManager fileExistsAtPath:decorateDirectory isDirectory:&isDir] && !isDir) {
        
        NSString* decorateConfig = [NSString stringWithContentsOfFile:decorateDirectory encoding:NSUTF8StringEncoding error:nil];
        return [ECJsonUtil objectWithJsonString:decorateConfig];
    }
    
    return nil;
}
#pragma mark- 获取完整的网络请求参数
+ (NSString *) getNetParam:(id)data
{
    if ([data isKindOfClass:[NSDictionary class]]) {
        return [ECJsonUtil stringWithDic:[data newParams]];
    }
    
    NSDictionary* params = [ECJsonUtil objectWithJsonString:data];
    params = [params newParams];
    return [ECJsonUtil stringWithDic:params];
}
#pragma mark- 获取app配置
+ (id) getPreference:(NSString *)key
{
//    SEL methodName = NSSelectorFromString(key);
//    
//    if ([[ECAppUtil shareInstance] respondsToSelector:methodName]) {
//        return  [[ECAppUtil shareInstance] performSelector:methodName];
//    }
    NSString* result = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return result ? result : @"";
}

// 设置app 属性
+ (void) setPreference:(id)preference forKey:(NSString *)key
{
    preference && key ? [[NSUserDefaults standardUserDefaults] setObject:preference forKey:key] : nil;
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//删除
+ (void) deletePreferenceForKey:key
{
    key ? [[NSUserDefaults standardUserDefaults] removeObjectForKey:key] : nil;
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark- 填充App
+ (void) inflateApp:(NSString *)codeString
{
    //获取APIKey,清除当前Token project/projectapps/get_son_appinfo
    
    [ApiKey applyApiKey:codeString didFinished:^{
        
        //获取样式配置，并保存    project/projects/detail
        [Decorate downloadDecorateConfig:^{
            
            //下载资源包     project/projects/package_resource
            [Decorate downloadDecorateResource:^{
                
                //填充ＡＰＰ成功，记录状态
                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"infalateSon"];
                
                //触发    onInflateAppSuccess
                ECBaseViewController* nowPageContext = [[[self class] shareInstance] nowPageContext];
                NSString* jsString = [nowPageContext.pageId stringByAppendingString:@".onInflateAppSuccess()"];
                [[ECJSUtil shareInstance] runJS:jsString];
                [nowPageContext.jsContext evaluateScript:jsString];
            }];
        }];
    }];
}

+ (void) deleteInflateAppInfo
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"infalateSon"];
    [ApiKey deletApiKey];
    [ECUser deleteUserInfo];
    [Decorate deleteDecorate];
}
@end


@interface ECUser ()
@property (strong, nonatomic) NSArray* signConfig;

@end
@implementation ECUser

+ (ECUser *) shareInstance
{
    static ECUser* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ECUser alloc] init];
    });
    return instance;
}
- (id) init
{
    self = [super init];
    
    return self;
}

#pragma mark-
+ (void) signUser:(NSArray *)signConfig successedBlock:(signUserSuccessedBlock)successedBlock faildBlock:(signUserFaildBlock)faildBlock
{
    [[self class] shareInstance].signUserSuccessedBlock = successedBlock;
    [[self class] shareInstance].signUserFaildBlock = faildBlock;
    [[[self class] shareInstance] signUser:signConfig withLocalData:YES];
}

- (void) signUser:(NSArray *)signConfig withLocalData:(BOOL)withLocalData
{
    self.signConfig = signConfig;
    for (NSString *key in signConfig) {
        id data = [self.userInfo objectForKey:key];
        if ([key isEqualToString:@"avatar"]) {
            data = [data objectForKey:@"url"];
        }
        if (!data || data == [NSNull null]  || ((NSString *)data).length == 0) {
            if (withLocalData) {
                [self loadUserData];
                return;
            }
            if (self.signUserFaildBlock) {
                self.signUserFaildBlock([NSString stringWithFormat:@"%@ is null .",key]);
            }
            return;
        }
    }
    if (self.signUserSuccessedBlock) {
        self.signUserSuccessedBlock();
    }
    
    self.signConfig = nil;
}

#pragma mark-
- (void) loadUserData
{
    NSDictionary* params = @{@"method": @"user/users/detail",@"apiversion":@"1.0"};
    [[ECNetRequest newInstance:API_URL] postNetRequest:params
                                         finishedBlock:^(NSDictionary *data) {
                                             ECLog(@" load user data successed: %@",data);
                                             self.userInfo = data;
                                             if (self.signConfig) {
                                                 [self signUser:self.signConfig withLocalData:NO];
                                             }
                                         } faildBlock:^(NSDictionary *data) {
                                             ECLog(@"load user data faild: %@",data);
                                         }];

}
#pragma mark-
- (void) setUserInfo:(NSDictionary *)userInfo
{
    [[NSUserDefaults standardUserDefaults] setObject:[ECJsonUtil stringWithDic:userInfo] forKey:@"ECUser.userInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSDictionary *) getUserInfo
{
    return [ECJsonUtil objectWithJsonString:[[NSUserDefaults standardUserDefaults] objectForKey:@"ECUser.userInfo"]];
}
+ (void) deleteUserInfo
{
    [[[self class] shareInstance] setUserInfo:@{}];
}
+ (void) saveUserName:(NSString *)username
{
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"ECUser.username"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *) getUserName
{
    NSString* username = [[NSUserDefaults standardUserDefaults] objectForKey:@"ECUser.username"];
    return username && (NSNull *)username != [NSNull null] ? username : @"";
}
+ (void) deleteUserName
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ECUser.username"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL) isLogin
{
    NSString* username = [[NSUserDefaults standardUserDefaults] objectForKey:@"ECUser.username"];
    return  username && (NSNull *)username != [NSNull null] ? YES : NO;
}
@end