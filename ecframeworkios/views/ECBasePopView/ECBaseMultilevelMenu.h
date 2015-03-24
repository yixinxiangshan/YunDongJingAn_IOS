//
//  ECBaseMultilevelMenu.h
//  ECPopViewTest
//
//  Created by 程巍巍 on 4/29/14.
//  Copyright (c) 2014 Littocats. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECBaseMultilevelMenu : UIView

+ (ECBaseMultilevelMenu *)initWithOptions:(NSArray *)options resultHandler:(void (^)(NSDictionary *option))resultHandler;

- (void)setOptions:(NSArray *)options;
@end
