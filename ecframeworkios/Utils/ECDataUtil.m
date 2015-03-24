//
//  ECDataUtil.m
//  ECDemoFrameWork
//
//  Created by EC on 9/2/13.
//  Copyright (c) 2013 EC. All rights reserved.
//

#import "ECDataUtil.h"
#import "NSStringExtends.h"
#import "ECJSUtil.h"
#import "ECJsonUtil.h"
#import "Constants.h"
#import "NSDictionaryExtends.h"
#import "NSArrayExtends.h"
#import "NSObjectExtends.h"
#import "ECAppUtil.h"
#import "ECPageUtil.h"
#import "ECWidgetUtil.h"

#define TAG "ECDataUtil"

@implementation ECDataUtil

/**
 * 更加强大的数据适配，支持数组list[]、表达式"{#***}"、指定值"{$***}"
 *
 * @param pageContext
 * @param widget
 * @param adapters
 * @param resString
 * @return
 */
+ (NSDictionary *) adapterDataFree:(ECBaseViewController*)pageContext widget:(ECBaseWidget*)widget adapters:(NSArray *)adapters resData:(NSDictionary *)resData
{
    
    if ([resData isEmpty]) {
        return nil;
    }
    if ([adapters isEmpty]) {
        return resData;
    }
    
    ECDataAdapter *dataAdapter = [[ECDataAdapter alloc] initWith:adapters dataSource:[[resData JSONString] JSONValue]];
    dataAdapter.pageContext = pageContext;
    dataAdapter.widget = widget;
    
    id data = [dataAdapter resultData];
    ECLog(@"data after adapter : %@",data);
    return data;
    
    // 旧的适配方法，弃用
//    ECLog(@"%s adapterDataFree : start ......",TAG);
//    // Parse Source Data
//    NSDictionary* sourceData;
////    id tempData = [ECJsonUtil objectWithJsonString:resString];
//    if ([resData isKindOfClass:[NSDictionary class]]) {
//        sourceData = resData;
//    }
//    
//    // result Data :
//    NSDictionary* resultDic = [NSDictionary new];
//    
//    //遍历adapters , 构造 resultDic
//    for (NSDictionary* adapter in adapters) {
//        NSString* from = [adapter valueForKey:@"key"];
//        NSString* to = [adapter valueForKey:@"value"];
//        // 构造 目标值
//        id object = [self buildValue:from pagegeContext:pageContext widget:widget resData:resData] ;
//        
//        // 构造目标key
//        if (object == nil) {
//            ECLog(@"%s adapterDataFree error: object is null ...(after get)",TAG);
//        } else {
//            object = [ECDataUtil setData:object forKey:to];
//            // 如果 object 不为空，则与 resultDic 合并
//            if (object == nil) {
//                ECLog(@"%s adapterDataFree error: object is null ...(after get)",TAG);
//            } else{
//                resultDic = [ECDataUtil merge:resultDic with:object];
//            }
//        }
//    }
//    
//    return resultDic;
}

#pragma mark- 构建目标值
+ (id) buildValue:(NSString *)valueExpression pagegeContext:(ECBaseViewController*)pageContext widget:(ECBaseWidget*)widget resData:(NSDictionary *)resData
{
    id object = nil ;
    
    NSArray* temps = [valueExpression componentsSeparatedByString:@"+"];

    if (temps.count == 1) {
        if ([valueExpression isExpression]) {
            NSString* resultString = [self getValuePurpose:valueExpression pageContext:pageContext widget:widget bundleData:resData];
            
            //            NSString* isJSON = [[ECJSUtil shareInstance] runJS:[NSString stringWithFormat:@"\"%@\".isJSON();",resultString]];
            if (![resultString hasPrefix:@"{"]) {
                object = resultString;
            }else{
                object = [ECJsonUtil objectWithJsonString:resultString];
            }
        }else{
            object = [ECDataUtil getData:resData forKey:valueExpression];
        }
        return object;
    }
    
    // 表达式集合的处理
    NSString *valueString = @"";
    for (NSString *temp in temps) {
        valueString = [NSString stringWithFormat:@"%@%@",valueString,[self buildValue:temp pagegeContext:pageContext widget:widget resData:resData]];
    }
    
    object = valueString.length ? valueString : nil;
    return object;
}

#pragma mark - 根据表达式获取相应数据
+(NSString*) getValuePurpose:(NSString*)des  controlId:(NSString*)controlId bundleData:(NSString*)bundleString{
    ECBaseViewController* pageContext = [[ECAppUtil shareInstance] nowPageContext];
    ECBaseWidget* widget = [ECWidgetUtil getWidget:controlId];
    NSDictionary* bundleData = [ECJsonUtil objectWithJsonString:bundleString];
    return [self getValuePurpose:des pageContext:pageContext widget:widget bundleData:bundleData];
}

