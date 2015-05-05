//
//  ECNetUtil.m
//  ECDemoFrameWork
//
//  Created by EC on 8/29/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECNetUtil.h"
#import <CoreFoundation/CoreFoundation.h>
#import <CoreFoundation/CFURL.h>
#import "NSStringExtends.h"
#import "ECViewUtil.h"
#import "ECAppUtil.h"
#import "ECJsonUtil.h"
#import "NSDictionaryExtends.h"

@implementation ECNetUtil

+ (void) applyToken
{
    [AccessToken applyToken];
}

+ (NSDictionary*) generateNetParams:(NSDictionary*)dataSourceDic pageContext:(ECBaseViewController*)pageContext widget:(ECBaseWidget*)widget{
    if (!dataSourceDic || ![dataSourceDic objectForKey:@"method"]) {
        return nil;
    }
    NSMutableDictionary* params = [NSMutableDictionary new];
    [params setObject:[dataSourceDic objectForKey:@"method"] forKey:@"method"];
    NSArray* paramsList = [dataSourceDic objectForKey:@"params"];
    if (paramsList) {
        for (id kvDic in paramsList) {
            if (![kvDic objectForKey:@"key"]) {
                continue;
            }
            NSString* value = [ECDataUtil getValuePurpose:[kvDic objectForKey:@"value"] pageContext:pageContext widget:widget bundleData:nil];
            if (value) {
                [params setObject:value forKey:[kvDic objectForKey:@"key"]];
            }else if([kvDic objectForKey:@"defaultValue"]){
                [params setObject:[kvDic objectForKey:@"defaultValue"] forKey:[kvDic objectForKey:@"key"]];
            }
        }
    }
    return params;
}

+ (BOOL)checkError:(NSString*)responseString{
    if ([responseString contain:@"\"error\""] || [responseString contain:@"\"Error\""]) {
        // Toast as {"error":{"errorDes":"XXX","errorId":"XXX"}}
        NSDictionary* errorDic = [ECJsonUtil objectWithJsonString:responseString];
        [ECViewUtil toast:[[errorDic objectForKey:@"error"] objectForKey:@"errorDes"]];
        return YES;
    }
    return NO;
}
@end


@interface AccessToken ()

@end
@implementation AccessToken
+ (AccessToken *) shareInstance
{
    static AccessToken* obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[AccessToken alloc] init];
    });
    
    return obj;
}
/**
 * 向服务器申请 access_token
 */
+ (void) applyToken
{
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"device", @"grant_type",[UIDevice UDID], @"devicenumber",tokenMethod(),@"method", [ApiKey getApiKey],@"client_id",[ApiKey getApiKey],@"api_key", nil];
    [[ECNetRequest newInstance:TOKEN_URL] postNetRequest:@"app.gettoken"
                                                  params:params
                                                delegate:[AccessToken shareInstance]
                                        finishedSelector:@selector(tokenRequestFinished:)
                                            failSelector:@selector(tokenRequestFailed :)
                                                useCache:NO
     ];
}
/**
 * 获取保存的 access_token
 */
+ (NSString *) getToken
{
//    return  [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    NSString *accessToken = [ECAppUtil getPreference:@"access_token"];
    return accessToken.length == 0 ? nil : accessToken;
}
+ (NSString *) getPushToken
{
//    return  [[NSUserDefaults standardUserDefaults] objectForKey:@"push_token"];
    NSString *pushToken = [ECAppUtil getPreference:@"push_token"];
    return pushToken.length == 23 ? pushToken : nil;
}
/**
 * 删除保存的 access_token
 */
+ (void) deleteToken
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"access_token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"push_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void) saveToken:(NSDictionary *)tokenDic
{
//    [[NSUserDefaults standardUserDefaults] setObject:[tokenDic objectForKey:@"access_token"] forKey:@"access_token"];
//    [[NSUserDefaults standardUserDefaults] setObject:[tokenDic objectForKey:@"push_android_token"] forKey:@"push_token"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [ECAppUtil setPreference:[tokenDic objectForKey:@"access_token"] forKey:@"access_token"];
    [ECAppUtil setPreference:[tokenDic objectForKey:@"push_android_token"] forKey:@"push_token"];
}
- (void) tokenRequestFinished:(NSNotification *)noti
{
    NSLog(@"NetRequestFinished : %@",noti.userInfo);
    
    [self saveToken:noti.userInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applyToken.finished" object:nil userInfo:[NSDictionary dictionaryWithObject:[noti.userInfo valueForKey:@"access_token"] forKey:@"access_token"]];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:noti.name object:nil];
}
- (void) tokenRequestFailed:(NSNotification *)noti
{
    NSLog(@"NetRequestFailed : %@",noti.userInfo);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applyToken.faild" object:nil userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:noti.name object:nil];
}
@end


@interface ApiKey ()
@property (nonatomic, copy) ApplyApiKeyFinished finishedBlock;

@end
@implementation ApiKey

+ (ApiKey *) shareInstance
{
    static ApiKey* obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[ApiKey alloc] init];
    });
    
    return obj;
}

