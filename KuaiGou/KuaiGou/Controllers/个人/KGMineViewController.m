//
//  KGMineViewController.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/12.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "KGMineViewController.h"
#import "KGLoginManager.h"
#import "KGGoodsCell.h"
#import "KGGoodsDetailViewController.h"

@implementation KGMineViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myGoodsButton.selected = YES;
    self.selectedIndex = 1;
    [self.tableView registerNib:[UINib nibWithNibName:@"KGGoodsCell" bundle:nil] forCellReuseIdentifier:@"KGGoodsCell"];
}

- (IBAction)logoutAction:(id)sender
{
    [[KGLoginManager sharedInstance] logoutWithCompletion:^(BOOL success, NSString *errorInfo) {
        [self.rdv_tabBarController setSelectedIndex:0];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (IBAction)myGoodsAction:(id)sender
{
    if (!self.myGoodsButton.selected) {
        self.myGoodsButton.selected = YES;
        self.myPromoteButton.selected = NO;
        self.selectedIndex = 1;
        page = 1;
        [self.tableView.header beginRefreshing];
    }
}

- (IBAction)myPromoteAction:(id)sender
{
    if (!self.myPromoteButton.selected) {
        self.myPromoteButton.selected = YES;
        self.myGoodsButton.selected = NO;
        self.selectedIndex = 2;
        page = 1;
        [self.tableView.header beginRefreshing];
    }
}

- (void)loadData
{
    if (self.lat && self.lng) {
        if (self.selectedIndex == 1) {
            [KGGoods getMyGoodsWithUserid:[KGLoginManager sharedInstance].user.userid token:[KGLoginManager sharedInstance].user.token pagenumber:page pagesize:pageCount completion:^(BOOL success, NSString *errorInfo, NSArray *array) {
                [self configureArray:array];
            }];
        } else {
            [KGGoods getMyPromoteGoodsWithUserid:[KGLoginManager sharedInstance].user.userid token:[KGLoginManager sharedInstance].user.token pagenumber:page pagesize:pageCount completion:^(BOOL success, NSString *errorInfo, NSArray *array) {
                [self configureArray:array];
            }];
        }
        
    } else {
        [KGLocationManager sharedInstance].locationService.delegate = self;
        [[KGLocationManager sharedInstance].locationService startUserLocationService];
    }
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [[KGLocationManager sharedInstance].locationService stopUserLocationService];
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    self.lat = userLocation.location.coordinate.latitude;
    self.lng = userLocation.location.coordinate.longitude;
    [self loadData];
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KGGoodsCell"];
    KGGoods *goods = [self.dataArray objectAtIndex:indexPath.row];
    [cell configureUIWithGoods:goods];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        double distance = [[KGLocationManager sharedInstance] distanceBetweenPoint1:CLLocationCoordinate2DMake(self.lat, self.lng) point2:CLLocationCoordinate2DMake(goods.lat.doubleValue, goods.lng.doubleValue)];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [cell.distanceLabel setText:[NSString stringWithFormat:@"%.2fm",distance]];
        });
    });
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGoods *goods = [self.dataArray objectAtIndex:indexPath.row];
    KGGoodsDetailViewController *vc = [KGGoodsDetailViewController viewControllerFromStoryboard];
    vc.itemid = goods.itemid;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
