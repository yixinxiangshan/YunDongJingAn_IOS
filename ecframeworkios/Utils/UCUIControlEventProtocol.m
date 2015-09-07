//
//  UCTouchEventProtocol.m
//  UniqueControllerTest
//
//  Created by cheng on 14-2-19.
//  Copyright (c) 2014年 littocats. All rights reserved.
//

#import "UCUIControlEventProtocol.h"
#import <objc/runtime.h>

static const char touchDown;
static const char touchDownRepeat;
static const char touchDragInside;
static const char touchDragInside;
static const char touchDragEnter;
static const char touchDragExit;
static const char touchUpInside;
static const char touchUpOutside;
static const char touchCancel;
static const char valueChanged;
static const char editingDidBegin;
static const char editingDidEnd;
static const char editingDidEndOnExit;
static const char allTouchEvents;
static const char applicationReserved;
static const char systemReserved;
static const char allEvents;



@interface NSObject (UCControlEvent)
-(IBAction)UIControlEventTouchDown:(UIControl *)sender;
-(IBAction)UIControlEventTouchDownRepeat:(UIControl *)sender;
-(IBAction)UIControlEventTouchDragInside:(UIControl *)sender;
-(IBAction)UIControlEventTouchDragOutside:(UIControl *)sender;
-(IBAction)UIControlEventTouchDragEnter:(UIControl *)sender;
-(IBAction)UIControlEventTouchDragExit:(UIControl *)sender;
-(IBAction)UIControlEventTouchUpInside:(UIControl *)sender;
-(IBAction)UIControlEventTouchUpOutside:(UIControl *)sender;
-(IBAction)UIControlEventTouchCancel:(UIControl *)sender;
-(IBAction)UIControlEventValueChanged:(UIControl *)sender;
-(IBAction)UIControlEventEditingDidBegin:(UIControl *)sender;
-(IBAction)UIControlEventEditingChanged:(UIControl *)sender;
-(IBAction)UIControlEventEditingDidEnd:(UIControl *)sender;
-(IBAction)UIControlEventEditingDidEndOnExit:(UIControl *)sender;
-(IBAction)UIControlEventAllTouchEvents:(UIControl *)sender;
-(IBAction)UIControlEventAllEditingEvents:(UIControl *)sender;
-(IBAction)UIControlEventApplicationReserved:(UIControl *)sender;
-(IBAction)UIControlEventSystemReserved:(UIControl *)sender;
-(IBAction)UIControlEventAllEvents:(UIControl *)sender;
@end

@implementation NSObject (UCControlEventProtocol)

-(IBAction)UIControlEventTouchDown:(UIControl *)sender{[self touchDown:sender];}
-(IBAction)UIControlEventTouchDownRepeat:(UIControl *)sender{[self touchDownRepeat:sender];}
-(IBAction)UIControlEventTouchDragInside:(UIControl *)sender{[self touchDragInside:sender];}
-(IBAction)UIControlEventTouchDragOutside:(UIControl *)sender{[self touchDragOutside:sender];}
-(IBAction)UIControlEventTouchDragEnter:(UIControl *)sender{[self touchDragEnter:sender];}
-(IBAction)UIControlEventTouchDragExit:(UIControl *)sender{[self touchDragExit:sender];}
-(IBAction)UIControlEventTouchUpInside:(UIControl *)sender{ [self touchUpInside:sender]; }
-(IBAction)UIControlEventTouchUpOutside:(UIControl *)sender{[self touchUpOutside:sender];}
-(IBAction)UIControlEventTouchCancel:(UIControl *)sender{[self touchCancel:sender];}
-(IBAction)UIControlEventValueChanged:(UIControl *)sender{[self valueChanged:sender];}
-(IBAction)UIControlEventEditingDidBegin:(UIControl *)sender{[self editingDidBegin:sender];}
-(IBAction)UIControlEventEditingChanged:(UIControl *)sender{[self editingChanged:sender];}
-(IBAction)UIControlEventEditingDidEnd:(UIControl *)sender{[self editingDidEnd:sender];}
-(IBAction)UIControlEventEditingDidEndOnExit:(UIControl *)sender{[self editingDidEndOnExit:sender];}
-(IBAction)UIControlEventAllTouchEvents:(UIControl *)sender{[self allTouchEvents:sender];}
-(IBAction)UIControlEventAllEditingEvents:(UIControl *)sender{[self allEditingEvents:sender];}
-(IBAction)UIControlEventApplicationReserved:(UIControl *)sender{[self applicationReserved:sender];}
-(IBAction)UIControlEventSystemReserved:(UIControl *)sender{[self systemReserved:sender];}
-(IBAction)UIControlEventAllEvents:(UIControl *)sender{[self allEvents:sender];}


-(void)touchDown:(UIControl *)sender{}
-(void)touchDownRepeat:(UIControl *)sender{}
-(void)touchDragInside:(UIControl *)sender{}
-(void)touchDragOutside:(UIControl *)sender{}
-(void)touchDragEnter:(UIControl *)sender{}
-(void)touchDragExit:(UIControl *)sender{}
-(void)touchUpInside:(UIControl *)sender{}
-(void)touchUpOutside:(UIControl *)sender{}
-(void)touchCancel:(UIControl *)sender{}
-(void)valueChanged:(UIControl *)sender{}
-(void)editingDidBegin:(UIControl *)sender{}
-(void)editingChanged:(UIControl *)sender{}
-(void)editingDidEnd:(UIControl *)sender{}
-(void)editingDidEndOnExit:(UIControl *)sender{}
-(void)allTouchEvents:(UIControl *)sender{}
-(void)allEditingEvents:(UIControl *)sender{}
-(void)applicationReserved:(UIControl *)sender{}
-(void)systemReserved:(UIControl *)sender{}
-(void)allEvents:(UIControl *)sender{}

@end

static const char *customAttributeUrl = "customAttributeurl";
static const char *customAttributeID = "customAttributeID";

@implementation UIControl (CustomAttribute)

- (NSString *) url
{
    return objc_getAssociatedObject(self, customAttributeUrl);
}
- (void) setUrl:(NSString *)url
{
    objc_setAssociatedObject(self, customAttributeUrl, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//ID
- (NSString *) ID
{
    return objc_getAssociatedObject(self, customAttributeID);
}
- (void) setID:(NSString *)ID
{
    objc_setAssociatedObject(self, customAttributeID, ID, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
