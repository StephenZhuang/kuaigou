//
//  UserCommandSender.m
//  NIM
//
//  Created by amao on 3/24/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "UserCommandSender.h"
#import "NIMSDK.h"


@interface UserCommandSender ()
@property (nonatomic,strong)    NSDate *lastTime;
@end

@implementation UserCommandSender
- (void)sendTypingState:(NIMSession *)session
{
    if (session.sessionType != NIMSessionTypeP2P)
    {
        return;
    }
    
    NSDate *now = [NSDate date];
    if (_lastTime == nil ||
        [now timeIntervalSinceDate:_lastTime] > 3)
    {
        _lastTime = now;
        
        NSDictionary *dict = @{NIMCommandID : @(NIMCommandTyping)};
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:0
                                                         error:nil];
        NSString *content = [[NSString alloc] initWithData:data
                                                  encoding:NSUTF8StringEncoding];
        
        NIMCustomSystemNotification *notification = [[NIMCustomSystemNotification alloc] initWithContent:content];
        notification.sendToOnlineUsersOnly  = YES;
        [[[NIMSDK sharedSDK] systemNotificationManager] sendCustomNotification:notification
                                                                     toSession:session
                                                                    completion:nil];
    }
}
@end
