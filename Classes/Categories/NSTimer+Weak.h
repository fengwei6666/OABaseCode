//
//  NSTimer+Weak.h
//  OutdoorAssistantApplication
//
//  Created by Li Ya tu on 15/9/8.
//  Copyright (c) 2015年 Lolaage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Weak)

+ (NSTimer *)lol_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                          block:(void(^)(void))block
                                        repeats:(BOOL)repeats;

@end
