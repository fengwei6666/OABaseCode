//
//  NSNull+InternalNullExtention.m
//  2bulu-QuanZi
//
//  Created by 罗亮富 on 15/4/22.
//  Copyright (c) 2015年 Lolaage. All rights reserved.
//

#import "NSNull+InternalNullExtention.h"

@implementation NSNull (InternalNullExtention)

- (void)forwardInvocation:(NSInvocation *)invocation
{
    if ([self respondsToSelector:[invocation selector]]) {
        [invocation invokeWithTarget:self];
    }
    
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *sig = [[self class] instanceMethodSignatureForSelector:selector];
    if(sig == nil) {
        sig = [NSMethodSignature signatureWithObjCTypes:"@^v^c"];
    }
    return sig;
}
@end

@implementation NSNumber (InternalNullExtention)

-(NSUInteger)length
{
    return 0;
}

@end
