//
//  NIMConversationManager.h
//  NIMLib
//
//  Created by Netease.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NIMMessage;
@class NIMSession;
@class NIMRecentSession;
/**
 *  会话管理器回调
 */
@protocol NIMConversationManagerDelegate <NSObject>

@optional

/**
 *  增加最近会话的回调
 *
 *  @param recentSession    最近会话
 *  @param totalUnreadCount 目前总未读数
 */
- (void)didAddRecentSession:(NIMRecentSession *)recentSession
           totalUnreadCount:(NSInteger)totalUnreadCount;

/**
 *  最近会话修改的回调
 *
 *  @param recentSession    最近会话
 *  @param totalUnreadCount 目前总未读数
 */
- (void)didUpdateRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount;

/**
 *  删除最近会话的回调
 *
 *  @param recentSession    最近会话
 *  @param totalUnreadCount 目前总未读数
 */
- (void)didRemoveRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount;


@end

/**
 *  会话管理器
 */
@protocol NIMConversationManager <NSObject>

/**
 *  删除某条消息
 *
 *  @param message 待删除的聊天消息
 *  @discussion 异步方法，消息会标记为已删除
 */
- (void)delMessage:(NIMMessage*)message;

/**
 *  删除某个会话的所有消息
 *
 *  @param session 待删除会话
 *  @discussion 异步方法，最近会话仍然保留，会话内消息将会标记为已删除
 */
- (void)deleteAllmessagesInSession:(NIMSession*)session;


/**
 *  删除某个最近会话
 *
 *  @param recentSession 待删除的最近会话
 *  @discussion 异步方法，删除最近会话，但保留会话内消息
 */
- (void)deleteRecentSession:(NIMRecentSession*)recentSession;


/**
 *  设置一个会话里所有消息置为已读
 *
 *  @param session 需设置的会话
 *  @discussion 异步方法，消息会标记为设置的状态
 */
- (void)markAllMessageReadInSession:(NIMSession*)session;


/**
 *  获取一个会话里某条消息之前的若干条的消息
 *
 *  @param session 消息所属的会话
 *  @param message 当前最早的消息,没有则传入nil
 *  @param limit   个数限制
 *
 *  @return 消息列表
 */
- (NSArray*)messagesInSession:(NIMSession*)session
                      message:(NIMMessage*)message
                        limit:(NSInteger)limit;

/**
 *  获取所有未读数,在主线程调用
 *
 *  @return 未读数
 */
- (NSInteger)allUnreadCount;

/**
 *  获取所有最近会话
 *
 *  @return 最近会话列表
 */
- (NSArray*)allRecentSession;

/**
 *  添加通知对象
 *
 *  @param delegate 通知对象
 */
- (void)addDelegate:(id<NIMConversationManagerDelegate>)delegate;

/**
 *  删除通知对象
 *
 *  @param delegate 通知对象
 */
- (void)removeDelegate:(id<NIMConversationManagerDelegate>)delegate;

@end


