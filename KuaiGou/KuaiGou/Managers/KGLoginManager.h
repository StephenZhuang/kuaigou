//
//  KGLoginManager.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/12.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KGUser.h"

@interface KGLoginManager : NSObject
@property (nonatomic , strong) KGUser *user;
@property (nonatomic , assign) BOOL isLogin;

+ (instancetype)sharedInstance;

- (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(void(^)(BOOL success,NSString *errorInfo))completion;
- (void)logoutWithCompletion:(void(^)(BOOL success,NSString *errorInfo))completion;
@end
