//
//  SessionVideoContentView.m
//  NIM
//
//  Created by chrisRay on 15/4/10.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "SessionVideoContentView.h"
#import "NIMMessage.h"
#import "NIMVideoObject.h"
#import "SessionMsgModel.h"
#import "SessionCellLayoutConstant.h"
#import "UIResponder+Router.h"
#import "LoadProgressView.h"
#import "SessionMsgModel+SessionCellLayoutProtocol.h"
#import "SessionCellActionHandler.h"
#import "UIView+NIMDemo.h"
#import "NIMSDK.h"

@interface SessionVideoContentView()

@property (nonatomic,strong,readwrite) UIImageView * imageView;

@property (nonatomic,strong) UIButton *playBtn;

@property (nonatomic,strong) LoadProgressView * progressView;

@end

@implementation SessionVideoContentView

- (instancetype)initSessionMessageContentView{
    self = [super initSessionMessageContentView];
    if (self) {
        self.opaque = YES;
        _imageView  = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.backgroundColor = [UIColor blackColor];
        [self addSubview:_imageView];
        _progressView = [[LoadProgressView alloc] initWithFrame:CGRectZero];
        _progressView.maxProgress = 0.99;
        [self addSubview:_progressView];
        
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"btn_play_normal"] forState:UIControlStateNormal];
        [_playBtn sizeToFit];
        [_playBtn setUserInteractionEnabled:NO];
        [self addSubview:_playBtn];
        
    }
    return self;
}

- (void)refresh:(SessionMsgModel *)data{
    [super refresh:data];
    NIMVideoObject * videoObject = (NIMVideoObject*)data.msgData.messageObject;
    UIImage * image              = [UIImage imageWithContentsOfFile:videoObject.coverPath];
    self.imageView.image         = image;
    _progressView.hidden         = (data.msgData.deliveryState != NIMMessageDeliveryStateDelivering);
    if (data.msgData.isReceivedMsg) {
        _playBtn.hidden = NO;
    }else{
        _playBtn.hidden = (data.msgData.deliveryState != NIMMessageDeliveryStateDeliveried);
    }

    if (!_progressView.hidden) {
        [_progressView setProgress:[[[NIMSDK sharedSDK] chatManager] messageTransportProgress:self.chatMessage.msgData]];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIEdgeInsets contentInsets = [self.chatMessage contentViewInsets];
    CGRect imageViewFrame = CGRectMake(contentInsets.left, contentInsets.top, [self.chatMessage contentSize].width, [self.chatMessage contentSize].height);
    self.imageView.frame  = imageViewFrame;
    _progressView.frame   = self.bounds;
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.cornerRadius = 13.0;
    maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    maskLayer.frame = self.imageView.bounds;
    self.imageView.layer.mask = maskLayer;
    
    self.playBtn.centerX = self.width  * .5f;
    self.playBtn.centerY = self.height * .5f;
}


- (void)onTap:(id)sender
{
    NIMVideoObject *videoObject = (NIMVideoObject*)[self.chatMessage msgData].messageObject;
    SessionCellEventParam *param = [[SessionCellEventParam alloc] initSessionCellEventParam:SessionMessageEventIDTapVideoCell
                                                                                      param:videoObject];
    [self nim_routerEvent:param];

}

- (void)updateProgress:(float)progress
{
    [_progressView setProgress:progress];
    if (progress>_progressView.maxProgress) {
        [_progressView setHidden:YES];
    }
}


@end
