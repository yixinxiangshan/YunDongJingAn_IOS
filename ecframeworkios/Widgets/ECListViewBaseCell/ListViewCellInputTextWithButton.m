//
//  ListViewCellInputTextWithButton.m
//  IOSProjectTemplate
//
//  Created by ecloud_mbp on 15/2/4.
//  Copyright (c) 2015年 ECloud. All rights reserved.
//

#import "ListViewCellInputTextWithButton.h"
#import "UIColorExtends.h"
#import "Constants.h"
#import "ECBaseViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ListViewCellInputTextWithButton()
@property (nonatomic) int countDown;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSString *title;
@end

@implementation ListViewCellInputTextWithButton

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class)
                                      owner:self
                                    options:nil];
    }
    // NSLog(@"listviewcellline centerTitle initWithStyle");
    return self;
}

- (void)awakeFromNib {
    //ECLog(@"ListViewCellInputTextWithButton centerTitle awakeFromNib");
}

- (void)setData:(NSDictionary *)data {
    [ECViewUtil setTextButtonWithConfig:self.button
                                   data:@{@"backgroundColor": @"#6Ba0ff" , @"hlBackgroundColor": @"#6Ba0ff", @"borderColor": @"#6Ba0ff" , @"titleColor": @"#ffffff" , @"hlTitleColor": @"#000000" , @"cornerRadius": @"5" }];
    self.title = data[@"btnName"];
    [self.button setTitle:data[@"btnName"] forState:UIControlStateNormal];
    [self.button setTag:1];
    [self.button addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchDown];
    [self.button addTarget:self action:@selector(buttonTaped:) forControlEvents:UIControlEventTouchUpInside ];
    self.editText.layer.borderColor = [[UIColor colorWithHexString:@"#D3D3D3"] CGColor];
    self.editText.layer.borderWidth = 1.0;
    self.editText.layer.cornerRadius = 5.0;
    self.editText.placeholderColor = [UIColor colorWithHexString:@"#cccccc"];
    self.editText.placeholder = NSLocalizedString(data[@"hint"], );
    
    if ([data[@"inputType"] isEqual:@"number"]||[data[@"inputType"] isEqual:@"phone"])
        self.editText.keyboardType = UIKeyboardTypeNumberPad;
    if ([data[@"inputText"] length] > 0) {
        self.editText.text = data[@"inputText"];
        [self.parent setFormInput:data[@"name"] NSString:self.editText.text];
    }
    // 表单值记录
    //    [self.editText addTarget:self
    //                      action:@selector(textFieldDidChange:)
    //            forControlEvents:UIControlEventEditingChanged];
    self.editText.delegate = self;
    // self.parent
    [super setData:data];
}

-(void)buttonTouch:(id)sender{
    //    UIButton *button = (UIButton*) sender;
    //    [button setBackgroundColor:[UIColor colorWithHexString:@"#CCCCCC"]];
}

// 按钮被点击
-(void)buttonTaped:(id)sender
{
    NSString *actionType = @"";
    UIButton *button = (UIButton*) sender;
    switch (button.tag) {
        case 1:
            actionType = @"button";
            break;
        default:
            actionType = @"button";
            break;
    }
    [self.parent.pageContext dispatchJSEvetn:[NSString stringWithFormat:@"%@.%@",self.parent.controlId,@"onItemInnerClick"]
                                  withParams:@{@"position":[NSNumber numberWithInteger:self.position],@"target":actionType ,@"_form":[self.parent getFormData]}];
    
    if(self.editText.text.length == 11) {
        self.countDown = 10;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimeLeft) userInfo:nil repeats:YES];
    }
    
}

- (void)updateTimeLeft {
    
    ECLog(@"%i", self.countDown);
    if (self.countDown == 0) {
        self.button.enabled = YES;
        [self.button setTitle:self.title forState:UIControlStateNormal];
        [self.timer invalidate];
        self.timer = nil;
    }
    else{
        self.countDown--;
        self.button.enabled = NO;
        self.button.alpha = 1.0f;
        [self.button setTitle:[NSString stringWithFormat:@"%d秒",self.countDown] forState:UIControlStateNormal];
    }
}

- (void)textViewDidChangeSelection:(GCPlaceholderTextView *)textView {
    [self.parent setFormInput:self.data[@"name"] NSString:textView.text];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.editText.layer.borderColor = [[UIColor colorWithHexString:@"#5793ff"] CGColor];
}

-(void)textViewEndEditing:(GCPlaceholderTextView *)textView{
    self.editText.layer.borderColor = [[UIColor colorWithHexString:@"#D3D3D3"] CGColor];
}
+ (CGFloat)heightForData:(NSDictionary *)data {
    return 60;
}

//分割线
- (void)drawRect:(CGRect)rect
{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
//    CGContextFillRect(context, rect);
//    //        下分割线
//    //    下分割线
//    CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:@"#CACACA"].CGColor);
//CGContextFillRect(context, CGRectMake(0, rect.size.height-1, rect.size.width, 1));
}

@end
