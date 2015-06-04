//
//  NIMNotificationObject.h
//  NIMLib
//
//  Created by Netease.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "NIMMessageObjectProtocol.h"



/**
 *  通知内容
 */
@interface NIMNotificationContent : NSObject
@end

/**
 *  群操作类型
 */
typedef NS_ENUM(NSInteger, NIMTeamOperationType){
    /**
     *  邀请成员
     */
    NIMTeamOperationTypeInvite          = 0,
    /**
     *  移除成员
     */
    NIMTeamOperationTypeKick            = 1,
    /**
     *  离开群
     */
    NIMTeamOperationTypeLeave           = 2,
    /**
     *  更新群信息
     */
    NIMTeamOperationTypeUpdate          = 3,
    /**
     *  解散群
     */
    NIMTeamOperationTypeDismiss         = 4,
    /**
     *  高级群申请加入成功
     */
    NIMTeamOperationTypeApplyPass       = 5,
    /**
     *  高级群群主转移群主身份
     */
    NIMTeamOperationTypeTransferOwner   = 6,
    /**
     *  添加管理员
     */
    NIMTeamOperationTypeAddManager      = 7,
    /**
     *  移除管理员
     */
    NIMTeamOperationTypeRemoveManager   = 8,
    /**
     *  高级群接受邀请进群
     */
    NIMTeamOperationTypeAcceptInvitation= 9,

};

/**
 *  群信息修改字段
 */
typedef NS_ENUM(NSInteger, NIMTeamUpdateTag){
    /**
     *  群名
     */
    NIMTeamUpdateTagName,
    /**
     *  群简介
     */
    NIMTeamUpdateTagIntro,
    /**
     *  群公告
     */
    NIMTeamUpdateTagAnouncement,
    /**
     *  群验证方式
     */
    NIMTeamUpdateTagJoinMode,
};

/**
 *  群通知内容
 */
@interface NIMTeamNotificationContent : NIMNotificationContent
/**
 *  操作发起者ID
 */
@property (nonatomic,copy,readonly)     NSString    *sourceID;

/**
 *  操作类型
 */
@property (nonatomic,assign,readonly)   NIMTeamOperationType  type;

/**
 *  被操作者ID列表
 */
@property (nonatomic,strong,readonly)   NSArray *targetIDs;

/**
 *  额外信息
 *  @discussion 目前只有更新群信息这个操作有额外信息,返回的是@(NIMTeamUpdateTag）
 */
@property (nonatomic,strong,readonly)   id extraData;
@end



/**
 *  通知对象
 */
@interface NIMNotificationObject : NSObject<NIMMessageObject>
/**
 *  通知内容
 */
@property (nonatomic,strong,readonly)    NIMNotificationContent  *content;
@end

