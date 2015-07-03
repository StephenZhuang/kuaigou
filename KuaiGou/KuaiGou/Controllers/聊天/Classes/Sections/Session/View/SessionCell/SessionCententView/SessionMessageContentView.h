//
//  SessionMessageContentView.h
//  NIMDemo
//
//  Created by ght on 15-1-28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionFileStatusProtocol.h"

@class SessionMsgModel;
@interface SessionMessageContentView : UIView <SessionFileStatusProtocol>
{
        UITapGestureRecognizer *_tapGesture;
}
@property (strong, nonatomic) SessionMsgModel   *chatMessage;

@property (nonatomic,strong) UIImageView * bubbleBGView;


- (instancetype)initSessionMessageContentView;

- (void)refresh:(SessionMsgModel*)data;

- (void)onTap:(id)sender;

@end
