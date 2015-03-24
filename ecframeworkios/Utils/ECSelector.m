//
//  ECSelector.m
//  IOSProjectTemplate
//
//  Created by 程巍巍 on 5/12/14.
//  Copyright (c) 2014 ECloud. All rights reserved.
//

#import "ECSelector.h"
#import "NSObjectExtends.h"
#import "ECBaseView.h"
#import "Constants.h"

#define experisionBufferLength 64

typedef NS_ENUM(char, ECSelectorOption) {
    ECSelectorOptionBrother     = '~',
    ECSelectorOptionChildren    = '>',
    ECSelectorOptionAllChildren = ' '
};
@interface NSArray (ECSelector)

- (NSMutableArray *)objectsMatch:(NSString *)expression option:(ECSelectorOption)option;
@end

@interface ECSelector ()

@property (nonatomic, strong) NSMutableArray *keyWords;

@property (nonatomic, strong) NSDictionary *objJSON;

@end

@implementation ECSelector

+ (ECSelector *)selectorWithScript:(NSString *)script
{
    ECSelector *selector = [[ECSelector alloc] init];
    [selector setScript:script];
    return selector;
}


#pragma mark- 表达式解析
- (ECSelector *)setScript:(NSString *)script
{
    self.keyWords = [NSMutableArray new];
    const char *script_c = [script UTF8String];
    
    char keyWord[32];
    char doit[32];
    
    for (int i = 0; i < 32; i ++) {
        keyWord[i] = 0;
        doit[i] = 0;
    }
    
    BOOL spaceFlag = NO;
    for (int i = 0; i < strlen(script_c); i ++) {
        char c = script_c[i];
        if (c == '#' || c == '.' || c == ':')  {
            //新词开始
            if (strlen(keyWord))
            {
                [self analyseKeyWord:keyWord doit:doit];
                for (int i = 0; i < 32; i ++) {
                    keyWord[i] = 0;
                    doit[i] = 0;
                }
            }
        }else if(c == ' ' || c == '>' || c == '~'){
            doit[strlen(doit)] = c;
            spaceFlag = YES;
            continue;
        }else if (spaceFlag){
            spaceFlag = NO;
            [self analyseKeyWord:keyWord doit:doit];
            for (int i = 0; i < 32; i ++) {
                keyWord[i] = 0;
                doit[i] = 0;
            }
        }
        keyWord[strlen(keyWord)] = script_c[i];
    }
    [self analyseKeyWord:keyWord doit:doit];
    ECLog(@"DQSelector script : %@",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:_keyWords options:0 error:nil] encoding:NSUTF8StringEncoding]);
    return self;
}

- (void)analyseKeyWord:(char *)keyWord doit:(char *)doit
{
    char c = doit[0];
    for (int i = 1; i < strlen(doit); i ++) {
        c = doit[i] != ' ' ? doit[i] : c;
    }
    
//    NSString *doitString = [[NSString alloc] initWithCString:&c encoding:NSUTF8StringEncoding];
//    NSString *key = [[NSString alloc] initWithCString:keyWord encoding:NSUTF8StringEncoding];
    
    NSString *doitString = [[NSString alloc] initWithCString:&c length:1];
    NSString *key = [[NSString alloc] initWithCString:keyWord length:strlen(keyWord)];
    
    if(c == ' ' || c == '>' || c == '~'){
        [_keyWords addObject:key];
        [_keyWords addObject:doitString];
    }else if (c == '#' || c == '.' || c == ':'){
        [_keyWords addObject:[doitString stringByAppendingString:key]];
    }else{
        [_keyWords addObject:key];
    }
}

#pragma mark-
- (ECSelector *)setObject:(NSDictionary *)objJSON
{
    self.objJSON = objJSON;
    return self;
}

#pragma mark- 执行
- (NSArray *)evalute
{
    NSMutableArray *resArray = _objJSON[@"subviews"];
    
    for (NSString *expression in _keyWords) {
        ECSelectorOption option = 0;
        switch ([expression UTF8String][0]) {
            case ' ':
                //递规所有子集查找
                option = ECSelectorOptionAllChildren;
                break;
            case '>':
                //当前子集中查找
                option = ECSelectorOptionChildren;
                break;
            case '~':
                //当前集平行查找（兄弟姐妹中查找）
                option = ECSelectorOptionBrother;
                break;
            default:
                resArray = [resArray objectsMatch:expression option:option];
                break;
        }
    }
    return resArray;
}
@end

@implementation NSArray (ECSelector)

- (NSMutableArray *)objectsMatch:(NSString *)expression option:(ECSelectorOption)option
{
    NSMutableArray *resArray = [NSMutableArray new];
    for (NSDictionary *obj in self) {
        switch ([expression UTF8String][0]) {
            case '#':
                //id
                if ([obj[@"id"] isEqualToString:[expression substringFromIndex:1]])
                    [resArray addObject:obj];
                break;
            case '.':
                //tag
                if ([obj[@"tag"] containsObject:[expression substringFromIndex:1]])
                    [resArray addObject:obj];
                break;
            case ':':
                //表达式
                break;
            default:
                //type
                if ([obj[@"type"] isEqualToString:[UIView kCustomViewClassMap][expression]])
                    [resArray addObject:obj];
                break;
        }
        //
        if (option == ECSelectorOptionChildren) {
            //递规到子集
            [resArray addObjectsFromArray:[resArray objectsMatch:expression option:0]];
        }
        if (option == ECSelectorOptionAllChildren) {
            //递规到子集的子集
            [resArray addObject:[resArray objectsMatch:expression option:ECSelectorOptionAllChildren]];
        }
        if (option == ECSelectorOptionBrother) {
            NSArray *brothers = [NSObject findObjectWithId:obj[@"_parentId"]];
            [resArray addObjectsFromArray:[brothers objectsMatch:expression option:0]];
        }
    }
    return resArray;
}
@end
