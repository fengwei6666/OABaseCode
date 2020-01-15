//
//  NSMutableDictionary+Utility.m
//  2bulu-QuanZi
//
//  Created by Kent Peifeng Ke on 14-5-26.
//  Copyright (c) 2014年 Lolaage. All rights reserved.
//

#import "NSDictionary+Utility.h"
#import "NSArray+Utility.h"

@implementation NSMutableDictionary (Utility)

- (void)xtxSetObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if ( anObject == nil ) {
        [self setObject:@"" forKey:aKey];
    }
    else{
        [self setObject:anObject forKey:aKey];
    }
}

-(void)setObjectIfExisted:(id)object forKey:(id<NSCopying>)key{
    if(object){
        [self setObject:object forKey:key];
    }
}

- (void)setUInteger:(NSUInteger)value forKey:(NSString *)defaultName
{
    [self setObject:[NSString stringWithFormat:@"%zu",(unsigned long)value] forKey:defaultName];
}

- (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName
{
    [self setObject:[NSString stringWithFormat:@"%ld",(long)value] forKey:defaultName];
}

- (void)setFloat:(float)value forKey:(NSString *)defaultName
{
    [self setObject:[NSString stringWithFormat:@"%f",(float)value] forKey:defaultName];
}
- (void)setDouble:(double)value forKey:(NSString *)defaultName
{
    [self setObject:[NSString stringWithFormat:@"%lf", isnan(value) ? 0 : (double)value] forKey:defaultName];
}
- (void)setBool:(BOOL)value forKey:(NSString *)defaultName
{
    if(value)
        [self setObject:@"1" forKey:defaultName];
    else
        [self setObject:@"0" forKey:defaultName];
}

@end

@implementation NSDictionary (Utility)

-(int64_t)longLongValueForKey:(id)key
{
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]])
    {
        return [obj longLongValue];
    }
    return 0;
}
-(int32_t)intValueForKey:(id)key
{
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]])
    {
        return [obj intValue];
    }
    return 0;
}

-(int16_t)shortValueForKey:(id)key
{
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSNumber class]])
    {
        return [obj shortValue];
    }else if ([obj isKindOfClass:[NSString class]]){
        return (int16_t)[(NSString *)obj intValue];
    }
    return 0;
}
-(int8_t)charValueForKey:(id)key
{
    id obj = [self objectForKey:key];
    if ( [obj isKindOfClass:[NSNumber class]])
    {
        return [obj charValue];
    }else if ([obj isKindOfClass:[NSString class]]){
        return (int8_t)[(NSString *)obj intValue];
    }
    return 0;
}

- (uint8_t)unsignedCharValueForKey:(id)key
{
    id obj = [self objectForKey:key];
    if ( [obj isKindOfClass:[NSNumber class]])
    {
        return [obj unsignedCharValue];
    }else if ([obj isKindOfClass:[NSString class]]){
        return (uint8_t)[(NSString *)obj intValue];
    }
    return 0;

}
-(BOOL)boolValueForKey:(id)key
{
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]])
    {
        return [obj boolValue];
    }
    return 0;
}

-(double)doubleValueForKey:(id)key
{
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]])
    {
        return [obj doubleValue];
    }
    return 0;
}

-(float)floatValueForKey:(id)key
{
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]])
    {
        return [obj floatValue];
    }
    return 0;
}

-(NSString *)stringForKey:(id)key
{
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSNull class]]) {
        return nil;
    }
    if ([obj isKindOfClass:[NSString class]]) {
        return obj;
    }
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@",obj];
    }
    return nil;
}

-(NSArray *)arrayForKey:(id)key;
{
	id obj = [self objectForKey:key];
    
    if ([obj isKindOfClass:[NSArray class]]) {
        if ([(NSArray *) obj containsObject:[NSNull null]]) {
            return nil;
        }
        return obj;
    }
    
    if([obj isKindOfClass:[NSString class]])
    {
        NSArray *dataArray = [NSArray arrayWithJsonString:obj];
        if (dataArray.count > 0) {
            obj = dataArray;
            return obj;
        }
        
    }

    return nil;
}
- (NSInteger)integerForKey:(NSString *)defaultName
{
    return [self longLongValueForKey:defaultName];
}
- (float)floatForKey:(NSString *)defaultName
{
    return [self floatValueForKey:defaultName];
}
- (double)doubleForKey:(NSString *)defaultName
{
    return [self doubleValueForKey:defaultName];
}
- (BOOL)boolForKey:(NSString *)defaultName
{
    return [self boolValueForKey:defaultName];
}





-(NSString *)jsonString
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:nil];
    if (!jsonData)
        return nil;
    else
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

- (NSString *)jsonStringNoneSpace {
    
    NSJSONWritingOptions option = NSJSONWritingPrettyPrinted;
    if (@available(iOS 11.0, *)) {
        option = NSJSONWritingSortedKeys;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:option // Pass 0 if you don't care about the readability of the generated string
                                                         error:nil];
    if (! jsonData)
        return nil;
    else
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


+(NSDictionary *)parametersFromQuery:(NSString *)query{
    
    NSArray * parameterStringArray = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary * paramDict = [[NSMutableDictionary alloc] initWithCapacity:parameterStringArray.count];
    for (NSString * paramString in parameterStringArray) {
        
        NSScanner *scanner = [NSScanner scannerWithString:paramString];
        
        NSString *key, *value;
        [scanner scanUpToString:@"=" intoString:&key];
        [scanner scanString:@"=" intoString:nil];
        [scanner scanUpToString:@"" intoString:&value];
        if(key && value)
            [paramDict setObject:value forKey:key];
    }
    return paramDict;
}

//通过json字符串获取字典
+(NSDictionary *)dictWithJsonString:(NSString *)string
{
    if (string == nil || ![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    
    if(err) {
        NSLog(@"json解析失败：%@",err);
        
        return nil;
    }
    
    return dic;
}

@end


@implementation NSMutableDictionary (Append)

-(BOOL)appendObject:(id)object forKey:(id)key
{
    id obj = [self objectForKey:key];
    if(obj)
    {
        if([obj isKindOfClass:[NSMutableArray class]])
        {
            NSMutableArray *blockArray = (NSMutableArray *)obj;
            [blockArray addObject:object];
        }
        else
        {
            NSMutableArray *blockArray = [NSMutableArray array];
            [blockArray addObject:obj];
            [blockArray addObject:object];
            [self setObject:blockArray forKey:key];
        }
        
        return YES;
    }
    else
    {
        [self setObject:object forKey:key];
        
        return NO;
    }
    
}

@end
