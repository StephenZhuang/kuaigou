//
//  VideoChatViewController.m
//  NIM
//
//  Created by chrisRay on 15/5/5.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "VideoChatViewController.h"
#import "UIView+Toast.h"
#import "M80TimerHolder.h"
#import "AudioChatViewController.h"
#import "NetCallChatInfo.h"
#import "SessionUtil.h"
#import "AudioUtil.h"
#import "VideoChatNetStatusView.h"

@interface VideoChatViewController ()

@property (nonatomic,assign) NIMNetCallCamera cameraType;

@property (nonatomic,strong) CALayer *localVideoLayer;

@property (nonatomic,assign) BOOL oppositeCloseVideo;

@end

@implementation VideoChatViewController

- (instancetype)initWithCallInfo:(NetCallChatInfo *)callInfo
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.callInfo = callInfo;
        self.callInfo.isMute = NO;
        self.callInfo.disableCammera = NO;
        if (!self.localVideoLayer) {
            //没有的话，尝试去取一把预览层（从视频切到语音再切回来的情况下是会有的）
            self.localVideoLayer = [NIMSDK sharedSDK].netCallManager.localPreviewLayer;
        }
        [[NIMSDK sharedSDK].netCallManager switchType:NIMNetCallTypeVideo];
    }
    return self;
}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.callInfo.callType = NIMNetCallTypeVideo;
        _cameraType = NIMNetCallCameraFront;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.localVideoLayer) {
        [self.localView.layer addSublayer:self.localVideoLayer];
    }
}

#pragma mark - Call Life
- (void)startByCaller{
    [super startByCaller];
    [self startInterface];
}

- (void)startByCallee{
    [super startByCallee];
    [self waitToCallInterface];
}
- (void)onCalling{
    [super onCalling];
    [self videoCallingInterface];
}

- (void)waitForConnectiong{
    [super waitForConnectiong];
    [self connectingInterface];
}

