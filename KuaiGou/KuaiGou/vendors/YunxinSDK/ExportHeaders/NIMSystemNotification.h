//
//  NIMSystemNotification.h
//  NIMLib
//
//  Created by Netease.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  系统通知类型
 */
typedef NS_ENUM(NSInteger, NIMSystemNotificationType){
    /**
     *  申请入群
     */
    NIMSystemNotificationTypeTeamApply              = 0,
    /**
     *  拒绝入群
     */
    NIMSystemNotificationTypeTeamApplyReject        = 1,
    /**
     *  邀请入群
     */
    NIMSystemNotificationTypeTeamInvite             = 2,
    /**
     *  拒绝入群邀请
     */
    NIMSystemNotificationTypeTeamIviteReject        = 3,
};


/**
 *  系统通知
 */
@interface NIMSystemNotification : NSObject
/**
 *  通知类型
 */
@property (nonatomic,assign,readonly)       NIMSystemNotificationType type;

/**
 *  时间戳
 */
@property (nonatomic,assign,readonly)       NSTimeInterval timestamp;
/**
 *  操作者
 */
@property (nonatomic,copy,readonly)         NSString *sourceID;
/**
 *  目标ID,群ID或者是用户ID
 */
@property (nonatomic,copy,readonly)         NSString *targetID;

/**
 *  被操作者
 */
@property (nonatomic,copy,readonly)         NSString *postscript;

/**
 *  额外信息
 */
@property (nonatomic,strong,readonly)       id extraData;
/**
 *  是否已读
 *  @discussion 修改这个属性并不会修改db中的数据
 */
@property (nonatomic,assign)       BOOL read;

/**
 *  消息处理状态
 *  @discussion 修改这个属性,后台会自动更新db中对应的数据,SDK调用者可以使用这个值来持久化他们对消息的处理结果,默认为0
 */
@property (nonatomic,assign)    NSInteger handleStatus;

@end


/**
 *  自定义系统消息
 *  @discussion 由APP后台发起,经IM服务器透传的系统通知
 */
@interface NIMCustomSystemNotification : NSObject

/**
 *  时间戳
 */
@property (nonatomic,assign,readonly)       NSTimeInterval timestamp;

/**
 *  透传的消息体内容
 */
@property (nonatomic,copy,readonly)  NSString    *content;

@end
