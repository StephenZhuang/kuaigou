//
//  TeamCardMemberItem.h
//  NIM
//
//  Created by chrisRay on 15/3/5.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardDataSourceProtocol.h"
#import "ContactDataItem.h"

@class UsrInfo;

@interface UserCardMemberItem : NSObject<CardHeaderData>

- (instancetype)initWithMember:(ContactDataMember*)member;

@end

@interface TeamCardMemberItem : NSObject<CardHeaderData>

@property (nonatomic, strong) UsrInfo *usrInfo;
@property (nonatomic, assign) NIMTeamMemberType type;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, strong) NIMTeam *team;

- (instancetype)initWithMember:(NIMTeamMember*)member;

@end
