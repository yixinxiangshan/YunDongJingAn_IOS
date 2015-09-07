//
//  UCTouchEventProtocol.h
//  UniqueControllerTest
//
//  Created by cheng on 14-2-19.
//  Copyright (c) 2014年 littocats. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ANYOBJECT [NSObject new]

@interface NSObject (UCControlEventProtocol)

-(void)touchDown:(UIControl *)sender;
-(void)touchDownRepeat:(UIControl *)sender;
-(void)touchDragInside:(UIControl *)sender;
-(void)touchDragOutside:(UIControl *)sender;
-(void)touchDragEnter:(UIControl *)sender;
-(void)touchDragExit:(UIControl *)sender;
-(void)touchUpInside:(UIControl *)sender;
-(void)touchUpOutside:(UIControl *)sender;
-(void)touchCancel:(UIControl *)sender;
-(void)valueChanged:(UIControl *)sender;
-(void)editingDidBegin:(UIControl *)sender;
-(void)editingChanged:(UIControl *)sender;
-(void)editingDidEnd:(UIControl *)sender;
-(void)editingDidEndOnExit:(UIControl *)sender;
-(void)allTouchEvents:(UIControl *)sender;
-(void)allEditingEvents:(UIControl *)sender;
-(void)applicationReserved:(UIControl *)sender;
-(void)systemReserved:(UIControl *)sender;
-(void)allEvents:(UIControl *)sender;

@end

@interface UIControl (CustomAttribute)

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *ID;
@end