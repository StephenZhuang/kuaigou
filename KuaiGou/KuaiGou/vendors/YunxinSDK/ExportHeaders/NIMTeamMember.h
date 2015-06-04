//
//  NIMTeamMember.h
//  NIMLib
//
//  Created by Netease.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  群成员类型
 */
typedef NS_ENUM(NSInteger, NIMTeamMemberType){
    /**
     *  普通群员
     */
    NIMTeamMemberTypeNormal = 0,
    /**
     *  群创建者
     */
    NIMTeamMemberTypeCreator = 1,
    /**
     *  群管理员
     */
    NIMTeamMemberTypeManager = 2,
    /**
     *  申请加入用户
     */
    NIMTeamMemberTypeApply   = 3,
};


/**
 *  群成员信息
 */
@interface NIMTeamMember : NSObject
/**
 *  群ID
 */
@property (nonatomic,copy,readonly)         NSString *teamId;

/**
 *  群成员ID
 */
@property (nonatomic,copy,readonly)         NSString *userId;

/**
 *  邀请者
 */
@property (nonatomic,copy,readonly)         NSString *invitor;

/**
 *  群成员类型
 */
@property (nonatomic,assign)                NIMTeamMemberType  type;

@end