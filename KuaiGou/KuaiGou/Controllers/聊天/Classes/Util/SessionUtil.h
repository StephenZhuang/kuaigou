//
//  NIMUtil.h
//  NIMDemo
//
//  Created by ght on 15-1-27.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "NIMSDK.h"
#import "NIMNotificationObject.h"

@interface SessionUtil : NSObject

+ (CGSize)getImageSizeWithImageOriginSize:(CGSize)originSize
                                  minSize:(CGSize)imageMinSize
                                  maxSize:(CGSize)imageMaxSize;

+ (NSString*)showNickInMessage:(NIMMessage *)message;

+ (NSString*)showNick:(NSString*)uid inSession:(NIMSession*)session;

+ (NSString*)showNick:(NSString*)uid teamId:(NSString*)teamId;


//接收时间格式化
+ (NSString*)showTime:(NSTimeInterval) msglastTime showDetail:(BOOL)showDetail;

+ (NSString *)currentUsrId;

+ (NSString *)currectUsrPassword;

//网络电话回单在消息上显示的内容
+ (NSString *)netcallMessageText:(NIMNotificationObject *)object;


+ (void)sessionWithInputURL:(NSURL*)inputURL
                  outputURL:(NSURL*)outputURL
               blockHandler:(void (^)(AVAssetExportSession*))handler;

@end
