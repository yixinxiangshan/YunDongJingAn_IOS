//
//  ECVoteView.h
//  ECDemoFrameWork
//
//  Created by cheng on 14-1-8.
//  Copyright (c) 2014年 EC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ECFormWidgetVoteDoneBlock)(NSInteger vote);

@interface ECFormWidgetCellVote : UIView

- (UIView *) initWithVoteDoneBlock:(ECFormWidgetVoteDoneBlock)voteDoneBlock;


@end
