//
//  SessionMsgModel.m
//  NIMDemo
//
//  Created by ght on 15-1-23.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "SessionMsgModel.h"
#import "SessionUtil.h"
#import "NIMNotificationObject.h"
#import "NIMMessage.h"
#import "UsrInfoData.h"
//单元格本身定义
NSInteger OtherCellMinHeight                = 70;//最小高度70 done
NSInteger SelfCellMinHeight                 = 40;
NSInteger OtherNickNameHeight               = 20;
//单元格和气泡之间的距离定义
NSInteger CellTopToBubbleTop                = 3;//单元格顶部到气泡顶部的距离 done
NSInteger CellBubbleButtomToCellButtom      = 13;//气泡底部到单元格底部的间距 done

//气泡定义
NSInteger BubbleTopToContetTop              = 0;//气泡顶部到内容顶部的高度 done
NSInteger ContentButtomToBubble             = 0;//内容底部到气泡底部的高度
NSInteger BubblePaddingForImage             = 3;
NSInteger BubbleArrowWidthForImage          = 5;

NSInteger ProtraitImageWidth                = 42;//头像宽
//其它人
NSInteger CellPaddingToProtrait             = 8;//单元格左边到头像的距离 done
NSInteger ProtraitRightToBubble             = 5;//头像到气泡左边的距离 done
NSInteger OtherBubbleOriginX                = 55;//气泡的起始位置
NSInteger OtherBubbleMinWidth               = 34;//气泡的最小宽度 done
NSInteger OtherBubbleLeftToContent          = 14;//气泡左边到内容左边的宽度 done
NSInteger OtherContentRightToBubble         = 14;//内容到气泡右边的宽度 done
NSInteger OtherBubbleArrowWidth             = 8;
NSInteger OtherContentOriginY               = 3;
NSInteger OtherContentOriginX               = 69;//内容的起始位置

NSInteger OtherContentMinWidth              = 2;

//自己
NSInteger SelfBubbleRightToContent          = 14;//气泡右边到内容的间距
NSInteger SelfBubbleLeftToContent           = 10;//气泡左边到内容的间距
NSInteger SelfBubbleMinWidth                = 48;
NSInteger SelfContentMinWidth               = 24;
NSInteger SelfBubbleArrowWidth              = 8;


//语音的排版
NSInteger SelfBubbleRightToContentForAudio  = 14;
NSInteger SelfBubbleLeftToContentForAudio   = 12;
NSInteger OtherBubbleLeftToContentForAudio  = 13;//气泡左边到内容左边的宽度
NSInteger OtherContentRightToBubbleForAudio = 12;//内容到气泡右边的宽度
NSInteger BubbleTopToContetTopForAudio      = 8;
NSInteger ContentButtomToBubbleForAudio     = 9;
NSInteger OtherCellMinHeightForAudio        = 53;

//文字的排版
NSInteger OtherBubbleLeftToContentForText   = 15;//done
NSInteger OtherContentRightToBubbleForText  = 15;//done
NSInteger OtherBubbleMinWidthForText        = 43;

NSInteger OtherCellMinHieghtForText         = 35;
NSInteger OtherBubbleTopToContentForText    = 11;// done
NSInteger OtherContentButtomToBubbleForText = 9;//内容底部到气泡底部的高度 done

NSInteger SelfBubbleRightToContentForText   = 15;
NSInteger SelfBubbleLeftToContentForText    = 11;
NSInteger SelfBubbleMinWidthForText         = 43;

NSInteger CellMinHeightForText              = 35;
NSInteger SelfBubbleTopToContentForText     = 11;
NSInteger SelfContentButtomToBubbleForText  = 9;//内容底部到气泡底部的高度

NSInteger AudioContentHeight                = 30;

NSInteger LocationMessageWidth              = 110;
NSInteger LocationMessageHeight             = 105;

NSInteger CustomMessageWidth                = 44;
NSInteger CustomMessageHeight               = 44;


