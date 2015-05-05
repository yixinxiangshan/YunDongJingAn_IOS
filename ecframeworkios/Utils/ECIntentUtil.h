//
//  ECIntentUtil.h
//  ECDemoFrameWork
//
//  Created by EC on 9/3/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECIntentUtil : NSObject

+ (void) makeCall:(NSString*)phoneNum;
+ (void) openWebBrowser:(NSString *)url;
+ (void) sendEmail:(NSString *)mailAddr title:(NSString*)title msg:(NSString*)msg;
+ (void) share:(NSString*)string;
+ (void) openVideo:(NSString*)url;

@end
