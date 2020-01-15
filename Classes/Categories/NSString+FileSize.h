//
//  NSString+FileSize.h
//  officialDemo2D
//
//  Created by Kent Peifeng Ke on 12/23/14.
//  Copyright (c) 2014 AutoNavi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FileSize)

+ (NSString *)formatFileSize:(unsigned long long)size;
- (unsigned long long)fileSizeFromFormat;

@end
