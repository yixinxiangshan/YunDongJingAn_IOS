//
//  ECItemClickDelegate.m
//  ECDemoFrameWork
//
//  Created by EC on 9/16/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECItemClickDelegate.h"
#import "Constants.h"

@implementation ECItemClickDelegate
-(id)initWithEventConfig:(NSDictionary*)eventConfigDic pageContext:(ECBaseViewController*) pageContext widget:(ECBaseWidget*)widget{
    self = [super initWithEventConfig:eventConfigDic pageContext:pageContext widget:widget];
    return self;
}

#pragma ItemClickDelegate
- (void)onItemClick:(NSString *)itemID
{
    ECLog(@"item clickin delegate...");
    NSDictionary* tempEventConfigDic = [self matchPosition:@"[position]" value:[NSString stringWithFormat:@"[%@]",itemID]];
    [self runJsD:tempEventConfigDic];
}
@end
