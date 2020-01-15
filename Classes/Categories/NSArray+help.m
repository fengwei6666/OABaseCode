//
//  NSArray+help.m
//  OutdoorAssistantApplication
//
//  Created by lolaage-A1 on 15/12/14.
//  Copyright © 2015年 Lolaage. All rights reserved.
//

#import "NSArray+help.h"
#import <objc/runtime.h>

@implementation NSArray (help)


//暂时数组元素支持NSNumber
- (BOOL)containAnObjectOfArray:(NSArray*)array
{
    BOOL isContain = NO;
    for (NSNumber *num1 in array)
    {
        for (NSNumber *num2 in self)
        {
            if ([num1 isEqualToNumber:num2])
            {
                isContain = YES;
            }
        }
    }
    
    return isContain;
}


- (BOOL)isContainedByArray:(NSArray*)array
{
    for (NSNumber *num1 in self)
    {
        BOOL isContain = NO;
        for (NSNumber *num2 in array)
        {
            if ([num1 isEqualToNumber:num2])
            {
                isContain = YES;
            }
        }
        
        if (!isContain)
        {
            return NO;
        }
    }
    
    return YES;
}




@end
