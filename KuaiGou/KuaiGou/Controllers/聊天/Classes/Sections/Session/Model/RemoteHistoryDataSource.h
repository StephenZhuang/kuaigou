//
//  SessionMsgHistoryDataSource.h
//  NIM
//
//  Created by chrisRay on 15/4/23.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SessionLogicImpl.h"

typedef void(^RemoteFetchMsgsResult)(NSError *error, NSArray *messages);
@interface RemoteHistoryDataSource : NSObject<SessionLogicDataSource>

- (instancetype)initWithSession:(NIMSession*)session;

@property (nonatomic, strong) NSMutableArray      *dataArray;  //显示用的数组，包括Msg和timeModel
@property (nonatomic, assign) NSInteger           fetchLimit; //默认100


- (void)remoteFetchPreMsgs:(RemoteFetchMsgsResult)result;

- (NSInteger)indexAtMsgArray:(NIMMessage*)msg;

@end
