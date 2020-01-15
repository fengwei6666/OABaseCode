//
//  NSError+Utility.m
//  2bulu-NewAssistant
//
//  Created by Kent Peifeng Ke on 3/23/15.
//  Copyright (c) 2015 È≠èÊñ∞Êù∞. All rights reserved.
//

#import "NSError+Utility.h"

NSString * const LA_NETWORK_ERROR_DOMAIN = @"LA_NETWORK_ERROR_DOMAIN";
@implementation NSError (Utility)
+(instancetype)errorFromJsonObject:(id)object
{
    if ([object isKindOfClass:[NSDictionary class]] == NO) {
        return nil;
    }
    
    NSDictionary * dict = object;
    NSInteger code = [[dict objectForKey:@"errCode"] intValue];
    NSString * message = [dict objectForKey:@"errMsg"];
    if (!message) {
        return nil;
    }
    
    return [self errorWithDomain:LA_NETWORK_ERROR_DOMAIN code:code userInfo:@{NSLocalizedDescriptionKey:message}];
    
}

@end
