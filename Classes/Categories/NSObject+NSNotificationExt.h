//
//  NSObject+NSNotificationExt.h
//  OutdoorAssistantApplication
//
//  Created by 罗亮富 on 15/11/6.
//  Copyright © 2015年 Lolaage. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NotificationHandleBlockType)(id object, NSDictionary *userInfo);

@interface NSObject (NSNotificationExt)

-(void)observeForNotification:(NSString *)notificationName object:(id)object handleBlock:(NotificationHandleBlockType)block;

-(void)unobserveForNotification:(NSString *)notificationName object:(id)object;

-(void)unobserveForAllNotifications;

@end

