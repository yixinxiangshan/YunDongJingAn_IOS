//
//  ECTextViewPlaceHolder.h
//  IOSProjectTemplate
//
//  Created by Zongzhan on 9/12/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ECTextViewPlaceHolder : UITextView
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;
@end
