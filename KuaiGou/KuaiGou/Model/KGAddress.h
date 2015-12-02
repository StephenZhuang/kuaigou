//
//  KGAddress.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/8/8.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGAddress : NSObject
@property (nonatomic , copy) NSString *province;
@property (nonatomic , copy) NSString *receiver;
@property (nonatomic , copy) NSString *city;
@property (nonatomic , copy) NSString *phone;
@property (nonatomic , copy) NSString *district;
@property (nonatomic , assign) BOOL isdefault;
@property (nonatomic , copy) NSString *userid;
@property (nonatomic , copy) NSString *addressid;
@property (nonatomic , copy) NSString *details;

+ (void)addAddressWithAddress:(KGAddress *)address
                   completion:(void(^)(BOOL success,NSString *errorInfo))completion;

+ (void)getAddressListPagenumber:(NSInteger)pagenumber
                        pagesize:(NSInteger)pagesize
                      completion:(void(^)(BOOL success,NSString *errorInfo,NSArray *array))completion;

+ (void)updateAddressWithAddress:(KGAddress *)address
                      completion:(void(^)(BOOL success,NSString *errorInfo))completion;

+ (void)deleteAddressWithAddressid:(NSString *)addressid
                        completion:(void(^)(BOOL success,NSString *errorInfo))completion;
@end