+ (void) applyApiKey:(NSString *)projectNumber
{
    [[self class] applyApiKey:projectNumber didFinished:^{
        
    }];

}

+ (void) applyApiKey:(NSString *)projectNumber didFinished:(ApplyApiKeyFinished)finishedBlock
{
    [ApiKey shareInstance].finishedBlock = finishedBlock;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:projectNumber,@"project_num",@"project/projectapps/get_son_appinfo",@"method",@"1.0",@"apiversion", nil];
    [[ECNetRequest newInstance:API_URL] postNetRequest:@"app.getapikey"
                                                params:params
                                              delegate:[ApiKey shareInstance]
                                      finishedSelector:@selector(apiKeyRequestFinished:)
                                          failSelector:@selector(apiKeyRequestFailed :)
                                              useCache:NO
     ];
    
}

+ (NSString *) getApiKey
{
    NSString* api_key = [[NSUserDefaults standardUserDefaults] objectForKey:@"api_key"];
    return api_key && api_key.length ? api_key : API_KEY;
}

+ (NSString *) getApiSecret
{
    NSString* api_secret = [[NSUserDefaults standardUserDefaults] objectForKey:@"api_secret"];
    return api_secret && api_secret.length ? api_secret : CLIENT_SECRET;
}

#pragma mark- private mthod
- (void) apiKeyRequestFinished:(NSNotification *)noti
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:noti.name object:nil];
    
    NSLog(@"NetRequestFinished : %@",noti.userInfo);
    if ([noti.userInfo isKindOfClass:[NSNull class]] || [noti.userInfo isEmpty]) {
        [ECViewUtil showConfirm:@"输入码错误，请确认后重新操作！" okTag:@"确定" cancelTag:@"取消"];
        return;
    }
    [AccessToken deleteToken];
    [self saveApiKey:[noti.userInfo valueForKey:@"api_key"]];
    [self saveApiSecret:[noti.userInfo valueForKey:@"api_secret"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applyApikey.finished" object:nil userInfo:nil];
    
    if (self.finishedBlock) {
        self.finishedBlock();
    }
}
- (void) apiKeyRequestFailed:(NSNotification *)noti
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:noti.name object:nil];
    
    NSLog(@"NetRequestFailed : %@",[ECJsonUtil stringWithDic:noti.userInfo]);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applyApiKey.finished" object:nil userInfo:nil];
    
    [[self class] deletApiKey];
}
- (void) saveApiKey:(NSString *)api_key
{
    [[NSUserDefaults standardUserDefaults] setObject:api_key forKey:@"api_key"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void) saveApiSecret:(NSString *)api_secret
{
    [[NSUserDefaults standardUserDefaults] setObject:api_secret forKey:@"api_secret"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) deletApiKey
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"api_key"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"api_secret"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"infalateSon"];
    [AccessToken deleteToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end

#import "ECDownloadRequest.h"
#import "ZipArchive.h"
@interface Decorate ()
@property (nonatomic, copy) DownloadDecorateResourceFinished downloadDecorateResourceFinishedBlock;
@property (nonatomic, copy) DownloadDecorateConfigFinished downloadDecorateConfigFinishedBlock;
@end
@implementation Decorate

+ (Decorate *) shareInstance
{
    static Decorate* obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[Decorate alloc] init];
    });
    
    return obj;
}

