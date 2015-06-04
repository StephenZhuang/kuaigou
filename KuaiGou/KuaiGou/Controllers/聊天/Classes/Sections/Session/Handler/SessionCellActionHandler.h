//
//  SessionCellActionHandler.h
//  NIMDemo
//
//  Created by ght on 15-1-23.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SessionLogicDelegate.h"

typedef NS_ENUM(NSInteger, SessionMessageEventID)
{
    SessionMessageEventIDTapVideoCell,                         //点击视频单元格
    SessionMessageEventIDTapPhoneNumber,                       //点击手机号或者电话号
    
    SessionMessageEventIDOpenUrl,                              //根据url打开webview
    SessionMessageEventIDPreviewPicture,                       //点击查看图片
    SessionMessageEventIDPreviewLocation,                      //点击查看位置
    
    SessionMessageEventIDStopAudioByViewVideo,     //查看视频时停止掉正正播放的语音
    SessionMessageEventIDRetrySendMsg,             //重发消息
    SessionMessageEventIDRetryReceiveMsg,          //重收消息
    SessionMessageEventIDDeleteMessage,            //删除消息
    
    SessionMessageEventIDSwitchToSpeekPlayAudio,   //切换到扬声器播放
    SessionMessageEventIDSwitchToListenPlayAudio,  //切换到听筒播放
};

//以下是按不同的参数构造的参数事件对像
@class SessionMsgModel;
@interface SessionCellEventParam : NSObject
@property (nonatomic, assign) SessionMessageEventID eventID;
@property (nonatomic, strong) id                    eventParam;  //用于记录辅助的一些数据对象

- (id)initSessionCellEventParam:(SessionMessageEventID)eID
                         param:(id)param;

@end



@protocol SessionMsgCellEventHandlerProtocol <NSObject>

/**
 *  事件处理
 *
 *  @param param 事件处理的参数
 */
- (void)sessionMessageEventHandle:(SessionCellEventParam*)param;

@end

@interface SessionCellActionHandler : NSObject <SessionMsgCellEventHandlerProtocol>

@property (nonatomic, weak) id<SessionLogicDelegate> logicDelegate;
@end
