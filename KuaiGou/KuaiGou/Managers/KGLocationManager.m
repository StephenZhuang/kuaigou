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

- (double)distanceBetweenPoint1:(CLLocationCoordinate2D)point1 point2:(CLLocationCoordinate2D)point2
{
    BMKMapPoint bpoint1 = BMKMapPointForCoordinate(point1);
    BMKMapPoint bpoint2 = BMKMapPointForCoordinate(point2);
    CLLocationDistance distance = BMKMetersBetweenMapPoints(bpoint1,bpoint2) * 0.001;
    return distance;
}
@end
