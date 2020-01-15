//
//  NSFileManager+Utility.h
//  officialDemo2D
//
//  Created by Kent Peifeng Ke on 12/22/14.
//  Copyright (c) 2014 AutoNavi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Utility)



///如果指定路径的文件夹不存在, 就创建一个
-(void)createDirectoryIfNotExisted:(NSURL *)directory;

///生成新的临时文件路径, 如果不提供前缀, 则默认使用 temp 作为前缀
-(NSURL *)newTemporaryFileUrlWithPrefix:(NSString *)prefix;

// 判断路径是否是目录
+ (BOOL)isDirectory:(NSString *)filePath;

@end
