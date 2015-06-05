//
//  SessionFileTransContentView.m
//  NIM
//
//  Created by chrisRay on 15/4/21.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "SessionFileTransContentView.h"
#import "LoadProgressView.h"
#import "NIMMessage.h"
#import "SessionMsgModel+SessionCellLayoutProtocol.h"
#import "UIResponder+Router.h"
#import "UIView+NIMDemo.h"
#import "SessionCellLayoutConstant.h"
#import "SessionCellActionHandler.h"

@interface SessionFileTransContentView()

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *sizeLabel;

@property (nonatomic,strong) UIProgressView *progressView;

@property (nonatomic,strong) UIView *bkgView;

@end

@implementation SessionFileTransContentView

- (instancetype)initSessionMessageContentView{
    self = [super initSessionMessageContentView];
    if (self) {
        self.opaque              = YES;
        _bkgView                 = [[UIView alloc]initWithFrame:CGRectZero];
        _bkgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bkgView];
        _imageView               = [[UIImageView alloc] initWithFrame:CGRectZero];
        UIImage * image          = [UIImage imageNamed:@"icon_file"];
        _imageView.image         = image;
        [_imageView sizeToFit];
        [self addSubview:_imageView];
        _titleLabel               = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font          = [UIFont systemFontOfSize:15.f];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [self addSubview:_titleLabel];
        _sizeLabel           = [[UILabel alloc] initWithFrame:CGRectZero];
        _sizeLabel.font      = [UIFont systemFontOfSize:13.f];
        _sizeLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:_sizeLabel];
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progress = 0.0f;
        [self addSubview:_progressView];
    }
    return self;
}

- (void)refresh:(SessionMsgModel *)data{
    [super refresh:data];
    NIMFileObject *fileObject = (NIMFileObject *)data.msgData.messageObject;
    self.titleLabel.text = fileObject.displayName;
    [self.titleLabel sizeToFit];
    self.sizeLabel.text = [NSString stringWithFormat:@"%zdKB",fileObject.fileLength/1024];
    [self.sizeLabel sizeToFit];
    if (data.isFromMe && data.msgData.deliveryState == NIMMessageDeliveryStateDelivering) {
        self.progressView.hidden   = NO;
        self.progressView.progress = [[NIMSDK sharedSDK].chatManager messageTransportProgress:data.msgData];
    }else{
        self.progressView.hidden = YES;
    }
}



- (void)layoutSubviews{
    [super layoutSubviews];
    UIEdgeInsets contentInsets = [self.chatMessage contentViewInsets];
    
    CGRect bkgViewFrame = CGRectMake(contentInsets.left, contentInsets.top, [self.chatMessage contentSize].width, [self.chatMessage contentSize].height);
    self.bkgView.frame = bkgViewFrame;

    self.imageView.left      = FileTransMessageIconLeft;
    self.imageView.centerY   = self.height * .5f;

    if (self.width < FileTransMessageTitleLeft + self.titleLabel.width + FileTransMessageSizeTitleRight) {
        self.titleLabel.width = self.width - FileTransMessageTitleLeft - FileTransMessageSizeTitleRight;
    }
    self.titleLabel.left     = FileTransMessageTitleLeft;
    self.titleLabel.top      = FileTransMessageTitleTop;
    
    self.sizeLabel.right     = self.width - FileTransMessageSizeTitleRight;
    self.sizeLabel.bottom    = self.height - FileTransMessageSizeTitleBottom;
    
    self.progressView.top    = FileTransMessageProgressTop;
    self.progressView.width  = self.width - FileTransMessageProgressLeft - FileTransMessageProgressRight;
    self.progressView.left   = FileTransMessageProgressLeft;
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.cornerRadius = 13.0;
    maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    maskLayer.frame = self.bkgView.bounds;
    self.bkgView.layer.mask = maskLayer;
}


- (void)onTap:(id)sender
{
    NIMFileObject   *fileObject = (NIMFileObject*)[self.chatMessage msgData].messageObject;
    SessionCellEventParam *param = [[SessionCellEventParam alloc] initSessionCellEventParam:SessionMessageEventIDPreviewFile
                                                                                      param:fileObject];
    [self nim_routerEvent:param];
}

- (void)updateProgress:(float)progress
{
    if (progress > 1.0) {
        progress = 1.0;
    }
    self.progressView.progress = progress;
}

@end

