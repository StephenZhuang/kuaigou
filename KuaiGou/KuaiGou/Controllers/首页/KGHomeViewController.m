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

@implementation KGHomeViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_t_logo"]];
    self.navigationItem.titleView = imageView;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bt_navb_search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
 
    [KGAds getZtWithCompletion:^(BOOL success, NSString *errorInfo, NSArray *array) {
        if (success) {
            NSMutableArray *imageArray = [[NSMutableArray alloc] init];
            for (KGAds *ads in array) {
                [imageArray addObject:[KGImageUrlHelper imageUrlWithKey:ads.adspic]];
            }
            [_adsView startAdsWithImageArray:imageArray block:^(NSInteger clickIndex) {
                NSLog(@"%@",@(clickIndex));
            }];
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
}

- (void)searchAction
{
    
}

#pragma mark - JXBAdPageViewDelegate
- (void)setWebImage:(UIImageView *)imgView imgUrl:(NSString *)imgUrl
{
    [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"bg_product_def"]];
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
    KGAds *ads = [self.adsArray objectAtIndex:indexPath.section];
    KGImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KGImageCell" forIndexPath:indexPath];
    [cell.logoImage sd_setImageWithURL:[NSURL URLWithString:[KGImageUrlHelper imageUrlWithKey:ads.adspic]] placeholderImage:[UIImage imageNamed:@"bg_product_def"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)catArray
{
    if (!_catArray) {
        _catArray = [[NSMutableArray alloc] init];
    }
    return _catArray;
}
@end
