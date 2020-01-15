//
//  NSFileManager+Utility.m
//  officialDemo2D
//
//  Created by Kent Peifeng Ke on 12/22/14.
//  Copyright (c) 2014 AutoNavi. All rights reserved.
//

#import "NSFileManager+Utility.h"

extern NSURL * gDocumentDirectory;

extern NSURL *gUserDirectory;

@implementation NSFileManager (Utility)







-(void)createDirectoryIfNotExisted:(NSURL *)directory
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:NSFileProtectionNone
                                                           forKey:NSFileProtectionKey];
    NSError *error;
    if(![fm fileExistsAtPath:directory.path isDirectory:NULL])
    {
        [fm createDirectoryAtURL:directory withIntermediateDirectories:YES attributes:attributes error:&error];
        NSAssert(!error, @"%s CREATE %@ failed %@",__PRETTY_FUNCTION__,directory,error);
    }
    else
    {
        [fm setAttributes:attributes ofItemAtPath:directory.path error:&error];
    }
}





-(NSURL *)newTemporaryFileUrlWithPrefix:(NSString *)prefix{
    NSString *fileName = [NSString stringWithFormat:@"%@_%@.tmp", (prefix.length)?prefix:@"temp", [[NSProcessInfo processInfo] globallyUniqueString]];
    NSURL *fileURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:fileName]];
    return fileURL;
}


+ (BOOL)isDirectory:(NSString *)filePath {
    
    NSNumber *isDirectory;
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    [fileUrl getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil];
    return isDirectory.boolValue;
}

@end
