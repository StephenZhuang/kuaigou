//
//  UsrInfoData.h
//  NIM
//
//  Created by Xuhui on 15/3/19.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NIMService.h"
#import "GroupedDataCollection.h"

@protocol UsrInfoProtocol <NSObject>

@property (nonatomic, copy) NSString *usrId;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *nick;

@end

@interface UsrInfo : NSObject <UsrInfoProtocol, GroupMemberProtocol>

@property (nonatomic, copy) NSString *usrId;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, assign) BOOL isFriend;

@end

@interface UsrInfoData : NIMService

- (UsrInfo *)queryUsrInfoById:(NSString *)usrId needRemoteFetch:(BOOL)needFetch fetchCompleteHandler:(void(^)(UsrInfo *info))handler;
- (NSArray *)queryUsrInfoByIds:(NSArray *)usrIds needRemoteFetch:(BOOL)needFetch fetchCompleteHandler:(void(^)(NSArray *infos))handler;

@end
