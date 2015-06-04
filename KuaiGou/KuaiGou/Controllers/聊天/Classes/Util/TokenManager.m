//
//  TokenManager.m
//  NIM
//
//  Created by Xuhui on 15/3/17.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "TokenManager.h"
#import "AFNetworking.h"
#import "NIMHttpRequest.h"
#import "NIMKeychain.h"
#import "SessionUtil.h"
#import "NSString+NIMDemo.h"

NSString *const TokenDidUpdatedNotification = @"TokenDidUpdatedNotification";
NSString *const NIMDemoTokenErrorDomain = @"NIMDemoTokenErrorDomain";

@interface TokenManager () {
    NSMutableArray *_handlers;
}

@end

@implementation TokenManager

- (instancetype)init {
    self = [super init];
    if(self) {
        _sdkToken = [[NIMKeychain defaultKeychain] passwordForService:@"sdkToken" account:[NSString stringWithFormat:@"NIMDemo-%@", [SessionUtil currentUsrId]] error:0];
        _accessToken = [[NIMKeychain defaultKeychain] passwordForService:@"accessToken" account:[NSString stringWithFormat:@"NIMDemo-%@", [SessionUtil currentUsrId]] error:0];
        _handlers = [NSMutableArray array];
    }
    return self;
}

- (void)updateWithUsrId:(NSString *)usrId password:(NSString *)password completeHandler:(void(^)(NSError *error))handler {
    @synchronized(self) {
        if(handler) [_handlers addObject:handler];
    }
    if(!self.updating) {
        @synchronized(self) {
            if(self.updating) return;
            self.updating = YES;
            __weak typeof(self) weakSelf = self;
            // 注意这里使用http是为了简化demo，真实的业务场景中务必使用更安全的方法获取token
            NSString *url = [[NSString alloc] initWithFormat:@"%@/token", WebApiBaseURL];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:url]];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            NSDictionary *param = @{@"userid": usrId,
                                    @"secret": [[password MD5String] lowercaseString],
                                    @"client_type": @(0)};
            
            NSData *data = [NSJSONSerialization dataWithJSONObject:param options:0 error:0];
            [request setHTTPBody:data];
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            void (^httpResponeHandler)(AFHTTPRequestOperation *operation) = ^(AFHTTPRequestOperation *operatione) {
                NSInteger	responseCode	= [operation.response statusCode];
                NSError		*error			= [operation error];
                NSData		*data           = [operation responseData];
                NSError     *reportError    = nil;
                if(responseCode == 200 && error == nil && data) {
                    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:0];
                    @synchronized(weakSelf) {
                        if(!weakSelf.updating) return;
                        weakSelf.updating = NO;
                        NSNumber *resCode = [result objectForKey:@"res"];
                        if(resCode.integerValue != 200) {
                            DDLogDebug(@"Update Token Failed: %@", [result objectForKey:@"errmsg"] ? : @"");
                            reportError = [NSError errorWithDomain:NIMDemoTokenErrorDomain code:NIMDemoTokenManagerErrorUpdateFailed userInfo:@{@"errmsg": [result objectForKey:@"errmsg"] ? : @""}];
                        } else {
                            NSDictionary *msg = [result objectForKey:@"msg"];
                            NSString *sdkToken = [msg objectForKey:@"sdktoken"];
                            if(sdkToken) {
                                _sdkToken = sdkToken;
                                [[NIMKeychain defaultKeychain] setPassword:_sdkToken
                                                                forService:@"sdkToken"
                                                             accessibility:kSecAttrAccessibleWhenUnlocked
                                                                   account:[NSString stringWithFormat:@"NIMDemo-%@", usrId] error:0];
                            }
                            NSString *accessToken = [msg objectForKey:@"access_token"];
                            if(accessToken) {
                                _accessToken = accessToken;
                                [[NIMKeychain defaultKeychain] setPassword:_accessToken
                                                                forService:@"accessToken"
                                                             accessibility:kSecAttrAccessibleWhenUnlocked
                                                                   account:[NSString stringWithFormat:@"NIMDemo-%@", usrId] error:0];
                            }
                        }
                        [[NSNotificationCenter defaultCenter] postNotificationName:TokenDidUpdatedNotification object:nil];
                        [weakSelf excuteCompleteHandlersWithError:reportError];
                    }
                } else {
                    @synchronized(weakSelf) {
                        if(!weakSelf.updating) return;
                        weakSelf.updating = NO;
                        DDLogDebug(@"%@", @"Update Acess Token Failed!");
                        reportError = [NSError errorWithDomain:NIMDemoTokenErrorDomain code:NIMDemoTokenManagerErrorUpdateFailed userInfo:nil];
                        [weakSelf excuteCompleteHandlersWithError:reportError];
                    }
                }
            };
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSData *responeData) {
                httpResponeHandler(operation);
            }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                httpResponeHandler(operation);
            }];
            [operation start];
        }
    }
}

- (void)excuteCompleteHandlersWithError:(NSError *)error {
    NSArray *tmp = [_handlers copy];
    [_handlers removeAllObjects];
    dispatch_async(dispatch_get_main_queue(), ^() {
        for (void(^handler)(NSError *) in tmp) {
            handler(error);
        }
    });
}

@end
