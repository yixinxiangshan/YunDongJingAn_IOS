//
//  ECWebWidget.m
//  ECDemoFrameWork
//
//  Created by EC on 11/11/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECWebWidget.h"
#import "NSDictionaryExtends.h"
#import "NSStringExtends.h"
#import "Constants.h"
#import "ECWidgetUtil.h"
#import "ECNetUtil.h"
#import "ECJsonUtil.h"
#import "ECJSUtil.h"
#import "WebViewJavascriptBridge.h"
#import "ECViewUtil.h"
#import "NSArrayExtends.h"
#import "ECAppUtil.h"
#import "ECWidgetUtil.h"
#import "ECListData.h"
#import "ECCoreData.h"
#import "NSObjectExtends.h"

#import "ECJSAPI.h"

#import "ECBaseViewController.h"
#import <objc/runtime.h>

@interface ECWebWidget ()
@property (strong, nonatomic) WebViewJavascriptBridge *javascriptBridge;
@property (nonatomic, strong) NSString* htmlDataString;
@property (nonatomic, strong) NSString* dataString;
@property (nonatomic, assign) float webDocumentHeight;
//控件属性
@property (nonatomic, strong) NSString* webTemplate;
@property (nonatomic, strong) NSString* htmlFile;

//与webview-js交互
@property (nonatomic, strong) WVJBResponseCallback responseCallback;

@end

@implementation ECWebWidget

- (id)initWithConfigDic:(NSDictionary*)configDic pageContext:(ECBaseViewController*)pageContext{
    self = [super initWithConfigDic:configDic pageContext:pageContext];
    [self parsingLayoutName];
    if (self.layoutName ==nil || [self.layoutName isEmpty]) {
        self.layoutName = @"ECWebWidget";
    }
    if ([self.controlId isEmpty]) {
        self.controlId = @"web_widget";
    }
    if (self) {
        [self setViewId:@"web_widget"];
        _webView = [[ECWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
        _webView.id = [@"webview_" stringByAppendingString:[NSString randomString]];
        _webView.context = pageContext;
        //设置 data detect type
        _webView.dataDetectorTypes = UIDataDetectorTypeNone;
        [self addSubview:_webView];
        
        NSString* postEventNotiName = [NSString randomString];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEventFromJavaScript:) name:postEventNotiName object:nil];
        _javascriptBridge = [WebViewJavascriptBridge bridgeForWebView:_webView webViewDelegate:self  handler:^(id data, WVJBResponseCallback responseCallback) {
            //接受JavaScript 发送过来的信息
            ECLog(@"msg from webview ");
            [[NSNotificationCenter defaultCenter] postNotificationName:postEventNotiName object:nil userInfo:data];
        }];
        [_javascriptBridge registerHandler:@"postEvent" handler:^(id data, WVJBResponseCallback responseCallback) {
            // 注册 方法名提供给 JavaScript 使用
            ECLog(@"postEvent from webView ");
            [[NSNotificationCenter defaultCenter] postNotificationName:postEventNotiName object:nil userInfo:data];
        }];
        
        
        [_javascriptBridge registerHandler:@"ECLog" handler:^(id data, WVJBResponseCallback responseCallback) {
            // 注册 方法名提供给 JavaScript 使用
            NSLog(@"Log webView %@",data);
        }];
        
        NSArray* jsMethod = @[@"getDecoratePath",@"getDecorateConfig",@"getNetParam",@"callWidgetMethod",@"ECLog",@"pullQueue",@"getConfigFilePath", @"putCache", @"getCache",@"getCaches", @"removeCaches", @"makeToast", @"callCoreApi"];
        for (NSString* methodName in jsMethod) {
            [_javascriptBridge registerHandler:methodName handler:^(id data, WVJBResponseCallback responseCallback) {
                
                //                if (![data isKindOfClass:[NSString class]]) {
                //                    ECLog(@"webwidget jsBridge , call handler , data format error : %@",[data class]);
                //                }
                SEL method = NSSelectorFromString([NSString stringWithFormat:@"%@:",methodName]);
                
                if ([self respondsToSelector:method]) {
                    id result = nil;
                    
                    NSMethodSignature* signature = [self methodSignatureForSelector:method];
                    if ([signature methodReturnType][0] == 'v') {
                        [self performSelector:method withObject:data];
                    }else{
                        result = [self performSelector:method withObject:data];
                    }
                    
                    if (responseCallback) {
                        responseCallback(result);
                    }
                }
            }];
        }
        [_javascriptBridge registerHandler:@"postRequest" handler:^(id data, WVJBResponseCallback responseCallback) {
            _responseCallback = responseCallback;
            [self postRequest:data callBack:responseCallback];
        }];
    }
    [self parsingConfigDic];
    
    
    return self;
    
}

