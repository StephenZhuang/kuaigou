//
//  KGLoginManager.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/12.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "KGLoginManager.h"
#import "NSString+ZXMD5.h"

@implementation KGLoginManager
+ (instancetype)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (BOOL)isLogin
{
    return [GVUserDefaults standardUserDefaults].isLogin;
}

- (void)setIsLogin:(BOOL)isLogin
{
    [GVUserDefaults standardUserDefaults].isLogin = isLogin;
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(void(^)(BOOL success,NSString *errorInfo))completion
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:username forKey:@"phone"];
    [parameters setObject:[password md5] forKey:@"password"];
    
    [[KGApiClient sharedClient] POST:@"/api/v1/account/login" parameters:parameters success:^(NSURLSessionDataTask *task, id data) {
        KGUser *user = [KGUser objectWithKeyValues:data];
        self.user = user;
        self.isLogin = YES;
        [GVUserDefaults standardUserDefaults].user = data;
        !completion?:completion(YES,@"");
    } failure:^(NSURLSessionDataTask *task, NSString *errorInfo) {
        !completion?:completion(NO,errorInfo);
    }];
}

- (void)logoutWithCompletion:(void(^)(BOOL success,NSString *errorInfo))completion
{
    if (self.isLogin) {
//        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
//        [parameters setObject:self.user.userid forKey:@"userid"];
//        [parameters setObject:self.user.token forKey:@"token"];
//        
//        [[KGApiClient sharedClient] POST:@"/api/v1/account/logout" parameters:parameters success:^(NSURLSessionDataTask *task, id data) {
            self.isLogin = NO;
            self.user = nil;
            [GVUserDefaults standardUserDefaults].user = nil;
            !completion?:completion(YES,@"");
//        } failure:^(NSURLSessionDataTask *task, NSString *errorInfo) {
//            !completion?:completion(NO,errorInfo);
//        }];
    }
}
@end
