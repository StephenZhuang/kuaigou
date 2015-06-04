//
//  SessionViewCell.h
//  NIMDemo
//
//  Created by ght on 15-1-28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionMsgModel.h"

@class SessionMessageContentView;
@class AvatarImageView;

@protocol SessionMsgCellEventHandlerProtocol;

@interface SessionViewCell : UITableViewCell
@property (nonatomic, strong) SessionMsgModel *chatMessage;
@property (nonatomic, weak)   id<SessionMsgCellEventHandlerProtocol> cellEventHandlerDelegate;

//UI
@property (nonatomic, strong) AvatarImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;               //姓名（群显示 个人不显示）
@property (nonatomic, strong) SessionMessageContentView *bubbleView;   //内容区域
@property (nonatomic, strong) UIActivityIndicatorView          *traningActivityIndicator;  //发送loading
@property (nonatomic, strong) UIButton *retryButton;  //重试
@property (nonatomic, strong) UILabel  *msgStatusLabel; //已读回执

@property (nonatomic, strong) UIImageView *audioPlayedIcon; //语音未读红点

- (void)reloadData:(SessionMsgModel*)data;

//刷UI
- (void)refreshSubStatusUI:(NIMMessage*)msgData;

+ (NSString*)cellIdentifierWithMsgType:(NIMMessageType)msgType isFromMe:(BOOL)isFromMe;

@end