- (NSDictionary *) getDecorateConfig
{
    NSString* decorateConfigName = [[self getDecoratePath] stringByAppendingString:@"decorateConfig.json.txt"];
    NSString* decorateConfigString = [NSString stringWithContentsOfFile:decorateConfigName encoding:NSUTF8StringEncoding error:nil];
    
    return [ECJsonUtil objectWithJsonString:decorateConfigString];
}
- (NSString *) getDecoratePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *decorateDirectory = [documentsDirectory stringByAppendingPathComponent:@"decorate"];
    
    BOOL isDir;
    if ([fileManager fileExistsAtPath:decorateDirectory isDirectory:&isDir] && isDir) {
        return [decorateDirectory stringByAppendingString:@"/"];
    }
    
    [fileManager createDirectoryAtPath:decorateDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    return [decorateDirectory stringByAppendingString:@"/"];
}
#pragma mark-
+ (void) downloadDecorateConfig
{
    [[self class] downloadDecorateConfig:^{
        
    }];
}
+ (void) downloadDecorateConfig:(DownloadDecorateConfigFinished)finishBlock
{
    [[self class] shareInstance].downloadDecorateConfigFinishedBlock = finishBlock;
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"project/projects/detail",@"method", nil];
    [[ECNetRequest newInstance:API_URL] postNetRequest:@"app.decorateconfig"
                                                  params:params
                                                delegate:[[self class] shareInstance]
                                        finishedSelector:@selector(decorateConfigRequestFinished:)
                                            failSelector:@selector(decorateConfigRequestFailed :)
                                                useCache:NO
     ];
}

+ (void) downloadDecorateResource
{
    [[self class] downloadDecorateResource:^{
        
    }];
}
+ (void) downloadDecorateResource:(DownloadDecorateResourceFinished)finishBlock
{
    [[self class] shareInstance].downloadDecorateResourceFinishedBlock = finishBlock;
    
    //
    NSString* resourcePath = [[[[[self class] shareInstance] getDecorateConfig] objectForKey:@"configs"] objectForKey:@"package_path"];
    
    NSArray* tempPath = [resourcePath componentsSeparatedByString:@"/"];
    
    NSString* requestURL = [[API_URL substringToIndex:[API_URL rangeOfString:@"/api"].location+1] stringByAppendingString:resourcePath];
    [[ECDownloadRequest newInstance:requestURL] postDownloadRequest:@"decorateresource.download"
                                                           delegate:[[self class] shareInstance]
                                                      startSelector:@selector(downloadstarted:)
                                                    processSelector:@selector(downloadProcess:)
                                                   finishedSelector:@selector(downloadFinished:)
                                                       failSelecotr:@selector(downloadFailed:)
                                                           fileName:tempPath.lastObject ];
    
}
+ (void) deleteDecorate
{
    //TODO:需实现清除方法
}
#pragma mark- private method
- (void) decorateConfigRequestFinished:(NSNotification *)noti
{
    NSLog(@"NetRequestFinished : %@",noti.userInfo);
    
    [self saveDecorateConfig:noti.userInfo];
    if (self.downloadDecorateConfigFinishedBlock) {
        self.downloadDecorateConfigFinishedBlock();
    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"decorateConfig.finished" object:nil userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:noti.name object:nil];
}
- (void) decorateConfigRequestFailed:(NSNotification *)noti
{
    NSLog(@"NetRequestFailed : %@",noti.userInfo);
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"decorateConfig.finished" object:nil userInfo:nil];
}

- (void) saveDecorateConfig:(NSDictionary *)decorate_config
{
    NSString* decorateConfigName = [[self getDecoratePath] stringByAppendingString:@"decorateConfig.json.txt"];
    NSString* decorateConfig = [ECJsonUtil stringWithDic:decorate_config];
    
    NSError* error;
    [decorateConfig writeToFile:decorateConfigName atomically:YES encoding:NSUTF8StringEncoding error:&error];
}
/*-------------------------------------------*/
-(void)downloadstarted:(NSNotification*) noti{
    NSLog(@"downloadstarted ");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:noti.name object:nil];
}
-(void)downloadProcess:(NSNotification*) noti{
    float process = [(NSNumber*)[noti.userInfo objectForKey:@"process"] floatValue];
    NSLog(@"downloadProcess : %f" , process);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:noti.name object:nil];
}
-(void)downloadFinished:(NSNotification*) noti{
    NSLog(@"downloadFinished : %@",[noti.userInfo objectForKey:@"filePath"]);
    NSString *filepath = [noti.userInfo objectForKey:@"filePath"];
    ZipArchive* zipArchive = [[ZipArchive alloc] init];
    if ([zipArchive UnzipOpenFile:filepath]) {
        BOOL ret = [zipArchive UnzipFileTo:[self getDecoratePath] overWrite: YES];
        if (YES == ret) {
            [zipArchive UnzipCloseFile];
            if (self.downloadDecorateResourceFinishedBlock) {
                self.downloadDecorateResourceFinishedBlock();
            }
        }else{
            NSLog(@"can not unarchive zip ");
        }
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:noti.name object:nil];
}
-(void)downloadFailed:(NSNotification*) noti{
    NSLog(@"downloadFailed XXXX ");
    [ApiKey deletApiKey];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:noti.name object:nil];
}

@end