//
//  ECMediaPlayer.h
//  ECDemoFrameWork
//
//  Created by cheng on 13-12-19.
//  Copyright (c) 2013年 EC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ECMediaPlayerPlayFinishedBlock)();
@interface ECMediaPlayer : NSObject

+ (id) shareInstance;
/**
 *  playWithURL
 *  url : NSString or NSURL
 */
+ (void) playWIthURL:(id)url finishedBlock:(ECMediaPlayerPlayFinishedBlock)finishedBlock;
+ (void) playWithURL:(id)url;
- (void) playWIthURL:(id)url finishedBlock:(ECMediaPlayerPlayFinishedBlock)finishedBlock;
- (void) playWithURL:(id)url;
@end
