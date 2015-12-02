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
- (double)distanceBetweenPoint1:(CLLocationCoordinate2D)point1 point2:(CLLocationCoordinate2D)point2;
@end
