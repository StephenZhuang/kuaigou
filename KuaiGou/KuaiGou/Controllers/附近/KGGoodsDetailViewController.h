//
//  KGGoodsDetailViewController.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/7/10.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HCSStarRatingView.h>
#import "KGGoods.h"
#import "AdScrollView.h"
#import "KGLocationManager.h"

@interface KGGoodsDetailViewController : UIViewController<BMKLocationServiceDelegate>
@property (nonatomic , assign) NSString *itemid;
@property (nonatomic , weak) IBOutlet AdScrollView *adsView;
@property (nonatomic , weak) IBOutlet UIImageView *headImg;
@property (nonatomic , weak) IBOutlet UILabel *nameLabel;
@property (nonatomic , weak) IBOutlet UILabel *addressLabel;
@property (nonatomic , weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic , weak) IBOutlet UILabel *tipLabel;
@property (nonatomic , weak) IBOutlet UILabel *priceLabel;
@property (nonatomic , weak) IBOutlet UILabel *originPriceLabel;
@property (nonatomic , weak) IBOutlet UILabel *titleLabel;
@property (nonatomic , weak) IBOutlet UILabel *contentLabel;
@property (nonatomic , weak) IBOutlet UIButton *shareButton;
@property (nonatomic , weak) IBOutlet HCSStarRatingView *ratingView;

@property (nonatomic , strong) KGGoods *goods;
@end
