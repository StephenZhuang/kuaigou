//
//  SessionMsgModel.h
//  NIMDemo
//
//  Created by ght on 15-1-23.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NIMSDK.h"
@class SessionMsgModel;

@interface SessionMsgModelFactory : NSObject

+ (SessionMsgModel*)msgModelWithMsg:(NIMMessage*)msgData;

@end

@interface SessionMsgModel : NSObject

@property (nonatomic, strong) NIMMessage *msgData;

//UI相关逻辑数据
@property (nonatomic, assign) BOOL       showSendMsgStatusView; //msgData.subStatus == isRecipt && isSender && lastOne
@property (nonatomic, assign) BOOL       isAudioPlaying;
@property (nonatomic, assign) BOOL       isFromMe; //是否为发送方
@property (nonatomic, assign) CGSize     contentSize; //内容尺寸

@end

@interface SessionNoticationMsgModel : SessionMsgModel

@property (nonatomic,copy) NSString *notificationFormatedMessage;

@end


@interface SessionTimeModel : NSObject
@property (nonatomic, assign) NSTimeInterval messageTime;
@end