//
//  LogManager.h
//  NIM
//
//  Created by Xuhui on 15/4/1.
//  Copyright (c) 2015年 Netease. All rights reserved.
//


@interface LogManager : NSObject

+ (instancetype)sharedManager;

- (void)start;

- (NSString *)log;

- (UIViewController *)demoLogViewController;

- (UIViewController *)sdkLogViewController;
@end
