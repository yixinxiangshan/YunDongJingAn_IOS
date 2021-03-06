//
//  ListViewCellInputText.m
//  IOSProjectTemplate
//
//  Created by Zongzhan on 1/15/15.
//  Copyright (c) 2015 ECloud. All rights reserved.
//

#import "ListViewCellInputText.h"
#import "UIColorExtends.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>

@implementation ListViewCellInputText

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
    self.editText.layer.borderColor = [[UIColor colorWithHexString:@"#D3D3D3"] CGColor];
    self.editText.layer.borderWidth = 1.0;
    self.editText.layer.cornerRadius = 5.0;
    self.editText.placeholderColor = [UIColor colorWithHexString:@"#cccccc"];
    self.editText.placeholder = NSLocalizedString(data[@"hint"], );
    
    if ([data[@"inputType"] isEqual:@"number"])
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

- (void)textViewDidChangeSelection:(GCPlaceholderTextView *)textView {
    [self.parent setFormInput:self.data[@"name"] NSString:textView.text];
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.editText.layer.borderColor = [[UIColor colorWithHexString:@"#5793ff"] CGColor];
}

- (void)textViewEndEditing:(GCPlaceholderTextView *)textView{
    self.editText.layer.borderColor = [[UIColor colorWithHexString:@"#D3D3D3"] CGColor];
}

+ (CGFloat)heightForData:(NSDictionary *)data {
    return 0;
}

//分割线  默认不要分割线。
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