+(NSString*) getValuePurpose:(NSString*)des pageContext:(ECBaseViewController*)pageContext widget:(ECBaseWidget*)widget bundleData:(NSDictionary*)bundleData{
    
    
    if ([des isEmpty]) {
        return nil;
    }
    if (![des isExpression]) {
        return  des;
    }
    NSString* desc = [des slim];
    if (!desc) {
        return nil;
    }
    if ([desc hasPrefix:@"$"]) {
        NSString* tempString = [[desc slimH] isEmpty] ? nil : [desc slimH];
        return tempString;
    }
    
    if ([desc hasPrefix:@"#"]) {
        //执行js
        return [[ECJSUtil shareInstance] runJS:[desc slimH]];
    }
    
    desc = [desc slimH];
    if ([desc isEmpty]) {
        return nil;
    }
    id tempValue;
    NSArray* ss = nil;
    NSString* valueRec ;
    NSString* valueKey ;
    if ([desc contain:@"."]) {
        ss = [desc componentsSeparatedByString:@"."];
    }
    if (ss==nil || [ss isEmpty]) {
        valueRec = desc;
    }else{
        valueRec = [ss objectAtIndex:0];
        valueKey = [ss objectAtIndex:1];
    }
    if ([valueRec isEqualToString:@"app"]) {
        //TODO: 获取整个app 级的数据
    }
    else if ([valueRec isEqualToString:@"page"]) {
        // 获取 页面级传参
        tempValue = [pageContext getParam:valueKey];
    }
    else if ([valueRec isEqualToString:@"pageData"]) {
        //TODO: 获取 页面数据中的值 ，考虑数组
        tempValue = [pageContext getParam:PAGE_DATA_KEY];
        if ([tempValue isEmpty]) {
            ECLog(@"page level data is nil ...");
            return nil;
        }
        tempValue = [ECJsonUtil objectWithJsonString:tempValue];
        for (int i = 1; i < [ss count]; i++) {
            if ([ss[i] hasSuffix:@"[]"]) {
                tempValue = [tempValue objectForKey:[ss[i] substringToIndex:[ss[i] length]-2]];
            }else{
                tempValue = [tempValue objectForKey:ss[i]];
            }
            
        }
    }
    else if([valueRec isEqualToString:@"widgetData"]){
        //TODO: 获取控件数据中的值,检测数组取值
        tempValue = [widget dataDic];
        for (int i = 1; i < [ss count]; i++) {
//            tempValue = [tempValue objectForKey:ss[i]];
            tempValue = [self getData:tempValue forKey:ss[i]];
        }
    }
    else if([valueRec isEqualToString:@"widgetConfig"]){
        // 获取 控件级传参
        tempValue = [widget getParam:valueKey];
    }
    else if([valueRec isEqualToString:@"self"]){
        // 获取事件绑定数据
        if (bundleData && [bundleData isKindOfClass:[NSDictionary class]])
            tempValue = [bundleData objectForKey:valueKey];
    }
    
    NSString* value = nil;
    if ([tempValue isKindOfClass:[NSDictionary class]] || [tempValue isKindOfClass:[NSArray class]])
        value = [tempValue JSONString];
    else if ([tempValue isKindOfClass:[NSString class]])
        value = tempValue;
    else
        // editor by cww , 处理空值，[NSString stringWithFormat:@"%@",object],当object 为 nil 时，得到的结果为：(null)
        value = tempValue ? [NSString stringWithFormat:@"%@",tempValue] : @"";
    
    return value;
}

+ (id) getValueForKey:(NSString *)keyExpression fromObject:(id)object
{
    NSString *keyTail = [keyExpression substringWithRegex:@"\\[[.]+\\]"];
    NSString *key = [keyExpression substringToIndex:keyExpression.length-keyTail.length];
    
    if ([key hasPrefix:@"("] && [key hasSuffix:@")"]) {
        key = [key substringWithRange:NSMakeRange(1, key.length-2)];
    }
    id value = nil;
    if ([object isKindOfClass:[NSDictionary class]]) {
        value = [object objectForKey:key];
    }else if ([object isKindOfClass:[NSArray class]]){
        value = [object objectAtIndex:[key integerValue]];
    }
    
    if (keyTail && keyTail.length > 2) {
        keyTail = [keyTail substringWithRange:NSMakeRange(1, keyTail.length - 2)];
        value = [self getValueForKey:keyTail fromObject:value];
    }
    return nil;
}

/**
 *
 */
