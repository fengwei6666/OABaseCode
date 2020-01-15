//
//  NSArray+help.h
//  OutdoorAssistantApplication
//
//  Created by lolaage-A1 on 15/12/14.
//  Copyright © 2015年 Lolaage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (help)

- (BOOL)containAnObjectOfArray:(NSArray*)array;

//self是否被 array 完全包含
- (BOOL)isContainedByArray:(NSArray*)array;

@end
