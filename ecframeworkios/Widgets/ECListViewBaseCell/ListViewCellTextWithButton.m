//
//  ListViewCellTextWithButton.m
//  IOSProjectTemplate
//
//  Created by Zongzhan on 1/21/15.
//  Copyright (c) 2015 ECloud. All rights reserved.
//

#import "ListViewCellTextWithButton.h"
#import "ECBaseViewController.h"
#import "ECViewUtil.h"
#import "UIColorExtends.h"
#import "PureLayout.h"

@implementation ListViewCellTextWithButton


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];
    }
    // NSLog(@"listviewcellline centerTitle initWithStyle");
    return self;
}

- (void)awakeFromNib
{
    // NSLog(@"listviewcellline centerTitle awakeFromNib");
    
}

- (void)setData:(NSDictionary *)data
{
    // NSLog(@"setData : %@",data);
    if (data[@"btnTitle"] != nil && [[NSString stringWithFormat:@"%@", data[@"btnTitle"]] length] > 0) {
        [ECViewUtil setTextButtonWithConfig:self.button
                                       data:@{@"backgroundColor": @"#ffffff" , @"hlBackgroundColor": @"#6Ba0ff", @"borderColor": @"#ffffff" , @"titleColor": @"#999999" , @"hlTitleColor": @"#000000" , @"cornerRadius": @"8" }];
        [self.button setTitle:data[@"btnTitle"] forState:UIControlStateNormal];
         [self.button setTag:1];
         [self.button addTarget:self action:@selector(buttonTaped:) forControlEvents:UIControlEventTouchUpInside ];
        self.button.hidden = NO;
    }else{
        self.button.hidden = YES;
    }
    if (data[@"btn1Title"] != nil && [[NSString stringWithFormat:@"%@", data[@"btn1Title"]] length] > 0) {
        [ECViewUtil setTextButtonWithConfig:self.button1
                                       data:@{@"backgroundColor": @"#6Ba0ff" , @"hlBackgroundColor": @"#ffffff", @"borderColor": @"#6Ba0ff" , @"titleColor": @"#ffffff" , @"hlTitleColor": @"#6Ba0ff" , @"cornerRadius": @"8" }];
        [self.button1 setTitle:data[@"btn1Title"] forState:UIControlStateNormal];
        [self.button1 setTag:2];
        [self.button1 addTarget:self action:@selector(buttonTaped:) forControlEvents:UIControlEventTouchUpInside ];
        [self.button1 autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:5];
        [self.button autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.button1 withOffset:-5];
        self.button1.hidden = NO;
    }else{
        [self.button autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:5];
        self.button1.hidden = YES;
    }
    
    // 标题
    if (data[@"title"] != nil && [[NSString stringWithFormat:@"%@", data[@"title"]] length] > 0) {
        [self.title setText:data[@"title"]];
    }
    
    // 背景
    if (data[@"_backgroundColor"] != nil && [data[@"_backgroundColor"][@"normal"] length]> 0) {
        UIView *backgrdView = [[UIView alloc] initWithFrame:self.frame];
        backgrdView.backgroundColor =[UIColor colorWithHexString:data[@"_backgroundColor"][@"normal"]];
        self.backgroundView = backgrdView;
    }else{
        self.backgroundView = nil;
    }
    
    //    self.editText.placeholderColor = [UIColor colorWithHexString:@"#cccccc"];
    //    self.editText.placeholder = NSLocalizedString(data[@"hint"],);
    //    if ([data[@"inputType"] isEqual:@"number"])
    //        self.editText.keyboardType = UIKeyboardTypeNumberPad;
    //
    //
    //    if ([data[@"inputText"] length] > 0){
    //        self.editText.text = data[@"inputText"];
    //        [self.parent setFormInput:data[@"name"] NSString:self.editText.text];
    //    }
    //    self.editText.delegate = self;
    //    [super setData:data];
}


+ (CGFloat)heightForData:(NSDictionary *)data {
    return 38;
}

// 右边按钮被点击
-(void)buttonTaped:(id)sender
{
    NSString *actionType = @"";
    NSString *viewName = @"";
    UIButton *button = (UIButton*) sender;
    switch (button.tag) {
        case 1:
            actionType = @"title_button";
            viewName = @"button";
            break;
        case 2:
            actionType = @"title_button1";
            viewName = @"button1";
            break;
        default:
            break;
    }
    [self.parent.pageContext dispatchJSEvetn:[NSString stringWithFormat:@"%@.%@",self.parent.controlId,@"onItemInnerClick"]
                                  withParams:@{@"position":[NSNumber numberWithInteger:self.position],@"target":actionType,@"viewName":viewName}];
}

@end
