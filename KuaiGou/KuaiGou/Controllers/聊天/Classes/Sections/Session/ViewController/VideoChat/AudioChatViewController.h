//
//  AudioChatViewController.h
//  NIM
//
//  Created by chrisRay on 15/5/12.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NetChatViewController.h"

@class NetCallChatInfo;
@class VideoChatNetStatusView;

@interface AudioChatViewController : NetChatViewController

- (instancetype)initWithCallInfo:(NetCallChatInfo *)callInfo;

@property (nonatomic,strong) IBOutlet UILabel *durationLabel;

@property (nonatomic,strong) IBOutlet UIButton *switchVideoBtn;

@property (nonatomic,strong) IBOutlet UIButton *muteBtn;

@property (nonatomic,strong) IBOutlet UIButton *speakerBtn;

@property (nonatomic,strong) IBOutlet UIButton *hangUpBtn;

@property (nonatomic,strong) IBOutlet UILabel  *connectingLabel;

@property (nonatomic,strong) IBOutlet UIButton *refuseBtn;

@property (nonatomic,strong) IBOutlet UIButton *acceptBtn;

@property (nonatomic,strong) IBOutlet VideoChatNetStatusView *netStatusView;

@end