#pragma mark- javascript method
- (void)handleEventFromJavaScript:(NSNotification*)noti{
    
    NSDictionary* data = [noti userInfo];
    ECLog(@"call from js , data : %@",data);
    NSString* jsString = [NSString stringWithFormat:@"%@(",[data valueForKey:@"methodName"]];
    NSMutableArray* paramArray = [NSMutableArray new];
    
    [data valueForKey:@"param1"] != [NSNull null] ? [paramArray addObject:[NSString stringWithFormat:@"\"%@\"",[[data valueForKey:@"param1"] transfer]]] : nil;
    
    [data valueForKey:@"param2"] != [NSNull null] ? [paramArray addObject:[NSString stringWithFormat:@"\"%@\"",[[data valueForKey:@"param2"] transfer]]] : nil;
    
    [data valueForKey:@"param3"] != [NSNull null] ? [paramArray addObject:[NSString stringWithFormat:@"\"%@\"",[[data valueForKey:@"param3"] transfer]]] : nil;
    
    jsString = [jsString stringByAppendingString:[paramArray componentsJoinedByString:@","]];
    
    jsString = [jsString stringByAppendingString:@");"];
    ECLog(@"jsstring = %@",jsString);
    [[ECJSUtil shareInstance] runJS:jsString];
}
/*-------供js调用oc的接口------------*/
- (NSString *) getDecoratePath:(id)data
{
    return [ECAppUtil getDecoratePath:data];
}
- (NSDictionary *) getDecorateConfig:(id)data
{
    //    NSLog(@"getDecorateConfig ; %@",[ECAppUtil getDecorateConfig]);
    return [ECAppUtil getDecorateConfig];
}
- (NSString *) getNetParam:(id)data
{
    return [ECAppUtil getNetParam:data];
    
}

- (NSString *) getConfigFilePath:(id)data
{
    return [self getResourcePath];
}

- (void) postRequest:(id)data callBack:(WVJBResponseCallback) responseCallback
{
    ECLog(@"postRequest ... ");
    [[ECNetRequest newInstance] postNetRequest:data
                                 finishedBlock:^(NSDictionary *data) {
                                     NSDictionary* dataDic = [[NSDictionary alloc] initWithObjectsAndKeys:data,@"data", nil];
                                     //    ECLog(@"postRequest success ... : %@",dataDic);
                                     responseCallback(dataDic);
                                 }
                                    faildBlock:^(NSDictionary *data) {
                                        responseCallback(data);
                                    }
                                      useCache:false];
    
}
- (void) callWidgetMethod:(NSDictionary *)params
{
    [ECWidgetUtil callWidgetMethod:params[@"controlId"] name:params[@"methodName"] param1:params[@"param1"] param2:params[@"param2"]];
}

- (NSString *) putCache:(id)data
{
    // parse params
    NSLog(@"web widget putCache : %@",data);
    NSDictionary *params = data;
    NSData *content;
    content = [params[@"content"] isKindOfClass:[NSString class]] ? [params[@"content"] dataUsingEncoding:NSUTF8StringEncoding] : [params[@"content"] JSONData];
    
    if ([[ECCoreDataSupport sharedInstance] putCachesWithContent:content
                                                             md5:params[@"md5"]
                                                           sort1:params[@"sort1"]
                                                           sort2:params[@"sort2"]
                                                         timeout:[params[@"cache_time"] doubleValue]]) {
        return @"{success:true}";
    }
    return @"{success:false}";
}

- (id) getCache:(id)data
{
    //    NSDictionary *params = [data JSONValue];
    NSDictionary *params = data;
    NSString * result = [[NSString alloc] initWithData:[[[ECCoreDataSupport sharedInstance] getCachesWithMd5:params[@"md5"]
                                                                                                       sort1:params[@"sort1"]
                                                                                                       sort2:params[@"sort2"]] firstObject]
                                              encoding:NSUTF8StringEncoding];
    return @{@"result":result};
}

- (id)getCaches:(id)data
{
    NSDictionary *params = data;
    NSArray *temp = [[ECCoreDataSupport sharedInstance] getCachesWithMd5:params[@"md5"]
                                                                   sort1:params[@"sort1"]
                                                                   sort2:params[@"sort2"]];
    NSMutableArray *result = [NSMutableArray new];
    [temp enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [result addObject:[[[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding] JSONValue]];
    }];
    
    return [result JSONString];
}

