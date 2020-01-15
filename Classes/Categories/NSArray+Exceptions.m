//
//  NSMutableArray+Exceptions.m
//  OutdoorAssistantApplication
//
//  Created by 罗亮富 on 2018/4/24.
//  Copyright © 2018年 Lolaage. All rights reserved.
//

#import "NSArray+Exceptions.h"
#import <objc/runtime.h>

@implementation NSMutableArray (Exceptions)


+ (void)load
{
    [self overwriteRemoveObjectsInRange];
}
//因为在ios11系统运行时apple的MapKit发生了removeObjectsInRange:越界的闪退，所以这里做一下方法替换
+(void)overwriteRemoveObjectsInRange
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL originalSelector = @selector(removeObjectsInRange:);
        SEL swizzledSelector = @selector(mob_removeObjectsInRange:);
        Class cls = NSClassFromString(@"__NSArrayM"); //这里如果使用self的话，交换不成功，很可能NSMutableArray只是__NSArrayM的子类
        if(cls)
            method_exchangeImplementations(class_getInstanceMethod(cls, originalSelector), class_getInstanceMethod(self, swizzledSelector));
    });
}

-(void)xtxAddObject:(id)anObject{
    if(anObject){
        [self addObject:anObject];
    }
    
}

//ios11系统，mapkit越界调用removeObjectsInRange:
-(void)mob_removeObjectsInRange:(NSRange)range
{
    NSUInteger c = self.count;
    if(range.location >= c)
        return;

    if((range.location + range.length) > c)
        range.length = c - range.location;

    [self mob_removeObjectsInRange:range];
}


@end

@implementation NSArray (Exceptions)

- (nullable id)xtxObjectAtIndex:(NSUInteger)index
{
    id obj = nil;
    if (self.count > index)
    {
        obj = [self objectAtIndex:index];
    }
    
    return obj;
}

@end
