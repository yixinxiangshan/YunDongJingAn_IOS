//
//  ECBaseImageView.m
//  IOSProjectTemplate
//
//  Created by 程巍巍 on 4/25/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import "ECBaseImageView.h"
#import "ECBaseView.h"
#import "UIImage+Resource.h"

@interface ECBaseImageView ()<ECAutoLayoutProtocol>

@end
@implementation ECBaseImageView

- (id)init
{
    self = [super init];
    if (self) {
        self.contentMode = [self kContentMode];
        UIImage *image = [UIImage imageWithPath:self.kProperties[@"imageSrc"]];
        self.image = image ? image : [UIImage imageNamed:@"ECBaseImageViewDefaultImage.png"];
    }
    return self;
}

- (UIViewContentMode)kContentMode
{
    NSString *contentModeValue = self.kProperties[@"contentMode"];
    UIViewContentMode contentMode = NSIntegerMax;
    if ([contentModeValue isEqualToString:@"scaleAspectFit"]) {
        contentMode = UIViewContentModeScaleAspectFit;
    }else if ([contentModeValue isEqualToString:@"scaleAspectFill"]) {
        contentMode = UIViewContentModeScaleAspectFill;
    }else if ([contentModeValue isEqualToString:@"ScaleToFill"]) {
        contentMode = UIViewContentModeScaleToFill;
    }
    
    return contentMode;
}
#pragma mark-
- (CGFloat)wrapContentForWidth
{
    return self.image.size.width;
}
- (CGFloat)wrapContentForHeight
{
    return self.image.size.height;
}
@end
