//
//  ECDownloadRequest.m
//  ECDemoFrameWork
//
//  Created by EC on 8/30/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECDownloadRequest.h"
#import "NSStringExtends.h"
#import "ECNetManager.h"
#import "ECViewUtil.h"

@interface ECDownloadRequest () <ASIHTTPRequestDelegate,ASIProgressDelegate>
@property (nonatomic, retain)  NSString*  name;
@end

@implementation ECDownloadRequest
@synthesize  name = _name;

+(ECDownloadRequest*)newInstance:(NSString*)netUrl{
    return [[ECDownloadRequest alloc] initWithURL:[NSURL URLWithString:netUrl]];
}
- (id)initWithURL:(NSURL *)newURL
{
	self = [super initWithURL:newURL];
    _md5Hash = [[newURL absoluteString] md5Hash];
    return self;
}
-(void) postDownloadRequest:(NSString*) name
                   delegate:(id) dDelegate
              startSelector:(SEL) startSelector
            processSelector:(SEL) processSelector
           finishedSelector:(SEL) finishedSelector
               failSelecotr:(SEL) failSelecotr
                   fileName:(NSString*)fileName{
    _savePath = [NSString appLibraryPath];
    _priorityLevel = 0;
    [self postDownloadRequest:name delegate:dDelegate startSelector:startSelector processSelector:processSelector finishedSelector:finishedSelector failSelecotr:failSelecotr savePath:_savePath priorityLevel:_priorityLevel fileName:fileName];
}

-(void) postDownloadRequest:(NSString*) name
                   delegate:(id) dDelegate
              startSelector:(SEL) startSelector
            processSelector:(SEL) processSelector
           finishedSelector:(SEL) finishedSelector
               failSelecotr:(SEL) failSelecotr
                   savePath:(NSString*) savePath 
              priorityLevel:(int) level
                   fileName:(NSString*)fileName{
    _savePath = (nil == savePath) ? [NSString appLibraryPath] : savePath;
    _priorityLevel = (level<0) ? 0 : level;
    _name = name;
    if(startSelector)
        [[NSNotificationCenter defaultCenter] addObserver:dDelegate selector:startSelector name:[NSString stringWithFormat:@"%@.start",name] object:nil];
    if(processSelector)
        [[NSNotificationCenter defaultCenter] addObserver:dDelegate selector:processSelector name:[NSString stringWithFormat:@"%@.process",name] object:nil];
    if(finishedSelector)
        [[NSNotificationCenter defaultCenter] addObserver:dDelegate selector:finishedSelector name:[NSString stringWithFormat:@"%@.finished",name] object:nil];
    if(failSelecotr)
        [[NSNotificationCenter defaultCenter] addObserver:dDelegate selector:failSelecotr name:[NSString stringWithFormat:@"%@.failed",name] object:nil];

    NSString* tempPath = [NSString stringWithFormat:@"%@/.tmp", [NSString appTmpPath]];
    _savePath = [NSString stringWithFormat:@"%@/%@",_savePath,(fileName==nil) ? _md5Hash : fileName];
    [self setDownloadDestinationPath:_savePath];//下载路径
    [self setTemporaryFileDownloadPath:tempPath];
    [self setAllowResumeForFileDownloads:YES];//断点续传
    
    self.delegate = self;
    self.downloadProgressDelegate = self;
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.savePath]) {
    }
    [self startDownload];
}

-(void)startDownload{
    // NSLog(@"startDownload path : %@",_savePath);
    [[ECNetManager sharedInstances] addOperation:self];
}
#pragma mark = ASIHTTPRequestDelegate
- (void)requestStarted:(ASIHTTPRequest *)request{
    // NSLog(@"requestStarted");
    [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@.start",_name] object:nil userInfo:nil];
    [ECViewUtil showLoadingDialog:Nil loadingMessage:nil cancelAble:NO];
}
- (void)requestFinished:(ASIHTTPRequest *)request{
    [ECViewUtil closeLoadingDialog];
    //TODO: 获取下载好的文件
//    NSString* disposition = [request.responseHeaders objectForKey:@"Content-Disposition"];
//    NSString* regexString = [NSString stringWithFormat:@"\\\"(.*?)\\\""];
//    NSError* err = nil;
//    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:&err];
//    NSArray* matchs = [regex matchesInString:disposition options:0 range:NSMakeRange(0, [disposition length])];
//    if (matchs!= nil && [matchs count]>0) {
//        NSLog(@"filename = %@",matchs);
//    }
    ECLog(@"download data success ! ");
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:_savePath,@"filePath", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@.finished",_name] object:nil userInfo:data];
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    [ECViewUtil closeLoadingDialog];
    [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@.failed",_name] object:nil userInfo:nil];
}
#pragma mark = ASIProgressDelegate
- (void)setProgress:(float)newProgress{
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:newProgress],@"process", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@.process",_name] object:nil userInfo:data];
}

@end
