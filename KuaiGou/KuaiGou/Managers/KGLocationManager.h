//
//  KGLocationManager.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/7/7.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI/BMapKit.h>

@interface KGLocationManager : NSObject<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
@property (nonatomic , strong) BMKLocationService *locationService;
+ (instancetype)sharedInstance;
@end