//+ (id) getData:(NSDictionary *)source forKey:(NSString *)keyValue
//{
//    NSArray* keys = [keyValue componentsSeparatedByString:@"."];
//    id obj = [[NSDictionary alloc] initWithDictionary:source];
//    for (NSString* key in keys) {
//        if ([key contain:@"[]"]) {
//            NSString* keyString = [key substringToIndex:[key rangeOfString:@"["].location];
//            obj = [obj objectForKey:keyString];
//        }else{
//            if ([key contain:@"["]) {
//                NSString* keyString = [key substringToIndex:[key rangeOfString:@"["].location];
//                NSString* indexString = [key substringFromIndex:[key rangeOfString:@"["].location];
//                if ([indexString contain:@"["]) {
//                    indexString = [indexString slim];
//                }
//                if ([indexString contain:@"("]) {
//                    indexString = [indexString slim];
//                }
//                NSInteger index = [indexString integerValue];
//                
//                obj = [[obj objectForKey:keyString] objectAtIndex:index];
//            }else{
//                if ([obj isKindOfClass:[NSDictionary class]]) {
//                    obj = [obj objectForKey:key];
//                }else if ([obj isKindOfClass:[NSArray class]]){
//                    NSMutableArray* temp = [NSMutableArray new];
//                    for (id item in obj) {
//                        if ([item isKindOfClass:[NSDictionary class]]) {
//                            id content = [item objectForKey:key];
//                            if (content) {
//                                [temp addObject:content];
//                            }else{
//                                ECLog(@"%s adapterDataFree error: key is wrong ...  key = %@",TAG,key);
//                                break;
//                            }
//                        }else{
//                            ECLog(@"%s adapterDataFree error: object format is wrong ...(after get)  key = %@",TAG,key);
//                            obj = nil ;
//                        }
//                    }
//                    obj = [NSArray arrayWithArray:temp];
//                }else{
//                    ECLog(@"%s adapterDataFree error: object format is wrong ...(after get)  key = %@",TAG,key);
//                    obj = nil;
//                }
//                
//            }
//        }
//    }
//    return obj;
//}

+ (id) getData:(id)source forKey:(NSString *)keyValue
{
    NSArray* keys = [keyValue componentsSeparatedByString:@"."];
    id obj ;
    // if ([source isKindOfClass:[NSArray class]])
    // {
    //     obj = [[NSArray alloc] initWithArray:source] ;
    // }else if ([source isKindOfClass:[NSDictionary class]]){
    //     obj = [[NSDictionary alloc] initWithDictionary:source];
    // }
    
    obj = [source copy];
    for (NSString* key in keys) {
        //获取列表
        if ([key contain:@"[]"]){
            NSString* keyString = [key substringToIndex:[key rangeOfString:@"["].location];
            obj = [self getData:obj forKey:keyString];
        }else
        //获取列表中的某一项
        if ([key firstRangeOfRegex:@"\\[.+\\]"].length > 2){
            NSString* keyString = [key substringToIndex:[key rangeOfString:@"["].location];
            
            NSString *indexString = [[key substringWithRegex:@"\\[.+\\]"] slim];
            if ([indexString firstRangeOfRegex:@"\\(.+\\)"].length > 2 ) {
                indexString = [indexString slim];
            }
            NSInteger index = [indexString integerValue];
            
            obj = [[self getData:obj forKey:keyString] objectAtIndex:index];
        }else
        //获取值
        //若为dictionary 则取出值
        if ([obj isKindOfClass:[NSDictionary class]]){
            obj = [obj objectForKey:key];
        }else
        //若为 array 则取出key 对应的一组值
        if ([obj isKindOfClass:[NSArray class]]){
            id tempObj = [NSMutableArray new];
            for (id object in obj) {
                id content = [self getData:object forKey:key];
                if (content) {
                    [tempObj addObject:content];
                }else{
                    ECLog(@"%s adapterDataFree error: key is wrong ...  key = %@",TAG,key);
                    break;
                }
            }
            obj = tempObj;
        }else{
            ECLog(@"%s adapterDataFree error: key is not exist or object not exist...  key = %@",TAG,key);
            break;
        }

    }
    return obj;
}
//+ (id) setData:(id)data forKey:(NSString *)keyValue
//{
//    NSArray* keys = [keyValue componentsSeparatedByString:@"."] ;
//    keys = [[keys reverseObjectEnumerator] allObjects];
//    if (keys.count == 0) {
//        return nil;
//    }
//    id obj = data;
//    for (NSString* key in keys) {
//        if ([key contain:@"[]"] && [obj isKindOfClass:[NSArray class]]) {
//            NSString* keyString = [key substringToIndex:[key rangeOfString:@"["].location];
//            obj = [NSDictionary dictionaryWithObject:obj forKey:keyString];
//        }else{
//            if ([key contain:@"["]) {
//                NSString* keyString = [key substringToIndex:[key rangeOfString:@"["].location];
//                NSInteger index = [[key substringWithRange:NSMakeRange([key rangeOfString:@"["].location+1, [key rangeOfString:@"]"].location - [key rangeOfString:@"["].location)] integerValue];
//                NSMutableArray* temObj = [[NSMutableArray alloc] initWithCapacity:index+1];
//                for (int i = 0; i < index; i ++) {
//                    [temObj insertObject:[NSDictionary new] atIndex:i];
//                }
//                [temObj insertObject:obj atIndex:index];
//                obj = [[NSDictionary alloc] initWithObjectsAndKeys:temObj,keyString, nil];
//                
//            }else{
//                if ([obj isKindOfClass:[NSArray class]]) {
//                    NSMutableArray* temp = [NSMutableArray new];
//                    for (id item in obj) {
//                        [temp addObject:[NSDictionary dictionaryWithObject:item forKey:key]];
//                    }
//                    obj = [NSArray arrayWithArray:temp];
//                    
//                }else{
//                    obj = [[NSDictionary alloc] initWithObjectsAndKeys:obj,key, nil];
//                    
//                }
//            }
//        }
//    }
//    return obj;
//}
+ (id) setData:(id)data forKey:(NSString *)keyValue
{
    NSArray* keys = [keyValue componentsSeparatedByString:@"."] ;
    keys = [[keys reverseObjectEnumerator] allObjects];
    if (keys.count == 0) {
        return nil;
    }
    id obj = data;
    for (int i = 0; i < keys.count; i ++) {
        NSString* key = [keys objectAtIndex:i];
        if ([key contain:@"[]"] && [obj isKindOfClass:[NSArray class]]) {
            NSString* keyString = [key substringToIndex:[key rangeOfString:@"["].location];
            NSString *nexKey = nil;
            if (i < keys.count - 1) {
                nexKey = [keys objectAtIndex: i+1];
            }
            if ([nexKey contain:@"[]"]) {
                NSMutableArray* temp = [NSMutableArray new];
                for (id item in obj) {
                    id content = [NSDictionary dictionaryWithObject:item forKey:keyString];
                    if (content) {
                        [temp addObject:content];
                    }
                }
                obj = [NSArray arrayWithArray:temp];
            }else{
                obj = [NSDictionary dictionaryWithObject:obj forKey:keyString];
            }
        }else
            // 插入到数组中的某个位置
        if ([key firstRangeOfRegex:@"\\[[0-9]+\\]"].length > 2) {
            NSString* keyString = [key substringToIndex:[key rangeOfString:@"["].location];
            NSInteger index = [[[key substringWithRegex:@"\\[[0-9]+\\]"] slim] integerValue];
            
            NSMutableArray* temObj = [[NSMutableArray alloc] initWithCapacity:index+1];
            for (int i = 0; i < index; i ++) {
                [temObj insertObject:[NSDictionary new] atIndex:i];
            }
            [temObj insertObject:obj atIndex:index];
            obj = [[NSDictionary alloc] initWithObjectsAndKeys:temObj,keyString, nil];
        }else
        if ([obj isKindOfClass:[NSArray class]]){
            NSMutableArray* temp = [NSMutableArray new];
            for (id item in obj) {
                id content = [self setData:item forKey:key];
                if (content) {
                    [temp addObject:content];
                }
            }
            obj = [NSArray arrayWithArray:temp];
        }else{
            obj = [[NSDictionary alloc] initWithObjectsAndKeys:obj,key, nil];
        }
    }
    return obj;
}
/**
 * sourceDic and dataDic is NSDictionary or NSArray
 */
