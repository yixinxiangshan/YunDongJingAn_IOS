//
//  ABSEngine.m
//  AddressBookSpy
//
//  Created by Johannes Fahrenkrug on 27.02.12.
//  Copyright (c) 2012 Springenwerk. All rights reserved.
//

#import "ECJSUtil.h"
#import "Constants.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "ECViewUtil.h"
#import "ECPageUtil.h"
#import "ECAppUtil.h"
#import "ECWidgetUtil.h"
#import "ECJsonUtil.h"
#import "ECIntentUtil.h"
#import "ECNetUtil.h"
#import "NSStringExtends.h"
#import "ECReflectionUtil.h"
#import "NSDictionaryExtends.h"
#import "NSArrayExtends.h"
#import "NSObjectExtends.h"

#import "ECJSAPI.h"

#import "ECQRCapture.h"
#import "ECMediaPlayer.h"
#import "ECListData.h"
#import "ECCoreData.h"
#import "ECTabWidget.h"

#import "ECJSAPI.h"

@interface ECJSUtil ()
@property (nonatomic, strong) NSMutableDictionary* jsMethodMap;
@end

@implementation ECJSUtil

+ (ECJSUtil*) shareInstance{
    static ECJSUtil* singleInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleInstance = [ECJSUtil new];
    });
    return singleInstance;
}

/**
 Lazily initializes and returns a JS context
 */
- (JSGlobalContextRef)JSContext
{
    if (_JSContext == NULL) {
        _JSContext = JSGlobalContextCreate(NULL);
        [self registerMethods];
    }
    
    return _JSContext;
}

/**
 Runs a string of JS in this instance's JS context and returns the result as a string
 */
- (NSString *)runJS:(NSString *)aJSString
{
    if (!aJSString) {
        ECLog(@"[JSC] JS String is empty!");
        return nil;
    }
    //    ECLog(@"runJS jsString : %@",aJSString);
    JSStringRef scriptJS = JSStringCreateWithUTF8CString([aJSString UTF8String]);
    JSValueRef exception = NULL;
    
    JSValueRef result = JSEvaluateScript([self JSContext], scriptJS, NULL, NULL, 0, &exception);
    NSString *res = nil;
    
    if (!result) {
        if (exception) {
            JSStringRef exceptionArg = JSValueToStringCopy([self JSContext], exception, NULL);
            NSString* exceptionRes = (__bridge_transfer NSString*)JSStringCopyCFString(kCFAllocatorDefault, exceptionArg);
            
            JSStringRelease(exceptionArg);
            ECLog(@"[JSC] JavaScript exception: %@", exceptionRes);
            //            ECLog(@"[JSC] jsString : %@",aJSString);
        }
        
        ECLog(@"[JSC] No result returned");
    } else {
        JSStringRef jstrArg = JSValueToStringCopy([self JSContext], result, NULL);
        res = (__bridge_transfer NSString*)JSStringCopyCFString(kCFAllocatorDefault, jstrArg);
        
        JSStringRelease(jstrArg);
    }
    
    JSStringRelease(scriptJS);
    
    return res;
}

/**
 Loads a JS library file from the app's bundle (without the .js extension)
 */
- (void)loadJSLibrary:(NSString*)libraryName
{
    NSString *library = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:libraryName ofType:@"js"]  encoding:NSUTF8StringEncoding error:nil];
    
    ECLog(@"[JSC] loading library %@...", libraryName);
    [self runJS:library];
}
/**
 * register method for js runtime
 */
-(void) registerMethod:(NSString *) methodName function:(JSObjectCallAsFunctionCallback)methodBody
{
    JSStringRef str = JSStringCreateWithUTF8CString([methodName cStringUsingEncoding:NSUTF8StringEncoding]);
    JSObjectRef func = JSObjectMakeFunctionWithCallback(_JSContext, str, methodBody);
    JSObjectSetProperty(_JSContext, JSContextGetGlobalObject(_JSContext), str, func, kJSPropertyAttributeNone, NULL);
    JSStringRelease(str);
}
/**
 * register all methods
 */
-(void)registerMethods{
    [self registerMethod:@"postEvent" function:ECJSPostEvent];
    [self registerMethod:@"NSLog" function:ECJSLog];
    [self registerMethod:@"MakeToast" function:ECJSToast];
    [self registerMethod:@"showConfirm" function:ECJSShowConfirm];
    [self registerMethod:@"showLoadingDialog" function:ECJSShowLoading];
    [self registerMethod:@"closeLoadingDianlog" function:ECJSCloseLoading];
    [self registerMethod:@"openActivity" function:ECJSOpenPage];
    [self registerMethod:@"openActivityWithFinished" function:ECJSOpenPageWithFinished];
    [self registerMethod:@"closeActivity" function:ECJSClosePage];
    [self registerMethod:@"refreshWidget" function:ECJSRefreshWidgetData];
    [self registerMethod:@"addDataIntoWidget" function:ECJSAddWidgetData];
    [self registerMethod:@"setAttrsForWidget" function:ECJSSetWidgetAttr];
    [self registerMethod:@"openWebBrowser" function:ECJSOpenWebBrowser];
    [self registerMethod:@"callPhoneNumber" function:ECJSMakeCall];
    [self registerMethod:@"sendEmail" function:ECJSSendEmail];
    [self registerMethod:@"putPageParam" function:ECJSPutPageParam];
    [self registerMethod:@"getPageParam" function:ECJSGetPageParam];
    [self registerMethod:@"checkError" function:ECJSCheckError];
    [self registerMethod:@"getValuePurpose" function:ECJSGetValuePurpose];
    [self registerMethod:@"callWidgetMethod" function:ECJSCallWidgetMethod];
    // add by cww
    [self registerMethod:@"openQRCapture" function:ECOpenQRCapture];
    [self registerMethod:@"getPreference" function:ECGetPreference];
    [self registerMethod:@"setPreference" function:ECSetPreference];
    [self registerMethod:@"inflateApp" function:ECInflateApp];
    [self registerMethod:@"signUser" function:ECSignUser];
    [self registerMethod:@"getDecorateConfig" function:ECGetDecorateConfig];
    [self registerMethod:@"getLocalUserInfo" function:ECGetLocalUserInfo];
    [self registerMethod:@"openVideo" function:ECOpenVideo];
    [self registerMethod:@"getPageId" function:ECGetPageId];
    
    [self registerMethod:@"pushQueue" function:ECPushQueue];
    
    [self registerMethod:@"clearInflated" function:ECClearInflated];
    [self registerMethod:@"clearCache" function:ECClearCache];
    
    [self registerMethod:@"openActivityFinishedOthers" function:ECOpenActivityFinishedOthers];
    
    //    [self registerMethod:@"getLocation" function:ECGetLocation];
    [self registerMethod:@"putPageParams" function:ECPutPageParams];
    [self registerMethod:@"refershWidget" function:ECRefershWidget];
    [self registerMethod:@"toast" function:ECToast];
    [self registerMethod:@"isUserLogin" function:ECIsLogin];
    [self registerMethod:@"saveUserName" function:ECSaveUserName];
    [self registerMethod:@"getUserName" function:ECGetUserName];
    [self registerMethod:@"deleteUserName" function:ECDeleteUserName];
    [self registerMethod:@"getPushToken" function:ECGetPushToken];
    [self registerMethod:@"getAppVersion" function:ECGetAppVersion];
    [self registerMethod:@"checkNewVersion" function:ECCheckNewVersion];
    
    [self registerMethod:@"putchCache" function:ECPutCache];
    [self registerMethod:@"getCache" function:ECGetCache];
    [self registerMethod:@"getCaches" function:ECGetCaches];
    [self registerMethod:@"removeCaches" function:ECRemoveCaches];
    
    
    [self registerMethod:@"setTabHostCurrentTab" function:ECSetTabHostCurrentTab];
    _jsMethodMap = [NSMutableDictionary new];
}

