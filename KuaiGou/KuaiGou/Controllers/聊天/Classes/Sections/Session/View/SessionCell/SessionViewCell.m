//
//  SessionViewCell.m
//  NIMDemo
//
//  Created by ght on 15-1-28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "SessionViewCell.h"
#import "SessionMessageContentView.h"
#import "SessionMsgModel+SessionCellLayoutProtocol.h"
#import "SessionCellLayoutConstant.h"
#import "UIView+NIMDemo.h"
#import "SessionCellActionHandler.h"
#import "SessionAudioContentView.h"
#import "SessionMsgCellFactory.h"
#import "AvatarImageView.h"
#import "ContactUtil.h"
#import "ContactDataItem.h"
#import "SessionUtil.h"
#import "NIMNotificationObject.h"

@interface SessionViewCell ()<PlayAudioUIDelegate>
{
    UILongPressGestureRecognizer *_longPressGesture;
    UIMenuController             *_menuController;
}
@end


@implementation SessionViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        //
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUIComponents];
        [self initGesture];
    }
    return self;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copyText:) || action == @selector(deleteMsg:)) {
        return YES;
    }
    return NO;
}

- (void)initUIComponents
{
    self.backgroundColor = [UIColor clearColor];
    
    //retyrBtn
    _retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_retryButton setImage:[UIImage imageNamed:@"btn_message_cell_error"] forState:UIControlStateNormal];
    [_retryButton setImage:[UIImage imageNamed:@"btn_message_cell_error"] forState:UIControlStateHighlighted];
    [_retryButton setFrame:CGRectMake(0, 0, 25, 25)];
    [_retryButton addTarget:self action:@selector(onRetryMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_retryButton];

    //traningActivityIndicator
    _traningActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0,0,20,20)];
    [self.contentView addSubview:_traningActivityIndicator];
    
    //headerView
    _headImageView = [AvatarImageView demoInstanceRecentSessionList];
    [self.contentView addSubview:_headImageView];
    
    //nicknamel
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:12.0];
    [_nameLabel setBackgroundColor:[UIColor clearColor]];
    [_nameLabel setTextColor:[UIColor darkGrayColor]];
    [_nameLabel setHidden:YES];
    [self.contentView addSubview:_nameLabel];

    //内容view
    NIMMessageType messageType = [self msgTypeWithCellReuseId:self.reuseIdentifier];
    if (messageType == NIMMessageTypeNotification) {
        NSString *notifyType = [self notifyTypeWithCellReuseId:self.reuseIdentifier];
        _bubbleView = [[[SessionMsgCellFactory viewClassFromNotificationType:notifyType] alloc] initSessionMessageContentView];
    }else{
        _bubbleView = [[[SessionMsgCellFactory viewClassFromSessionMessageType:messageType] alloc] initSessionMessageContentView];
    }

    if (messageType == NIMMessageTypeAudio) {
        ((SessionAudioContentView*)_bubbleView).audioUIDelegate = self;
    }

    [self.contentView addSubview:_bubbleView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self layoutNameLabel];
    [self layoutBubbleView];
    [self layoutRetryButton];
    [self layoutActivityIndicator];
}

- (void)layoutNameLabel
{
    if ([_chatMessage nickNameShow]) {
        _nameLabel.frame = CGRectMake(OtherBubbleOriginX + 2, -3,
                                      200, OtherNickNameHeight);
    }
}

- (void)layoutBubbleView
{
    UIEdgeInsets contentInsets = [self.chatMessage bubbleViewInsets];
    if ([_chatMessage isFromMe]) {
        contentInsets.left = CGRectGetMinX(self.headImageView.frame) - ProtraitRightToBubble  - CGRectGetWidth(self.bubbleView.bounds);
    }
    _bubbleView.left = contentInsets.left;
    _bubbleView.top = contentInsets.top;
}

- (void)layoutActivityIndicator
{
    if (_traningActivityIndicator.isAnimating) {
        CGFloat centerX = 0;
        if ([_chatMessage isFromMe]) {
            centerX = CGRectGetMinX(_bubbleView.frame) - [_chatMessage retryButtonBubblePadding] - CGRectGetWidth(_traningActivityIndicator.bounds)/2;;
        } else
        {
            centerX = CGRectGetMaxX(_bubbleView.frame) + [_chatMessage retryButtonBubblePadding] +  CGRectGetWidth(_traningActivityIndicator.bounds)/2;
        }
        self.traningActivityIndicator.center = CGPointMake(centerX,
                                                           _bubbleView.center.y);
    }
}

- (void)layoutRetryButton
{
    if (!_retryButton.isHidden) {
        CGFloat centerX = 0;
        if (![_chatMessage isFromMe]) {
          centerX = CGRectGetMaxX(_bubbleView.frame) + [_chatMessage retryButtonBubblePadding] +CGRectGetWidth(_retryButton.bounds)/2;
        } else
        {
          centerX = CGRectGetMinX(_bubbleView.frame) - [_chatMessage retryButtonBubblePadding] - CGRectGetWidth(_retryButton.bounds)/2;
        }
       
        _retryButton.center = CGPointMake(centerX, _bubbleView.center.y);
    }
}