+ (id) merge:(id)sourceDic with:(id)dataDic
{
    id temp;

    if ([sourceDic isKindOfClass:[NSDictionary class]] && [dataDic isKindOfClass:[NSDictionary class]]) {
        temp = [NSMutableDictionary dictionaryWithDictionary:sourceDic];
        NSEnumerator *keys = [(NSDictionary *)dataDic keyEnumerator];
        id key;
        while (key = [keys nextObject]) {
            id obj = [sourceDic objectForKey:key];
            
            if (obj == nil) {
                [temp addEntriesFromDictionary:dataDic];
            }else{
                [temp addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[ECDataUtil merge:obj with:[dataDic objectForKey:key]] forKey:key]];
            }
        }
        sourceDic = [NSDictionary dictionaryWithDictionary:temp];
    }else if ([sourceDic isKindOfClass:[NSArray class]] && [dataDic isKindOfClass:[NSArray class]]){
        
        temp = [NSMutableArray arrayWithArray:(NSArray *)sourceDic];
        if (![ECDataUtil isLikeSuperficial:sourceDic with:dataDic]) {
            for (int i = 0; i < [(NSArray *)dataDic count]; i ++) {
                if (i < [temp count]) {
                    [temp setObject:[ECDataUtil merge:[temp objectAtIndex:i] with:[dataDic objectAtIndex:i]] atIndex:i];
                }else{
                    [temp setObject:[dataDic objectAtIndex:i] atIndex:i];
                }
            }
        }else{
            [(NSMutableArray *)temp addObjectsFromArray:dataDic];
        }
        sourceDic = [NSArray arrayWithArray:temp];
    }else{
        sourceDic = dataDic;
    }
    return sourceDic;
}
/**
 *
 */
+ (BOOL) isLikeSuperficial:(id)object1 with:(id)object2
{
    if ([object1 isKindOfClass:[NSArray class]] && [object2 isKindOfClass:[NSArray class]]) {
        for (id item1 in object1) {
            for (id item2 in object2) {
                if (![ECDataUtil isLikeSuperficial:item1 with:item2]) {
                    
                    return NO;
                }
            }
        }
        return YES;
    }else if ([object1 isKindOfClass:[NSDictionary class]] && [object2 isKindOfClass:[NSDictionary class]]){
        NSEnumerator *enumerator1 = [(NSDictionary *)object1 keyEnumerator];
        NSEnumerator *enumerator2 = [(NSDictionary *)object2 keyEnumerator];
        id key;
        while (key = [enumerator1 nextObject]) {
            if (![object2 objectForKey:key]) {
                return NO;
            }
        }
        while (key = [enumerator2 nextObject]) {
            if (![object1 objectForKey:key]) {
                return NO;
            }
        }
        
        return YES;
    }
    return YES;
}
@end

@implementation ECDataAdapter