/**
 处理PostEvent
 */
JSValueRef ECJSPostEvent(JSContextRef ctx,
                         JSObjectRef function,
                         JSObjectRef thisObject,
                         size_t argumentCount,
                         const JSValueRef arguments[],
                         JSValueRef* exception){
    
    JSStringRef     jstrMethodName = JSValueToStringCopy(ctx, arguments[0], NULL);
    NSString* methodName = (__bridge_transfer  NSString*)JSStringCopyCFString(kCFAllocatorDefault, jstrMethodName);
    NSString* jsMethodString = [methodName stringByAppendingString:@"("];
    for (int i=1; i<argumentCount; i++) {
        JSStringRef jsStringParam = JSValueToStringCopy(ctx, arguments[i], NULL);
        NSString* stringParam = (__bridge_transfer NSString*)JSStringCopyCFString(kCFAllocatorDefault, jsStringParam);
        if (stringParam != nil && ![stringParam isEqualToString:@"null"]) {
            //对参数进行转义
            stringParam = [stringParam stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
            stringParam = [stringParam stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
            
            jsMethodString = [jsMethodString stringByAppendingString:[NSString stringWithFormat:@"\"%@\",",stringParam]];
        }
    }
    jsMethodString = [[jsMethodString substringFromIndex:jsMethodString.length-1] isEqualToString:@","] ? [jsMethodString slimE] : jsMethodString;
    jsMethodString = [jsMethodString stringByAppendingString:@");"];
    [[ECJSUtil shareInstance] runJS:jsMethodString];
    
    return JSValueMakeNull(ctx);
}

/**
 打印log信息
 */
JSValueRef ECJSLog(JSContextRef ctx,
                   JSObjectRef function,
                   JSObjectRef thisObject,
                   size_t argumentCount,
                   const JSValueRef arguments[],
                   JSValueRef* exception){
    JSStringRef     jstrArg = JSValueToStringCopy(ctx, arguments[0], NULL);
    ECLog(@"JSLog : %@",(__bridge_transfer  NSString*)JSStringCopyCFString(kCFAllocatorDefault, jstrArg));
    return JSValueMakeNull(ctx);
}
/**
 提示信息
 */
JSValueRef ECJSToast(JSContextRef ctx,
                     JSObjectRef function,
                     JSObjectRef thisObject,
                     size_t argumentCount,
                     const JSValueRef arguments[],
                     JSValueRef* exception){
    JSStringRef     jstrArg = JSValueToStringCopy(ctx, arguments[0], NULL);
    [ECViewUtil toast:(__bridge_transfer NSString*)JSStringCopyCFString(kCFAllocatorDefault, jstrArg)];
    return JSValueMakeNull(ctx);
}
/**
 确认框
 */
JSValueRef ECJSShowConfirm(JSContextRef ctx,
                           JSObjectRef function,
                           JSObjectRef thisObject,
                           size_t argumentCount,
                           const JSValueRef arguments[],
                           JSValueRef* exception){
    JSStringRef     msg = JSValueToStringCopy(ctx, arguments[0], NULL);
    JSStringRef     okTag = JSValueToStringCopy(ctx, arguments[1], NULL);
    JSStringRef     cancelTag = JSValueToStringCopy(ctx, arguments[2], NULL);
    [ECViewUtil showConfirm:(__bridge_transfer NSString*)JSStringCopyCFString(kCFAllocatorDefault, msg)
                      okTag:(__bridge_transfer NSString*)JSStringCopyCFString(kCFAllocatorDefault, okTag)
                  cancelTag:(__bridge_transfer NSString*)JSStringCopyCFString(kCFAllocatorDefault, cancelTag)];
    return JSValueMakeNull(ctx);
}

/**
 加载框
 */
JSValueRef ECJSShowLoading(JSContextRef ctx,
                           JSObjectRef function,
                           JSObjectRef thisObject,
                           size_t argumentCount,
                           const JSValueRef arguments[],
                           JSValueRef* exception){
    JSStringRef     title = JSValueToStringCopy(ctx, arguments[0], NULL);
    JSStringRef     message = JSValueToStringCopy(ctx, arguments[1], NULL);
    JSStringRef     cancelAbleString = JSValueToStringCopy(ctx, arguments[2], NULL);
    BOOL cancelAble = ((__bridge_transfer NSString*)JSStringCopyCFString(kCFAllocatorDefault, cancelAbleString)).boolValue;
    [ECViewUtil showLoadingDialog:(__bridge_transfer NSString*)JSStringCopyCFString(kCFAllocatorDefault, title)
                   loadingMessage:(__bridge_transfer NSString*)JSStringCopyCFString(kCFAllocatorDefault, message)
                       cancelAble:cancelAble];
    return JSValueMakeNull(ctx);
}
JSValueRef ECJSCloseLoading(JSContextRef ctx,
                            JSObjectRef function,
                            JSObjectRef thisObject,
                            size_t argumentCount,
                            const JSValueRef arguments[],
                            JSValueRef* exception){
    [ECViewUtil closeLoadingDialog];
    return JSValueMakeNull(ctx);
}

/**
 打开页面
 */
JSValueRef ECJSCallWidgetMethod(JSContextRef ctx,
                                JSObjectRef function,
                                JSObjectRef thisObject,
                                size_t argumentCount,
                                const JSValueRef arguments[],
                                JSValueRef* exception){
    
    NSString* controlId = [[ECJSUtil shareInstance] bridgeStringFromJsToOc:JSValueToStringCopy(ctx, arguments[0], NULL)];
    ECBaseWidget* widget = [ECWidgetUtil getWidget:controlId];
    NSString* methodName = [[ECJSUtil shareInstance] bridgeStringFromJsToOc:JSValueToStringCopy(ctx, arguments[1], NULL)];
    NSString* param1 = nil;
    NSString* param2 = nil;
    if (argumentCount >=3) {
        param1 = [[ECJSUtil shareInstance] bridgeStringFromJsToOc:JSValueToStringCopy(ctx, arguments[2], NULL)];
    }
    if (argumentCount >=4) {
        param2 = [[ECJSUtil shareInstance] bridgeStringFromJsToOc:JSValueToStringCopy(ctx, arguments[3], NULL)];
    }
    methodName = param1 == nil?methodName:[methodName stringByAppendingString:@":"];
    param2 = [param2 isEmpty]?nil:param2;
    
    [ECReflectionUtil performSelectorWithInvoker:widget selectName:methodName objectOne:param1 objectTwo:nil];
    return JSValueMakeNull(ctx);
}


/**
 打开页面
 */
JSValueRef ECJSOpenPage(JSContextRef ctx,
                        JSObjectRef function,
                        JSObjectRef thisObject,
                        size_t argumentCount,
                        const JSValueRef arguments[],
                        JSValueRef* exception){
    if (argumentCount != 3) {
        return nil;
    }
    
    NSString* pageName = (__bridge_transfer NSString*)JSStringCopyCFString(kCFAllocatorDefault, JSValueToStringCopy(ctx, arguments[1], NULL));
    NSString* paramString = (__bridge_transfer NSString*)JSStringCopyCFString(kCFAllocatorDefault, JSValueToStringCopy(ctx, arguments[2], NULL));
    
    [ECPageUtil openNewPage:pageName params:paramString];
    return JSValueMakeNull(ctx);
}

JSValueRef ECJSOpenPageWithFinished(JSContextRef ctx,
                                    JSObjectRef function,
                                    JSObjectRef thisObject,
                                    size_t argumentCount,
                                    const JSValueRef arguments[],
                                    JSValueRef* exception){
    if (argumentCount != 3) {
        return nil;
    }
    //    JSStringRef     pageName = JSValueToStringCopy(ctx, arguments[0], NULL);
    //    JSStringRef     params = JSValueToStringCopy(ctx, arguments[1], NULL);
    //    JSStringRef     url = JSValueToStringCopy(ctx, arguments[1], NULL);
    //    //TODO: 打开新页面，并关闭之前页面
    //    [ECPageUtil openNewPage:(__bridge_transfer NSString*)JSStringCopyCFString(kCFAllocatorDefault, pageName)
    //                     params:(__bridge_transfer NSString*)JSStringCopyCFString(kCFAllocatorDefault, params)];
    
    
    NSString* pageName = (__bridge_transfer NSString*)JSStringCopyCFString(kCFAllocatorDefault, JSValueToStringCopy(ctx, arguments[1], NULL));
    NSString* paramString = (__bridge_transfer NSString*)JSStringCopyCFString(kCFAllocatorDefault, JSValueToStringCopy(ctx, arguments[2], NULL));
    [ECPageUtil openNewPageWithFinished:pageName params:paramString];
    return JSValueMakeNull(ctx);
}

/**
 关闭页面
 */
JSValueRef ECJSClosePage(JSContextRef ctx,
                         JSObjectRef function,
                         JSObjectRef thisObject,
                         size_t argumentCount,
                         const JSValueRef arguments[],
                         JSValueRef* exception){
    //TODO: 添加关闭页面方法，包含参数和不含参数
    NSString* closeSuccess = nil;
    if (argumentCount >=1) {
        closeSuccess = [[ECJSUtil shareInstance] bridgeStringFromJsToOc:JSValueToStringCopy(ctx, arguments[0], NULL)];
    }
    [ECPageUtil closeNowPage:closeSuccess];
    return JSValueMakeNull(ctx);
}

/**
 刷新控件数据
 */
JSValueRef ECJSRefreshWidgetData(JSContextRef ctx,
                                 JSObjectRef function,
                                 JSObjectRef thisObject,
                                 size_t argumentCount,
                                 const JSValueRef arguments[],
                                 JSValueRef* exception){
    
    NSString* controlId = [[ECJSUtil shareInstance] bridgeStringFromJsToOc:JSValueToStringCopy(ctx, arguments[0], NULL)];
    ECBaseWidget* widget = [[[ECAppUtil shareInstance] nowPageContext] getWidget:controlId];
    
    //当只有一个参数时
    if (argumentCount==1) {
        [widget refreshWidget];
        return JSValueMakeNull(ctx);
    }
    //当有两个参数时
    NSString* newDataString = [[ECJSUtil shareInstance] bridgeStringFromJsToOc:JSValueToStringCopy(ctx, arguments[1], NULL)];
    
    [widget refreshWidgetData:[ECJsonUtil objectWithJsonString:newDataString]];
    return JSValueMakeNull(ctx);
}

/**
 新增控件数据
 */
JSValueRef ECJSAddWidgetData(JSContextRef ctx,
                             JSObjectRef function,
                             JSObjectRef thisObject,
                             size_t argumentCount,
                             const JSValueRef arguments[],
                             JSValueRef* exception){
    JSStringRef     newData = JSValueToStringCopy(ctx, arguments[0], NULL);
    JSStringRef     controlId = JSValueToStringCopy(ctx, arguments[1], NULL);
    ECBaseWidget* widget = [[[ECAppUtil shareInstance] nowPageContext] getWidget:(__bridge_transfer NSString*)JSStringCopyCFString(kCFAllocatorDefault, controlId)];
    //    [ECWidgetUtil addWidgetData:[[ECAppUtil shareInstance] nowPageContext]  widget:widget dataSourceDic:[ECJsonUtil objectWithJsonString:(__bridge_transfer NSString*)JSStringCopyCFString(kCFAllocatorDefault, newData)]];
    return JSValueMakeNull(ctx);
}

/**
 设置控件属性
 */
JSValueRef ECJSSetWidgetAttr(JSContextRef ctx,
                             JSObjectRef function,
                             JSObjectRef thisObject,
                             size_t argumentCount,
                             const JSValueRef arguments[],
                             JSValueRef* exception){
    JSStringRef     attrsString = JSValueToStringCopy(ctx, arguments[0], NULL);
    JSStringRef     controlId = JSValueToStringCopy(ctx, arguments[1], NULL);
    [ECWidgetUtil setAttrsForWidget:(__bridge_transfer NSString*)JSStringCopyCFString(kCFAllocatorDefault, attrsString)
                          controlId:(__bridge_transfer NSString*)JSStringCopyCFString(kCFAllocatorDefault, controlId)];
    return JSValueMakeNull(ctx);
}

/**
 打开网页
 */
JSValueRef ECJSOpenWebBrowser(JSContextRef ctx,
                              JSObjectRef function,
                              JSObjectRef thisObject,
                              size_t argumentCount,
                              const JSValueRef arguments[],
                              JSValueRef* exception){
    JSStringRef     url = JSValueToStringCopy(ctx, arguments[0], NULL);
    [ECIntentUtil openWebBrowser:(__bridge_transfer NSString*)JSStringCopyCFString(kCFAllocatorDefault, url)];
    return JSValueMakeNull(ctx);
}

/**
 打电话
 */
JSValueRef ECJSMakeCall(JSContextRef ctx,
                        JSObjectRef function,
                        JSObjectRef thisObject,
                        size_t argumentCount,
                        const JSValueRef arguments[],
                        JSValueRef* exception){
    JSStringRef     phoneNum = JSValueToStringCopy(ctx, arguments[0], NULL);
    [ECIntentUtil makeCall:(__bridge_transfer NSString*)JSStringCopyCFString(kCFAllocatorDefault, phoneNum)];
    return JSValueMakeNull(ctx);
}

/**
 发送邮件
 */
JSValueRef ECJSSendEmail(JSContextRef ctx,
                         JSObjectRef function,
                         JSObjectRef thisObject,
                         size_t argumentCount,
                         const JSValueRef arguments[],
                         JSValueRef* exception){
    //TODO: send email
    //    JSStringRef     title = JSValueToStringCopy(ctx, arguments[0], NULL);
    //    [ECIntentUtil makeCall:(__bridge_transfer NSString*)JSStringCopyCFString(kCFAllocatorDefault, phoneNum)];
    return JSValueMakeNull(ctx);
}

/**
 保存页面级传参
 */
JSValueRef ECJSPutPageParam(JSContextRef ctx,
                            JSObjectRef function,
                            JSObjectRef thisObject,
                            size_t argumentCount,
                            const JSValueRef arguments[],
                            JSValueRef* exception){
    NSString* key = [[ECJSUtil shareInstance] bridgeStringFromJsToOc:JSValueToStringCopy(ctx, arguments[0], NULL)];
    NSString* value = [[ECJSUtil shareInstance] bridgeStringFromJsToOc:JSValueToStringCopy(ctx, arguments[1], NULL)];
    [[[ECAppUtil shareInstance] nowPageContext] putParam:key value:value];
    return JSValueMakeNull(ctx);
}


/**
 获得页面级传参
 */
JSValueRef ECJSGetPageParam(JSContextRef ctx,
                            JSObjectRef function,
                            JSObjectRef thisObject,
                            size_t argumentCount,
                            const JSValueRef arguments[],
                            JSValueRef* exception){
    JSStringRef     key = JSValueToStringCopy(ctx, arguments[0], NULL);
    [ECPageUtil getPageParam:(__bridge_transfer NSString*)JSStringCopyCFString(kCFAllocatorDefault, key)];
    return JSValueMakeNull(ctx);
}

/**
 验证网络返回数据
 */
JSValueRef ECJSCheckError(JSContextRef ctx,
                          JSObjectRef function,
                          JSObjectRef thisObject,
                          size_t argumentCount,
                          const JSValueRef arguments[],
                          JSValueRef* exception){
    JSStringRef     responseString = JSValueToStringCopy(ctx, arguments[0], NULL);
    [ECNetUtil checkError:(__bridge_transfer NSString*)JSStringCopyCFString(kCFAllocatorDefault, responseString)];
    return JSValueMakeNull(ctx);
}


JSValueRef ECJSGetValuePurpose(JSContextRef ctx,
                               JSObjectRef function,
                               JSObjectRef thisObject,
                               size_t argumentCount,
                               const JSValueRef arguments[],
                               JSValueRef* exception){
    NSString*   controlId = [[ECJSUtil shareInstance] bridgeStringFromJsToOc:JSValueToStringCopy(ctx, arguments[0], NULL)];
    NSString*   desc = [[ECJSUtil shareInstance] bridgeStringFromJsToOc:JSValueToStringCopy(ctx, arguments[1], NULL)];
    NSString*   bundleString = @"";
    if (argumentCount>=2) {
        bundleString = [[ECJSUtil shareInstance] bridgeStringFromJsToOc:JSValueToStringCopy(ctx, arguments[2], NULL)];
    }
    NSString* result = [ECDataUtil getValuePurpose:desc controlId:controlId bundleData:bundleString];
    return JSValueMakeString(ctx, JSStringCreateWithUTF8CString([result UTF8String]));
}


#pragma mark- jsMethod add by cww
-(NSString*) bridgeStringFromJsToOc:(JSStringRef) jsString{
    return (__bridge_transfer NSString*)JSStringCopyCFString(kCFAllocatorDefault, jsString);
}

JSValueRef ECOpenQRCapture(JSContextRef ctx,
                           JSObjectRef function,
                           JSObjectRef thisObject,
                           size_t argumentCount,
                           const JSValueRef arguments[],
                           JSValueRef* exception){
    [ECQRCapture start:^(NSString *resultString) {
        ECBaseViewController* nowPageContext = [[ECAppUtil shareInstance] nowPageContext];
        NSString* jsString = [NSString stringWithFormat:@"%@.onQRCapture(\"{'codeString':'%@'}\");",nowPageContext.pageId,resultString];
        [[ECJSUtil shareInstance] runJS:jsString];
    }];
    return JSValueMakeNull(ctx);
}

JSValueRef ECOpenVideo(JSContextRef ctx,
                       JSObjectRef function,
                       JSObjectRef thisObject,
                       size_t argumentCount,
                       const JSValueRef arguments[],
                       JSValueRef* exception){
    NSString* urlString = (__bridge_transfer NSString*)JSStringCopyCFString(kCFAllocatorDefault, JSValueToStringCopy(ctx, arguments[0], NULL));
    [ECMediaPlayer playWithURL:urlString];
    return JSValueMakeNull(ctx);
}

JSValueRef ECGetPreference(JSContextRef ctx,
                           JSObjectRef function,
                           JSObjectRef thisObject,
                           size_t argumentCount,
                           const JSValueRef arguments[],
                           JSValueRef* exception){
    JSStringRef keyString = JSValueToStringCopy(ctx, arguments[0], NULL);
    NSString* result = [ECAppUtil getPreference:(__bridge_transfer NSString*)JSStringCopyCFString(kCFAllocatorDefault, keyString)];
    
    return JSValueMakeString(ctx, JSStringCreateWithUTF8CString([result UTF8String]));
    //    return JSValueMakeNull(ctx);
}

//
JSValueRef ECSetPreference(JSContextRef ctx,
                           JSObjectRef function,
                           JSObjectRef thisObject,
                           size_t argumentCount,
                           const JSValueRef arguments[],
                           JSValueRef* exception){
    NSString* keyString = [[ECJSUtil shareInstance] bridgeStringFromJsToOc:JSValueToStringCopy(ctx, arguments[0], NULL)];
    id preference = [[ECJSUtil shareInstance] bridgeStringFromJsToOc:JSValueToStringCopy(ctx, arguments[1], NULL)];
    
    [ECAppUtil setPreference:preference forKey:keyString];
    
    return JSValueMakeNull(ctx);
}

JSValueRef ECInflateApp(JSContextRef ctx,
                        JSObjectRef function,
                        JSObjectRef thisObject,
                        size_t argumentCount,
                        const JSValueRef arguments[],
                        JSValueRef* exception){
    JSStringRef codeString = JSValueToStringCopy(ctx, arguments[0], NULL);
    [ECAppUtil inflateApp:(__bridge_transfer NSString*)JSStringCopyCFString(kCFAllocatorDefault, codeString)];
    
    return JSValueMakeNull(ctx);
}



JSValueRef ECSignUser(JSContextRef ctx,
                      JSObjectRef function,
                      JSObjectRef thisObject,
                      size_t argumentCount,
                      const JSValueRef arguments[],
                      JSValueRef* exception){
    NSArray* signParams = [(__bridge_transfer NSString*)JSStringCopyCFString(kCFAllocatorDefault, JSValueToStringCopy(ctx, arguments[0], NULL)) componentsSeparatedByString:@","];
    [ECUser signUser:signParams
      successedBlock:^{
          ECLog(@"sign user successed .");
          
          ECBaseViewController* nowPageContext = [[ECAppUtil shareInstance] nowPageContext];
          NSString* jsString = [NSString stringWithFormat:@"%@.onSignSuccess()",nowPageContext.pageId];
          [[ECJSUtil shareInstance] runJS:jsString];
      } faildBlock:^(NSString *errorMessage) {
          ECLog(@"sign user faild .");
          
          ECBaseViewController* nowPageContext = [[ECAppUtil shareInstance] nowPageContext];
          NSString* jsString = [NSString stringWithFormat:@"%@.onSignFailed()",nowPageContext.pageId];
          [[ECJSUtil shareInstance] runJS:jsString];
      }];
    
    return JSValueMakeNull(ctx);
}

JSValueRef ECGetDecorateConfig(JSContextRef ctx,
                               JSObjectRef function,
                               JSObjectRef thisObject,
                               size_t argumentCount,
                               const JSValueRef arguments[],
                               JSValueRef* exception){
    NSDictionary* decorateConfig = [ECAppUtil getDecorateConfig];
    return JSValueMakeString(ctx, JSStringCreateWithUTF8CString([[ECJsonUtil stringWithDic:decorateConfig] UTF8String]));
    //    return JSValueMakeFromJSONString(ctx, JSStringCreateWithUTF8CString([[ECJsonUtil stringWithDic:decorateConfig] UTF8String]));
}
JSValueRef ECGetLocalUserInfo(JSContextRef ctx,
                              JSObjectRef function,
                              JSObjectRef thisObject,
                              size_t argumentCount,
                              const JSValueRef arguments[],
                              JSValueRef* exception){
    
    NSDictionary* localUserInfo = [[ECUser shareInstance] getUserInfo];
    return JSValueMakeString(ctx, JSStringCreateWithUTF8CString([[ECJsonUtil stringWithDic:localUserInfo] UTF8String]));
}

JSValueRef ECGetPageId(JSContextRef ctx,
                       JSObjectRef function,
                       JSObjectRef thisObject,
                       size_t argumentCount,
                       const JSValueRef arguments[],
                       JSValueRef* exception){
    
    NSString* pageId = [[[ECAppUtil shareInstance] nowPageContext] pageId];
    return JSValueMakeString(ctx, JSStringCreateWithUTF8CString([pageId UTF8String]));
}

JSValueRef ECPushQueue(JSContextRef ctx,
                       JSObjectRef function,
                       JSObjectRef thisObject,
                       size_t argumentCount,
                       const JSValueRef arguments[],
                       JSValueRef* exception){
    
    NSString* sort1 = [[ECJSUtil shareInstance] bridgeStringFromJsToOc:JSValueToStringCopy(ctx, arguments[0], NULL)];
    NSString* sort2 = [[ECJSUtil shareInstance] bridgeStringFromJsToOc:JSValueToStringCopy(ctx, arguments[1], NULL)];
    NSString* content = [[ECJSUtil shareInstance] bridgeStringFromJsToOc:JSValueToStringCopy(ctx, arguments[2], NULL)];
    
    [ECListDataSupport pushQueue:content sort1:sort1 sort2:sort2];
    
    return JSValueMakeNull(ctx);
}

JSValueRef ECClearInflated(JSContextRef ctx,
                           JSObjectRef function,
                           JSObjectRef thisObject,
                           size_t argumentCount,
                           const JSValueRef arguments[],
                           JSValueRef* exception){
    [ECAppUtil deleteInflateAppInfo];
    return JSValueMakeNull(ctx);
}
JSValueRef ECOpenActivityFinishedOthers(JSContextRef ctx,
                                        JSObjectRef function,
                                        JSObjectRef thisObject,
                                        size_t argumentCount,
                                        const JSValueRef arguments[],
                                        JSValueRef* exception){
    NSString* pageName = (__bridge_transfer NSString*)JSStringCopyCFString(kCFAllocatorDefault, JSValueToStringCopy(ctx, arguments[1], NULL));
    NSString* paramString = (__bridge_transfer NSString*)JSStringCopyCFString(kCFAllocatorDefault, JSValueToStringCopy(ctx, arguments[2], NULL));
    
    [ECPageUtil openNewPageWithFinishedOthers:pageName params:paramString];
    return JSValueMakeNull(ctx);
}

JSValueRef ECClearCache(JSContextRef ctx,
                        JSObjectRef function,
                        JSObjectRef thisObject,
                        size_t argumentCount,
                        const JSValueRef arguments[],
                        JSValueRef* exception){
    [[ECCoreDataSupport sharedInstance] deleteAllCaches];
    return JSValueMakeNull(ctx);
}

//JSValueRef ECGetLocation(JSContextRef ctx,
//                        JSObjectRef function,
//                        JSObjectRef thisObject,
//                        size_t argumentCount,
//                        const JSValueRef arguments[],
//                        JSValueRef* exception){
//
//    NSLog(@"ECJSUtil  arguments count : %zu",argumentCount);
//
//    NSString* objectid = [[ECJSUtil shareInstance] bridgeStringFromJsToOc:JSValueToStringCopy(ctx, arguments[0], NULL)];
//    [LocationUtil getUserLocationWith:^(NSArray *userLocation) {
//        CLLocation* location = [userLocation lastObject];
//        CLLocationCoordinate2D coordinate = [location getBMKCoordinate2D];
//
//        NSString* jsString = [NSString stringWithFormat:@"%@.onLocationSuccess(\"{\\\"latitude\\\":\\\"%f\\\",\\\"longitude\\\":\\\"%f\\\"}\")",objectid,coordinate.latitude, coordinate.longitude];
//        [[ECJSUtil shareInstance] runJS:jsString];
//    }];
//
//    return JSValueMakeNull(ctx);
//}

JSValueRef ECPutPageParams(JSContextRef ctx,
                           JSObjectRef function,
                           JSObjectRef thisObject,
                           size_t argumentCount,
                           const JSValueRef arguments[],
                           JSValueRef* exception)
{
    
    NSString* paramsString = [[ECJSUtil shareInstance] bridgeStringFromJsToOc:JSValueToStringCopy(ctx, arguments[0], NULL)];
    [ECPageUtil putPageParams:paramsString];
    return JSValueMakeNull(ctx);
}

JSValueRef ECPutPageParam(JSContextRef ctx,
                          JSObjectRef function,
                          JSObjectRef thisObject,
                          size_t argumentCount,
                          const JSValueRef arguments[],
                          JSValueRef* exception)
{
    
    NSString* keyString = [[ECJSUtil shareInstance] bridgeStringFromJsToOc:JSValueToStringCopy(ctx, arguments[0], NULL)];
    NSString* param = [[ECJSUtil shareInstance] bridgeStringFromJsToOc:JSValueToStringCopy(ctx, arguments[1], NULL)];
    [ECPageUtil putPageParam:(NSString *)keyString param:(NSString *)param];
    return JSValueMakeNull(ctx);
}

// 刷新控件
JSValueRef ECRefershWidget(JSContextRef ctx,
                           JSObjectRef function,
                           JSObjectRef thisObject,
                           size_t argumentCount,
                           const JSValueRef arguments[],
                           JSValueRef* exception)
{
    
    NSString* widgetId = [[ECJSUtil shareInstance] bridgeStringFromJsToOc:JSValueToStringCopy(ctx, arguments[0], NULL)];
    NSString* dataSource = argumentCount == 2 ? [[ECJSUtil shareInstance] bridgeStringFromJsToOc:JSValueToStringCopy(ctx, arguments[1], NULL)] : nil;
    
    [ECWidgetUtil refershWidget:widgetId dataSource:dataSource];
    return JSValueMakeNull(ctx);
}

// Toast
JSValueRef ECToast(JSContextRef ctx,
                   JSObjectRef function,
                   JSObjectRef thisObject,
                   size_t argumentCount,
                   const JSValueRef arguments[],
                   JSValueRef* exception)
{
    
    NSString* msg = [[ECJSUtil shareInstance] bridgeStringFromJsToOc:JSValueToStringCopy(ctx, arguments[0], NULL)];
    [ECViewUtil toast:msg];
    return JSValueMakeNull(ctx);
}

// isLogin
JSValueRef ECIsLogin(JSContextRef ctx,
                     JSObjectRef function,
                     JSObjectRef thisObject,
                     size_t argumentCount,
                     const JSValueRef arguments[],
                     JSValueRef* exception)
{
    BOOL isLogin = [ECUser isLogin];
    return JSValueMakeBoolean(ctx, isLogin);
}
JSValueRef ECSaveUserName(JSContextRef ctx,
                          JSObjectRef function,
                          JSObjectRef thisObject,
                          size_t argumentCount,
                          const JSValueRef arguments[],
                          JSValueRef* exception)
{
    NSString* username = [[ECJSUtil shareInstance] bridgeStringFromJsToOc:JSValueToStringCopy(ctx, arguments[0], NULL)];
    [ECUser saveUserName:username];
    return JSValueMakeNull(ctx);
}
JSValueRef ECGetUserName(JSContextRef ctx,
                         JSObjectRef function,
                         JSObjectRef thisObject,
                         size_t argumentCount,
                         const JSValueRef arguments[],
                         JSValueRef* exception)
{
    NSString* userName = [ECUser getUserName];
    return JSValueMakeString(ctx, JSStringCreateWithUTF8CString([userName UTF8String]));
}
JSValueRef ECDeleteUserName(JSContextRef ctx,
                            JSObjectRef function,
                            JSObjectRef thisObject,
                            size_t argumentCount,
                            const JSValueRef arguments[],
                            JSValueRef* exception)
{
    [ECUser deleteUserName];
    return JSValueMakeNull(ctx);
}

JSValueRef ECGetPushToken(JSContextRef ctx,
                          JSObjectRef function,
                          JSObjectRef thisObject,
                          size_t argumentCount,
                          const JSValueRef arguments[],
                          JSValueRef* exception)
{
    NSString* pushToken = [AccessToken getPushToken];
    return JSValueMakeString(ctx, JSStringCreateWithUTF8CString([pushToken UTF8String]));
}

JSValueRef ECGetAppVersion(JSContextRef ctx,
                           JSObjectRef function,
                           JSObjectRef thisObject,
                           size_t argumentCount,
                           const JSValueRef arguments[],
                           JSValueRef* exception)
{
    NSString* appVersion = [ECAppUtil getAppVersion];
    return JSValueMakeString(ctx, JSStringCreateWithUTF8CString([appVersion UTF8String]));
}

JSValueRef ECCheckNewVersion(JSContextRef ctx,
                             JSObjectRef function,
                             JSObjectRef thisObject,
                             size_t argumentCount,
                             const JSValueRef arguments[],
                             JSValueRef* exception)
{
    BOOL isNewVersion = [ECAppUtil checkNewVersion];
    return JSValueMakeBoolean(ctx, isNewVersion);
}

JSValueRef ECSetTabHostCurrentTab(JSContextRef ctx,
                                  JSObjectRef function,
                                  JSObjectRef thisObject,
                                  size_t argumentCount,
                                  const JSValueRef arguments[],
                                  JSValueRef* exception)
{
    NSString* tabHostId = [[ECJSUtil shareInstance] bridgeStringFromJsToOc:JSValueToStringCopy(ctx, arguments[0], NULL)];
    NSInteger tabIndex = [[[ECJSUtil shareInstance] bridgeStringFromJsToOc:JSValueToStringCopy(ctx, arguments[1], NULL)] integerValue];
    
    ECTabWidget *tabHost = (ECTabWidget *)[ECWidgetUtil getWidget:tabHostId];
    [tabHost selectItemWithTag:tabIndex];
    return JSValueMakeNull(ctx);
}

JSValueRef ECPutCache(JSContextRef ctx,
                      JSObjectRef function,
                      JSObjectRef thisObject,
                      size_t argumentCount,
                      const JSValueRef arguments[],
                      JSValueRef* exception)
{
    NSString *paramString = [[ECJSUtil shareInstance] bridgeStringFromJsToOc:JSValueToStringCopy(ctx, arguments[0], NULL)];
    NSDictionary *params = [paramString JSONValue];
    NSData *content;
    content = [params[@"content"] isKindOfClass:[NSString class]] ? [params[@"content"] dataUsingEncoding:NSUTF8StringEncoding] : [params[@"content"] JSONData];
    
    if ([[ECCoreDataSupport sharedInstance] putCachesWithContent:content
                                                             md5:params[@"md5"]
                                                           sort1:params[@"sort1"]
                                                           sort2:params[@"sort2"]
                                                         timeout:[params[@"cache_time"] doubleValue]]) {
    }
    return JSValueMakeNull(ctx);
}
JSValueRef ECGetCache(JSContextRef ctx,
                      JSObjectRef function,
                      JSObjectRef thisObject,
                      size_t argumentCount,
                      const JSValueRef arguments[],
                      JSValueRef* exception)
{
    NSString *paramString = [[ECJSUtil shareInstance] bridgeStringFromJsToOc:JSValueToStringCopy(ctx, arguments[0], NULL)];
    NSDictionary *params = [paramString JSONValue];
    NSString * result = [[NSString alloc] initWithData:[[[ECCoreDataSupport sharedInstance] getCachesWithMd5:params[@"md5"]
                                                                                                       sort1:params[@"sort1"]
                                                                                                       sort2:params[@"sort2"]] firstObject]
                                              encoding:NSUTF8StringEncoding];
    return JSValueMakeFromJSONString(ctx, JSStringCreateWithUTF8CString([[@{@"result":result} JSONString] UTF8String]));
}
JSValueRef ECGetCaches(JSContextRef ctx,
                       JSObjectRef function,
                       JSObjectRef thisObject,
                       size_t argumentCount,
                       const JSValueRef arguments[],
                       JSValueRef* exception)
{
    
    return JSValueMakeNull(ctx);
}
JSValueRef ECRemoveCaches(JSContextRef ctx,
                          JSObjectRef function,
                          JSObjectRef thisObject,
                          size_t argumentCount,
                          const JSValueRef arguments[],
                          JSValueRef* exception)
{
    NSString *paramString = [[ECJSUtil shareInstance] bridgeStringFromJsToOc:JSValueToStringCopy(ctx, arguments[0], NULL)];
    NSDictionary *params = [paramString JSONValue];
    [[ECCoreDataSupport sharedInstance] removeCacheWithMd5:params[@"md5"]
                                                     sort1:params[@"sort1"]
                                                     sort2:params[@"sort2"]];
    return JSValueMakeNull(ctx);
}

//JSValueRef ECShareString(JSContextRef ctx,
//                          JSObjectRef function,
//                          JSObjectRef thisObject,
//                          size_t argumentCount,
//                          const JSValueRef arguments[],
//                          JSValueRef* exception)
//{
//    NSString *paramString = [[ECJSUtil shareInstance] bridgeStringFromJsToOc:JSValueToStringCopy(ctx, arguments[0], NULL)];
////    [ECAppUtil shareString:paramString];
//    [ECShareUtils share:paramString];
//    return JSValueMakeNull(ctx);
//}
@end

@interface ECJSContext ()

/**
 *  JSContext
 */
@property (nonatomic) JSGlobalContextRef jsContext;
@end

@implementation ECJSContext

- (id)initWithParent:(NSObject *)parent
{
    self = [super init];
    if (self) {
        self.id = [@"jsContext_" stringByAppendingString:[NSString randomString]];
        self.parent = parent;
        self.jsContext = [[[ECJSUtil alloc] init] JSContext];
        [self evaluateScript:[NSString stringWithFormat:@"_lang='zh';_debug=%@;_pid='%@';",EC_DEBUG_ON ? @"true" : @"false", self.id]];
        
        //注入 callApi 方法
        JSStringRef str = JSStringCreateWithUTF8CString([@"callDeviceApi" cStringUsingEncoding:NSUTF8StringEncoding]);
        JSObjectRef func = JSObjectMakeFunctionWithCallback(_jsContext, str, callDeviceApi);
        JSObjectSetProperty(_jsContext, JSContextGetGlobalObject(_jsContext), str, func, kJSPropertyAttributeNone, NULL);
        JSStringRelease(str);
        
        //load  default lib
        [self evaluateScript:[ECJSContext loadJSString:@"promise.js"]];
        [self evaluateScript:[ECJSContext loadJSString:@"env_ios.js"]];
        [self evaluateScript:[ECJSContext loadJSString:@"api.js"]];
    }
    return self;
}
#pragma mark-
- (void)dealloc
{
    JSGlobalContextRelease(_jsContext);
}
- (NSString *) evaluateScript:(NSString *)script
{
    if (!script) {
        NSLog(@"[ECJSContext] JS String is empty!");
        return nil;
    }
    // ECLog(@"runJS jsString : %s",[script UTF8String]);
    JSValueRef exception = NULL;
    JSStringRef scriptJS = JSStringCreateWithUTF8CString([script UTF8String]);
    
    //    JSContext *context = [JSContext contextWithJSGlobalContextRef:[self jsContext]];
    //    JSValue *function = context[@"factorial"];
    //    JSValue *result = [function callWithArguments:@[@10]];
    //    NSLog(@"factorial(10) = %d", [resulttoInt32]);
    // JSValue *r =  [context evaluateScript:script];
    // ECLog(@"evaluateScript : %@" , [r toString] );
    
    JSValueRef result = JSEvaluateScript([self jsContext], scriptJS, NULL, NULL, 0, &exception);
    NSString *res = nil;
    //    JSValue *result =  = ;
    if (!result) {
        if (exception) {
            JSStringRef exceptionArg = JSValueToStringCopy([self jsContext], exception, NULL);
            NSString* exceptionRes = (__bridge_transfer NSString*)JSStringCopyCFString(kCFAllocatorDefault, exceptionArg);
            
            JSStringRelease(exceptionArg);
            ECLog(@"[JSC] JavaScript exception: %@\n\n*************** jsError *************\n\n%@\n\n*************** jsError *************\n\n", exceptionRes,script);
        }
        
        //        ECLog(@"[JSC] No result returned");
    } else {
        JSStringRef jstrArg = JSValueToStringCopy([self jsContext], result, NULL);
        res = (__bridge_transfer NSString*)JSStringCopyCFString(kCFAllocatorDefault, jstrArg);
        
        JSStringRelease(jstrArg);
    }
    
    JSStringRelease(scriptJS);
    return res;
}
- (NSString *) callbackWithId:(NSString *)callbackId argument:(id)arg
{
    NSString *jsString ;
    if ([arg isKindOfClass:[NSString class]]) {
        jsString = [NSString stringWithFormat:@"_response_callbacks['%@']('%@');",callbackId,arg];
    }else{
        jsString = [NSString stringWithFormat:@"_response_callbacks['%@'](%@);",callbackId,[arg JSONString]];
    }
    // ECLog(@"\n\n callbackWithId : %@ \n\n" ,jsString);
    return [self evaluateScript:jsString];
}

+ (NSString *)callbackWithJSContextId:(NSString *)contextId callbackId:(NSString *)callbackId argument:(id)argument
{
    ECJSContext *jsContext = (ECJSContext *)[NSObject findObjectWithId:contextId];
    return [jsContext callbackWithId:callbackId argument:argument];
}

JSValueRef callDeviceApi(JSContextRef ctx,
                         JSObjectRef function,
                         JSObjectRef thisObject,
                         size_t argumentCount,
                         const JSValueRef arguments[],
                         JSValueRef* exception)
{
    NSString *method = [[ECJSUtil shareInstance] bridgeStringFromJsToOc:JSValueToStringCopy(ctx, arguments[0], NULL)];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[[[ECJSUtil shareInstance] bridgeStringFromJsToOc:JSValueToStringCopy(ctx, arguments[1], NULL)] JSONValue]];
    NSString *callbackId = [[ECJSUtil shareInstance] bridgeStringFromJsToOc:JSValueToStringCopy(ctx, arguments[2], NULL)];
    NSDictionary *action = [[[ECJSUtil shareInstance] bridgeStringFromJsToOc:JSValueToStringCopy(ctx, arguments[3], NULL)] JSONValue];
    
    //    ECLog(@"callDeviceApi: method: \nmethod = %@\nparams = %@\ncallbackId = %@\naction = %@",method,params,callbackId,action);
    
    [ECJSAPI callDeviceAPI:method params:params callbackId:callbackId action:action];
    return JSValueMakeNull(ctx);
}

// load js file
+ (NSString *)loadJSString:(NSString *)strName
{
    NSString *filePath = [NSString stringWithFormat:@"%@/webview/%@",[NSString appConfigPath],strName];
    //    ECLog(@"load JSString : %@",filePath);
    NSString *jsString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    return jsString ? jsString : @"";
}
@end