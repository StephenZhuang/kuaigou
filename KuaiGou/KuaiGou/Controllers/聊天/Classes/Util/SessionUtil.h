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

@interface SessionUtil : NSObject

+ (CGSize)getImageSizeWithImageOriginSize:(CGSize)originSize
                                  minSize:(CGSize)imageMinSize
                                  maxSize:(CGSize)imageMaxSize;

+ (NSString*)showTimeInSession:(NSTimeInterval) messageTime;

//接收时间格式化
+ (NSString*)showTime:(NSTimeInterval) msglastTime;

+ (NSString *)currentUsrId;

+ (NSString *)currectUsrPassword;

+ (void)sessionWithInputURL:(NSURL*)inputURL
                  outputURL:(NSURL*)outputURL
               blockHandler:(void (^)(AVAssetExportSession*))handler;

@end
