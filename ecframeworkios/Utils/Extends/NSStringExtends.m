//
//  NSStringExtends.m
//  Extends
//
//  Created by Alix on 9/24/12.
//  Copyright (c) 2012 ecloud. All rights reserved.
//

#import "NSStringExtends.h"
#import "NSDataExtends.h"
#import "Constants.h"


@implementation NSString (Extends)
#pragma mark - 
- (BOOL)isWhitespaceOrNewLine{
    NSCharacterSet* whitespaces = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSUInteger index=0; index < self.length; index++) {
        unichar c = [self characterAtIndex:index];
        if (NO == [whitespaces characterIsMember:c]) {
            return NO;
        }
    }
    return YES;
}

//将NSString转化为NSArray或者NSDictionary
- (id) JSONValue
{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    return error ? nil : result;
}

#pragma mark - 
- (BOOL)isEmpty{
    return (([self length] > 0 && ![self isEqualToString:@"null"] && ![self isEqualToString:@"undefined"])? NO : YES);
}

#pragma mark - 
- (NSString*)md5Hash{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5Hash];
}

#pragma mark - 
- (NSString*)sha1Hash{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha1Hash];
}

#pragma mark - 
+ (NSString*)appDoucmentsPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

#pragma mark -
+ (NSString*)appLibraryPath{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString* basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

#pragma mark-
+ (NSString *)appConfigPath
{
    if (EC_DEBUG_ON) {
        return [self appLibraryPath];
    }else{
        return [NSString stringWithFormat:@"%@/assets",[[NSBundle mainBundle] bundlePath]];
    }
}
#pragma mark-
+ (NSString *)appStaticResourcePath
{
    if (EC_DEBUG_ON) {
        return [self appLibraryPath];
    }else{
        return [NSString stringWithFormat:@"%@/config",[[NSBundle mainBundle] bundlePath]];
    }
}

#pragma mark - 
+ (NSString*)appCachesPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

#pragma mark - 
+ (NSString*)appTmpPath{
    return NSTemporaryDirectory();
}

#pragma mark - 
+ (NSString*)filepathWithRootDirectory:(NSString *)rootDir fileName:(NSString *)fileName{
    if (nil != rootDir && nil != fileName && [rootDir length] > 0 && [fileName length] > 0) {
        return [rootDir stringByAppendingPathComponent:fileName];
    }
    return nil;
}

#pragma mark -
- (NSString*)urlEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding{
    return ((__bridge  NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), encoding));
}

#pragma mark - 
- (NSString*)urlEncodedString{
    return [self urlEncodedStringWithCFStringEncoding:kCFStringEncodingUTF8];
}
#pragma mark - 
- (NSString*)urlString{
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
#pragma mark - 
- (NSDictionary*)queryContentsUsingEncoding:(NSStringEncoding)encoding{
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:self];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 1 || kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSMutableArray* values = [pairs objectForKey:key];
            if (nil == values) {
                values = [NSMutableArray array];
                [pairs setObject:values forKey:key];
            }
            if (kvPair.count == 1) {
                [values addObject:[NSNull null]];
                
            } else if (kvPair.count == 2) {
                NSString* value = [[kvPair objectAtIndex:1]
                                   stringByReplacingPercentEscapesUsingEncoding:encoding];
                [values addObject:value];
            }
        }
    }
    return [NSDictionary dictionaryWithDictionary:pairs];
}