#pragma mark - Interface
//正在接听中界面
- (void)startInterface{
    self.acceptBtn.hidden = YES;
    self.refuseBtn.hidden   = YES;
    self.hungUpBtn.hidden   = NO;
    self.connectingLabel.hidden = NO;
    self.connectingLabel.text = @"正在呼叫，请稍候...";
    self.switchModelBtn.hidden = YES;
    self.switchCameraBtn.hidden = YES;
    self.muteBtn.hidden = YES;
    self.disableCameraBtn.hidden = YES;
    [self.hungUpBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    [self.hungUpBtn addTarget:self action:@selector(hangup) forControlEvents:UIControlEventTouchUpInside];
}

//选择是否接听界面
- (void)waitToCallInterface{
    self.acceptBtn.hidden = NO;
    self.refuseBtn.hidden   = NO;
    self.hungUpBtn.hidden   = YES;
    NSString *nick = [SessionUtil showNick:self.callInfo.caller inSession:nil];
    self.connectingLabel.text = [nick stringByAppendingString:@"的来电"];
    self.muteBtn.hidden = YES;
    self.switchCameraBtn.hidden = YES;
    self.disableCameraBtn.hidden = YES;
    self.switchModelBtn.hidden = YES;
}

//连接对方界面
- (void)connectingInterface{
    self.acceptBtn.hidden = YES;
    self.refuseBtn.hidden   = YES;
    self.hungUpBtn.hidden   = NO;
    self.connectingLabel.hidden = NO;
    self.connectingLabel.text = @"正在连接对方...请稍后...";
    self.switchModelBtn.hidden = YES;
    self.switchCameraBtn.hidden = YES;
    self.muteBtn.hidden = YES;
    self.disableCameraBtn.hidden = YES;
    [self.hungUpBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    [self.hungUpBtn addTarget:self action:@selector(hangup) forControlEvents:UIControlEventTouchUpInside];
}

//接听中界面(视频)
- (void)videoCallingInterface{
    NIMNetCallNetStatus status = [NIMSDK sharedSDK].netCallManager.netStatus;
    [self.netStatusView refreshWithNetState:status];
    self.acceptBtn.hidden = YES;
    self.refuseBtn.hidden   = YES;
    self.hungUpBtn.hidden   = NO;
    self.connectingLabel.hidden = YES;
    self.muteBtn.hidden = NO;
    self.switchCameraBtn.hidden = NO;
    self.disableCameraBtn.hidden = NO;
    self.switchModelBtn.hidden = NO;
    self.muteBtn.selected = self.callInfo.isMute;
    self.disableCameraBtn.selected = self.callInfo.disableCammera;
    [self.switchModelBtn setTitle:@"语音模式" forState:UIControlStateNormal];
    [self.hungUpBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    [self.hungUpBtn addTarget:self action:@selector(hangup) forControlEvents:UIControlEventTouchUpInside];
    self.localVideoLayer.hidden = NO;
}

//切换接听中界面(语音)
- (void)audioCallingInterface{
    AudioChatViewController *vc = [[AudioChatViewController alloc] initWithCallInfo:self.callInfo];
    [self dismiss:^{
//        UINavigationController *nav = (UINavigationController*)[MainTabController instance].selectedViewController;
//        [nav presentViewController:vc animated:NO completion:nil];
    }];
}

#pragma mark - IBAction

- (IBAction)acceptToCall:(id)sender{
    BOOL accept = (sender == self.acceptBtn);
    [self response:accept];
}

- (IBAction)mute:(BOOL)sender{
    self.callInfo.isMute = !self.callInfo.isMute;
    self.player.volume = !self.callInfo.isMute;
    [[NIMSDK sharedSDK].netCallManager setMute:self.callInfo.isMute];
    self.muteBtn.selected = self.callInfo.isMute;
}

- (IBAction)switchCamera:(id)sender{
    if (self.cameraType == NIMNetCallCameraFront) {
        self.cameraType = NIMNetCallCameraBack;
    }else{
        self.cameraType = NIMNetCallCameraFront;
    }
    [[NIMSDK sharedSDK].netCallManager switchCamera:self.cameraType];
}


- (IBAction)disableCammera:(id)sender{
    self.callInfo.disableCammera = !self.callInfo.disableCammera;
    [[NIMSDK sharedSDK].netCallManager setCameraDisable:self.callInfo.disableCammera];
    self.disableCameraBtn.selected = self.callInfo.disableCammera;
    if (self.callInfo.disableCammera) {
        [self.localVideoLayer removeFromSuperlayer];
        [[NIMSDK sharedSDK].netCallManager control:self.callInfo.callID type:NIMNetCallControlTypeCloseVideo];
    }else{
        [self.localView.layer addSublayer:self.localVideoLayer];
        [[NIMSDK sharedSDK].netCallManager control:self.callInfo.callID type:NIMNetCallControlTypeOpenVideo];
    }
}

- (IBAction)switchCallingModel:(id)sender{
    [[NIMSDK sharedSDK].netCallManager control:self.callInfo.callID type:NIMNetCallControlTypeToAudio];
    [self switchToAudio];
}


#pragma mark - NIMNetCallManagerDelegate

- (void)setLocalVideoLayer:(CALayer *)localVideoLayer{
    _localVideoLayer = localVideoLayer;
}

- (void)onLocalPreviewReady:(CALayer *)layer{
    if (self.localVideoLayer) {
        [self.localVideoLayer removeFromSuperlayer];
    }
    self.localVideoLayer = layer;
    layer.frame = self.localView.bounds;
    [self.localView.layer addSublayer:layer];
}

- (void)onRemoteImageReady:(CGImageRef)image{
    if (self.oppositeCloseVideo) {
        return;
    }
    self.remoteView.contentMode = UIViewContentModeScaleAspectFill;
    self.remoteView.image = [UIImage imageWithCGImage:image];
}

- (void)onHangup:(UInt64)callID
              by:(NSString *)user{
    if (self.callInfo.callID == callID) {
        [self dismiss:nil];
    }
}

- (void)onControl:(UInt64)callID
             from:(NSString *)user
             type:(NIMNetCallControlType)control{
    [super onControl:callID from:user type:control];
    switch (control) {
        case NIMNetCallControlTypeToAudio:
            [self switchToAudio];
            break;
        case NIMNetCallControlTypeCloseVideo:
            [self resetRemoteImage];
            self.oppositeCloseVideo = YES;
            [self.view makeToast:@"对方关闭了摄像头"];
            break;
        case NIMNetCallControlTypeOpenVideo:
            self.oppositeCloseVideo = NO;
            [self.view makeToast:@"对方开启了摄像头"];
            break;
        default:
            break;
    }
}

- (void)onCall:(UInt64)callID status:(NIMNetCallStatus)status{
    if (self.callInfo.callID != callID) {
        return;
    }
    [super onCall:callID status:status];
    //记时
    switch (status) {
        case NIMNetCallStatusConnect:
            self.durationLabel.hidden = NO;
            self.durationLabel.text = self.durationDesc;
            break;
        default:
            break;
    }
}

- (void)onCall:(UInt64)callID
     netStatus:(NIMNetCallNetStatus)status{
    [self.netStatusView refreshWithNetState:status];
}

#pragma mark - M80TimerHolderDelegate

- (void)onM80TimerFired:(M80TimerHolder *)holder{
    [super onM80TimerFired:holder];
    self.durationLabel.text = self.durationDesc;
}


#pragma mark - Misc
- (void)switchToAudio{
    [self audioCallingInterface];
}

- (NSString*)durationDesc{
    if (!self.callInfo.startTime) {
        return @"";
    }
    NSTimeInterval time = [NSDate date].timeIntervalSince1970;
    NSTimeInterval duration = time - self.callInfo.startTime;
    return [NSString stringWithFormat:@"%02d:%02d",(int)duration/60,(int)duration%60];
}

- (void)resetRemoteImage{
    self.remoteView.image = [UIImage imageNamed:@"netcall_bkg.jpg"];
}


@end