- (id) resultData
{
    _resultData = [self adaptDataWithAdapter:_adapter sequence:nil];
    [self adaptSpecialData];
    
    return _resultData;
}

#pragma  mark- 转换适配器
- (id) initWith:(NSArray *)adapterSource dataSource:(id)dataSource
{
    self = [super init];
    if (self) {
        _dataSource = dataSource;
        [self initAdapter:adapterSource];
    }
    return self;
}
- (void) initAdapter:(NSArray *)adapter
{
    _adapter = [NSMutableDictionary new];
    _lastAdapters = [NSMutableArray arrayWithArray:adapter];
    
    //合成适配器
    for (NSDictionary *item in adapter) {
        NSString *keyExpression = [item objectForKey:@"value"];
        
        //例：{"key":"cms_sort_options[].cnname","value":"options[].text"}  {"key": "cms_sort_options[].items[].id","value": "options[].options[].value"} {"key": "cms_sort_options[].items[2].id","value": "options[].options[].value"}
        //存在固定索引，则跳过
        NSRange indexRange = [keyExpression firstRangeOfRegex:@"\\[[0-9]+\\]"];
        if (indexRange.length > 2) {
            //为不影响数据结够，keyExpression 移除索引
//            while (indexRange.length > 2) {
//                keyExpression = [keyExpression stringByReplacingCharactersInRange:indexRange withString:@"[]"];
//                indexRange = [keyExpression firstRangeOfRegex:@"\\[[0-9]+\\]"];
//            }
            continue;
        }else{
            //从 lastAdapters 中移除
            [_lastAdapters removeObject:item];
        }
        
        NSMutableArray *keys = [NSMutableArray arrayWithArray:[keyExpression componentsSeparatedByString:@"."]];
        NSString *valueExpression = [item objectForKey:@"key"];
        //处理,递规，构造数据结构
        [self addObjectToAdapter:_adapter withKeys:keys value:valueExpression];
    }
    
}

- (id) addObjectToAdapter:(id)adapter withKeys:(NSMutableArray *)keys value:(NSString *)value
{
    if (keys.count == 1) {
        if (!adapter) {
            adapter = [NSMutableDictionary new];
        }
        NSString *key = [keys firstObject];
        //和谐key value 中的 [],此处为直接取对像，不再需要类型标志
        key = [key rangeOfString:@"[]"].location != NSNotFound ? [key substringWithRange:NSMakeRange(0, key.length-2)] : key;
        value = value.length > 2 && [[value substringFromIndex:value.length - 2] isEqualToString:@"[]"] ? [value substringWithRange:NSMakeRange(0, value.length-2)] : value;
        
        [adapter setObject:value forKey:key];
        return adapter;
    }
    
    NSString *key = [keys firstObject];
    [keys removeObjectAtIndex:0];
    BOOL isArray = NO;
    //处理 key
    if ([key rangeOfString:@"[]"].location != NSNotFound) {
        key = [key substringWithRange:NSMakeRange(0, key.length-2)];
        isArray = YES;
    }
    
    id obj = nil;
    
    if (!adapter) {
        adapter = [NSMutableDictionary new];
    }
    obj = [adapter objectForKey:key];
    
    if (isArray) {
        if (!obj) {
            obj = [NSMutableArray new];
        }
        if (![obj isKindOfClass:[NSMutableArray class]]) {
            NSLog(@"数据类型匹配错误: (type of obj : %@ , required type : %@",[obj class],isArray ? @"Array" : @"Dictionary");
            return nil;
        }
        
        id subAdapter = [NSMutableDictionary new];
        [self addObjectToAdapter:subAdapter withKeys:keys value:value];
        
        if ([obj count] == 0) {
            [obj addObject:subAdapter];
        }else{
            //adapter 为 array,检测adapter中是否存在 当前 key
            for (int i = 0; i < [obj count]; i ++) {
                NSMutableDictionary *item = [obj objectAtIndex:i];
                NSString *subAdapterKey = [[subAdapter allKeys] firstObject];
                
                id itemValue = !subAdapterKey ? nil : [item objectForKey:subAdapterKey];
                if (itemValue) {
                    //adapter中存在 当前 key ，则将subAdapter对像中的{key:object}对像（只有一个）加入itemValue
                    if ([itemValue isKindOfClass:[NSMutableArray class]]) {
                        [itemValue addObject:[[subAdapter objectForKey:subAdapterKey] firstObject]];
                    }else if ([item isKindOfClass:[NSMutableDictionary class]]) {
                        [item setObject:[subAdapter objectForKey:subAdapterKey] forKey:subAdapterKey];
                    }else{
                        NSLog(@"error 类型匹配错误");
                    }
                }else if (i == [obj count] - 1){
                    //adapter中不存在 当前 key，则构建新的 {key:object}对像
                    [obj addObject:subAdapter];
                    break;
                }
            }
        }
        
    }else{
        if (!obj) {
            obj = [NSMutableDictionary new];
        }
        if (![obj isKindOfClass:[NSMutableDictionary class]]) {
            NSLog(@"数据类型匹配错误: (type of obj : %@ , required type : %@",[obj class],isArray ? @"Array" : @"Dictionary");
            return nil;
        }
        [self addObjectToAdapter:obj withKeys:keys value:value];
    }
    
    
    if ([adapter isKindOfClass:[NSMutableDictionary class]]) {
        [adapter setObject:obj forKey:key];
    }else{
        [adapter addObject:obj];
    }
    return adapter;
}

