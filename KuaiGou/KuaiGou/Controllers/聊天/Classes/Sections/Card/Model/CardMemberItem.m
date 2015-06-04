//
//  CardMemberItem.m
//  NIM
//
//  Created by chrisRay on 15/3/5.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "CardMemberItem.h"
#import "ContactUtil.h"
#import "ContactDataItem.h"
#import "UsrInfoData.h"
@interface TeamCardMemberItem()
@property (nonatomic,strong) NIMTeamMember *member;
@end;

@implementation TeamCardMemberItem

- (instancetype)initWithMember:(NIMTeamMember*)member{
    self = [self init];
    if (self) {
        _member  = member;
        _usrInfo = [[UsrInfoData sharedInstance] queryUsrInfoById:member.userId needRemoteFetch:NO fetchCompleteHandler:nil];
    }
    return self;
}

- (BOOL)isEqual:(id)object{
    if (![object isKindOfClass:[TeamCardMemberItem class]]) {
        return NO;
    }
    TeamCardMemberItem *obj = (TeamCardMemberItem*)object;
    return [obj.memberId isEqualToString:self.memberId];
}

- (NIMTeamMemberType)type {
    return _member.type;
}

- (void)setType:(NIMTeamMemberType)type {
    _member.type = type;
}

- (NSString *)title {
    return _usrInfo.nick ? _usrInfo.nick : _member.userId;
}

- (NIMTeam *)team {
    return [[NIMSDK sharedSDK].teamManager teamById:_member.teamId];
}

#pragma mark - TeamCardHeaderData

- (UIImage*)imageNormal{
    NSString *imageName = [ContactUtil queryContactByUsrId:self.member.userId].iconUrl;
    UIImage * image = [UIImage imageNamed:imageName];
    if (image) {
        return image;
    }else{
        return [UIImage imageNamed:@"DefaultAvatar"];
    }
}

- (UIImage*)imageHighLight{
    NSString *imageName = [ContactUtil queryContactByUsrId:self.member.userId].iconUrl;
    UIImage * image = [UIImage imageNamed:imageName];
    if (image) {
        return image;
    }else{
        return [UIImage imageNamed:@"DefaultAvatar"];
    }
}

- (NSString*)memberId{
    return self.member.userId;
}

@end



@interface UserCardMemberItem()
@property (nonatomic,strong) ContactDataMember *member;
@end;

@implementation UserCardMemberItem

- (instancetype)initWithMember:(ContactDataMember*)member{
    self = [self init];
    if (self) {
        _member = member;
    }
    return self;
}

- (BOOL)isEqual:(id)object{
    if (![object isKindOfClass:[UserCardMemberItem class]]) {
        return NO;
    }
    UserCardMemberItem *obj = (UserCardMemberItem*)object;
    return [obj.memberId isEqualToString:self.memberId];
}

#pragma mark - TeamCardHeaderData

- (UIImage*)imageNormal{
    NSString *imageName = self.member.iconUrl;
    UIImage * image = [UIImage imageNamed:imageName];
    if (image) {
        return image;
    }else{
        return [UIImage imageNamed:@"DefaultAvatar"];
    }
}

- (UIImage*)imageHighLight{
    NSString *imageName = self.member.iconUrl;
    UIImage * image = [UIImage imageNamed:imageName];
    if (image) {
        return image;
    }else{
        return [UIImage imageNamed:@"DefaultAvatar"];
    }
}

- (NSString*)title{
    return self.member.nick;
}

- (NSString*)memberId{
    return self.member.usrId;
}

@end
