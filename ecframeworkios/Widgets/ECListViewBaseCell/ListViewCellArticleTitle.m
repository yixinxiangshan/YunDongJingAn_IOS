//
//  ListViewCellArticle.m
//  IOSProjectTemplate
//
//  Created by Zongzhan on 11/4/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import "ListViewCellArticleTitle.h"
#import "ECViewUtil.h"
#import "UIColorExtends.h"

@implementation ListViewCellArticleTitle

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
    
    [ECViewUtil setText:self.title data:data[@"headTitle"]];
    [ECViewUtil setText:self.subtitle data:data[@"subheadTitle"]];
    // 背景
    if (data[@"_backgroundColor"] != nil && [data[@"_backgroundColor"][@"normal"] length]> 0) {
        UIView *backgrdView = [[UIView alloc] initWithFrame:self.frame];
        backgrdView.backgroundColor =[UIColor colorWithHexString:data[@"_backgroundColor"][@"normal"]];
        self.backgroundView = backgrdView;
    }else{
        self.backgroundView = nil;
    }

    // 设置行高
    //    if (data[@"content"] != nil && [data[@"content"] length] > 0) {
    //        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //        paragraphStyle.lineHeightMultiple = 30.0f;
    //        paragraphStyle.maximumLineHeight = 30.0f;
    //        paragraphStyle.minimumLineHeight = 30.0f;
    //        NSString *string = self.content.text;
    //        NSDictionary *ats = @{NSFontAttributeName : [UIFont fontWithName:@"Helvetica Neue" size:18.0f],NSParagraphStyleAttributeName : paragraphStyle};
    //        self.content.attributedText = [[NSAttributedString alloc] initWithString:string attributes:ats];
    //    }
    
}

+ (CGFloat)heightForData:(NSDictionary *)data
{
    return  95;
//    if (!([data[@"content"] length] > 0) && !([data[@"imgcover"] length] > 0)) {
//        return 76;
//    }else if([data[@"content"] length] > 0 && data[@"title"] == nil ){
//        // 屏幕
//        CGRect frm =[ UIScreen mainScreen ].applicationFrame;
//        // 计算text高度
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
//        [label setNumberOfLines:0];
//        label.lineBreakMode = NSLineBreakByWordWrapping;
//        UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:18.f];
//        label.font = font;
//        CGSize size = CGSizeMake( frm.size.width - 20 , CGFLOAT_MAX );  //LableWight标签宽度，固定的
//        CGSize labelsize = [data[@"content"] sizeWithFont:font constrainedToSize:size lineBreakMode:label.lineBreakMode];
//        return labelsize.height + 25.f;
//    }else{
//        // 屏幕
//        CGRect frm =[ UIScreen mainScreen ].applicationFrame;
//        // 计算text高度
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
//        [label setNumberOfLines:0];
//        label.lineBreakMode = NSLineBreakByWordWrapping;
//        UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:18.f];
//        label.font = font;
//        CGSize size = CGSizeMake( frm.size.width - 20 , CGFLOAT_MAX );  //LableWight标签宽度，固定的
//        CGSize labelsize = [data[@"content"] sizeWithFont:font constrainedToSize:size lineBreakMode:label.lineBreakMode];
//        
//        return labelsize.height + 270.f;
//    }
}
//分割线
- (void)drawRect:(CGRect)rect
{
    if ((![self.data[@"hasFooterDivider"] isEmpty]) && [self.data[@"hasFooterDivider"] isEqualToString:@"true"]) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
        CGContextFillRect(context, rect);
        //上分割线，
        //        CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:@"#EAEAEA"].CGColor);
        //        CGContextFillRect(context, CGRectMake(0, 0, rect.size.width, 1));
        //    下分割线
        CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:@"#EAEAEA"].CGColor);
        CGContextFillRect(context, CGRectMake(0, rect.size.height-1, rect.size.width, 1));
    }
}
@end
