//
//  SessionMsgHelper.m
//  NIMDemo
//
//  Created by ght on 15-1-28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "SessionMsgConverter.h"
#import "LocationPoint.h"

@implementation SessionMsgConverter


+ (NIMMessage*)msgWithText:(NSString*)text
{
    NIMMessage *textMessage = [[NIMMessage alloc] init];
    textMessage.text        = text;
    textMessage.timestamp   = [SessionMsgConverter currentTime];
    return textMessage;
}

+ (NIMMessage*)msgWithImage:(UIImage*)image
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    NIMImageObject * imageObject = [[NIMImageObject alloc] initWithImage:image];
    imageObject.displayName = [NSString stringWithFormat:@"图片发送于%@",dateString];
    NIMImageOption *option = [[NIMImageOption alloc] init];
    option.compressQuality = 0.8;
    NIMMessage *message          = [[NIMMessage alloc] init];
    message.messageObject        = imageObject;
    message.timestamp      = [SessionMsgConverter currentTime];
    return message;
}

+ (NIMMessage*)msgWithAudio:(NSString*)filePath
{
    NIMAudioObject *audioObject = [[NIMAudioObject alloc] initWithSourcePath:filePath];
    NIMMessage *message = [[NIMMessage alloc] init];
    message.messageObject = audioObject;
    message.timestamp   = [SessionMsgConverter currentTime];
    return message;
}

+ (NIMMessage*)msgWithVideo:(NSString*)filePath
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    NIMVideoObject *videoObject = [[NIMVideoObject alloc] initWithSourcePath:filePath];
    videoObject.displayName = [NSString stringWithFormat:@"视频发送于%@",dateString];
    NIMMessage *message = [[NIMMessage alloc] init];
    message.messageObject = videoObject;
    message.timestamp   = [SessionMsgConverter currentTime];
    return message;
}

+ (NIMMessage*)msgWithLocation:(LocationPoint*)locationPoint{
    NIMLocationObject *locationObject = [[NIMLocationObject alloc] initWithLatitude:locationPoint.coordinate.latitude Longitude:locationPoint.coordinate.longitude address:locationPoint.title];
    NIMMessage *message               = [[NIMMessage alloc] init];
    message.messageObject             = locationObject;
    message.timestamp                 = [SessionMsgConverter currentTime];
    return message;
}

+ (NIMMessage*)msgWithCustom:(CustomMessageType)messageType{
    NIMCustomObject *customObject = [[NIMCustomObject alloc] init];
    switch (messageType) {
        case CustomMessageTypeJanKenPon:{
            NSString *content = [CustomSessionViewHelper janKenPonContent];
            customObject.content = content;
            break;
        }
        default:
            return nil;
            break;
    }
    NIMMessage *message               = [[NIMMessage alloc] init];
    message.messageObject             = customObject;
    message.timestamp                 = [SessionMsgConverter currentTime];
    return message;
}

+ (NSTimeInterval)currentTime{
    return [[NSDate date] timeIntervalSince1970];
}
@end
