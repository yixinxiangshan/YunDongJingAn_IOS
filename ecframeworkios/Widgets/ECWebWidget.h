//
//  ECWebWidget.h
//  ECDemoFrameWork
//
//  Created by EC on 11/11/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECBaseWidget.h"
@class ECWebView;
@interface ECWebWidget : ECBaseWidget <UIWebViewDelegate>

@property (strong, nonatomic) ECWebView *webView;

- (id)initWithConfigDic:(NSDictionary*)configDic pageContext:(ECBaseViewController*)pageContext;

- (NSString *) callJSMethod:(NSString *)methodName params:(id)params;
@end

@class ECBaseViewController;
@interface ECWebView : UIWebView

@property (nonatomic, weak) ECBaseViewController *context;
/**
 *  单通道js回调接口
 */
- (NSString *) callbackWithId:(NSString *)callbackId argument:(id)arg;
@end