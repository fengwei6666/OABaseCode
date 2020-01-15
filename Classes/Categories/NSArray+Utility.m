//
//  NSArray+Utility.m
//  2bulu-NewAssistant
//
//  Created by Kent Peifeng Ke on 4/1/15.
//  Copyright (c) 2015 È≠èÊñ∞Êù∞. All rights reserved.
//

#import "NSArray+Utility.h"

@implementation NSArray (Utility)

//发现了一个闪退异常 -[NSMutableRLEArray revceiveSeverPushHandle:]: unrecognized selector sent to instance 0x1702033c0\
估计是系统运行时方法调用的问题，实际代码中并未发现有主动调用revceiveSeverPushHandle:方法，都是在类的内部注册的通知
-(void)revceiveSeverPushHandle:(id)obj
{
    // do nothing
}

-(id)la_objectAtIndex:(NSUInteger)index
{
    return (index<self.count)?self[index]:nil;
}

-(NSString *)jsonString
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:nil];
    if (! jsonData)
        return nil;
    else
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

//通过json字符串获取数组
+(NSArray *)arrayWithJsonString:(NSString *)string
{
    if (string == nil || ![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    
    if(err) {
        return nil;
    }
    
    return arr;
}


@end

@implementation NSMutableSet (Utility)

-(void)la_removeObject:(id)object{

    if (object) {
        [self removeObject:object];
    }
}




@end
