//
//  KGAds.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/6/4.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGAds : NSObject
@property (nonatomic , copy) NSString *itemid;
@property (nonatomic , copy) NSString *adspic;

+ (void)getAdsWithCompletion:(void(^)(BOOL success,NSString *errorInfo,NSArray *array))completion;
+ (void)getZtWithCompletion:(void(^)(BOOL success,NSString *errorInfo,NSArray *array))completion;
@end
