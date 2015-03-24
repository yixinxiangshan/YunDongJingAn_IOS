//
//  ECBaseLabel.m
//  IOSProjectTemplate
//
//  Created by 程巍巍 on 4/24/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import "ECBaseLabel.h"
#import "UIColorExtends.h"

@implementation ECBaseLabel

- (id)init
{
    self = [super init];
    if (self) {
        self.numberOfLines = 0;
        self.lineBreakMode = NSLineBreakByWordWrapping;
        [self setBackgroundColor:[UIColor colorWithScript:self.kProperties[@"backgroundColor"]]];
        self.text = self.kProperties[@"text"];
        [self setTextColor:[UIColor colorWithHexString:self.kProperties[@"textColor"]]];
        [self setFont:[UIFont systemFontOfSize:[self.kProperties[@"textSize"] floatValue]]];
    }
    return self;
}
#pragma mark- override
- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize defaultSize = [super sizeThatFits:CGSizeZero];
    CGSize reSize;
    
    reSize.width = [self.kProperties[@"width"] isEqualToString:@"wrap_content"] ? defaultSize.width : self.width;
    reSize.height = [self.kProperties[@"height"] isEqualToString:@"wrap_content"] ? defaultSize.height : self.height;
    return reSize;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self sizeToFit];
}
@end
