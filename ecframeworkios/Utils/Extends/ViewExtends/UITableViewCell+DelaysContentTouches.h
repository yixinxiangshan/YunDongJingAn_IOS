//
//  UITableViewCell+DelaysContentTouches.h
//
//  If you have UIButtons or any GestureRecognizer inside a UITableViewCell
//  then set delaysContentTouches to NO to disable the annoying delay when
//  touching the button / gesture recognizer.
//
//  Created by Fredrik Palm (@palmtrae) on 03/04/14.
//  (credit: http://stackoverflow.com/questions/19256996/uibutton-not-showing-highlight-on-tap-in-ios7)
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (DelaysContentTouches)

- (void)setDelaysContentTouches:(BOOL)delaysContentTouches;

@end