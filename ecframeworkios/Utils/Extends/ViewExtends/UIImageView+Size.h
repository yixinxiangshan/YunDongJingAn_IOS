//
//  UIImageView+Size.h
//  ECDemoFrameWork
//
//  Created by EC on 9/5/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface UIImageView (Size)

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder fitHeight:(BOOL)fitHeight;

- (void)fitHeight;


@end
