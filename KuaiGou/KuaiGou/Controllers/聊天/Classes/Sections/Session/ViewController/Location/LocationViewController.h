//
//  LocationViewController.h
//  NIM
//
//  Created by chrisRay on 15/2/28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class LocationPoint;
@protocol LocationViewControllerDelegate <NSObject>
- (void)onSendLocation:(LocationPoint*)locationPoint;
@end

@interface LocationViewController : UIViewController<MKMapViewDelegate>

@property(nonatomic,strong) IBOutlet MKMapView *mapView;

@property(nonatomic,weak)  id<LocationViewControllerDelegate> delegate;

- (instancetype)initWithLocationPoint:(LocationPoint*)locationPoint;

@end
