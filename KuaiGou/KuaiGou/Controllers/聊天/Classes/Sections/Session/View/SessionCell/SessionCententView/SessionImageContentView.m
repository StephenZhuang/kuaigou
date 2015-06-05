//
//  SessionImageContentView.m
//  NIMDemo
//
//  Created by chrisRay on 15/1/28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "SessionImageContentView.h"
#import "NIMMessage.h"
#import "NIMImageObject.h"
#import "SessionMsgModel.h"
#import "SessionCellLayoutConstant.h"
#import "UIResponder+Router.h"
#import "LoadProgressView.h"
#import "SessionMsgModel+SessionCellLayoutProtocol.h"
#import "SessionCellActionHandler.h"
#import "UIView+NIMDemo.h"
#import "NIMSDK.h"

@interface SessionImageContentView()

@property (nonatomic,strong,readwrite) UIImageView * imageView;

@property (nonatomic,strong) LoadProgressView * progressView;

@end

@implementation SessionImageContentView

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

    }
    return self;
}

- (void)refresh:(SessionMsgModel *)data{
    [super refresh:data];
    NIMImageObject * imageObject = (NIMImageObject*)data.msgData.messageObject;
    UIImage * image              = [UIImage imageWithContentsOfFile:imageObject.thumbPath];
    self.imageView.image         = image;
    self.progressView.hidden     = (data.msgData.deliveryState != NIMMessageDeliveryStateDelivering);
    if (!self.progressView.hidden) {
        [self.progressView setProgress:[[[NIMSDK sharedSDK] chatManager] messageTransportProgress:self.chatMessage.msgData]];
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
}


- (void)onTap:(id)sender
{
    NIMImageObject * imageObject = (NIMImageObject*)[self.chatMessage msgData].messageObject;
    SessionCellEventParam *param = [[SessionCellEventParam alloc] initSessionCellEventParam:SessionMessageEventIDPreviewPicture
                                                                                      param:imageObject];
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
