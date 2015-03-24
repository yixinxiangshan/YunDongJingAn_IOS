//
//  ListViewCellInputTextWithButton.h
//  IOSProjectTemplate
//
//  Created by ecloud_mbp on 15/2/4.
//  Copyright (c) 2015年 ECloud. All rights reserved.
//

#import "ECListViewBaseCell.h"
#import "ECListViewBase.h"
#import "GCPlaceholderTextView.h"

@interface ListViewCellInputTextWithButton : ECListViewBaseCell<ECListViewCellProtocol , UITextViewDelegate>
//editText
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *editText;
@property (weak, nonatomic) IBOutlet UIButton *button;
@end