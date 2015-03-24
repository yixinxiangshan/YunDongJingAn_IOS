//
//  ListViewCellInputTextWithButton.m
//  IOSProjectTemplate
//
//  Created by ecloud_mbp on 15/2/4.
//  Copyright (c) 2015年 ECloud. All rights reserved.
//

#import "ListViewCellSetting.h"
#import "Constants.h"
#import "ECViewUtil.h"
#import "ECBaseViewController.h"
#import "UIColorExtends.h"

@implementation ListViewCellSetting
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
    // NSLog(@"listviewcellline centerTitle awakeFromNib");
}

- (void)setData:(NSDictionary *)data {
    [ECViewUtil setText:self.title data:data[@"name"]];
    [ECViewUtil setText:self.description1 data:data[@"description"]];
    [self.description1 setTextColor: [UIColor colorWithHexString:@"AAAAAA"]];
    if (data[@"isOpen"] != nil && [data[@"isOpen"] intValue] != 0){
        [self.switchButton setOn:YES];
    }else{
         [self.switchButton setOn:NO];
    }
   
    [self.switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
}

-(void)switchAction:(id)sender{
    NSString *actionType = @"switchBtn";
    NSString *isChecked = @"";
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        isChecked =@"true";
//        showSwitchValue.text = @"是";
        NSLog(@"是");
    }else {
        isChecked =@"false";
         NSLog(@"否");
//        showSwitchValue.text = @"否";
        
    }
    [self.parent.pageContext dispatchJSEvetn:[NSString stringWithFormat:@"%@.%@",self.parent.controlId,@"onItemInnerClick"]
                                  withParams:@{@"position":[NSNumber numberWithInteger:self.position],@"target":actionType ,@"isChecked":isChecked,@"_form":[self.parent getFormData]}];
}

+ (CGFloat)heightForData:(NSDictionary *)data {
    return 60;
}



@end
