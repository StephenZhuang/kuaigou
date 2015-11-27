//
//  KGGoods.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/6/1.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGGoods : NSObject
@property (nonatomic , copy) NSString *itemid;
@property (nonatomic , copy) NSString *title;
@property (nonatomic , copy) NSString *info;
@property (nonatomic , assign) float price;
@property (nonatomic , assign) NSInteger stock;
@property (nonatomic , copy) NSString *effdate;
/**
 *  一级分类
 */
@property (nonatomic , assign) NSInteger catpid;
/**
 *  二级分类
 */
@property (nonatomic , assign) NSInteger catid;
@property (nonatomic , copy) NSString *isdiscount;
@property (nonatomic , assign) float discount;
@property (nonatomic , copy) NSString *ispromote;
@property (nonatomic , assign) float promote;
@property (nonatomic , copy) NSString *lat;
@property (nonatomic , copy) NSString *lng;
@property (nonatomic , copy) NSString *address;
@property (nonatomic , assign) NSInteger trademodeid;
@property (nonatomic , copy) NSString *status;
@property (nonatomic , copy) NSString *image;
@property (nonatomic , copy) NSString *userid;
@property (nonatomic , assign) NSInteger u_level;
@property (nonatomic , copy) NSString *u_nickname;
@property (nonatomic , copy) NSString *u_avatar;

@property (nonatomic , copy) NSString *catNames;

+ (void)addGoodsWithGoods:(KGGoods *)goods
               completion:(void(^)(BOOL success,NSString *errorInfo))completion;

+ (void)deleteGoodsWithItemid:(NSString *)itemid
                   completion:(void(^)(BOOL success,NSString *errorInfo))completion;

+ (void)collectGoodsWithItemid:(NSString *)itemid
                    completion:(void(^)(BOOL success,NSString *errorInfo))completion;

+ (void)uncollectGoodsWithItemid:(NSString *)itemid
                      completion:(void(^)(BOOL success,NSString *errorInfo))completion;

+ (void)getNearbyGoodsWithLat:(NSNumber *)lat
                          lng:(NSNumber *)lng
                       catpid:(NSInteger)catpid
                        catid:(NSInteger)catid
                         sort:(NSString *)sort
                     sortmode:(NSString *)sortmode
                   pagenumber:(NSInteger)pagenumber
                     pagesize:(NSInteger)pagesize
                          dis:(NSInteger)dis
                   completion:(void(^)(BOOL success,NSString *errorInfo,NSArray *array))completion;

+ (void)getGoodsDetailWithItemid:(NSString *)itemid
                      completion:(void(^)(BOOL success,NSString *errorInfo,KGGoods *goods))completion;

+ (void)getHomeGoodsWithLat:(NSNumber *)lat
                        lng:(NSNumber *)lng
                 pagenumber:(NSInteger)pagenumber
                   pagesize:(NSInteger)pagesize
                        dis:(NSInteger)dis
                 completion:(void(^)(BOOL success,NSString *errorInfo,NSArray *array))completion;

+ (void)getMyGoodsWithUserid:(NSString *)userid
                       token:(NSString *)token
                  pagenumber:(NSInteger)pagenumber
                    pagesize:(NSInteger)pagesize
                  completion:(void(^)(BOOL success,NSString *errorInfo,NSArray *array))completion;

+ (void)getMyPromoteGoodsWithUserid:(NSString *)userid
                              token:(NSString *)token
                         pagenumber:(NSInteger)pagenumber
                           pagesize:(NSInteger)pagesize
                         completion:(void(^)(BOOL success,NSString *errorInfo,NSArray *array))completion;

+ (void)searchGoodsWithString:(NSString *)string
                   pagenumber:(NSInteger)pagenumber
                     pagesize:(NSInteger)pagesize
                   completion:(void(^)(BOOL success,NSString *errorInfo,NSArray *array))completion;

- (CGFloat)displayPrice;
@end