NSInteger TeamNotificationMessageWidth      = 300;
NSInteger TeamNotificationMessageHeight     = 40;

NSInteger FileTransMessageWidth             = 220;
NSInteger FileTransMessageHeight            = 110;
NSInteger FileTransMessageIconLeft          = 15;
NSInteger FileTransMessageProgressLeft      = 90;
NSInteger FileTransMessageProgressRight     = 20;
NSInteger FileTransMessageProgressTop       = 75;
NSInteger FileTransMessageTitleLeft         = 90;
NSInteger FileTransMessageTitleTop          = 25;
NSInteger FileTransMessageSizeTitleRight    = 15;
NSInteger FileTransMessageSizeTitleBottom   = 15;

NSInteger UnknowMessageWidth                = 100;
NSInteger UnknowMessageHeight               = 40;
NSInteger UnknowBubbleTopToContetTop        = 13;
NSInteger UnknowSelfBubbleLeftToContent     = 10;
NSInteger UnknowContentButtomToBubble       = 0;
NSInteger UnknowSelfBubbleRightToContent    = 14;
NSInteger UnknowOtherBubbleLeftToContent    = 14;
NSInteger UnknowOtherContentRightToBubble   = 14;


//Session List
NSInteger SessionListAvatarLeft             = 15;
NSInteger SessionListNameTop                = 15;
NSInteger SessionListNameLeftToAvatar       = 15;
NSInteger SessionListMessageLeftToAvatar    = 15;
NSInteger SessionListMessageBottom          = 15;
NSInteger SessionListTimeRight              = 15;
NSInteger SessionListTimeTop                = 15;
NSInteger SessionBadgeTimeBottom            = 15;
NSInteger SessionBadgeTimeRight             = 15;

@interface SessionMsgModel()

- (instancetype)initWithNIMMessage:(NIMMessage*)msg;

@end

@implementation SessionMsgModelFactory

+ (SessionMsgModel*)msgModelWithMsg:(NIMMessage*)msgData;{
    switch (msgData.messageType) {
        case NIMMessageTypeNotification:
            return [[SessionNoticationMsgModel alloc] initWithNIMMessage:msgData];
            break;
        default:
            return [[SessionMsgModel alloc] initWithNIMMessage:msgData];
            break;
    }
}

@end

@implementation SessionMsgModel

- (instancetype)initWithNIMMessage:(NIMMessage*)msg
{
    if (self = [self init]) {
        _msgData = msg;
        _showSendMsgStatusView = NO;
        _isAudioPlaying = NO;
        
        NSString *currentUserID = [[[NIMSDK sharedSDK] loginManager] currentAccount];
        _isFromMe = [msg.from isEqualToString:currentUserID];
    }
    return self;
}

- (NSString*)description{
    return _msgData.text;
}

- (BOOL)isEqual:(id)object{
    if (![object isKindOfClass:[SessionMsgModel class]]) {
        return NO;
    }else{
        SessionMsgModel * model = object;
        return [self.msgData isEqual:model.msgData];
    }
}

@end



@implementation SessionNoticationMsgModel
- (instancetype)initWithNIMMessage:(NIMMessage*)msg
{
    if (self = [super initWithNIMMessage:msg]) {
    }
    return self;
}

