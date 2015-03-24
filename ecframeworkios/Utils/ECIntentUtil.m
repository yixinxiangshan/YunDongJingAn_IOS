//
//  ECIntentUtil.m
//  ECDemoFrameWork
//
//  Created by EC on 9/3/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECIntentUtil.h"
#import <MessageUI/MessageUI.h>
#import "ECAppUtil.h"

@implementation ECIntentUtil

+ (void) makeCall:(NSString*)phoneNum{
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:phoneNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}
+ (void) openWebBrowser:(NSString *)url{
    if (![url hasPrefix:@"http://"]) {
        url = [@"http://" stringByAppendingString:url];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}
+ (void) sendEmail:(NSString *)mailAddr title:(NSString*)title msg:(NSString*)msg{
//    MFMailComposeViewController* mailControler = [[MFMailComposeViewController alloc] init];
//    [mailControler setSubject:title];
//    [mailControler setMessageBody:msg isHTML:NO];
//    if (mailControler) {
//        [[[ECAppUtil shareInstance] nowPageContext] presentModalViewController:mailControler animated:YES];
//    }
}
+ (void) share:(NSString*)string{
    
}

+ (void) openVideo:(NSString*)url{
    
}

@end
