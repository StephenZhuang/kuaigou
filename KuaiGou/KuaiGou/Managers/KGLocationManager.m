//
//  KGLocationManager.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/7/7.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "KGLocationManager.h"

@implementation KGLocationManager
+ (instancetype)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (BMKLocationService *)locationService
{
    if (!_locationService) {
        _locationService = [[BMKLocationService alloc] init];
    }
    return _locationService;
}
@end
