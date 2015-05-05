//
//  ECGroupItemDelegate.m
//  ECDemoFrameWork
//
//  Created by EC on 10/25/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECGroupItemClickDelegate.h"

@implementation ECGroupItemClickDelegate

-(id)initWithEventConfig:(NSDictionary*)eventConfigDic pageContext:(ECBaseViewController*) pageContext widget:(ECBaseWidget*)widget{
    return [super initWithEventConfig:eventConfigDic pageContext:pageContext widget:widget];
}

-(void)onClick:(NSString*)groupId position:(NSString*)position{
    NSDictionary* tempEventConfigDic = [self matchPosition:@"[groupId]" value:[NSString stringWithFormat:@"[%@]",groupId]];
    tempEventConfigDic = [self matchPosition:@"[position]" value:[NSString stringWithFormat:@"[%@]",position] eventConfigDic:tempEventConfigDic];
    [self runJsD:tempEventConfigDic];
}

@end
