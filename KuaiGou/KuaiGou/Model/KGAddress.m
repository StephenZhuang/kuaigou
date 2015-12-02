//
//  KGAddress.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/8/8.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "KGAddress.h"
#import "KGLoginManager.h"

@implementation KGAddress
+ (void)addAddressWithAddress:(KGAddress *)address
                   completion:(void(^)(BOOL success,NSString *errorInfo))completion
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[KGLoginManager sharedInstance].user.token forKey:@"token"];
    [parameters setObject:address.province forKey:@"province"];
    [parameters setObject:address.city forKey:@"city"];
    [parameters setObject:address.district forKey:@"district"];
    [parameters setObject:address.details forKey:@"details"];
    [parameters setObject:address.receiver forKey:@"receiver"];
    [parameters setObject:address.phone forKey:@"phone"];
    [parameters setObject:@(address.isdefault) forKey:@"isdefault"];

    
    [[KGApiClient sharedClient] POST:@"/api/v1/address/create" parameters:parameters success:^(NSURLSessionDataTask *task, id data) {
        !completion?:completion(YES,@"");
    } failure:^(NSURLSessionDataTask *task, NSString *errorInfo) {
        !completion?:completion(NO,errorInfo);
    }];
}

+ (void)getAddressListPagenumber:(NSInteger)pagenumber
                        pagesize:(NSInteger)pagesize
                      completion:(void(^)(BOOL success,NSString *errorInfo,NSArray *array))completion
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@(pagenumber) forKey:@"pagenumber"];
    [parameters setObject:@(pagesize) forKey:@"pagesize"];
    [parameters setObject:[KGLoginManager sharedInstance].user.token forKey:@"token"];
    
    [[KGApiClient sharedClient] POST:@"/api/v1/address" parameters:parameters success:^(NSURLSessionDataTask *task, id data) {
        NSDictionary *dic = data;
        NSArray *arr = [dic objectForKey:@"list"];
        NSArray *array = [KGAddress objectArrayWithKeyValuesArray:arr];
        !completion?:completion(YES,@"",array);
    } failure:^(NSURLSessionDataTask *task, NSString *errorInfo) {
        !completion?:completion(NO,errorInfo,nil);
    }];
}

+ (void)updateAddressWithAddress:(KGAddress *)address
                      completion:(void(^)(BOOL success,NSString *errorInfo))completion
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[KGLoginManager sharedInstance].user.token forKey:@"token"];
    [parameters setObject:address.addressid forKey:@"addressid"];
    [parameters setObject:address.province forKey:@"province"];
    [parameters setObject:address.city forKey:@"city"];
    [parameters setObject:address.district forKey:@"district"];
    [parameters setObject:address.details forKey:@"details"];
    [parameters setObject:address.receiver forKey:@"receiver"];
    [parameters setObject:address.phone forKey:@"phone"];
    [parameters setObject:@(address.isdefault) forKey:@"isdefault"];
    
    
    [[KGApiClient sharedClient] POST:@"/api/v1/address/update" parameters:parameters success:^(NSURLSessionDataTask *task, id data) {
        !completion?:completion(YES,@"");
    } failure:^(NSURLSessionDataTask *task, NSString *errorInfo) {
        !completion?:completion(NO,errorInfo);
    }];
}

+ (void)deleteAddressWithAddressid:(NSString *)addressid
                        completion:(void(^)(BOOL success,NSString *errorInfo))completion
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[KGLoginManager sharedInstance].user.token forKey:@"token"];
    [parameters setObject:addressid forKey:@"addressid"];
    
    [[KGApiClient sharedClient] POST:@"/api/v1/address/delete" parameters:parameters success:^(NSURLSessionDataTask *task, id data) {
        !completion?:completion(YES,@"");
    } failure:^(NSURLSessionDataTask *task, NSString *errorInfo) {
        !completion?:completion(NO,errorInfo);
    }];
}
@end
