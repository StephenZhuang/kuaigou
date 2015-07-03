//
//  SessionLogicImpl.h
//  NIM
//
//  Created by chrisRay on 15/4/22.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "SessionLogicDelegate.h"
@class SessionViewLayoutManager;
@class SessionMsgDatasource;
@protocol SessionLogicLayout;
@protocol SessionLogicDataSource;


@interface SessionLogicImpl : NSObject<SessionLogicDelegate>

- (instancetype)initWithLayoutManager:(id<SessionLogicLayout>)layoutManager
                           dataSource:(id<SessionLogicDataSource>)dataSource;

@end


@protocol SessionLogicLayout <NSObject>

//删除具体行的cell
-(void)deleteCellAtRows:(NSArray*)delIndexs;

@end


@protocol SessionLogicDataSource <NSObject>

@optional
//删除消息 并返回是删除的哪一个
- (NSArray*)deleteMessage:(SessionMsgModel *)msg;

@end