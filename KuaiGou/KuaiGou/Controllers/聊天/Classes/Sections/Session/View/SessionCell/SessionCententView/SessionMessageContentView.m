//
//  SessionMessageContentView.m
//  NIMDemo
//
//  Created by ght on 15-1-28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "SessionMessageContentView.h"
#import "SessionMsgModel+SessionCellLayoutProtocol.h"
#import "SessionCellLayoutConstant.h"

@implementation SessionMessageContentView

- (instancetype)initSessionMessageContentView
{
    CGSize size = DefaultBubbleSize;
    if (self = [self initWithFrame:CGRectMake(0, 0, size.width, size.height)]) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [self addGestureRecognizer:_tapGesture];
        _bubbleBGView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,size.width,size.height)];
        _bubbleBGView.opaque = YES;
        _bubbleBGView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_bubbleBGView];
    }
    return self;
}

- (void)refresh:(SessionMsgModel*)data{
    self.chatMessage = data;
    CGSize size = [data bubbleViewSize];
    self.bounds = CGRectMake(0, 0, size.width, size.height);
    [_bubbleBGView setImage:[data bubbleImageForState:UIControlStateNormal]];
    _bubbleBGView.frame = self.bounds;
}


- (void)layoutSubviews{
    [super layoutSubviews];
}


- (void)updateProgress:(float)progress
{
    
}

- (void)onTap:(id)sender
{
}

@end
