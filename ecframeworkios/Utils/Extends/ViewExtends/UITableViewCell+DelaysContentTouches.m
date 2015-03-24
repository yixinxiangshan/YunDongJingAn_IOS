//
//  UITableViewCell+DelaysContentTouches.m
//
//  Created by Fredrik Palm (@palmtrae) on 03/04/14.
//
//  (credit: http://stackoverflow.com/questions/19256996/uibutton-not-showing-highlight-on-tap-in-ios7)
//

#import "UITableViewCell+DelaysContentTouches.h"

@implementation UITableViewCell (DelaysContentTouches)

- (void)setDelaysContentTouches:(BOOL)delaysContentTouches
{
    
    
    for (id view in self.subviews) {
        if ([NSStringFromClass([view class]) isEqualToString:@"UITableViewCellScrollView"]) {
            [(UIScrollView *)view setDelaysContentTouches:delaysContentTouches];
            break;
        }
    }
}

@end