//
//  SessionMsgDatasource.m
//  NIMDemo
//
//  Created by ght on 15-1-27.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "SessionMsgDatasource.h"
#import "NIMSDK.h"
#import "SessionMsgConverter.h"
#import "UITableView+ScrollToBottom.h"

int64_t MaxMessageTimeInterval = 5*60; //5分钟
static NSInteger MaxMessageCount = 20;

@interface SessionMsgDatasource()
@end


@implementation SessionMsgDatasource
{
    NIMSession *_currentSession;
    dispatch_queue_t _messageQueue;
    NSMutableDictionary *_msgIdDict;
}

- (instancetype)initWithSession:(NIMSession*)session
{
    if (self = [self init]) {
        _currentSession = session;
        _newMsgTimeTag = 0;
        _oldMsgTimeTag = 0;
        _beginSerialID = LLONG_MAX;
        _msgArray  = [NSMutableArray array];
        _msgIdDict = [NSMutableDictionary dictionary];
        [self initData];
    }
    return self;
}

- (void)initData
{
    [self readInitMsgs];
    [[[NIMSDK sharedSDK] conversationManager] markAllMessageReadInSession:_currentSession];
}

- (void)readInitMsgs
{
    //read DB
    NSArray *msgDataList = [[[NIMSDK sharedSDK] conversationManager] messagesInSession:_currentSession
                                                                               message:nil
                                                                                 limit:MaxMessageCount];
    [msgDataList enumerateObjectsUsingBlock:^(NIMMessage *obj, NSUInteger idx, BOOL *stop) {
        [self addNewMsgTimWithTime:obj.timestamp];
        SessionMsgModel *msgModel = [SessionMsgModelFactory msgModelWithMsg:obj];
        [_msgArray addObject:msgModel];
        NSInteger msgIndex = [_msgArray count] - 1;
        [_msgIdDict setObject:@(msgIndex) forKey:msgModel.msgData.messageId];
    }];
    //设置时间戳
    _oldMsgTimeTag = ((NIMMessage*)[msgDataList firstObject]).timestamp;
}

-(NSInteger)indexAtMsgArray:(NIMMessage*)msg
{
    NSInteger index = -1;
    NSNumber *indexNumber = [_msgIdDict objectForKey:msg.messageId];
    if (indexNumber) {
        index = indexNumber.integerValue;
    }
    if (index > -1) {
        [_msgArray replaceObjectAtIndex:index withObject:[SessionMsgModelFactory msgModelWithMsg:msg]];
    }
  
    return index;
}

#pragma mark - msg
- (NSInteger)msgCount
{
    return [_msgArray count];
}

-(NSArray*)addMessages:(NSArray*)msgs
{
    NSMutableArray *toAddArray = [NSMutableArray array];
    for (NIMMessage * msg in msgs) {
        if (![self messageIsExist:msg]) {
            if ([self addNewMsgTimWithTime:msg.timestamp]) {
                NSInteger msgTimeIndex = [_msgArray count] - 1;
                [toAddArray addObject:@(msgTimeIndex)];
            }
            [_msgArray addObject:[SessionMsgModelFactory msgModelWithMsg:msg]];
            NSInteger msgIndex = [_msgArray count] - 1;
            [toAddArray addObject:@(msgIndex)];
            [_msgIdDict setObject:@(msgIndex) forKey:msg.messageId];
        }
    }
    return toAddArray;
}

- (BOOL)messageIsExist:(NIMMessage *)msg
{
    return [_msgIdDict objectForKey:msg.messageId] != nil;
}


