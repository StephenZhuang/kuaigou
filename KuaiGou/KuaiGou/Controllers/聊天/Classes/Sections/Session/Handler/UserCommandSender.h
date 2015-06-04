//
//  UserCommandSender.h
//  NIM
//
//  Created by amao on 3/24/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>


#define NIMCommandID    @"id"
#define NIMCommandTyping  (1)

@class NIMSession;

@interface UserCommandSender : NSObject
- (void)sendTypingState:(NIMSession *)session;
@end