#pragma mark - 网络请求参数聚合
+ (NSString*)polymerizeRequestParams:(NSDictionary*)params{
    if (nil == params) {
        return nil;
    }
    
	NSArray* keys = [params.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    if ([keys count] == 0) {
        return nil;
    }
    NSMutableString* joined = [[NSMutableString alloc] init];
	for (id obj in [keys objectEnumerator]) {
		id value = [params valueForKey:obj];
		if ([value isKindOfClass:[NSString class]]) {
			[joined appendString:obj];
			[joined appendString:@"="];
			[joined appendString:value];
            [joined appendString:@"&"];
		} else if ([value isKindOfClass:[NSNumber class]]) {
            [joined appendString:obj];
			[joined appendString:@"="];
			[joined appendString:[NSString stringWithFormat:@"%d", [value intValue]]];
            [joined appendString:@"&"];
        }
	}
    
    if ([joined hasSuffix:@"&"]) {
        NSString* retStr = [joined substringToIndex:[joined length]-1];
        return retStr;
    }
    if ([joined isEmpty]) {
        return nil;
    }
    return joined;
}

#pragma mark -
- (NSString*)addingPercentEscapesUsingEncoding:(NSStringEncoding)encoding{
    return [self stringByAddingPercentEscapesUsingEncoding:encoding];
}

#pragma mark - 
- (NSString*)addingPercentEscapes{
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - 
+ (NSString*)UDID{
    return [UIDevice UDID];
}


#pragma mark - 根据时间和随机值创建calllID
+(NSString*)randomCallID{
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"ssyyyyMMmmHHdd"];
    return [NSString stringWithFormat:@"%@%ld",[format stringFromDate:[NSDate date]], random() & 0xFFFF];
}
#pragma mark- 一个基于时间的网络请求中用到的id
+ (NSString *) randomString
{
    return [[self class] randomCallID];
}
#pragma mark - 根据参数生成sig
+ (NSString*)calcSigHashWithMehtodName:(NSString*)method
                                callID:(NSString*)callID
                                apiKey:(NSString*)apiKey
                                secret:(NSString*)secret{
    //    NSString* aduexStr = [NSString stringWithFormat:@"api_key=%@call_id=%@method=%@%@",apiKey, callID, method, secret];
    NSString* aduexStr = [NSString stringWithFormat:@"api_key=%@call_id=%@method=%@%@",apiKey, callID, method, secret];
    return [aduexStr md5Hash];
}
#pragma mark - 获取查询课程时间参数
+ (NSString*)YearAndMouth{
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM"];
    return [NSString stringWithFormat:@"%@",[format stringFromDate:[NSDate date]]];
}

- (BOOL)contain:(NSString*)string{
    if ([self rangeOfString:string].location != NSNotFound) {
        return YES;
    }
    return NO;
}
#pragma mark - 去头去尾
- (NSString*) slim{
    if ([self length] <=2) {
        return nil;
    }
    return [self substringWithRange:NSMakeRange(1, [self length]-2)];
}

- (NSString*) slimH{
    if ([self length] <= 1) {
        return nil;
    }
    return [self substringFromIndex:1];
}

- (NSString*) slimE{
    if ([self length] <= 1) {
        return nil;
    }
    return [self substringToIndex:[self length]-1];
}

- (NSString* )transfer{
    NSString* string = [self compress];
    string = [string stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    return  [string stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
}
- (NSString*)compress{
    return [[self componentsSeparatedByString:@"\n"] componentsJoinedByString:@" "];
}

- (BOOL)isExpression{
    if (([self hasPrefix:@"{_"] || [self hasPrefix:@"{#"] || [self hasPrefix:@"{$"]) && [self hasSuffix:@"}"]) {
        return YES;
    }
    return NO;
}

- (NSString*)featureString{
    if ([self isEmpty]) 
        return nil;
    return [NSString stringWithFormat:@"%@%@",[[self substringToIndex:1] uppercaseString],[self substringFromIndex:1]];
}
- (NSString *) toCamelCase:(BOOL)firstUp
{
    if ([self isEmpty]) {
        return nil;
    }
    NSString* firstWord;
    NSString* temp = [NSString stringWithFormat:@"%@",self];
    while ([temp rangeOfString:@"_"].location != NSNotFound) {
        firstWord = [temp substringWithRange:NSMakeRange([temp rangeOfString:@"_"].location, 2)];
        temp = [temp stringByReplacingOccurrencesOfString:firstWord withString:[[firstWord uppercaseString] substringFromIndex:1]];
    }
    if (firstUp) {
        return [temp featureString];
    }
    return temp;
}

- (NSString *) toUnderLineCase 
{
    if ([self isEmpty]) {
        return nil;
    }
    NSString* temp = [NSString stringWithFormat:@"%@",self];
    
    for (int i = 1; i < self.length; i ++) {
        char c = [self characterAtIndex:i];
        if (c < 91 && c > 64) {
            temp =  [temp stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%c",c] withString:[NSString stringWithFormat:@"_%c",c+32]];
        }
    }
    return [NSString stringWithFormat:@"%@%@",[[temp substringToIndex:1] lowercaseString],[temp substringFromIndex:1]];
}

#pragma mark-
+ (NSString *)stringWithFileName:(NSString *)filename type:(NSString *)type
{
    NSString* filepath = [[NSBundle mainBundle] pathForResource:filename ofType:type];
    return [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
}

#pragma mark-  range 正则
- (NSRange) firstRangeOfRegex:(NSString *)regexString
{
    NSError *error = NULL;
    NSRange range;
    range.length = 0;
    range.location = 0;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        
    }
    NSTextCheckingResult *result = [regex firstMatchInString:self options:0 range:NSMakeRange(0, [self length])];
    if (result.range.location == NSIntegerMax) {
        NSLog(@"NSRegularExpression not found : %@  return <NSRange  ; lenth = 0, location = 0>",error);
        return range;
    }
    return result.range;
}

#pragma mark- subString 正则
- (NSString *) substringWithRegex:(NSString *)regexString
{
    NSRange range = [self firstRangeOfRegex:regexString];
    return [self substringWithRange:range];
}

#pragma mark- 使用 正则 替换字符串
- (NSString *) stringByReplacingOccurrencesOfString:(NSString *)target withRegex:(NSString *)regexString byString:(NSString *)newString
{
    NSString* subString = [self substringWithRegex:regexString];
    return [self stringByReplacingOccurrencesOfString:subString withString:newString];
}

@end




#pragma mark - 获取设备号
@implementation UIDevice (UDID)
+ (NSString*)UDID{
    //TODO: 变换存放UDID 位置
    //    NSString* uuid = [ECKeyChain deviceUDID];
    //    if (uuid && uuid.length) {
    //        return uuid;
    //    }
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"com.ecloudiot.ios.applications.deviceudid"]) {
        return [userDefaults objectForKey:@"com.ecloudiot.ios.applications.deviceudid"];
    }
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef strRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    [userDefaults setObject:((__bridge NSString*)strRef) forKey:@"com.ecloudiot.ios.applications.deviceudid"];
    return ((__bridge  NSString*)strRef);
}
@end
