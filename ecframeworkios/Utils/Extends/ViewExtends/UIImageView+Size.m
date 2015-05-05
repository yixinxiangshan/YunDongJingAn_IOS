//
//  UIImageView+Size.m
//  ECDemoFrameWork
//
//  Created by EC on 9/5/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "UIImageView+Size.h"

@implementation UIImageView (Size)

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder fitHeight:(BOOL)fitHeight{
    __block BOOL _fitHeight = fitHeight;
    __block UIImageView* imageView = self;
    [self setImageWithURL:url placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (_fitHeight) {
            [imageView fitHeight];
        }
    }];
}

-(void)fitHeight{
    UIImage* image = [self image];
    if (image == nil) {
        return;
    }
    CGFloat showHeight = self.frame.size.width*image.size.height/image.size.width;
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, showHeight)];
}

@end