#pragma mark- 适配数据
- (id) adaptDataWithAdapter:(id)adapter sequence:(NSMutableArray *)sequence
{
    //初始化结果类型
    id result;
    if ([adapter isKindOfClass:[NSDictionary class]]) {
        result = [NSMutableDictionary new];
    }else if ([adapter isKindOfClass:[NSArray class]]){
        result = [NSMutableArray new];
    }else{
        return nil;
    }
    
    //解析adapter
    //结果为 dictionary
    if ([result isKindOfClass:[NSDictionary class]]) {
        //遍历 dictionary
        NSEnumerator *enumerator = [adapter keyEnumerator];
        id key;
        while (key = [enumerator nextObject]) {
            id value = [adapter objectForKey:key];
            
            //修正，若value 不是 字符串（表达式），则递规
            if ([value isKindOfClass:[NSString class]]) {
                value = [self getValue:value sequence:sequence];
            }else{
                value = [self adaptDataWithAdapter:value sequence:sequence];
            }
//            if ([value isKindOfClass:[NSArray class]]) {
//                //若value应为 NSArray , 则递规
//                value = [self adaptDataWithAdapter:value sequence:sequence];
//                
//            }else{
//                //若value应为 NSDictionary , 则将 直接解析 value
//                
//                value = [self getValue:value sequence:sequence];
//            }
            // 将 value 加入 result
            [result setObject:value ? value : [NSNull null] forKey:key];
        }
    }
    //结果为 array
    else if ([result isKindOfClass:[NSArray class]]){
        //sequence 中保存递规过程，数组索引，对像类型为 NSNumber
        sequence = !sequence ? [NSMutableArray new] : sequence;
        int index = 0;
        //加入当前索引
        [sequence addObject:[NSNumber numberWithInt:index]];
        
        
        BOOL hasNextObject = YES;
        
        //记录result中对像数量的可能值，不作为依据（－1表示不参考该值，0表示对像数量应为0)
        NSInteger objectCountShouldBe = -1;
        while (hasNextObject) {
            NSMutableDictionary *object = [NSMutableDictionary new];
            
            //索引标志，若值表达式，没有使用索引，则结果对像为定值，只取一个
            BOOL indexUseFlag = NO;
            
            for (NSDictionary *item in adapter) {
                NSString *key = [[item allKeys] firstObject];
                //item 为空时，表示无效键值对，跳过
                if (!key) {
                    continue;
                }
                
                id value = [item objectForKey:key];
                //检测是否需要索引值，并更新 indexUseFlag
                if (!indexUseFlag && [value isKindOfClass:[NSString class]]) {
                    indexUseFlag = [value rangeOfString:@"[]"].location == NSNotFound ? NO : YES;
                }else if ([value isKindOfClass:[NSArray class]]){
                    indexUseFlag = YES;
                }
                
                if ([value isKindOfClass:[NSArray class]]) {
                    //若value应为 NSArray , 则递规，例：item = {"key":[...]},
                    value = [self adaptDataWithAdapter:value sequence:sequence];
                }else{
                    //若value应为 NSDictionary，例：item = {"key":"value"},
                    value = [self getValue:value sequence:sequence];
                    
                    //更新 objectCountShouldBe
                    if ([value isKindOfClass:[NSString class]] && [value isEqualToString:@"ObjectCountShouldBeZero"]) {
                        objectCountShouldBe = 0;
                    }
                }
                //value 表达式的结果不为空，则加入结果
                if (value && objectCountShouldBe != 0) {
                    //如果 value 为 NSMutableArray ，则需要判断 value 中对像的数量，对像数量为 0 ，则跳过
                    if ([value isKindOfClass:[NSMutableArray class]] && [value count] == 0) {
                        continue;
                    }
                    [object setObject:value forKey:key];
                }
            }
            //如果 object 等于空对像（{}），则退出
            {
                if ([[object JSONString] isEqualToString:@"{}"]) {
                    hasNextObject = NO;
                }else{
                    //或者与上一个对像值（JSONString)相等：
                    if ([result count]  > 0 && [[object JSONString] isEqualToString:[[result lastObject] JSONString]]) {
                        hasNextObject = NO;
                        //若当前 result 中只有一个对像，则应为正常结果，否则将其移除
                        [result count] > 1 ? [result removeLastObject] : nil;
                        
                    }else{
                        //放入结果集
                        [result addObject:object];
                    }
                }
            }
            
            //没有使用索引，则结果对像为定值，退出
            if (!indexUseFlag) {
                hasNextObject = NO;
            }
            //当前索引 ＋1
            index ++;
            //更新索引
            [sequence replaceObjectAtIndex:sequence.count-1 withObject:[NSNumber numberWithInt:index]];
        }
        //退出当前适配过程时，索引序列 squence 移除当前索引值
        [sequence removeLastObject];
    }
    return result;
}


