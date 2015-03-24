//
//  ListViewCellInputText.h
//  IOSProjectTemplate
//
//  Created by Zongzhan on 1/15/15.
//  Copyright (c) 2015 ECloud. All rights reserved.
//

#import "ECListViewBaseCell.h"
#import "ECListViewBase.h"
#import "GCPlaceholderTextView.h"

@interface ListViewCellInputText : ECListViewBaseCell<ECListViewCellProtocol , UITextViewDelegate>
//editText
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *editText;

@end
