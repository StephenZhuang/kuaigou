//
//  NIMNotificationCenter.m
//  NIM
//
//  Created by Xuhui on 15/3/25.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NIMNotificationCenter.h"
#import "UsrInfoData.h"

@interface NIMNotificationCenter () <NIMSystemNotificationManagerDelegate>

@end

@implementation NIMNotificationCenter

-(instancetype)init {
    self = [super init];
    if(self) {
        [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    }
    return self;
}

- (void)onReceiveSystemNotification:(NIMSystemNotification *)notification {
    [[UsrInfoData sharedInstance] queryUsrInfoById:notification.sourceID needRemoteFetch:YES fetchCompleteHandler:nil];
}

@end
