//
//  SessionListCell.m
//  NIMDemo
//
//  Created by chrisRay on 15/2/10.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "SessionListCell.h"
#import "AvatarImageView.h"
#import "NIMRecentSession.h"
#import "SessionCellLayoutConstant.h"
#import "UIView+NIMDemo.h"
#import "NIMMessage.h"
#import "SessionUtil.h"
#import "BadgeView.h"
#import "ContactUtil.h"
#import "ContactDataItem.h"

@implementation SessionListCell
#define AvatarWidth 40
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _avatarImageView = [AvatarImageView demoInstanceRecentSessionList];
        [self addSubview:_avatarImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.backgroundColor = [UIColor whiteColor];
        _nameLabel.font            = [UIFont systemFontOfSize:15.f];
        [self addSubview:_nameLabel];
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageLabel.backgroundColor = [UIColor whiteColor];
        _messageLabel.font            = [UIFont systemFontOfSize:14.f];
        _messageLabel.textColor       = [UIColor lightGrayColor];
        [self addSubview:_messageLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.backgroundColor = [UIColor whiteColor];
        _timeLabel.font            = [UIFont systemFontOfSize:14.f];
        _timeLabel.textColor       = [UIColor lightGrayColor];
        [self addSubview:_timeLabel];
        
        _badgeView = [BadgeView viewWithBadgeTip:@""];
        [self addSubview:_badgeView];
    }
    return self;
}


#define NameLabelMaxWidth    160.f
#define MessageLabelMaxWidth 200.f
- (void)refresh:(NIMRecentSession*)recent{
    NIMMessage *lastMessage = recent.lastMessage;
    if (recent.session.sessionType == NIMSessionTypeP2P) {
        self.avatarImageView.clipPath = YES;
        ContactDataMember *contact = [ContactUtil queryContactByUsrId:lastMessage.session.sessionId];
        NSString *imageName = contact.iconUrl;
        UIImage * image = [UIImage imageNamed:imageName];
        if (image) {
            self.avatarImageView.image = image;
        }else{
            self.avatarImageView.image = [UIImage imageNamed:@"DefaultAvatar"];
        }
        self.nameLabel.text = [SessionUtil showNick:lastMessage.session.sessionId inSession:lastMessage.session];
    }else if(recent.session.sessionType == NIMSessionTypeTeam){
        self.avatarImageView.clipPath = NO;
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:recent.session.sessionId];
        self.avatarImageView.image = [UIImage imageNamed:@"avatar_group"];
        self.nameLabel.text = team.teamName;
    }
    [self.nameLabel sizeToFit];
    self.nameLabel.width = self.nameLabel.width > NameLabelMaxWidth ? NameLabelMaxWidth : self.nameLabel.width;
    
    self.messageLabel.text  = [self messageContent:lastMessage];
    [self.messageLabel sizeToFit];
    self.messageLabel.width = self.messageLabel.width > MessageLabelMaxWidth ? MessageLabelMaxWidth : self.messageLabel.width;

    self.timeLabel.text = [SessionUtil showTime:lastMessage.timestamp showDetail:NO];
    [self.timeLabel sizeToFit];
    if (recent.unreadCount) {
        self.badgeView.hidden = NO;
        self.badgeView.badgeValue = @(recent.unreadCount).stringValue;
    }else{
        self.badgeView.hidden = YES;
    }
    
    

}

- (NSString*)messageContent:(NIMMessage*)lastMessage{
    NSString *text     = @"";
    switch (lastMessage.messageType) {
        case NIMMessageTypeText:
            text = lastMessage.text;
            break;
        case NIMMessageTypeAudio:
            text = @"[语音]";
            break;
        case NIMMessageTypeImage:
            text = @"[图片]";
            break;
        case NIMMessageTypeVideo:
            text = @"[视频]";
            break;
        case NIMMessageTypeLocation:
            text = @"[位置]";
            break;
        case NIMMessageTypeNotification:{
            return [self notificationMessageContent:lastMessage];
        }
        case NIMMessageTypeFile:
            text = @"[文件]";
            break;
        case NIMMessageTypeCustom:
            text = @"[猜拳]";
            break;
        default:
            break;
    }
    NSString *currentUserID = [[[NIMSDK sharedSDK] loginManager] currentAccount];
    if (!lastMessage.from || [lastMessage.from isEqualToString:currentUserID]) {
        return text;
    }
    NSString *nickName = [SessionUtil showNickInMessage:lastMessage];
    return [nickName stringByAppendingFormat:@" : %@",text];
}

- (NSString *)notificationMessageContent:(NIMMessage *)lastMessage{
    NIMNotificationObject *object = lastMessage.messageObject;
    if (object.notificationType == NIMNotificationTypeNetCall) {
        NIMNetCallNotificationContent *content = (NIMNetCallNotificationContent *)object.content;
        if (content.callType == NIMNetCallTypeAudio) {
            return @"[网络通话]";
        }
        return @"[视频聊天]";
    }
    if (object.notificationType == NIMNotificationTypeTeam) {
        return @"[群信息更新]";
    }
    return @"[未知消息]";
}


- (void)layoutSubviews{
    [super layoutSubviews];
    _avatarImageView.left    = SessionListAvatarLeft;
    _avatarImageView.centerY = self.height * .5f;
    _nameLabel.top           = SessionListNameTop;
    _nameLabel.left          = _avatarImageView.right + SessionListNameLeftToAvatar;
    _messageLabel.left       = _avatarImageView.right + SessionListMessageLeftToAvatar;
    _messageLabel.bottom     = self.height - SessionListMessageBottom;
    _timeLabel.right         = self.width - SessionListTimeRight;
    _timeLabel.top           = SessionListTimeTop;
    _badgeView.right         = self.width - SessionBadgeTimeRight;
    _badgeView.bottom        = self.height - SessionBadgeTimeBottom;
}



@end
