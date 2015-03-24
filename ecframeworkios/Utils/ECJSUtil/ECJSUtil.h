//
//  ABSEngine.h
//  AddressBookSpy
//
//  Created by Johannes Fahrenkrug on 27.02.12.
//  Copyright (c) 2012 Springenwerk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScript.h>
@interface ECJSUtil : NSObject {
    JSGlobalContextRef _JSContext;
}

+ (ECJSUtil*) shareInstance;

- (JSGlobalContextRef) JSContext;
- (NSString *)runJS:(NSString *)aJSString;
- (void)loadJSLibrary:(NSString*)libraryName;

@end

@interface ECJSContext : NSObject

/**
 *  parent
 */
@property (nonatomic, weak) NSObject* parent;

- (id) initWithParent:(NSObject *)parent;

- (NSString *) callbackWithId:(NSString *)callbackId argument:(id)arg;
+ (NSString *) callbackWithJSContextId:(NSString *)contextId callbackId:(NSString *)callbackId argument:(id)argument;

- (NSString *)evaluateScript:(NSString *)script;

+ (NSString *)loadJSString:(NSString *)strName;
@end