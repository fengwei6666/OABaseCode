//
//  NSMutableArray+Exceptions.h
//  OutdoorAssistantApplication
//
//  Created by 罗亮富 on 2018/4/24.
//  Copyright © 2018年 Lolaage. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface NSMutableArray (Exceptions)

-(void)xtxAddObject:(id)anObject;

//因为在ios11系统运行时apple的MapKit发生了removeObjectsInRange:越界的闪退，所以这里做一下方法替换
+(void)overwriteRemoveObjectsInRange;

@end


@interface NSArray (Exceptions)
- (nullable id)xtxObjectAtIndex:(NSUInteger)index;
@end
NS_ASSUME_NONNULL_END