- (void) removeCaches:(id)data
{
    //    NSDictionary *params = [data JSONValue];
    NSDictionary *params = data;
    [[ECCoreDataSupport sharedInstance] removeCacheWithMd5:params[@"md5"]
                                                     sort1:params[@"sort1"]
                                                     sort2:params[@"sort2"]];
}

- (void) makeToast:(NSString *)data
{
    [ECViewUtil toast:data];
}

//call core api , 单通道jsAPI
- (void)callCoreApi:(NSDictionary *)params
{
    [ECJSAPI callDeviceAPI:params[@"method"] params:[params[@"paramString"] JSONValue] callbackId:params[@"callbackId"] action:[params[@"action"] JSONValue]];
}

- (void) ECLog:(NSString *)msg
{
    ECLog(@"web widget js msg : %@",msg);
}
- (id) pullQueue:(id)params
{
    NSString* sort1 = params[@"sort1"];
    NSString* sort2 = params[@"sort2"];
    NSNumber* count = params[@"count"];
    id result = [ECJsonUtil objectWithJsonString:[ECListDataSupport pullQueue:sort1 sort2:sort2 count:[count integerValue]]];
    
    return result;
}
/*-------供oc调用js的接口------------*/
- (void) sendMsgtoWebView:(NSString *)msg
{
    [_javascriptBridge callHandler:@"sendMsgtoWebView" data:msg responseCallback:nil];
}
//同步调用webView javaScript 函数，返回结果为 NSString
- (NSString *) callJSMethod:(NSString *)methodName params:(id)params
{
    NSString* paramString = [NSString stringWithFormat:@"%@",params];
    //    if (params && params.count) {
    //        for (int i = 0; i < params.count; i ++) {
    //            paramString = [NSString stringWithFormat:@"%@,%@",paramString,params[i]];
    //        }
    //        paramString = [paramString substringFromIndex:1];
    //    }
    
    NSString* jsString = [NSString stringWithFormat:@"%@(\"%@\");",methodName,[paramString transfer]];
    
    return [self.webView stringByEvaluatingJavaScriptFromString:jsString];
}
- (id)callFun:(NSString *)funName param:(id)param
{
    NSString *jsString = [NSString stringWithFormat:@"%@(%@);",funName,[param isKindOfClass:[NSString class]] ? param : [param JSONString]];
    return [self.webView stringByEvaluatingJavaScriptFromString:jsString];
}
- (void) setdata{
    [super setdata];
    _dataString = [ECJsonUtil stringWithDic:self.dataDic];
    if (_htmlFile) {
        NSString *htmlFilePath = [NSString stringWithFormat:@"%@/webview/views/%@",[self getResourcePath],_htmlFile];
        _webTemplate = [NSString stringWithContentsOfFile:htmlFilePath encoding:NSUTF8StringEncoding error:nil];
    }
    
    NSMutableDictionary* paramsDic = [NSMutableDictionary new];
    NSString* jsScriptString = [self getJSString:_webTemplate];
    _webTemplate = [_webTemplate stringByReplacingOccurrencesOfString:jsScriptString withString:@""];
    
    [paramsDic setObject:_webTemplate forKey:@"template"];
    [paramsDic setObject:_dataString forKey:@"data"];
    NSString* paramsString = [NSString stringWithFormat:@"var params = %@;",[ECJsonUtil stringWithDic:paramsDic]];
    NSString* jsString = [NSString stringWithFormat:@"%@new AppController().getWebHtml(params);",paramsString];
    _htmlDataString = [[ECJSUtil shareInstance] runJS:jsString];
    _htmlDataString = [_htmlDataString stringByAppendingString:jsScriptString];
    
    NSString* indexHtmlPath   = [NSString stringWithFormat:@"%@/webview/layout_ios.html",[self getResourcePath]];
    NSString* indexHtmlString = [NSString stringWithContentsOfFile:indexHtmlPath encoding:NSUTF8StringEncoding error:nil];
    
    indexHtmlString = _htmlDataString ? [indexHtmlString stringByReplacingOccurrencesOfString:@"#{html body}" withString:_htmlDataString] : nil;
    indexHtmlString = [indexHtmlString stringByReplacingOccurrencesOfString:@"{baseurl}" withString:[NSString stringWithFormat:@"file://%@",[self getConfigFilePath:nil]]];
    indexHtmlString = [indexHtmlString stringByReplacingOccurrencesOfString:@"{rand}" withString:[NSString randomString]];
    indexHtmlString = [indexHtmlString stringByReplacingOccurrencesOfString:@"{parentid}" withString:_webView.id];
    indexHtmlString = [indexHtmlString stringByReplacingOccurrencesOfString:@"\"{debug}\"" withString:EC_DEBUG_ON ? @"true" : @"false"];
    
    
    ECLog(@"_htmlDataString = %@",indexHtmlString);
    //    ECLog(@"api.js \n%@",[NSString stringWithContentsOfURL:[NSURL URLWithString:[[NSString stringWithFormat:@"file://%@",[self getConfigFilePath:nil]] stringByAppendingString:@"/webview/api.js"]] encoding:NSUTF8StringEncoding error:nil]);
    [_webView loadHTMLString:indexHtmlString baseURL:[NSURL URLWithString:[NSString appDoucmentsPath]]];
}
#pragma mark-
//获取script
- (NSString *) getJSString:(NSString *)htmlDataString
{
    NSString* regexString = @"<script[^>]*>[\\s\\S]*(?=<\\/script>)<\\/script>";
    //    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:nil];
    //
    //    NSArray* matchArray = nil;
    //    matchArray = [regex matchesInString:htmlDataString options:NSMatchingReportProgress range:NSMakeRange(0, htmlDataString.length)];
    //
    //    if (matchArray.count != 1) {
    //        ECLog(@"formatHtmlDataString error ...");
    //    }
    //
    //    NSString* tempString;
    //    for (NSTextCheckingResult* result in matchArray) {
    //        tempString = [htmlDataString substringWithRange:result.range];
    //    }
    
    // [NSString substringWithRegex:regex] 方法只返回第一个匹配到的对像
    NSString *tempString = [htmlDataString substringWithRegex:regexString];
    return tempString;
}

