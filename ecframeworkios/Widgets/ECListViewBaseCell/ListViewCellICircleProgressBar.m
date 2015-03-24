//
//  ListViewCellICircleProgressBar.m
//  IOSProjectTemplate
//
//  Created by Zongzhan on 10/31/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import "ListViewCellICircleProgressBar.h"
#import "ECViewUtil.h"
#import "PureLayout.h"
#import "ECBaseViewController.h"
#import "ECViewUtil.h"
#import "UIColorExtends.h"

@implementation ListViewCellICircleProgressBar

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
    [ECViewUtil getImageButtonByConfig:self.imageLeftBtn config:data[@"imageLeftBtn"]];
    [ECViewUtil getImageButtonByConfig:self.imageRightBtn config:data[@"imageRightBtn"]];
    [ECViewUtil getImageByConfig:self._bottomDivider config:data[@"_bottomDivider"]];
    [ECViewUtil setText:self.progressBarInnerText data:data[@"progressBarInnerText"]];
    [self.imageLeftBtn setTag:2];
    [self.imageLeftBtn addTarget:self action:@selector(buttonTaped:) forControlEvents:UIControlEventTouchUpInside ];
    [self.imageRightBtn setTag:3];
    [self.imageRightBtn addTarget:self action:@selector(buttonTaped:) forControlEvents:UIControlEventTouchUpInside ];
    //    右上角按钮
    if (data[@"rightText"] != nil && [[NSString stringWithFormat:@"%@", data[@"rightText"]] length] > 0) {
        self.rightText.hidden = NO;
        [ECViewUtil setTextButtonWithConfig:self.rightText
                                       data:@{@"backgroundColor": @"#ffffff" , @"hlBackgroundColor": @"#6Ba0ff", @"borderColor": @"#6Ba0ff" , @"titleColor": @"#6Ba0ff" , @"hlTitleColor": @"#000000" , @"cornerRadius": @"13" }];

        if (data[@"rightText_notice_show"] != nil && [data[@"rightText_notice_show"] intValue] != 0){
            [ECViewUtil getImageByConfig:self.rightText_notice config:data[@"rightText_notice"]];
            self.rightText_notice.hidden = NO;
        }else{
            self.rightText_notice.hidden = YES;
        }
        [self.rightText setTitle:data[@"rightText"] forState:UIControlStateNormal];
        [self.rightText setTag:1];
        [self.rightText addTarget:self action:@selector(buttonTaped:) forControlEvents:UIControlEventTouchUpInside ];
        [self.rightText addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown ];
    }else{
        self.rightText.hidden = YES;
        self.rightText_notice.hidden = YES;
    }
    //  添加并设置processbar
    [ECViewUtil setText:self.progressBarTitleText data:[NSString stringWithFormat:@"%@", data[@"progressBarInnerNum"]]];
    self.progressBar = [[EFCircularSlider alloc] init];
    self.progressBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.progressBar.currentValue = [[NSString stringWithFormat:@"%@",data[@"progressBarInnerNum"]] floatValue];
    self.progressBar.lineWidth = 2;
    self.progressBar.unfilledColor = [UIColor colorWithRed:141.0/255 green:141.0/255 blue:141.0/255 alpha:1.0];
    self.progressBar.filledColor = [UIColor colorWithRed:143.0/255 green:219.0/255 blue:31.0/255 alpha:1.0];
    self.progressBar.handleType = CircularSliderHandleTypeDoubleCircleWithOpenCenter;
    self.progressBar.handleColor = [UIColor colorWithRed:237.0/255 green:237.0/255 blue:237.0/255 alpha:1.0];
    self.progressBar.frame = CGRectMake(270.0f, 20.0f, 200/2+20, 200/2+20);
    [self addSubview:self.progressBar];
    //  设置autolayout
    [self.progressBar autoCenterInSuperview];
}



+ (CGFloat)heightForData:(NSDictionary *)data
{
    //    使用xib的时候尽量用 autolayout
    return 130;
}
-(void)buttonDown:(id)sender{
    // UIButton *button = (UIButton*) sender;
    // NSLog(@"11");
}
// 右边按钮被点击
-(void)buttonTaped:(id)sender
{
    NSString *actionType = @"";
    UIButton *button = (UIButton*) sender;
    switch (button.tag) {
        case 1:
            actionType = @"rightText";
            break;
        case 2:
            actionType = @"leftBtn";
            break;
        case 3:
            actionType = @"rightBtn";
            break;
        default:
            break;
    }
    // NSLog(@"22");
    // button.highlighted = YES;
    // [button setBackgroundColor:[UIColor colorWithHexString:@"000000"]];
    [self.parent.pageContext dispatchJSEvetn:[NSString stringWithFormat:@"%@.%@",self.parent.controlId,@"onItemInnerClick"]
                                  withParams:@{@"position":[NSNumber numberWithInteger:self.position],@"target":actionType}];
    
}

@end
