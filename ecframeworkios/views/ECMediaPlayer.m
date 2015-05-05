//
//  ECMediaPlayer.m
//  ECDemoFrameWork
//
//  Created by cheng on 13-12-19.
//  Copyright (c) 2013年 EC. All rights reserved.
//

#import "ECMediaPlayer.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ECAppUtil.h"

@interface ECMediaPlayer ()

@property (strong, nonatomic) MPMoviePlayerViewController* playerController;
@property (strong, nonatomic) NSURL* url;

@property (nonatomic, copy) ECMediaPlayerPlayFinishedBlock finishedBlock;
@end

@implementation ECMediaPlayer

+ (id) shareInstance
{
    static ECMediaPlayer* instance = nil;
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ECMediaPlayer alloc] init];
    });
    return instance;
}

+ (void) playWithURL:(id)url
{
    [self playWIthURL:url finishedBlock:^{
        ;
    }];
}
- (void) playWithURL:(id)url
{
    [self playWIthURL:url finishedBlock:^{
        ;
    }];
}

+ (void) playWIthURL:(id)url finishedBlock:(ECMediaPlayerPlayFinishedBlock)finishedBlock
{
    [[self shareInstance] playWIthURL:url finishedBlock:finishedBlock];
}
- (void) playWIthURL:(id)url finishedBlock:(ECMediaPlayerPlayFinishedBlock)finishedBlock
{
    id urlPath;
    if ([url isKindOfClass:[NSString class]]) {
        urlPath = [[NSURL alloc] initWithString:url];
    }else if ([url isKindOfClass:[NSURL class]]){
        urlPath = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",url]];
    }
    
    if (!urlPath || ![urlPath isKindOfClass:[NSURL class]]) {
        NSLog(@"URL : %@ is not aviliable ...",url);
        return;
    }
    //TODO: 检测是否正在播放
    self.url = urlPath;
    self.finishedBlock = finishedBlock;
    [self play];
}
#pragma mark-
- (void) play
{
    self.playerController = [[MPMoviePlayerViewController alloc] initWithContentURL:self.url];
    self.playerController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    MPMoviePlayerController *player = [self.playerController moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playVideoFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [[[ECAppUtil shareInstance] getNowController] presentModalViewController:self.playerController animated:YES];
    
    [player play];
}
- (void) playVideoFinished:(NSNotification *)theNotification//当点击Done按键或者播放完毕时调用此函数
{
    MPMoviePlayerController *player = [theNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [player stop];
    [self.playerController dismissModalViewControllerAnimated:YES];
    
    self.url = nil;
    
    self.finishedBlock();
}
@end
