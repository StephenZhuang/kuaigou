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

- (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:username forKey:@"phone"];
    [parameters setObject:[password md5] forKey:@"password"];
    
    [[KGApiClient sharedClient] POST:@"/api/v1/account/login" parameters:parameters success:^(NSURLSessionDataTask *task, id data) {
        NSLog(@"success");
    } failure:^(NSURLSessionDataTask *task, NSString *errorInfo) {
        NSLog(@"failure");
    }];
}
@end
