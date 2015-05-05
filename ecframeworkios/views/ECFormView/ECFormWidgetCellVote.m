//
//  ECVoteView.m
//  ECDemoFrameWork
//
//  Created by cheng on 14-1-8.
//  Copyright (c) 2014年 EC. All rights reserved.
//

#import "ECFormWidgetCellVote.h"
#import "UIImage+Resource.h"

@interface ECFormWidgetCellVote ()
@property (copy, nonatomic) ECFormWidgetVoteDoneBlock voteDoneBlock;
@end

@implementation ECFormWidgetCellVote

- (UIView *) initWithVoteDoneBlock:(ECFormWidgetVoteDoneBlock)voteDoneBlock;
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"ECFormWidgetCellVote" owner:self options:nil] lastObject];
    if (self) {
        self.voteDoneBlock = voteDoneBlock;
        
        for (UIButton* button in self.subviews) {
            if ([button isKindOfClass:[UIButton class]]) {
                [button addTarget:self action:@selector(vote:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    return self;
}

- (void)vote:(UIButton *)sender {
    [self updateVote:sender.tag];
    if (self.voteDoneBlock) {
        self.voteDoneBlock(sender.tag);
    }
}

- (void) updateVote:(NSInteger)vote
{
    for (UIButton* button in [self subviews]) {
        if (button.tag <= vote) {
            [button setImage:[UIImage imageWithPath:@"gen_star_solid.png"] forState:UIControlStateNormal];
        }else{
            [button setImage:[UIImage imageWithPath:@"gen_star_stroke.png"] forState:UIControlStateNormal];
        }
    }
}
@end