- (NSInteger)loadHistoryMessages
{
    NSInteger scrollToIndex = -1;
    @autoreleasepool {
        //
        __block SessionMsgModel *currentOldestMsg = nil;
        [_msgArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[SessionMsgModel class]]) {
                currentOldestMsg = (SessionMsgModel*)obj;
                *stop = YES;
            }
        }];
        if (currentOldestMsg) {
            NSArray *olderMessages = [[[NIMSDK sharedSDK] conversationManager] messagesInSession:_currentSession message:currentOldestMsg.msgData limit:MaxMessageCount];
            for (NSInteger i = [olderMessages count] -1; i>=0; i--) {
                NIMMessage *msg = [olderMessages objectAtIndex:i];
                scrollToIndex++;
                if ([self addOldMsgTimeWithTime:msg.timestamp]) {
                    scrollToIndex++;
                }
                [_msgArray insertObject:[SessionMsgModelFactory msgModelWithMsg:msg] atIndex:1];
               
            }
            _oldMsgTimeTag = ((NIMMessage*)[olderMessages firstObject]).timestamp;
        }
    }
    return scrollToIndex;
}

- (NSArray*)deleteMessage:(SessionMsgModel *)msg
{
    NSMutableArray *dels = [NSMutableArray array];
    NSInteger delTimeIndex = -1;
    NSInteger delMsgIndex = [_msgArray indexOfObject:msg];
    if (delMsgIndex > 0) {
        BOOL delMsgIsSingle = (delMsgIndex == _msgArray.count-1 || [_msgArray[delMsgIndex+1] isKindOfClass:[SessionTimeModel class]]);
        if ([_msgArray[delMsgIndex-1] isKindOfClass:[SessionTimeModel class]] && delMsgIsSingle) {
            delTimeIndex = delMsgIndex-1;
            [_msgArray removeObjectAtIndex:delTimeIndex];
            [dels addObject:@(delTimeIndex)];
        }
    }
    if (delMsgIndex > -1) {
        [_msgArray removeObject:msg];
        [_msgIdDict removeObjectForKey:msg.msgData.messageId];
        [dels addObject:@(delMsgIndex)];
    }
    [[[NIMSDK sharedSDK] conversationManager] delMessage:msg.msgData];
    return dels;
}

#pragma mark - update
- (void)updateOtherMessageHiddReceipt:(SessionMsgModel*)msgModel
{
    NSInteger index = [self.msgArray count] -1;
    for (; index >= 0; index --)
    {
        if ([self.msgArray count] <= 0)
        {
            break;
        }
        id obj = [self.msgArray objectAtIndex:index];
        if (![obj isKindOfClass:[SessionMsgModel class]])
        {
            continue;
        }
        SessionMsgModel *data = (SessionMsgModel*)obj;
        if ([data.msgData.messageId isEqualToString:msgModel.msgData.messageId])
        {
            continue;
        }
        if (data.showSendMsgStatusView)
        {
            data.showSendMsgStatusView = NO;
            //刷新table
            //[self reloadTableViewCellBySessionMessageData:data];
        }
    }
}

- (void)deleteAllMessages
{
    [[[NIMSDK sharedSDK] conversationManager] deleteAllmessagesInSession:_currentSession];
}

#pragma mark - private methods
- (BOOL)addNewMsgTimWithTime:(NSTimeInterval)msgTime
{
    if (_newMsgTimeTag == 0 || msgTime - _newMsgTimeTag > MaxMessageTimeInterval) {
        _newMsgTimeTag = msgTime;
        SessionTimeModel *timeModel = [[SessionTimeModel alloc] init];
        timeModel.messageTime = msgTime;
        [_msgArray addObject:timeModel];
        return YES;
    }
    return NO;
}

- (BOOL)addOldMsgTimeWithTime:(NSTimeInterval)msgTime
{
    if (_oldMsgTimeTag - msgTime > MaxMessageTimeInterval) {
        //
        _oldMsgTimeTag = msgTime;
        SessionTimeModel *timeModel = [[SessionTimeModel alloc] init];
        timeModel.messageTime = msgTime;
        [_msgArray insertObject:timeModel atIndex:0];
        return YES;
    }
    return NO;
}

@end
