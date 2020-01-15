//
//  NSArray+Utility.h
//  2bulu-NewAssistant
//
//  Created by Kent Peifeng Ke on 4/1/15.
//  Copyright (c) 2015 È≠èÊñ∞Êù∞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Utility)
-(id)la_objectAtIndex:(NSUInteger)index;
-(NSString *)jsonString;

//通过json字符串获取数组
+(NSArray *)arrayWithJsonString:(NSString *)string;
@end


@interface NSMutableSet(Utility)
-(void)la_removeObject:(id)object;

@end
