//
//  NIMNotificationCenter.m
//  NIM
//
//  Created by Xuhui on 15/3/25.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NIMNotificationCenter.h"
#import "UsrInfoData.h"
//#import "VideoChatViewController.h"
//#import "AudioChatViewController.h"
#import "SessionViewController.h"
@interface NIMNotificationCenter () <NIMSystemNotificationManagerDelegate,NIMNetCallManagerDelegate>

@end

@implementation NIMNotificationCenter

- (instancetype)init {
    self = [super init];
    if(self) {
        [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
        [[NIMSDK sharedSDK].netCallManager addDelegate:self];
    }
    return self;
}

- (void)dealloc{
    [[NIMSDK sharedSDK].systemNotificationManager removeDelegate:self];
    [[NIMSDK sharedSDK].netCallManager removeDelegate:self];
}

#pragma mark - NIMSystemNotificationManagerDelegate
- (void)onReceiveSystemNotification:(NIMSystemNotification *)notification {
    [[UsrInfoData sharedInstance] queryUsrInfoById:notification.sourceID needRemoteFetch:YES fetchCompleteHandler:nil];
}

#pragma mark - NIMNetCallManagerDelegate
- (void)onReceive:(UInt64)callID from:(NSString *)caller type:(NIMNetCallType)type{
    if ([NIMSDK sharedSDK].netCallManager.currentCallID > 0) {
        [[NIMSDK sharedSDK].netCallManager control:callID type:NIMNetCallControlTypeBusyLine];
        return;
    };
    UIViewController *vc;
    switch (type) {
        case NIMNetCallTypeVideo:{
//            vc = [[VideoChatViewController alloc] initWithCaller:caller callId:callID];
            
        }
            break;
        case NIMNetCallTypeAudio:{
//            vc = [[AudioChatViewController alloc] initWithCaller:caller callId:callID];
        }
            break;
        default:
            break;
    }
    if (!vc) {
        return;
    }

}

@end
