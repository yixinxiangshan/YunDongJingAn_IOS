//
//  ECDownloadRequest.h
//  ECDemoFrameWork
//
//  Created by EC on 8/30/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ASIHTTPRequest.h"

@interface ECDownloadRequest : ASIHTTPRequest

@property (nonatomic, retain)  NSString*  md5Hash; // 用于标识符
@property (nonatomic, retain)  NSString*  savePath;
@property (nonatomic, assign)  int  priorityLevel;

+(ECDownloadRequest*)newInstance:(NSString*)netUrl;

-(void) postDownloadRequest:(NSString*) name
                   delegate:(id) dDelegate
              startSelector:(SEL) startSelector
            processSelector:(SEL) processSelector
           finishedSelector:(SEL) finishedSelector
               failSelecotr:(SEL) failSelecotr
                   fileName:(NSString*)fileName;

-(void) postDownloadRequest:(NSString*) name
                   delegate:(id) dDelegate
              startSelector:(SEL) startSelector
            processSelector:(SEL) processSelector
           finishedSelector:(SEL) finishedSelector 
               failSelecotr:(SEL) failSelecotr
                   savePath:(NSString*) savePath
              priorityLevel:(int) level
                   fileName:(NSString*)fileName;


@end
