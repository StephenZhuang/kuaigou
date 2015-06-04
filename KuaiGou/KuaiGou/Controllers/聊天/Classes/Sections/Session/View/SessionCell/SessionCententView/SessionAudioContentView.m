//
//  SessionAudioCententView.m
//  NIMDemo
//
//  Created by ght on 15-2-3.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "SessionAudioContentView.h"
#import "SessionMsgModel+SessionCellLayoutProtocol.h"
#import "UIView+NIMDemo.h"
#import "NIMAudioObject.h"
@interface SessionAudioContentView()<NIMMediaManagerDelgate>

@property (nonatomic,strong) UIImageView *voiceImageView;

@property (nonatomic,strong) UILabel *durationLabel;

@end

@implementation SessionAudioContentView

-(instancetype)initSessionMessageContentView{
    self = [super initSessionMessageContentView];
    if (self) {
        [self addVoiceView];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addVoiceView{
    UIImage * image = [UIImage imageNamed:@"ReceiverVoiceNodePlaying.png"];
    _voiceImageView = [[UIImageView alloc] initWithImage:image];
    NSArray * animateNames = @[@"ReceiverVoiceNodePlaying001.png",@"ReceiverVoiceNodePlaying002.png",@"ReceiverVoiceNodePlaying003.png"];
    NSMutableArray * animationImages = [[NSMutableArray alloc] initWithCapacity:animateNames.count];
    for (NSString * animateName in animateNames) {
        UIImage * animateImage = [UIImage imageNamed:animateName];
        [animationImages addObject:animateImage];
    }
    _voiceImageView.animationImages = animationImages;
    _voiceImageView.animationDuration = 1.0;
    [self addSubview:_voiceImageView];
    
    _durationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _durationLabel.backgroundColor = [UIColor clearColor];
    _durationLabel.font = [UIFont systemFontOfSize:14.f];
    _durationLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:_durationLabel];
}

- (void)refresh:(SessionMsgModel*)data{
    [super refresh:data];
    NIMAudioObject *object = data.msgData.messageObject;
    _durationLabel.text = [NSString stringWithFormat:@"%zd\"",object.duration/1000];
    [_durationLabel sizeToFit];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    UIEdgeInsets contentInsets = [self.chatMessage contentViewInsets];
    if ([self.chatMessage isFromMe]) {
        self.voiceImageView.right = self.width - contentInsets.right;
        _durationLabel.left = contentInsets.left;
    } else
    {
       self.voiceImageView.left = contentInsets.left;
        _durationLabel.right = self.width - contentInsets.right;
    }
    _voiceImageView.centerY = self.height * .5f;
    _durationLabel.centerY = _voiceImageView.centerY;
}

-(void)onTap:(id)sender
{
    if ([[self.chatMessage msgData] attachmentDownloadState]== NIMMessageAttachmentDownloadStateFailed) {
        if (self.audioUIDelegate && [self.audioUIDelegate respondsToSelector:@selector(retryDownloadMsg)]) {
            [self.audioUIDelegate retryDownloadMsg];
        }
        return;
    }
    if ([[self.chatMessage msgData] attachmentDownloadState] == NIMMessageAttachmentDownloadStateDownloading) {
        //TODO 提示
        
    } else if ([[self.chatMessage msgData] attachmentDownloadState] == NIMMessageAttachmentDownloadStateDownloaded) {
        if (![self.chatMessage isAudioPlaying]) {
            NIMAudioObject *audioObject = (NIMAudioObject*)[self.chatMessage msgData].messageObject;
            [[NIMSDK sharedSDK].mediaManager playAudio:audioObject.path withDelegate:self];
        } else {
            [[NIMSDK sharedSDK].mediaManager stopPlay];
            [self stopPlayingUI];
        }
    }
}

#pragma mark - NIMMediaManagerDelgate

- (void)playAudio:(NSString *)filePath didBeganWithError:(NSError *)error {
    if(filePath && !error) {
        self.chatMessage.isAudioPlaying = YES;
        if (self.audioUIDelegate && [self.audioUIDelegate respondsToSelector:@selector(startPlayingAudioUI)]) {
            [self.audioUIDelegate startPlayingAudioUI];
            [self.voiceImageView startAnimating];
        }
    }
}

- (void)playAudio:(NSString *)filePath didCompletedWithError:(NSError *)error
{
    [self stopPlayingUI];
}

#pragma mark - private methods
- (void)stopPlayingUI
{
    self.chatMessage.isAudioPlaying = NO;
    [self.voiceImageView stopAnimating];
}
@end
