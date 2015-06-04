//
//  TokenManager.h
//  NIM
//
//  Created by Xuhui on 15/3/17.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NIMService.h"

extern NSString *const TokenDidUpdatedNotification;

extern NSString *const NIMDemoTokenErrorDomain;

typedef NS_ENUM(NSInteger, NIMDemoTokenManagerError) {
    NIMDemoTokenManagerErrorUpdateFailed
};

@interface TokenManager : NIMService
@property (nonatomic, assign) BOOL updating;
@property (nonatomic, readonly, copy) NSString *sdkToken;
@property (nonatomic, readonly, copy) NSString *accessToken;

- (void)updateWithUsrId:(NSString *)usrId password:(NSString *)password completeHandler:(void(^)(NSError *error))handler;

@end
