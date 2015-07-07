//
//  KGGoods.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/6/1.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "KGGoods.h"
#import "KGLoginManager.h"

@implementation KGGoods
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.catid = -1;
        self.catpid = -1;
        self.trademodeid = 1;
        self.discount = 1;
    }
    return self;
}

+ (void)addGoodsWithGoods:(KGGoods *)goods
               completion:(void(^)(BOOL success,NSString *errorInfo))completion
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[KGLoginManager sharedInstance].user.token forKey:@"token"];
    [parameters setObject:@"create" forKey:@"action"];
    [parameters setObject:goods.title forKey:NSStringFromSelector(@selector(title))];
    [parameters setObject:goods.info forKey:NSStringFromSelector(@selector(info))];
    [parameters setObject:@(goods.price) forKey:NSStringFromSelector(@selector(price))];
    [parameters setObject:@(goods.stock) forKey:NSStringFromSelector(@selector(stock))];
    [parameters setObject:@(goods.catpid) forKey:NSStringFromSelector(@selector(catpid))];
    [parameters setObject:@(goods.catid) forKey:NSStringFromSelector(@selector(catid))];
    [parameters setObject:@(goods.trademodeid) forKey:NSStringFromSelector(@selector(trademodeid))];
    [parameters setObject:goods.isdiscount forKey:NSStringFromSelector(@selector(isdiscount))];
    [parameters setObject:@(goods.discount) forKey:NSStringFromSelector(@selector(discount))];
    [parameters setObject:goods.ispromote forKey:NSStringFromSelector(@selector(ispromote))];
    [parameters setObject:@(goods.promote) forKey:NSStringFromSelector(@selector(promote))];
    [parameters setObject:goods.lat forKey:NSStringFromSelector(@selector(lat))];
    [parameters setObject:goods.lng forKey:NSStringFromSelector(@selector(lng))];
    [parameters setObject:goods.address forKey:NSStringFromSelector(@selector(address))];
    [parameters setObject:goods.image forKey:NSStringFromSelector(@selector(image))];
    [parameters setObject:goods.effdate forKey:NSStringFromSelector(@selector(effdate))];
    
    [[KGApiClient sharedClient] POST:@"/api/v1/item" parameters:parameters success:^(NSURLSessionDataTask *task, id data) {
        !completion?:completion(YES,@"");
    } failure:^(NSURLSessionDataTask *task, NSString *errorInfo) {
        !completion?:completion(NO,errorInfo);
    }];
}

+ (void)deleteGoodsWithItemid:(NSString *)itemid
                   completion:(void(^)(BOOL success,NSString *errorInfo))completion
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[KGLoginManager sharedInstance].user.token forKey:@"token"];
    [parameters setObject:@"delete" forKey:@"action"];
    [parameters setObject:itemid forKey:@"itemid"];
    
    [[KGApiClient sharedClient] POST:@"/api/v1/item" parameters:parameters success:^(NSURLSessionDataTask *task, id data) {
        !completion?:completion(YES,@"");
    } failure:^(NSURLSessionDataTask *task, NSString *errorInfo) {
        !completion?:completion(NO,errorInfo);
    }];
}

+ (void)collectGoodsWithItemid:(NSString *)itemid
                    completion:(void(^)(BOOL success,NSString *errorInfo))completion
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[KGLoginManager sharedInstance].user.token forKey:@"token"];
    [parameters setObject:itemid forKey:@"itemid"];
    
    [[KGApiClient sharedClient] POST:@"/api/v1/item/fav" parameters:parameters success:^(NSURLSessionDataTask *task, id data) {
        !completion?:completion(YES,@"");
    } failure:^(NSURLSessionDataTask *task, NSString *errorInfo) {
        !completion?:completion(NO,errorInfo);
    }];
}

+ (void)uncollectGoodsWithItemid:(NSString *)itemid
                      completion:(void(^)(BOOL success,NSString *errorInfo))completion
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[KGLoginManager sharedInstance].user.token forKey:@"token"];
    [parameters setObject:itemid forKey:@"itemid"];
    
    [[KGApiClient sharedClient] POST:@"/api/v1/item/unfav" parameters:parameters success:^(NSURLSessionDataTask *task, id data) {
        !completion?:completion(YES,@"");
    } failure:^(NSURLSessionDataTask *task, NSString *errorInfo) {
        !completion?:completion(NO,errorInfo);
    }];
}

+ (void)getNearbyGoodsWithLat:(NSNumber *)lat
                          lng:(NSNumber *)lng
                       catpid:(NSInteger)catpid
                        catid:(NSInteger)catid
                         sort:(NSString *)sort
                     sortmode:(NSString *)sortmode
                   pagenumber:(NSInteger)pagenumber
                     pagesize:(NSInteger)pagesize
                          dis:(NSInteger)dis
                   completion:(void(^)(BOOL success,NSString *errorInfo,NSArray *array))completion
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:lat forKey:@"lat"];
    [parameters setObject:lng forKey:@"lng"];
    [parameters setObject:@(catpid) forKey:@"catpid"];
    [parameters setObject:@(catid) forKey:@"catid"];
    [parameters setObject:sort forKey:@"sort"];
    [parameters setObject:sortmode forKey:@"sortmode"];
    [parameters setObject:@(pagenumber) forKey:@"pagenumber"];
    [parameters setObject:@(pagesize) forKey:@"pagesize"];
    [parameters setObject:@(dis) forKey:@"dis"];
    [[KGApiClient sharedClient] POST:@"/api/v1/items/near" parameters:parameters success:^(NSURLSessionDataTask *task, id data) {
        NSDictionary *dic = data;
        NSArray *arr = [dic objectForKey:@"list"];
        NSArray *array = [KGGoods objectArrayWithKeyValuesArray:arr];
        !completion?:completion(YES,@"",array);
    } failure:^(NSURLSessionDataTask *task, NSString *errorInfo) {
        !completion?:completion(NO,errorInfo,nil);
    }];
}

@end
