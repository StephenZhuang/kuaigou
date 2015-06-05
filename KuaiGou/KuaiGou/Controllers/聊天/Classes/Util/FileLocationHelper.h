//
//  FileLocationHelper.h
//  NIM
//
//  Created by chrisRay on 15/4/12.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VideoExt   (@"mp4")
#define RDVideo    (@"video")

@interface FileLocationHelper : NSObject

+ (NSString *)getAppDocumentPath;

+ (NSString *)getAppTempPath;

+ (NSString *)getAppLibraryPath;

+ (NSString *)userDirectory;

+ (NSString *)genFilenameWithExt: (NSString *)ext;

+ (NSString *)genTempFilepath: (NSString *)ext;

+ (NSString *)filepathForVideo: (NSString *)filename;

@end