//
//  KGGoodsDetailViewController.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/7/10.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "KGGoodsDetailViewController.h"
#import "KGImageUrlHelper.h"
#import "KGLoginManager.h"
#import "KGLoginViewController.h"
#import <SDWebImageDownloader.h>
#import "JSRSA.h"
#import "KGAddOrderViewController.h"

@interface KGGoodsDetailViewController ()

@end

@implementation KGGoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [KGGoods getGoodsDetailWithItemid:_itemid completion:^(BOOL success, NSString *errorInfo, KGGoods *goods) {
        self.goods = goods;
        [self updateUI];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)updateUI
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSMutableArray *imageArray = [[NSMutableArray alloc] init];
        NSArray *array = [self.goods.image componentsSeparatedByString:@","];
        for (NSString *img in array) {
            [imageArray addObject:[KGImageUrlHelper imageUrlWithKey:img]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [_adsView configUIWithArray:imageArray];
            _adsView.clickAtIndex = ^(NSInteger index) {
                
            };
        });
    });
    
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[KGImageUrlHelper imageUrlWithKey:self.goods.u_avatar]]  placeholderImage:[UIImage imageNamed:@"DefaultAvatar"]];
    [self.nameLabel setText:self.goods.u_nickname];
    [self.addressLabel setText:self.goods.address];
    [self.ratingView setValue:self.goods.u_level];
    NSArray *arr = @[@"送货上门",@"上门自提"];
    [self.tipLabel setText:arr[self.goods.trademodeid -1]];
    if (self.goods.isdiscount.integerValue == 1) {
        [self.originPriceLabel setText:[NSString stringWithFormat:@"￥ %.2f",self.goods.price]];
        CGFloat price = self.goods.price * self.goods.discount;
        [self.priceLabel setText:[NSString stringWithFormat:@"￥ %.2f",price]];
    } else {
        [self.priceLabel setText:[NSString stringWithFormat:@"￥ %.2f",self.goods.price]];
        [self.originPriceLabel setHidden:YES];
    }
    
    [self.titleLabel setText:self.goods.title];
    [self.contentLabel setText:self.goods.info];
    
    if (self.goods.ispromote.integerValue == 1) {
        NSString * string = [NSString stringWithFormat:@"分享推广(%.0f",self.goods.promote * 100];
        string = [string stringByAppendingString:@"%)"];
        [self.shareButton setTitle:string forState:UIControlStateNormal];
    } else {
        [self.shareButton setTitle:@"分享推广" forState:UIControlStateNormal];
    }
    
    [KGLocationManager sharedInstance].locationService.delegate = self;
    [[KGLocationManager sharedInstance].locationService startUserLocationService];
    
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [[KGLocationManager sharedInstance].locationService stopUserLocationService];
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        double distance = [[KGLocationManager sharedInstance] distanceBetweenPoint1:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude) point2:CLLocationCoordinate2DMake(self.goods.lat.doubleValue, self.goods.lng.doubleValue)];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [self.distanceLabel setText:[NSString stringWithFormat:@"%.2fm",distance]];
        });
    });
}

- (IBAction)showAction:(id)sender
{
    if ([[KGLoginManager sharedInstance] isLogin]) {
        NSString *imgUrl = [KGImageUrlHelper imageUrlWithKey:[[self.goods.image componentsSeparatedByString:@","] firstObject]];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imgUrl] options:SDWebImageDownloaderLowPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        
            NSDate *date = [NSDate new];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *time = [formatter stringFromDate:date];
            
            NSString *string = [NSString stringWithFormat:@"itemid=%@&promoterid=%@&promotetime=%@",self.goods.itemid,[KGLoginManager sharedInstance].user.userid,time];
            NSString *encode = [[JSRSA sharedInstance] privateEncrypt:string];
            NSString *urlString = [@"http://www.kgapp.net/skip?p=" stringByAppendingString:encode];
            
            NSArray *activityItems = @[self.goods.title,[NSURL URLWithString:urlString],image];
            UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
            activityController.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
                if (completed) {
                    
                }
            };
            [self presentViewController:activityController animated:YES completion:nil];
        }];
        
        
        
    } else {
        KGLoginViewController *vc = [KGLoginViewController viewControllerFromStoryboard:@"Login"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (IBAction)buyAction:(id)sender
{
    if (self.goods && self.goods.stock > 0) {
        if ([[KGLoginManager sharedInstance] isLogin]) {
            KGAddOrderViewController *vc = [KGAddOrderViewController viewControllerFromStoryboard:@"Nearby"];
            vc.goods = self.goods;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            KGLoginViewController *vc = [KGLoginViewController viewControllerFromStoryboard:@"Login"];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
