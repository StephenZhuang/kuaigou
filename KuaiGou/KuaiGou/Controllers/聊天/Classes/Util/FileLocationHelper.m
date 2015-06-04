//
//  FileLocationHelper.m
//  NIM
//
//  Created by chrisRay on 15/4/12.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "FileLocationHelper.h"
#import <sys/stat.h>

@interface FileLocationHelper ()
+ (NSString *)filepathForDir: (NSString *)dirname filename: (NSString *)filename;
@end


@implementation FileLocationHelper
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue:@(YES)
                                  forKey:NSURLIsExcludedFromBackupKey
                                   error:&error];
    if(!success)
    {
        DDLogError(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
    
}
+ (NSString *)getAppDocumentPath
{
    static NSString *appDocumentPath = nil;
    if (appDocumentPath == nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        appDocumentPath= [[NSString alloc]initWithFormat:@"%@/",[paths objectAtIndex:0]];
        [FileLocationHelper addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:appDocumentPath]];
    }
    return appDocumentPath;
    
}

+ (NSString *)getAppTempPath
{
    return NSTemporaryDirectory();
}

+ (NSString *)getAppLibraryPath
{
    static NSString *libraryPath = nil;
    if (libraryPath == nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        libraryPath= [[NSString alloc]initWithFormat:@"%@/",[paths objectAtIndex:0]];
    }
    return libraryPath;
}

+ (NSString *)userDirectory
{
    NSString *documentPath = [FileLocationHelper getAppDocumentPath];
    NSString *userID = [NIMSDK sharedSDK].loginManager.currentAccount;
    if ([userID length] == 0)
    {
        DDLogError(@"Error: Get User Directory While UserID Is Empty");
    }
    NSString* userDirectory= [NSString stringWithFormat:@"%@%@/",documentPath,userID];
    if (![[NSFileManager defaultManager] fileExistsAtPath:userDirectory])
    {
        mkdir([userDirectory UTF8String], 0777);
    }
    return userDirectory;
}

+ (NSString *)resourceDir: (NSString *)resouceName
{
    NSString *dir = [NSString stringWithFormat:@"%@%@/",[FileLocationHelper userDirectory],resouceName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dir])
    {
        mkdir([dir UTF8String], 0777);
    }
    return dir;
}


+ (NSString *)filepathForVideo: (NSString *)filename
{
    return [FileLocationHelper filepathForDir:kRDVideo
                                     filename:filename];
}

+ (NSString *)genFilenameWithExt: (NSString *)ext
{
    CFUUIDRef uuid = CFUUIDCreate(nil);
    NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuid);
    CFRelease(uuid);
    NSString *uuidStr = [[uuidString stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
    NSString *name = [NSString stringWithFormat:@"%@",uuidStr];
    return [ext length] ? [NSString stringWithFormat:@"%@.%@",name,ext]:name;
}

+ (NSString *)genTempFilepath: (NSString *)ext
{
    CFUUIDRef uuid = CFUUIDCreate(nil);
    NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuid);
    CFRelease(uuid);
    return [NSString stringWithFormat:@"%@tmp_%@.%@",[FileLocationHelper getAppTempPath],uuidString,ext];
}


#pragma mark - 辅助方法
+ (NSString *)filepathForDir: (NSString *)dirname
                    filename: (NSString *)filename
{
    return [NSString stringWithFormat:@"%@%@",[FileLocationHelper resourceDir:dirname],filename];
}

@end
