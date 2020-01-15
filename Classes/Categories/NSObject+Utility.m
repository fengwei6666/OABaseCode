//
//  NSObject+Utility.m
//  OutdoorAssistantApplication
//
//  Created by 罗亮富 on 2017/2/5.
//  Copyright © 2017年 Lolaage. All rights reserved.
//

#import "NSObject+Utility.h"
#import <objc/runtime.h>

@implementation NSObject (Utility)

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    [self setValuesForKeysWithDictionary:dictionary];
    return self;
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [self init];
    [self setValuesForKeysWithDictionary:dict];
    return self;
}

- (void)setValue:(nullable id)value forUndefinedKey:(NSString *)key
{
    //do nothing
   // NSLog(@"set %@ for undefined key:%@",value,key);
}



//检测 对象 是否包含某个属性
+ (BOOL)getVariableWithVarName:(NSString *)name
{
    unsigned int outCount, i;
    Ivar *ivars = class_copyIvarList(self, &outCount);
    BOOL ret = NO;
    for (i = 0; i < outCount; i++) {
        Ivar property = ivars[i];
        NSString *keyName = [NSString stringWithCString:ivar_getName(property) encoding:NSUTF8StringEncoding];
        keyName = [keyName stringByReplacingOccurrencesOfString:@"_" withString:@""];
        if ([keyName isEqualToString:name]) {
            ret = YES;
            break;
        }
    }
    
    free(ivars);
    
    return ret;
}

/*
 通过NSDictionary设置实例对象的属性值，例如子类具有 一下属性
 @property (nonatomic,strong) NSString *name;
 @property (nonatomic) NSInteger age;
 可以通过以下NSDictionary来设置这些参数
 @{@"name":@"Andy",@"age":@17};
*/
-(void)setPropertyValuesFromDictionary:(NSDictionary *)valueDictionary
{
    [valueDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {

        NSString *propertyString = key;
        NSString *firstLetter = [propertyString substringWithRange:NSMakeRange(0, 1)];
        NSString *s1 = [firstLetter uppercaseString];
        NSString *s2 = @"";
        if(propertyString.length > 1)
            s2 = [propertyString substringFromIndex:1];
        
        NSString *setter = [NSString stringWithFormat:@"set%@%@:",s1,s2];
        SEL setterMtd = NSSelectorFromString(setter);
        if([self respondsToSelector:setterMtd])//优先选择setter方法
        {
            NSMethodSignature *mtdSig = [self methodSignatureForSelector:setterMtd];
            const char *argType = [mtdSig getArgumentTypeAtIndex:2];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:mtdSig];
            
            if( *argType == '@'
               || *argType == '*'
               || *argType == '['
               || *argType == ':')
            {
                [invocation setArgument:&obj atIndex:2];
            }
            else if( *argType == 'B'
                    || *argType == 'c')
            {
                char numberValue = [obj intValue];//这里不要用charValue，因为NSString不支持charValue方法
                [invocation setArgument:&numberValue atIndex:2];
            }
            else if( *argType == 'q')
            {
                long long numberValue = [obj longLongValue];
                [invocation setArgument:&numberValue atIndex:2];
            }
            else if( *argType == 's')
            {
                short numberValue = [obj shortValue];
                [invocation setArgument:&numberValue atIndex:2];
            }
            else if( *argType == 'f')
            {
                float numberValue = [obj floatValue];
                [invocation setArgument:&numberValue atIndex:2];
            }
            else if( *argType == 'd')
            {
                double numberValue = [obj doubleValue];
                [invocation setArgument:&numberValue atIndex:2];
            }
            else if( *argType == 'l')
            {
                long numberValue = [obj longValue];
                [invocation setArgument:&numberValue atIndex:2];
            }

            invocation.target = self;
            invocation.selector = setterMtd;
        
            [invocation invoke];

        }
        else if([[self class]getVariableWithVarName:key])//没有setter方法的情况下才进行实例变量赋值
        {
            [self setValue:obj forKey:[NSString stringWithFormat:@"_%@",key]];
        }
        
    }];
}


#pragma mark- multy delegates
static char delegatesKey;

-(void)addDelegate:(id)delegate
{
    NSHashTable *tb = self.delegates;
    @synchronized(tb)
    {
        [tb addObject:delegate];
    }
}
-(void)removeDelegate:(id)delegate
{
    NSHashTable *tb = self.delegates;
    @synchronized(tb)
    {
        [tb removeObject:delegate];
    }
}
-(NSHashTable *)delegates
{
    NSHashTable *hashTable = objc_getAssociatedObject(self, &delegatesKey);
    if(!hashTable)
    {
        hashTable = [NSHashTable weakObjectsHashTable];
        objc_setAssociatedObject(self, &delegatesKey, hashTable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return hashTable;
}

-(void)emunateDelegatesWithBlock:(void (^)(id delegate, BOOL *stop))emBlock
{
    NSHashTable *tb = self.delegates;
    @synchronized(tb)
    {
        @autoreleasepool//放在循环外面是为delegates中的元素在没有其他引用的时候被销毁，主要目的并非为了降低内存峰值
        {
            BOOL shouldBreak = NO;
            for(id d in tb)
            {
                emBlock(d,&shouldBreak);
                if(shouldBreak)
                    break;
            }
        }
    }
}

@end
