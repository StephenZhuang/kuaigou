//
//  SessionMsgDatasource.h
//  NIMDemo
//
//  Created by ght on 15-1-27.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

/**
 * 为会话窗口提供数据源 管理消息状态
 */
#import <Foundation/Foundation.h>
#import "SessionMsgModel.h"
#import "SessionLogicDelegate.h"

@class NIMSession;
@class NIMMessage;
@interface SessionMsgDatasource : NSObject

- (instancetype)initWithSession:(NIMSession*)session;

@property (nonatomic, strong) NSMutableArray *msgArray;
@property (nonatomic, assign) NSTimeInterval      newMsgTimeTag;               //记录最新消息的时间tag
@property (nonatomic, assign) NSTimeInterval      oldMsgTimeTag;               //记录最旧历史消息的时间tag(已显示的)
@property (nonatomic, assign) int64_t        beginSerialID;

- (NSInteger)indexAtMsgArray:(NIMMessage*)msg;
- (NSInteger)msgCount;

//数据对外接口
- (NSInteger)loadHistoryMessages;
- (NSArray*)addMessages:(NSArray*)msgs;
- (NSArray*)deleteMessage:(SessionMsgModel*)msg;

//更新已读回执状态
- (void)updateOtherMessageHiddReceipt:(SessionMsgModel*)msgModel;

//del
- (void)deleteAllMessages;

@end
