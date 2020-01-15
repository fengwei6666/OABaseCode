//
//  NSObject+Utility.h
//  OutdoorAssistantApplication
//
//  Created by 罗亮富 on 2017/2/5.
//  Copyright © 2017年 Lolaage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Utility)

/*通过NSDictionary设置实例对象的属性值，例如子类具有 一下属性
 @property (nonatomic,strong) NSString *name;
 @property (nonatomic) NSInteger age;
 可以通过以下NSDictionary来设置这些参数
 @{@"name":@"Andy",@"age":@17};
 */
-(void)setPropertyValuesFromDictionary:(NSDictionary *)valueDictionary;

//检测 对象 是否包含某个属性
+ (BOOL)getVariableWithVarName:(NSString *)name;

#pragma mark- multy delegates

//the delegate object will be added to a weak NSHashTable
-(void)addDelegate:(id)delegate;
-(void)removeDelegate:(id)delegate;
-(NSHashTable *)delegates;
-(void)emunateDelegatesWithBlock:(void (^)(id delegate, BOOL *stop))block;

@end
