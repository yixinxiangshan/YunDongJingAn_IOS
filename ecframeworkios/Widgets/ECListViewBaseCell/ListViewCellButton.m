//
//  ListViewCellButton.m
//  IOSProjectTemplate
//
//  Created by Zongzhan on 11/4/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import "ListViewCellButton.h"
#import "PureLayout.h"
#import "ECBaseViewController.h"
#import "UIColorExtends.h"
#import "ECViewUtil.h"

@implementation ListViewCellButton


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];
    }
    
    return self;
}

- (void)awakeFromNib
{
    
}

- (void)setData:(NSDictionary *)data
{
    [super setData:data];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.button setTitle:data[@"btnTitle"] forState:UIControlStateNormal];
    if ([self.data[@"btnType"] isEqualToString:@"ok"]) {
        // [self.button.layer setMasksToBounds:YES];
        // [self.button.layer setCornerRadius:5.0];
        // [self.button.layer setBorderWidth:1.0];
        // [self.button.layer setBorderColor:[UIColor colorWithHexString:@"#6Ba0ff"].CGColor];
        // [self.button setBackgroundColor:[UIColor colorWithHexString:@"#6Ba0ff"]];
        // [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [ECViewUtil setTextButtonWithConfig:self.button
                                       data:@{@"backgroundColor": @"#6Ba0ff" , @"hlBackgroundColor": @"#6Ba0ff", @"borderColor": @"#6Ba0ff" , @"titleColor": @"#ffffff" , @"hlTitleColor": @"#000000" , @"cornerRadius": @"5" }];

    }
    if ([self.data[@"btnType"] isEqualToString:@"disable"]) {
        [self.button.layer setMasksToBounds:YES];
        [self.button.layer setCornerRadius:5.0];
        [self.button.layer setBorderWidth:1.0];
        [self.button.layer setBorderColor:[UIColor colorWithRed:212.0/255 green:212.0/255 blue:212.0/255 alpha:1.0].CGColor];
        [self.button setEnabled:NO];
    }
    if ([self.data[@"btnType"] isEqualToString:@"cancel"]) {
        [self.button.layer setMasksToBounds:YES];
        [self.button.layer setCornerRadius:5.0];
        [self.button.layer setBorderWidth:1.0];
        [self.button.layer setBorderColor:[UIColor colorWithHexString:@"#6Ba0ff"].CGColor];
        // [self.button.layer setBorderColor:[UIColor colorWithRed:107.0/255 green:160.0/255 blue:255.0/255 alpha:1.0].CGColor];
    }
    if (![self.data[@"btnType"] isEqualToString:@"disable"]) {
        [self.button setTag:1];
        [self.button addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchDown];
        [self.button addTarget:self action:@selector(buttonTaped:) forControlEvents:UIControlEventTouchUpInside ];
    }
    
}

+ (CGFloat)heightForData:(NSDictionary *)data
{
    //    使用xib的时候尽量用 autolayout
    return 55;
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
    
}

//分割线  默认 不要分割线。
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