//取值
- (id) getValue:(NSString *)valueExpression sequence:(NSArray *)sequence
{
    //多值拼接（局部组装），例：expresion+expresion
    NSArray *valueExpressions = [valueExpression componentsSeparatedByString:@"+"];
    if (valueExpressions.count > 1) {
        NSMutableString *result = [NSMutableString new];
        for (NSString *expression in valueExpressions) {
            id resultValue = [self getValue:expression sequence:sequence];
            if (resultValue && (NSNull *)resultValue != [NSNull null]) {
                [result appendString:resultValue];
            }
        }
        return result;
    }
    
    //特殊表达式，例：{$0} {_value} ...
    if ([valueExpression isExpression]) {
        return [ECDataUtil getValuePurpose:valueExpression pageContext:_pageContext widget:_widget bundleData:_dataSource];
    }
    
    //处理表达式
    valueExpressions = [valueExpression componentsSeparatedByString:@"."];
    NSMutableArray *expressionArray = [NSMutableArray new];
    int index = 1;
    //倒序解析
    for (int i = valueExpressions.count-1; i >= 0; i--) {
        NSString *key = [valueExpressions objectAtIndex:i];
        
        if ([key isExpression]) {
            key = [ECDataUtil getValuePurpose:key pageContext:_pageContext widget:_widget bundleData:_dataSource];
        }
        
        NSString *indexString = [key substringWithRegex:@"\\[[0-9]*\\]"];
        
        //数组中取值,例：key[]、key[11]
        if (indexString.length > 0) {
            if (indexString.length > 2) {
                //索引已存在,例：key［11]
                [expressionArray addObject:[NSNumber numberWithInt:[[indexString substringWithRange:NSMakeRange(1, indexString.length-1)] integerValue]]];
            }else if (indexString.length == 2){
                //索引不存在，例：key[]
                int sequenceIndex = sequence.count-index;
                //sequenceIndex 超出 sequence 的范围，则返回 nil
                if (sequenceIndex < 0) {
                    return nil;
                }
                [expressionArray addObject:[sequence objectAtIndex:sequenceIndex]];
            }
            [expressionArray addObject:[key stringByReplacingOccurrencesOfString:indexString withString:@""]];
            index++;
        }
        //字典中取值，例：key
        else{
            [expressionArray addObject:key];
        }
    }
    //倒序操作（因为 expressionArray 中 key 的顺序与 ，取值 valueExpressions 中的 key 顺序相反），取值过程
    id object = _dataSource;
    for (int i = expressionArray.count - 1; i >= 0; i --) {
        NSString *key = [expressionArray objectAtIndex:i];
        if ([key isKindOfClass:[NSNumber class]] && [object isKindOfClass:[NSArray class]]) {
            //dataSource 为 NSArray，key 为 NSNumber
            //如果 索引值(key)超出范围,
            if ([key integerValue] >= [object count]) {
                //object 中对像个数为0, 则返回 ObjectCountShouldBeZero ，否则返回 NSNull
                return [object count] == 0 ? @"ObjectCountShouldBeZero" :[NSNull null];
            }
            object = [object objectAtIndex:[key integerValue]];
        }else if ([key isKindOfClass:[NSString class]] && [object isKindOfClass:[NSDictionary class]]){
            //dataSource 为 NSDictionary，key 为 NSString
            object = [object objectForKey:key];
        }else{
            //key 为 空（@"",nil) 或着 dataSource 与 key 的类型不匹配（dataSource 为 NSArray时，key 应为 NSNumber;dataSource 为 NSDictionary时，key 应为 NSString),返回 nil
            NSLog(@"dataSource or key error . (type of dataSource : %@; key : %@",NSStringFromClass([object class]),key);
            return [NSNull null];
        }
    }
    return object ? object : [NSNull null];
}

#pragma mark- 处理例外数据的适配器 _lastAdapters
- (void) adaptSpecialData
{
    //遍历例外数据的适配器
    for (NSDictionary *adapter in _lastAdapters) {
        //adapter {"key": "cms_sort_options[].items[].cnname","value": "options[1].options[].text"}
        //处理value表达式
        NSArray *valueExpressionArray = [[adapter objectForKey:@"value"] componentsSeparatedByString:@"."];
        NSMutableArray *valueExpressionSequeue = [NSMutableArray new];
        for (NSString *expression in valueExpressionArray) {
            NSRange rangeOfIndex = [expression firstRangeOfRegex:@"\\[[0-9]*\\]"];
            if (rangeOfIndex.length == 0) {
                //如果 对像应为 NSDictionary
                [valueExpressionSequeue addObject:expression];
            }else if (rangeOfIndex.length > 0){
                //如果 对像应为 NSArray
                [valueExpressionSequeue addObject:[expression substringToIndex:expression.length - rangeOfIndex.length]];
                if (rangeOfIndex.length == 2) {
                    //无索引值,设置索引为 －1，表示需遍历当前 array
                    [valueExpressionSequeue addObject:[NSNumber numberWithInt:-1]];
                }else if (rangeOfIndex.length > 2){
                    //存在索引值，则加入
                    NSInteger index = [[expression substringWithRange:NSMakeRange(rangeOfIndex.location+1, rangeOfIndex.length-2)] integerValue];
                    [valueExpressionSequeue addObject:[NSNumber numberWithInteger:index]];
                }
            }
        }
        //设置例外数据到resultData
        [self adaptSpecialDataToResultData:_resultData WithKeySequeue:valueExpressionSequeue valueExpression:[adapter objectForKey:@"key"] sequence:nil];
    }
}

