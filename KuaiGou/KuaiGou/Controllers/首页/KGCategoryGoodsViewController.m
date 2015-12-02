//
//  KGCategoryGoodsViewController.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/11/27.
//  Copyright © 2015年 Hatlab. All rights reserved.
//

#import "KGCategoryGoodsViewController.h"
#import "KGGoods.h"
#import "KGGoodsCell.h"
#import "KGGoodsDetailViewController.h"

@implementation KGCategoryGoodsViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.category.name;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"KGGoodsCell" bundle:nil] forCellReuseIdentifier:@"KGGoodsCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)loadData
{
    if (self.lat && self.lng) {
        [KGGoods getNearbyGoodsWithLat:@(self.lat) lng:@(self.lng) catpid:self.category.catid catid:-1 sort:@"price" sortmode:@"desc" pagenumber:page pagesize:pageCount dis:10 completion:^(BOOL success, NSString *errorInfo, NSArray *array) {
            [self configureArray:array];
        }];
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
            [cell.distanceLabel setText:[NSString stringWithFormat:@"%.2fkm",distance]];
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
