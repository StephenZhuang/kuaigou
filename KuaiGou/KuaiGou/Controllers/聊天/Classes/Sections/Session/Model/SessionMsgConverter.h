//
//  SessionMsgHelper.h
//  NIMDemo
//
//  Created by ght on 15-1-28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NIMSDK.h"
#import "CustomSessionViewHelper.h"

@class LocationPoint;

@interface SessionMsgConverter : NSObject

+ (NIMMessage*)msgWithText:(NSString*)text;

+ (NIMMessage*)msgWithImage:(UIImage*)image;

+ (NIMMessage*)msgWithAudio:(NSString*)filePath;

+ (NIMMessage*)msgWithVideo:(NSString*)filePath;

+ (NIMMessage*)msgWithLocation:(LocationPoint*)locationPoint;

+ (NIMMessage*)msgWithCustom:(CustomMessageType)messageType;

@end