//
//  LogManager.m
//  NIM
//
//  Created by Xuhui on 15/4/1.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "LogManager.h"
#import "LogViewController.h"
#import "NIMSDK.h"

@protocol NIMSDKPrivateProtocol <NSObject>
- (UIViewController *)logViewController;

@end

@interface LogManager () {
    DDFileLogger *_fileLogger;
}

@end

@implementation LogManager

+ (instancetype)sharedManager
{
    static LogManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LogManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        [DDLog addLogger:[DDASLLogger sharedInstance]];
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
        _fileLogger = [[DDFileLogger alloc] init];
        _fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
        _fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
        [DDLog addLogger:_fileLogger];
    }
    return self;
}

- (void)start
{
    DDLogInfo(@"App Started SDK Version %@",[[NIMSDK sharedSDK] sdkVersion]);
}

- (NSString *)log {
    return [NSString stringWithContentsOfFile:_fileLogger.currentLogFileInfo.filePath encoding:NSUTF8StringEncoding error:0];
}

- (UIViewController *)demoLogViewController {
    LogViewController *vc = [[LogViewController alloc] initWithNibName:nil bundle:nil];
    return vc;
}

- (UIViewController *)sdkLogViewController
{
    UIViewController *vc = nil;
    NIMSDK *sdk = [NIMSDK sharedSDK];
    if ([sdk respondsToSelector:@selector(logViewController)])
    {
        vc = [(id<NIMSDKPrivateProtocol>)sdk logViewController];
    }
    return vc;
}

@end
