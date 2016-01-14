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
#import "BNCoreServices.h"
#import "NIMSessionViewController.h"
#import "MBProgressHUD+ZXAdditon.h"

@interface KGGoodsDetailViewController ()<BNNaviRoutePlanDelegate,BNNaviUIManagerDelegate>

@end

@implementation KGGoodsDetailViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Nearby" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:self.view];
    [KGGoods getGoodsDetailWithItemid:_itemid completion:^(BOOL success, NSString *errorInfo, KGGoods *goods) {
        [hud hide:YES];
        self.goods = goods;
        [self updateUI];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    self.navigationController.navigationBar.hidden = NO;
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
    NSArray *arr = @[@"上门自提"];
    if (self.goods.trademodeid > 0) {
        [self.tipLabel setText:arr[self.goods.trademodeid -1]];
    }
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
    
    if ([self.goods.userid isEqualToString:[KGLoginManager sharedInstance].user.userid]) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAction)];
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)deleteAction
{
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:self.view];
    [self.goods deleteGoodsWithCompletion:^(BOOL success, NSString *errorInfo) {
        [hud turnToSuccess:@"删除成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [[KGLocationManager sharedInstance].locationService stopUserLocationService];
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        self.lat = userLocation.location.coordinate.latitude;
        self.lng = userLocation.location.coordinate.longitude;
        double distance = [[KGLocationManager sharedInstance] distanceBetweenPoint1:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude) point2:CLLocationCoordinate2DMake(self.goods.lat.doubleValue, self.goods.lng.doubleValue)];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [self.distanceLabel setText:[NSString stringWithFormat:@"%.2fkm",distance]];
        });
    });
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    [[KGLocationManager sharedInstance].locationService stopUserLocationService];
    self.lat = 39.92;
    self.lng = 116.46;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        double distance = [[KGLocationManager sharedInstance] distanceBetweenPoint1:CLLocationCoordinate2DMake(self.lat, self.lng) point2:CLLocationCoordinate2DMake(self.goods.lat.doubleValue, self.goods.lng.doubleValue)];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [self.distanceLabel setText:[NSString stringWithFormat:@"%.2fkm",distance]];
        });
    });
}

- (IBAction)showAction:(id)sender
{
    if ([[KGLoginManager sharedInstance] isLogin]) {
        NSString *imgUrl = [KGImageUrlHelper imageUrlWithKey:[[self.goods.image componentsSeparatedByString:@","] firstObject]];
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            NSDate *date = [NSDate new];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *time = [formatter stringFromDate:date];
            
            NSString *string = [NSString stringWithFormat:@"itemid=%@&promoterid=%@&promotetime=%@",self.goods.itemid,[KGLoginManager sharedInstance].user.userid,time];
//                NSString *encode = [[JSRSA sharedInstance] privateEncrypt:string];
            NSData* sampleData = [string dataUsingEncoding:NSUTF8StringEncoding];
            
            NSString * base64String = [sampleData base64EncodedStringWithOptions:0];
            NSString *urlString = [@"http://www.kgapp.net/skip?p=" stringByAppendingString:base64String];
            NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)urlString, NULL, NULL,  kCFStringEncodingUTF8 ));
            
            NSURL *url = [[NSURL alloc] initWithString:encodedString];
            
            NSArray *activityItems = @[self.goods.title,url?url:urlString,image];
            UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
            activityController.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
                if (completed) {
                    
                }
            };
            [self presentViewController:activityController animated:YES completion:nil];
        }];
        
    } else {
        KGLoginViewController *vc = [KGLoginViewController viewControllerFromStoryboard];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (IBAction)buyAction:(id)sender
{
    if (self.goods && self.goods.stock > 0) {
        if ([[KGLoginManager sharedInstance] isLogin]) {
//            KGAddOrderViewController *vc = [KGAddOrderViewController viewControllerFromStoryboard:@"Nearby"];
//            vc.goods = self.goods;
//            [self.navigationController pushViewController:vc animated:YES];
            [self startNavi];
        } else {
            KGLoginViewController *vc = [KGLoginViewController viewControllerFromStoryboard];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
}

//发起导航
- (void)startNavi
{
    //节点数组
    NSMutableArray *nodesArray = [[NSMutableArray alloc]    initWithCapacity:2];
    
    //起点
    BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init];
    startNode.pos = [[BNPosition alloc] init];
    startNode.pos.x = self.lng;
    startNode.pos.y = self.lat;
    startNode.pos.eType = BNCoordinate_BaiduMapSDK;
    [nodesArray addObject:startNode];
    
    //终点
    BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
    endNode.pos = [[BNPosition alloc] init];
    endNode.pos.x = self.goods.lng.floatValue;
    endNode.pos.y = self.goods.lat.floatValue;
    endNode.pos.eType = BNCoordinate_BaiduMapSDK;
    [nodesArray addObject:endNode];
    //发起路径规划
    [BNCoreServices_RoutePlan startNaviRoutePlan:BNRoutePlanMode_Recommend naviNodes:nodesArray time:nil delegete:self userInfo:nil];
}

//算路成功回调
-(void)routePlanDidFinished:(NSDictionary *)userInfo
{
    NSLog(@"算路成功");
    
    //路径规划成功，开始导航
    [BNCoreServices_UI showNaviUI: BN_NaviTypeReal delegete:self isNeedLandscape:YES];
}

- (IBAction)chatAction:(id)sender
{
    NIMSession *session = [NIMSession session:self.goods.userid type:NIMSessionTypeP2P];
    NIMSessionViewController *vc = [[NIMSessionViewController alloc] initWithSession:session];
    [self.navigationController pushViewController:vc animated:YES];
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
