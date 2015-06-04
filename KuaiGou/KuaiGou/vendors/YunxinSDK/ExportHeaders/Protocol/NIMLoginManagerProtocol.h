//
//  NIMLoginManagerProtocol.h
//  NIMLib
//
//  Created by Netease.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  登录Block
 *
 *  @param error 登录结果,如果成功error为nil
 */
typedef void(^NIMLoginHandler)(NSError *error);


/**
 *  登录步骤枚举
 */
typedef NS_ENUM(NSInteger, NIMLoginStep)
{
    /**
     *  连接服务器
     */
    NIMLoginStepLinking = 1,
    /**
     *  连接服务器成功
     */
    NIMLoginStepLinkOK,
    /**
     *  连接服务器失败
     */
    NIMLoginStepLinkFailed,
    /**
     *  登录
     */
    NIMLoginStepLogining,
    /**
     *  登录成功
     */
    NIMLoginStepLoginOK,
    /**
     *  登录失败
     */
    NIMLoginStepLoginFailed,
    /**
     *  开始同步
     */
    NIMLoginStepSyncing,
    /**
     *  同步完成
     */
    NIMLoginStepSyncOK,
    /**
     *  网络切换
     *  @discussion 这个并不是登录步骤的一种,但是UI有可能需要通过这个状态进行UI展现
     */
    NIMLoginStepNetChanged,
};

/**
 *  被踢下线的原因
 */
typedef NS_ENUM(NSInteger, NIMKickReason)
{
    /**
     *  被另外一个客户端踢下线
     */
    NIMKickReasonByClient,
    /**
     *  被服务器踢下线
     */
    NIMKickReasonByServer,
};


/**
 *  登录相关回调
 */
@protocol NIMLoginManagerDelegate <NSObject>

@optional
/**
 *  被踢(服务器/其他端)回调
 *
 *  @param code 被踢原因
 */
- (void)onKick:(NIMKickReason)code;

/**
 *  登录回调
 *
 *  @param step 登录步骤
 *  @discussion 这个回调主要用于客户端UI的刷新
 */
- (void)onLogin:(NIMLoginStep)step;

/**
 *  自动登录失败回调
 *
 *  @param error 失败原因
 */
- (void)onAutoLoginFailed:(NSError *)error;
@end

/**
 *  登录协议
 */
@protocol NIMLoginManager <NSObject>

/**
 *  登录
 *
 *  @param account    账号
 *  @param token      令牌 (在后台绑定的登录token)
 *  @param completion 完成回调
 */
- (void)login:(NSString *)account
        token:(NSString *)token
   completion:(NIMLoginHandler)completion;

/**
 *  登出
 *
 *  @param completion 完成回调
 */
- (void)logout:(NIMLoginHandler)completion;

/**
 *  返回当前登录账号
 *
 *  @return 当前登录账号,如果没有登录成功,这个地方会返回nil
 */
- (NSString *)currentAccount;

/**
 *  添加登录委托
 *
 *  @param delegate 登录委托
 */
- (void)addDelegate:(id<NIMLoginManagerDelegate>)delegate;

/**
 *  移除登录委托
 *
 *  @param delegate 登录委托
 */
- (void)removeDelegate:(id<NIMLoginManagerDelegate>)delegate;
@end
