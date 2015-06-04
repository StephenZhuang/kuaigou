//
//  KGLoginManager.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/12.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "KGLoginManager.h"
#import "NSString+ZXMD5.h"
#import <Toast/UIView+Toast.h>
#import "ContactsData.h"
#import "NIMNotificationCenter.h"

NSString *NotificationLogin = @"NIMLogin";
NSString *NotificationLogout = @"NIMLogout";

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

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout:) name:NotificationLogout object:nil];
    }
    return self;
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
        [GVUserDefaults standardUserDefaults].user = [user keyValues];
        !completion?:completion(YES,@"");
    } failure:^(NSURLSessionDataTask *task, NSString *errorInfo) {
        !completion?:completion(NO,errorInfo);
    }];
    
    [self doYunxinLoginWithUsername:username password:password];
}

- (void)logoutWithCompletion:(void(^)(BOOL success,NSString *errorInfo))completion
{
    if (self.isLogin) {
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setObject:self.user.userid forKey:@"userid"];
        [parameters setObject:self.user.token forKey:@"token"];
        
        [[KGApiClient sharedClient] POST:@"/api/v1/account/logout" parameters:parameters success:^(NSURLSessionDataTask *task, id data) {
            self.isLogin = NO;
            self.user = nil;
            [GVUserDefaults standardUserDefaults].user = nil;
            !completion?:completion(YES,@"");
        } failure:^(NSURLSessionDataTask *task, NSString *errorInfo) {
            !completion?:completion(NO,errorInfo);
        }];
        
        [self doLogout];
    }
}

- (void)checkPhone:(NSString *)phone completion:(void(^)(BOOL success,NSString *code))completion
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:phone forKey:@"phone"];
    
    [[KGApiClient sharedClient] POST:@"/api/v1/account/reg/step1" parameters:parameters success:^(NSURLSessionDataTask *task, id data) {
        !completion?:completion(YES,data);
    } failure:^(NSURLSessionDataTask *task, NSString *errorInfo) {
        !completion?:completion(NO,errorInfo);
    }];
}

- (void)registerWithPhone:(NSString *)phone password:(NSString *)password completion:(void(^)(BOOL success,NSString *errorInfo))completion
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:phone forKey:@"phone"];
    [parameters setObject:[password md5] forKey:@"password"];
    
    [[KGApiClient sharedClient] POST:@"/api/v1/account/reg/step2" parameters:parameters success:^(NSURLSessionDataTask *task, id data) {
        !completion?:completion(YES,@"");
    } failure:^(NSURLSessionDataTask *task, NSString *errorInfo) {
        !completion?:completion(NO,errorInfo);
    }];
}

- (void)doYunxinLoginWithUsername:(NSString *)username password:(NSString *)password
{
    [[[NIMSDK sharedSDK] loginManager] login:username
                                       token:[[password md5] lowercaseString]
                                  completion:^(NSError *error) {
                                      if (error == nil)
                                      {
                                          [GVUserDefaults standardUserDefaults].username = username;
                                          [GVUserDefaults standardUserDefaults].password = password;
                                          
                                          [[NIMServiceManager sharedManager] start];
                                      }
                                      else
                                      {
                                          [[UIApplication sharedApplication].keyWindow makeToast:@"云信登录失败" duration:2.0 position:CSToastPositionCenter];
                                      }
                                  }];
}

-(void)logout:(NSNotification*)note
{
    [self logoutWithCompletion:^(BOOL success, NSString *errorInfo) {
        
    }];
}

- (void)doLogout
{
    [[NIMServiceManager sharedManager] destory];
    [GVUserDefaults standardUserDefaults].username = nil;
    [GVUserDefaults standardUserDefaults].password = nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[[NIMSDK sharedSDK] loginManager] removeDelegate:self];
}

#pragma NIMLoginManagerDelegate
-(void)onKick:(NIMKickReason)code
{
    NSString *reason = code == NIMKickReasonByClient ? @"该账号已在其他地方登录" : @"你被服务器踢下线";
    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLogout object:nil];
        [[UIApplication sharedApplication].keyWindow makeToast:reason duration:2.0 position:CSToastPositionCenter];
        
    }];
}

- (void)onLogin:(NIMLoginStep)step
{
    if (step == NIMLoginStepSyncOK)
    {
        [[NIMNotificationCenter sharedInstance] start];
        [[ContactsData sharedInstance] update];
    }
}
@end
