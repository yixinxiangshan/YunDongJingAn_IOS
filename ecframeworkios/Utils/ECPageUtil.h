//
//  ECPageUtil.h
//  ECDemoFrameWork
//
//  Created by EC on 9/2/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECBaseViewController.h"

#define PAGE_DATA_KEY @"pageData"

@interface ECPageUtil : NSObject

+(NSString*) loadConfigString:(NSString*) pageName;
/**
 * 打开一个新的页面
 */
+(void) openNewPage:(NSString*)pageName params:(NSString*)paramString;
+(void) openNewPageWithFinished:(NSString*)pageName params:(NSString*)paramString;
+(void) openNewPageWithFinishedOthers:(NSString*)pageName params:(NSString*)paramString;

+(void)closeNowPage:(NSString*)successJs;

+(ECBaseViewController*)initPage:(NSString*)pageName params:(NSString*)paramString;

+(ECBaseViewController*)initPage:(NSString*)pageName params:(NSString*)paramString parentView:(UIView*)parentView;

+(NSString*) getPageNibName:(NSString*) pageConfigString;

+(void) initPage:(ECBaseViewController*) pageContext pageConfigString:(NSString*)pageConfigString;

+(void) savePageParams:(NSString*) paramsString pageContext:(ECBaseViewController*)pageContext;

+ (void) initWidgets:(NSDictionary*) pageDic pageContext:(ECBaseViewController*) pageContext;

+ (void) getPageData:(NSDictionary*) pageDic pageContext:(ECBaseViewController*) pageContext;

+ (void)putPageString:(NSString*)pageString pageContext:(ECBaseViewController*) pageContext;

+ (void) putPageParams:(NSString*)paramsString;

+ (void) putPageParam:(NSString*)keyString param:(NSString *)param;

//editor by cww
+ (NSString *) getPageParam:(NSString*)key;

@end
