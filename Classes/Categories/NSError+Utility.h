//
//  NSError+Utility.h
//  2bulu-NewAssistant
//
//  Created by Kent Peifeng Ke on 3/23/15.
//  Copyright (c) 2015 È≠èÊñ∞Êù∞. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const LA_NETWORK_ERROR_DOMAIN;
@interface NSError (Utility)

+(instancetype)errorFromJsonObject:(id)object;
@end
