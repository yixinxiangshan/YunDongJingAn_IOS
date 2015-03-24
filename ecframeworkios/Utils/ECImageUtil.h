//
//  ECImageUtil.h
//  ECDemoFrameWork
//
//  Created by EC on 9/10/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECImageUtil : NSObject

+ (NSString*)getImageWholeUrl:(NSString*)imageName;

+ (NSString*)getFitImageWholeUrl:(NSString*)imageName;

+ (NSString*)getSImageWholeUrl:(NSString*)imageName;

+ (UIImage *) imageWithUIColor:(UIColor *)color;
+ (UIImage *) imageWithUIColor:(UIColor *)color size:(CGSize)size;

@end
