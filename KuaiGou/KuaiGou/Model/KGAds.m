//
//  KGAds.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/6/4.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "KGAds.h"

@implementation KGAds
+ (void)getAdsWithCompletion:(void(^)(BOOL success,NSString *errorInfo,NSArray *array))completion
{
    [[KGApiClient sharedClient] POST:@"/api/v1/ad/ads" parameters:nil success:^(NSURLSessionDataTask *task, id data) {
        NSArray *array = [KGAds objectArrayWithKeyValuesArray:data];
        !completion?:completion(YES,@"",array);
    } failure:^(NSURLSessionDataTask *task, NSString *errorInfo) {
        !completion?:completion(NO,errorInfo,nil);
    }];
}

+ (void)getZtWithCompletion:(void(^)(BOOL success,NSString *errorInfo,NSArray *array))completion
{
    [[KGApiClient sharedClient] POST:@"/api/v1/ad/zt" parameters:nil success:^(NSURLSessionDataTask *task, id data) {
        NSArray *array = [KGAds objectArrayWithKeyValuesArray:data];
        !completion?:completion(YES,@"",array);
    } failure:^(NSURLSessionDataTask *task, NSString *errorInfo) {
        !completion?:completion(NO,errorInfo,nil);
    }];
}
@end
