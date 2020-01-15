//
//  NSTimer+Weak.m
//  OutdoorAssistantApplication
//
//  Created by Li Ya tu on 15/9/8.
//  Copyright (c) 2015年 Lolaage. All rights reserved.
//

#import "NSTimer+Weak.h"

@implementation NSTimer (Weak)

+ (NSTimer *)lol_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                          block:(void(^)(void))block
                                        repeats:(BOOL)repeats
{
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(lol_blockInvoke:)
                                       userInfo:[block copy]
                                        repeats:repeats];
}


+ (void)lol_blockInvoke:(NSTimer*)timer {
    void (^block)(void) = timer.userInfo;
    if (block) {
        block();
    }
}

@end