- (void) adaptSpecialDataToResultData:(id)resultData WithKeySequeue:(NSMutableArray *)keySequeue valueExpression:(NSString *)valueExpression sequence:(NSMutableArray *)sequence
{
    if (!sequence) {
        sequence = [NSMutableArray new];
    }
    
    //当前索引（dictionary 为 NSString , array 为 NSNumber）
    id currentIndex = [keySequeue firstObject];
    //移除已处理的 key
    [keySequeue removeObjectAtIndex:0];
    
    //需更新的对像
    id value = nil;
    
    if ([currentIndex isKindOfClass:[NSString class]]) {
        //当前索引为 NSString ,则resultData 应为 NSMutableDictionary
        if (![resultData isKindOfClass:[NSMutableDictionary class]]) {
            NSLog(@"数据格式匹配错误（type of resultData : %@ , type needed is \"NSMutableDictionary\"）",[resultData class]);
            return;
        }
        
        //如果已经递规到数据的顶层分支，则替换分支中的数据
        if (keySequeue.count == 0) {
            [resultData setObject:[self getValue:valueExpression sequence:sequence] forKey:currentIndex];
            return;
        }
        
        value = [resultData objectForKey:currentIndex];
        if (!value) {
            if ([keySequeue firstObject] && [[keySequeue firstObject] isKindOfClass:[NSString class]]) {
                value = [NSMutableDictionary new];
                
            }else{
                value = [NSMutableArray new];
            }
            [resultData setObject:value forKey:currentIndex];
        }
        
        //递规
        [self adaptSpecialDataToResultData:value WithKeySequeue:keySequeue valueExpression:valueExpression sequence:sequence];
        
    }else if ([currentIndex isKindOfClass:[NSNumber class]]){
        if (![resultData isKindOfClass:[NSMutableArray class]]) {
            NSLog(@"数据格式匹配错误（type of resultData : %@ , type needed is \"NSMutableArray\"）",[resultData class]);
            return;
        }
        
        //如果已经递规到数据的顶层分支，则替换分支中的数据
        if (keySequeue.count == 0) {
            [resultData removeAllObjects];
            
            value = [self getValue:valueExpression sequence:sequence];
            if ([value isKindOfClass:[NSString class]]) {
                value = [value JSONValue];
            }else{
                value = [[value JSONString] JSONValue];
            }
            if ([value isKindOfClass:[NSMutableArray class]]) {
                //匹配 value 为 NSMutableArray,NSNull 丢弃
                [value enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if ((NSNull *)obj != [NSNull null]) {
                        [resultData addObject:obj];
                    }
                }];
            }else{
                NSLog(@"数据格式匹配错误（type of resultData : %@ , type needed is \"NSMutableArray\"）",[value class]);
            }
            return;
        }
        
        
        //默认值表达式索引为 0
        [sequence addObject:[NSNumber numberWithInt:0]];
        if ([currentIndex integerValue] == -1) {
            // currentIndex = -1 ,表示需遍历数组每个对像
            for (int i = 0; i < [resultData count]; i ++) {
                [sequence replaceObjectAtIndex:sequence.count-1 withObject:[NSNumber numberWithInt:i]];
                value = [resultData objectAtIndex:i];
                //递规
                [self adaptSpecialDataToResultData:value WithKeySequeue:[NSMutableArray arrayWithArray:keySequeue] valueExpression:valueExpression sequence:sequence];
            }
        }else{
            // currentIndex != -1 ,表示需更新数组中特定位置的对像
            if ([currentIndex integerValue] >= [resultData count]) {
                NSLog(@"索引超出范围（count of resultData : %i , currentIndex : %@ )",[resultData count],currentIndex);
                NSLog(@"添加 NSNull 补充");
                while ([currentIndex integerValue] >= [resultData count]) {
                    [resultData addObject:[NSNull null]];
                }
            }
            value = [resultData objectAtIndex:[currentIndex integerValue]];
            if (!value || (NSNull *)value == [NSNull null]) {
                if ([keySequeue firstObject] && [[keySequeue firstObject] isKindOfClass:[NSString class]]) {
                    value = [NSMutableDictionary new];
                    
                }else{
                    value = [NSMutableArray new];
                }
                [resultData replaceObjectAtIndex:[currentIndex integerValue] withObject:value];
            }
            //递规
            [self adaptSpecialDataToResultData:value WithKeySequeue:keySequeue valueExpression:valueExpression sequence:sequence];
        }
        
        [sequence removeLastObject];
    }else{
        NSLog(@"数据格式匹配错误（type of resultData : %@ , type needed is \"NSMutableDictionary or NSMutableArray\"）",[resultData class]);
        return;
    }
    
    
}
@end
