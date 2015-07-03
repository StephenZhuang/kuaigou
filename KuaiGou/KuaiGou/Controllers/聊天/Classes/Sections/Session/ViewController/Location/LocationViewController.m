//
//  LocationViewController.m
//  NIM
//
//  Created by chrisRay on 15/2/28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//
#import "LocationViewController.h"
#import "UIView+Toast.h"
#import "LocationPoint.h"
#import <AddressBookUI/AddressBookUI.h>
#import <CoreLocation/CoreLocation.h>
@interface LocationViewController (){
    BOOL  _updateUserLocation;
}
@property(nonatomic,strong) UIBarButtonItem *sendButton;
@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,strong) LocationPoint *locationPoint;
@property(nonatomic,strong) CLGeocoder * geoCoder;
@end

@implementation LocationViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _geoCoder = [[CLGeocoder alloc] init];
    }
    return self;
}

- (instancetype)initWithLocationPoint:(LocationPoint*)locationPoint{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        _locationPoint = locationPoint;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"位置";
    self.mapView.delegate = self;
    if (self.locationPoint) {
        MKCoordinateRegion theRegion;
        theRegion.center = self.locationPoint.coordinate;
        theRegion.span.longitudeDelta	= 0.01f;
        theRegion.span.latitudeDelta	= 0.01f;
        [self.mapView addAnnotation:self.locationPoint];
        [self.mapView setRegion:theRegion animated:YES];
    }else{
        [self setUpRightNavButton];
        self.locationPoint   = [[LocationPoint alloc] init];
        if ([CLLocationManager locationServicesEnabled]) {
            if (IOS8) {
                [_locationManager requestAlwaysAuthorization];
            }
            CLAuthorizationStatus status = CLLocationManager.authorizationStatus;
            if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
                [self.view makeToast:@"请在设置-隐私里允许程序使用地理位置服务"];
            }else{
                self.mapView.showsUserLocation = YES;
            }
        }else{
            [self.view makeToast:@"请打开地理位置服务"];
        }
    }
    
}

- (void)setUpRightNavButton{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(onSend:)];
    self.navigationItem.rightBarButtonItem = item;
    self.sendButton = item;
    self.sendButton.enabled = NO;
}

- (void)onSend:(id)sender{
    if ([self.delegate respondsToSelector:@selector(onSendLocation:)]) {
        [self.delegate onSendLocation:self.locationPoint];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - MKMapViewDelegate



- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    if (!_updateUserLocation) {
        return;
    }
    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    [self reverseGeoLocation:centerCoordinate];
}



- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated

{
    if (!_updateUserLocation) {
        return;
    }
    [_mapView removeAnnotations:_mapView.annotations];
}



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    static NSString *reusePin = @"reusePin";
    MKPinAnnotationView * pin = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:reusePin];
    if (!pin) {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reusePin];
    }
    pin.canShowCallout	= YES;
    return pin;

}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    _updateUserLocation = YES;
    MKCoordinateRegion theRegion;
    theRegion.center = userLocation.coordinate;
    theRegion.span.longitudeDelta	= 0.01f;
    theRegion.span.latitudeDelta	= 0.01f;
    [_mapView setRegion:theRegion animated:NO];
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    [_mapView selectAnnotation:self.locationPoint animated:YES];
    UIView * view = [mapView viewForAnnotation:self.mapView.userLocation];
    view.hidden = YES;
}


- (void)reverseGeoLocation:(CLLocationCoordinate2D)locationCoordinate2D{
    if (self.geoCoder.isGeocoding) {
        [self.geoCoder cancelGeocode];
    }
    CLLocation *location = [[CLLocation alloc]initWithLatitude:locationCoordinate2D.latitude
                                                     longitude:locationCoordinate2D.longitude];
    __weak LocationViewController *wself = self;
    self.sendButton.enabled = NO;
    [self.geoCoder reverseGeocodeLocation:location
                      completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error == nil) {
             CLPlacemark *mark = [placemarks lastObject];
             NSString * title  = [wself nameForPlaceMark:mark];
             LocationPoint *ponit = [[LocationPoint alloc]initWithCoordinate:locationCoordinate2D andTitle:title];
             wself.locationPoint = ponit;
             [wself.mapView addAnnotation:ponit];
             wself.sendButton.enabled = YES;
         } else {
             wself.locationPoint = nil;
         }
    }];
}

- (NSString *)nameForPlaceMark: (CLPlacemark *)mark
{
    NSString *name = ABCreateStringWithAddressDictionary(mark.addressDictionary,YES);
    unichar characters[1] = {0x200e};   //format之后会出现这个诡异的不可见字符，在android端显示会很诡异，需要去掉
    NSString *invalidString = [[NSString alloc]initWithCharacters:characters length:1];
    NSString *formattedName =  [[name stringByReplacingOccurrencesOfString:@"\n" withString:@" "]
                                stringByReplacingOccurrencesOfString:invalidString withString:@""];
    return formattedName;
}

@end