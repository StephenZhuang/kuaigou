//
//  KGUser.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/19.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "KGUser.h"
#import "KGLoginManager.h"

@implementation KGUser
- (void)updateAvatarWithCompletion:(void(^)(BOOL success,NSString *errorInfo))completion
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:self.token forKey:@"token"];
    [parameters setObject:self.avatar forKey:@"avatar"];
    
    
    [[KGApiClient sharedClient] POST:@"/api/v1/user/avatar" parameters:parameters success:^(NSURLSessionDataTask *task, id data) {
        !completion?:completion(YES,@"");
    } failure:^(NSURLSessionDataTask *task, NSString *errorInfo) {
        !completion?:completion(NO,errorInfo);
    }];
}

- (void)updateNicknameWithCompletion:(void(^)(BOOL success,NSString *errorInfo))completion
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:self.token forKey:@"token"];
    [parameters setObject:self.nickname forKey:@"nickname"];
    
    
    [[KGApiClient sharedClient] POST:@"/api/v1/user/profile" parameters:parameters success:^(NSURLSessionDataTask *task, id data) {
        !completion?:completion(YES,@"");
    } failure:^(NSURLSessionDataTask *task, NSString *errorInfo) {
        !completion?:completion(NO,errorInfo);
    }];
}

- (void)feedbackWithContent:(NSString *)content
                 completion:(void(^)(BOOL success,NSString *errorInfo))completion
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:self.token forKey:@"token"];
    [parameters setObject:content forKey:@"message"];
    
    
    [[KGApiClient sharedClient] POST:@"/api/v1/fb/send" parameters:parameters success:^(NSURLSessionDataTask *task, id data) {
        !completion?:completion(YES,@"");
    } failure:^(NSURLSessionDataTask *task, NSString *errorInfo) {
        !completion?:completion(NO,errorInfo);
    }];
}
@end
