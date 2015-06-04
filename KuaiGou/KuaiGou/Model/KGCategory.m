//
//  KGCategory.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/6/4.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "KGCategory.h"

@implementation KGCategory
+ (void)getParentCategoryWithCompletion:(void(^)(BOOL success,NSString *errorInfo,NSArray *array))completion
{
    [[KGApiClient sharedClient] POST:@"/api/v1/cat/pid" parameters:nil success:^(NSURLSessionDataTask *task, id data) {
        NSArray *array = [KGCategory objectArrayWithKeyValuesArray:data];
        !completion?:completion(YES,@"",array);
    } failure:^(NSURLSessionDataTask *task, NSString *errorInfo) {
        !completion?:completion(NO,errorInfo,nil);
    }];
}

+ (void)getChildCategoryWithPid:(NSInteger)pid
                     completion:(void(^)(BOOL success,NSString *errorInfo,NSArray *array))completion
{
    [[KGApiClient sharedClient] POST:@"/api/v1/cat/id" parameters:@{@"pid":@(pid)} success:^(NSURLSessionDataTask *task, id data) {
        NSArray *array = [KGCategory objectArrayWithKeyValuesArray:data];
        !completion?:completion(YES,@"",array);
    } failure:^(NSURLSessionDataTask *task, NSString *errorInfo) {
        !completion?:completion(NO,errorInfo,nil);
    }];
}

+ (void)getSevenCategoryWithCompletion:(void(^)(BOOL success,NSString *errorInfo,NSArray *array))completion
{
    [[KGApiClient sharedClient] POST:@"/api/v1/cat/seven" parameters:nil success:^(NSURLSessionDataTask *task, id data) {
        NSArray *array = [KGCategory objectArrayWithKeyValuesArray:data];
        !completion?:completion(YES,@"",array);
    } failure:^(NSURLSessionDataTask *task, NSString *errorInfo) {
        !completion?:completion(NO,errorInfo,nil);
    }];
}

+ (void)getAllCategoryWithCompletion:(void(^)(BOOL success,NSString *errorInfo,NSArray *array))completion
{
    [[KGApiClient sharedClient] POST:@"/api/v1/cat" parameters:nil success:^(NSURLSessionDataTask *task, id data) {
        NSArray *array = [KGCategory objectArrayWithKeyValuesArray:data];
        !completion?:completion(YES,@"",array);
    } failure:^(NSURLSessionDataTask *task, NSString *errorInfo) {
        !completion?:completion(NO,errorInfo,nil);
    }];
}
@end