- (NSString *) getResourcePath
{
    return [NSString appStaticResourcePath];
}
#pragma  mark-  UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self sizeToFit];
    //ECLog(@"webViewDidFinishLoad : %@",_webView);
    //    [self callJSMethod:@"callCoreApi" params:@"{\"params\":\"params_callcoreapi\"}"];
}

# pragma - mark 设置frame
- (CGSize)sizeThatFits:(CGSize)size{
    if (self.insertType<=0)
        self.insertType = 2;
    float w = 0;
    float h = 0;
    // fit content
    // check fit father
    switch (self.insertType) {
        case 1: // (fillparent,fillparent) self.frame = parent.frame
            w = [self superview].frame.size.width;
            h = [self superview].frame.size.height;
            break;
        case 2: // (fillparent,wrapcontent) self.width = parent.width self.height = self.contentSize.height
            w = [self superview].frame.size.width;
            h = [[_webView stringByEvaluatingJavaScriptFromString:@"document.height"] floatValue];
            [_webView.scrollView setScrollEnabled:NO];
            break;
        case 3: // (wrapcontent,fillparent) self.width = parent.width self.height = parent.frame.size.height
            w = self.frame.size.width;
            h = [self superview].frame.size.height;
            break;
        case 4: // (wrapcontent,wrapcontent)
            w = self.frame.size.width;
            h = [[_webView stringByEvaluatingJavaScriptFromString:@"document.height"] floatValue];
            [_webView.scrollView setScrollEnabled:NO];
            break;
        default:
            break;
    }
    [_webView.scrollView setFrame:CGRectMake(0, 0, w, h)];
    [_webView setFrame:CGRectMake(0, 0, w, h)];
    //ECLog(@"w = %f , h = %f",w,h);
    return CGSizeMake(w, h);
}

#pragma  mark getter & setter
-(void)setWebTemplateS:(NSString *)webTemplate{
    _webTemplate = webTemplate;
}
- (void) setHtmlFileS:(NSString *)htmlFile
{
    _htmlFile = htmlFile;
}
#pragma mark- widget life circle event
- (void) onPageResume:(id)param
{
    [self callJSMethod:@"onPageResume" params:param];
}
@end

@implementation ECWebView

- (NSString *) callbackWithId:(NSString *)callbackId argument:(id)arg
{
    NSString *jsString ;
    if ([arg isKindOfClass:[NSString class]]) {
        jsString = [NSString stringWithFormat:@"_response_callbacks['%@']('%@');",callbackId,arg];
    }else{
        jsString = [NSString stringWithFormat:@"_response_callbacks['%@'](%@);",callbackId,[arg JSONString]];
    }
    return [self stringByEvaluatingJavaScriptFromString:jsString];
}
@end