- (void)reloadData:(SessionMsgModel *)data
{
    _chatMessage = data;
    _headImageView.frame = [_chatMessage avatarViewRect];
    NSString *imageName = [ContactUtil queryContactByUsrId:data.msgData.from].iconUrl;
    UIImage * image = [UIImage imageNamed:imageName];
    if (image) {
        _headImageView.image = image;
    }else{
        _headImageView.image = [UIImage imageNamed:@"DefaultAvatar"];
    }
    if([_chatMessage nickNameShow])
    {
        NSString *nick = [SessionUtil showNickInMessage:data.msgData];
        [_nameLabel setText:nick];
    }
    [_nameLabel setHidden:![_chatMessage nickNameShow]];
    [_bubbleView refresh:data];
    [self refreshSubStatusUI:data.msgData];
}

- (void)refreshSubStatusUI:(NIMMessage*)msgData
{
    _chatMessage.msgData = msgData;
    BOOL isActivityIndicatorHidden = [_chatMessage activityIndicatorHidden];
    if (isActivityIndicatorHidden) {
         [_traningActivityIndicator stopAnimating];
    } else
    {
        [_traningActivityIndicator startAnimating];
    }
    [_traningActivityIndicator setHidden:isActivityIndicatorHidden];
    [_retryButton setHidden:[_chatMessage retryButtonHidden]];
    [_bubbleView refresh:_chatMessage];
    [self setNeedsLayout];
}

- (void)initGesture
{
    _longPressGesture= [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesturePress:)];
    [self addGestureRecognizer:_longPressGesture];
}

+ (NSString*)cellIdentifierWithMsgType:(SessionMsgModel *)model
{
    BOOL isFromMe = model.isFromMe;
    NIMMessageType msgType = model.msgData.messageType;
    if (msgType != NIMMessageTypeNotification) {
        return [NSString stringWithFormat:@"messageCell_%@_%@",@(msgType),@(isFromMe)];
    }else{
        NIMNotificationObject *object = model.msgData.messageObject;
        NSString *notify = NSStringFromClass([object.content class]);
        return [NSString stringWithFormat:@"messageCell_%@_%@_%@",@(msgType),@(isFromMe),notify];
    }

}

- (NIMMessageType)msgTypeWithCellReuseId:(NSString*)cellReuseId
{
    NSArray * components = [cellReuseId componentsSeparatedByString:@"_"];
    if (components.count == 3 || components.count == 4) {
        return [components[1] integerValue];
    }
    return NIMMessageTypeCustom;
}


- (NSString *)notifyTypeWithCellReuseId:(NSString*)cellReuseId
{
    NSArray * components = [cellReuseId componentsSeparatedByString:@"_"];
    return components[3];
}

#pragma mark - cell actions
- (void)longGesturePress:(UIGestureRecognizer*)gestureRecognizer
{
    if (!self.needDelete) {
        return;
    }
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gestureRecognizer locationInView:self];
        if (CGRectContainsPoint(self.bubbleView.frame,point))
        {
            if ([self becomeFirstResponder]) {
                if (!_menuController) {
                    _menuController = [UIMenuController sharedMenuController];
                }
                
                NSMutableArray *metuItems = [NSMutableArray arrayWithObjects:[[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"删除", nil) action:@selector(deleteMsg:)], nil];
                if ([_chatMessage msgData].messageType == NIMMessageTypeText) {
                    [metuItems insertObject:[[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"复制", nil) action:@selector(copyText:)] atIndex:0];
                }
                
                _menuController.menuItems = metuItems;
                [_menuController setTargetRect:_bubbleView.frame inView:self];
                [_menuController setMenuVisible:YES animated:YES];
            }
        }
    }
}

- (void)onRetryMessage:(id)sender
{
    //重发或重收
    SessionCellEventParam *param = [[SessionCellEventParam alloc] initSessionCellEventParam:[_chatMessage.msgData isReceivedMsg]?SessionMessageEventIDRetryReceiveMsg:SessionMessageEventIDRetrySendMsg param:[_chatMessage msgData]];
    if (self.cellEventHandlerDelegate && [self.cellEventHandlerDelegate respondsToSelector:@selector(sessionMessageEventHandle:)]) {
        //
        [self.cellEventHandlerDelegate sessionMessageEventHandle:param];
    }
}

- (void)nim_routerEvent:(id)data
{
    if ([data isKindOfClass:[SessionCellEventParam class]])
    {
        if (self.cellEventHandlerDelegate && [self.cellEventHandlerDelegate respondsToSelector:@selector(sessionMessageEventHandle:)]) {
            [self.cellEventHandlerDelegate sessionMessageEventHandle:data];
        }
    }
    else
    {
        DDLogWarn(@"%@ not recognized",data);
    }
}

- (void)copyText:(id)sender
{
    if (_chatMessage.msgData.text.length) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:_chatMessage.msgData.text];
    }
}

- (void)deleteMsg:(id)sender
{
    //删除
    SessionCellEventParam *param = [[SessionCellEventParam alloc] initSessionCellEventParam:SessionMessageEventIDDeleteMessage param:_chatMessage];
    if (self.cellEventHandlerDelegate && [self.cellEventHandlerDelegate respondsToSelector:@selector(sessionMessageEventHandle:)]) {
        [self.cellEventHandlerDelegate sessionMessageEventHandle:param];
    }
}

#pragma mark - PlayAudioUIDelegate
- (void)retryDownloadMsg
{
    [self onRetryMessage:nil];
}

- (void)startPlayingAudioUI
{
    //更新DB
    NIMMessage * message = self.chatMessage.msgData;
    message.isPlayed  = YES;
    //hidden红点
    // 开始start
}

@end
