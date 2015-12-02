//
//  KGApiClient.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/13.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>

@interface KGApiClient : AFHTTPSessionManager
+ (instancetype)sharedClient;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id data))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSString *errorInfo))failure;
@end
