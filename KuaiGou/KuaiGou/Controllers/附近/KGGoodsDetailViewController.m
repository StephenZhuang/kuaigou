//
//  KGGoodsDetailViewController.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/7/10.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "KGGoodsDetailViewController.h"
#import "KGImageUrlHelper.h"

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
    _adsView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _adsView.delegate = nil;
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
            [_adsView startAdsWithImageArray:imageArray block:^(NSInteger clickIndex) {
                NSLog(@"%@",@(clickIndex));
            }];
        });
    });
    
}

- (void)setWebImage:(UIImageView *)imgView imgUrl:(NSString *)imgUrl
{
    [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"bg_product_def"]];
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
