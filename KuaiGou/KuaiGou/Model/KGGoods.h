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
@property (nonatomic , assign) NSInteger catpid;
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

+ (void)addGoodsWithGoods:(KGGoods *)goods
               completion:(void(^)(BOOL success,NSString *errorInfo))completion;

+ (void)deleteGoodsWithItemid:(NSString *)itemid
                   completion:(void(^)(BOOL success,NSString *errorInfo))completion;
@end
