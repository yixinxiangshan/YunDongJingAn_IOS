//
//  ECLinearLayout.h
//  IOSProjectTemplate
//
//  Created by 程巍巍 on 4/16/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import "ECBaseLayout.h"

typedef NS_ENUM(char, DQLinearLayoutOrientation) {
    DQLinearLayoutOrientationVertical   = 'v',
    DQLinearLayoutOrientationHorizontal = 'h'
};

@interface ECLinearLayout : ECBaseLayout

@property (nonatomic, readonly) DQLinearLayoutOrientation orientation;
@end

//#import <UIKit/UIKit.h>
//#import "ECBaseView.h"
//
//@interface ECLinearLayout : ECBaseView
//
///**
// *  方向 vertical horizontal
// *  h or v
// *  
// */
//@property (nonatomic, readonly) char orientation;
//
//@end
