//
//  SessionMsgHistoryDataSource.m
//  NIM
//
//  Created by chrisRay on 15/4/23.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "RemoteHistoryDataSource.h"
#import "SessionMsgModel.h"

@interface RemoteHistoryDataSource(){
    NIMSession *_currentSession;
    NSMutableArray *_msgArray; //消息数组
    NSTimeInterval _lastTime;
}

@end

@implementation RemoteHistoryDataSource

- (instancetype)initWithSession:(NIMSession*)session
{
    if (self = [self init]) {
        _currentSession = session;
        _fetchLimit    = 100;
        _lastTime  = 0;
        _msgArray  = [NSMutableArray array];
        _dataArray = [NSMutableArray array];
    }
    return self;
}

- (void)remoteFetchPreMsgs:(RemoteFetchMsgsResult)result{
    NIMHistoryMessageSearchOption *searchOpt = [[NIMHistoryMessageSearchOption alloc] init];
    searchOpt.startTime  = 0;
    searchOpt.endTime    = [_msgArray.firstObject msgData].timestamp;
    searchOpt.currentMessage = [_msgArray.firstObject msgData];
    searchOpt.limit      = self.fetchLimit;
    searchOpt.reverse    = NO;
    searchOpt.sync       = NO;
    __block typeof(self) wself = self;
    [[NIMSDK sharedSDK].conversationManager fetchMessageHistory:_currentSession option:searchOpt result:^(NSError *error, NSArray *messages) {
        if (!error) {
            if (messages.count) {
                [wself deleteFirstTimeModelIfExist];
                [messages enumerateObjectsUsingBlock:^(NIMMessage *obj, NSUInteger idx, BOOL *stop) {
                    SessionMsgModel *msgModel = [SessionMsgModelFactory msgModelWithMsg:obj];
                    [_msgArray insertObject:msgModel atIndex:0];
                    [_dataArray insertObject:msgModel atIndex:0];
                    [wself addOldMsgTimeWithTime:obj.timestamp forceAdd:NO];
                }];
                if (![_dataArray.firstObject isKindOfClass:[SessionTimeModel class]]) {
                    [wself addOldMsgTimeWithTime:[_msgArray.firstObject msgData].timestamp forceAdd:YES];
                }
            }
        }
        if (result) {
            result(error,messages);
        }
    }];
}


- (BOOL)addOldMsgTimeWithTime:(NSTimeInterval)msgTime forceAdd:(BOOL)forceAdd
{
    if (!_lastTime) {
        _lastTime = [_msgArray.lastObject msgData].timestamp;
    }
    NSTimeInterval oldMsgTime = _lastTime;
    extern int64_t MaxMessageTimeInterval;
    if (oldMsgTime - msgTime > MaxMessageTimeInterval || forceAdd) {
        SessionTimeModel *timeModel = [[SessionTimeModel alloc] init];
        timeModel.messageTime = msgTime;
        [_dataArray insertObject:timeModel atIndex:0];
        _lastTime = msgTime;
        return YES;
    }
    return NO;
}


- (void)deleteFirstTimeModelIfExist{
    if ([_dataArray.firstObject isKindOfClass:[SessionTimeModel class]]) {
        [_dataArray removeObjectAtIndex:0];
    }
}


-(NSInteger)indexAtMsgArray:(NIMMessage*)msg
{
    __block NSInteger index = -1;
    [_dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[SessionMsgModel class]]) {
            SessionMsgModel *model = obj;
            if ([msg isEqual:model.msgData]) {
                index = idx;
                *stop = YES;
            }
        }
    }];
    return index;
}



@end
