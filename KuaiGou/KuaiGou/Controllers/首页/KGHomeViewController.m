//
//  KGHomeViewController.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/12.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "KGHomeViewController.h"
#import "KGUploadManager.h"
#import "KGImageUrlHelper.h"
#import "KGAds.h"
#import "KGImageCell.h"
#import "KGCategoryCollectionViewCell.h"
#import "KGCategory.h"
#import "JSRSA.h"
#import "UITableView+ZXTableViewLine.h"
#import "KGGoods.h"
#import "KGGoodsCell.h"
#import "KGGoodsDetailViewController.h"

@implementation KGHomeViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_t_logo"]];
    self.navigationItem.titleView = imageView;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bt_navb_search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
 
    [self.tableView registerNib:[UINib nibWithNibName:@"KGGoodsCell" bundle:nil] forCellReuseIdentifier:@"KGGoodsCell"];
    
    [KGAds getZtWithCompletion:^(BOOL success, NSString *errorInfo, NSArray *array) {
        if (success) {
            if (array.count > 0) {                
                NSMutableArray *imageArray = [[NSMutableArray alloc] init];
                for (KGAds *ads in array) {
                    [imageArray addObject:[KGImageUrlHelper imageUrlWithKey:ads.adspic]];
                }
                [_adsView configUIWithArray:imageArray];
                _adsView.clickAtIndex = ^(NSInteger index) {
                    
                };
            }
        }
    }];
    
    [KGAds getAdsWithCompletion:^(BOOL success, NSString *errorInfo, NSArray *array) {
        [self.adsArray addObjectsFromArray:array];
        [self.tableView reloadData];
    }];
    
    [KGCategory getSevenCategoryWithCompletion:^(BOOL success, NSString *errorInfo, NSArray *array) {
        [self.catArray addObjectsFromArray:array];
        [self.collectionView reloadData];
    }];
    
    [self.tableView setExtrueLineHidden];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
}

- (void)searchAction
{

}

- (void)loadData
{
    if (self.lat && self.lng) {
        [KGGoods getHomeGoodsWithLat:@(self.lat) lng:@(self.lng) pagenumber:page pagesize:pageCount dis:10 completion:^(BOOL success, NSString *errorInfo, NSArray *array) {
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
    return self.adsArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < self.adsArray.count) {
        return 1;
    } else {
        return self.dataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < self.adsArray.count) {
        return 80;
    } else {
        return 85;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < self.adsArray.count) {
        KGAds *ads = [self.adsArray objectAtIndex:indexPath.section];
        KGImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KGImageCell" forIndexPath:indexPath];
        [cell.logoImage sd_setImageWithURL:[NSURL URLWithString:[KGImageUrlHelper imageUrlWithKey:ads.adspic]] placeholderImage:[UIImage imageNamed:@"bg_product_def"]];
        return cell;
    } else {
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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < self.adsArray.count) {
        
    } else {
        KGGoods *goods = [self.dataArray objectAtIndex:indexPath.row];
        KGGoodsDetailViewController *vc = [KGGoodsDetailViewController viewControllerFromStoryboard];
        vc.itemid = goods.itemid;
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.catArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KGCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KGCategoryCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.row < self.catArray.count) {
        KGCategory *category = [self.catArray objectAtIndex:indexPath.row];
        [cell.logoImage sd_setImageWithURL:[NSURL URLWithString:[KGImageUrlHelper imageUrlWithKey:category.avatar]] placeholderImage:[UIImage imageNamed:@"bg_product_def"]];
        [cell.titleLabel setText:category.name];
    } else {
        [cell.logoImage setImage:[UIImage imageNamed:@"ic_sort_08"]];
        [cell.titleLabel setText:@"更多"];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - setters and getters
- (NSMutableArray *)adsArray
{
    if (!_adsArray) {
        _adsArray = [[NSMutableArray alloc] init];
    }
    return _adsArray;
}

- (NSMutableArray *)catArray
{
    if (!_catArray) {
        _catArray = [[NSMutableArray alloc] init];
    }
    return _catArray;
}
@end
