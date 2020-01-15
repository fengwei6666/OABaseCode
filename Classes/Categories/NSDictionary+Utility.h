//
//  NSMutableDictionary+Utility.h
//  2bulu-QuanZi
//
//  Created by Kent Peifeng Ke on 14-5-26.
//  Copyright (c) 2014年 Lolaage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Utility)

- (void)xtxSetObject:(id)anObject forKey:(id<NSCopying>)aKey;

/**
 *  如果该Object存在,就添加到字典里; 如果不存在则忽略.
 *
 *  @param object 要添加到字典里的Object, 可以为nil.
 *  @param key    相对应的Key.
 */
-(void)setObjectIfExisted:(id)object forKey:(id<NSCopying>)key;

- (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName;
- (void)setFloat:(float)value forKey:(NSString *)defaultName;
- (void)setDouble:(double)value forKey:(NSString *)defaultName;
- (void)setBool:(BOOL)value forKey:(NSString *)defaultName;
- (void)setUInteger:(NSUInteger)value forKey:(NSString *)defaultName;

@end

@interface NSDictionary (Utility)

-(int64_t)longLongValueForKey:(id)key;
-(int32_t)intValueForKey:(id)key;
-(int16_t)shortValueForKey:(id)key;
-(int8_t)charValueForKey:(id)key;
-(uint8_t)unsignedCharValueForKey:(id)key;
-(BOOL)boolValueForKey:(id)key;
-(double)doubleValueForKey:(id)key;
-(float)floatValueForKey:(id)key;
-(NSString *)stringForKey:(id)key;
-(NSArray *)arrayForKey:(id)key;

- (NSInteger)integerForKey:(NSString *)defaultName;
- (float)floatForKey:(NSString *)defaultName;
- (double)doubleForKey:(NSString *)defaultName;
- (BOOL)boolForKey:(NSString *)defaultName;

-(NSString *)jsonString;
- (NSString *)jsonStringNoneSpace;

+(NSDictionary *)parametersFromQuery:(NSString *)query;

//通过json字符串获取字典
+(NSDictionary *)dictWithJsonString:(NSString *)string;

@end


@interface NSMutableDictionary (Append)

//object不能是NSArray及其子类 如果返回YES,则表示追加成功，NO则表示之前没有对应key的object，并把object添加到对应的key
-(BOOL)appendObject:(id)object forKey:(id)key;

@end