- (NSString*)notificationFormatedMessage{
    NIMNotificationObject *object = self.msgData.messageObject;
    if (self.msgData.messageType == NIMMessageTypeNotification)
    {
        if (object.notificationType == NIMNotificationTypeTeam)
        {
            NIMTeamNotificationContent *content = (NIMTeamNotificationContent*)object.content;
            NSString *currentAccount = [[NIMSDK sharedSDK].loginManager currentAccount];
            NSString *source;
            if ([content.sourceID isEqualToString:currentAccount]) {
                source = @"你";
            }else{
                source = [SessionUtil showNick:content.sourceID inSession:self.msgData.session];
            }
            NSMutableArray *targets = [[NSMutableArray alloc] init];
            for (NSString *item in content.targetIDs) {
                if ([item isEqualToString:currentAccount]) {
                    [targets addObject:@"你"];
                }else{
                    NSString *targetShowName = [SessionUtil showNick:item inSession:self.msgData.session];
                    [targets addObject:targetShowName];
                }
            }
            NSString *targetText = [targets count] > 1 ? [targets componentsJoinedByString:@","] : [targets firstObject];
            switch (content.type) {
                case NIMTeamOperationTypeInvite:{
                    NSString *str = [NSString stringWithFormat:@"%@邀请%@",source,targets.firstObject];
                    if (targets.count>1) {
                        str = [str stringByAppendingFormat:@"等%zd人",targets.count];
                    }
                    str = [str stringByAppendingFormat:@"进入了群聊"];
                    _notificationFormatedMessage = str;
                }
                    break;
                case NIMTeamOperationTypeDismiss:
                    _notificationFormatedMessage = [NSString stringWithFormat:@"%@解散了群聊",source];
                    break;
                case NIMTeamOperationTypeKick:{
                    NSString *str = [NSString stringWithFormat:@"%@将%@",source,targets.firstObject];
                    if (targets.count>1) {
                        str = [str stringByAppendingFormat:@"等%zd人",targets.count];
                    }
                    str = [str stringByAppendingFormat:@"移出了群聊"];
                    _notificationFormatedMessage = str;
                }
                    break;
                case NIMTeamOperationTypeUpdate:
                {
                    NIMTeamUpdateTag tag = [[content extraData] integerValue];
                    switch (tag) {
                        case NIMTeamUpdateTagName:
                            _notificationFormatedMessage = [NSString stringWithFormat:@"%@更新了群名称",source];
                            break;
                        case NIMTeamUpdateTagIntro:
                            _notificationFormatedMessage = [NSString stringWithFormat:@"%@更新了群介绍",source];
                            break;
                        case NIMTeamUpdateTagAnouncement:
                            _notificationFormatedMessage = [NSString stringWithFormat:@"%@更新了群公告",source];
                            break;
                        case NIMTeamUpdateTagJoinMode:
                            _notificationFormatedMessage = [NSString stringWithFormat:@"%@更新了群验证方式",source];
                            break;
                        default:
                             _notificationFormatedMessage = [NSString stringWithFormat:@"%@更新了群信息",source];
                            break;
                    }
                }
                   
                    break;
                case NIMTeamOperationTypeLeave:
                    _notificationFormatedMessage = [NSString stringWithFormat:@"%@离开了群聊",source];
                    break;
                case NIMTeamOperationTypeApplyPass:{
                    if ([source isEqualToString:targetText]) {
                        //说明是以不需要验证的方式进入
                        _notificationFormatedMessage = [NSString stringWithFormat:@"%@进入了群聊",source];
                    }else{
                        _notificationFormatedMessage = [NSString stringWithFormat:@"%@通过了%@的入群申请",source,targetText];
                    }
                }
                    break;
                case NIMTeamOperationTypeTransferOwner:
                    _notificationFormatedMessage = [NSString stringWithFormat:@"%@转移了群主身份给%@",source,targetText];
                    break;
                case NIMTeamOperationTypeAddManager:
                    _notificationFormatedMessage = [NSString stringWithFormat:@"%@被群主添加为群管理员",targetText];
                    break;
                case NIMTeamOperationTypeRemoveManager:
                    _notificationFormatedMessage = [NSString stringWithFormat:@"%@被群主撤销了群管理员身份",targetText];
                    break;
                case NIMTeamOperationTypeAcceptInvitation:
                    _notificationFormatedMessage = [NSString stringWithFormat:@"%@接受%@的邀请进群",source,targetText];
                    break;
                default:
                    break;
            }

        }
    }
    if (!_notificationFormatedMessage.length) {
        _notificationFormatedMessage = [NSString stringWithFormat:@"未知系统信息"];
    }
    return _notificationFormatedMessage;
}


@end


@implementation SessionTimeModel


@end
