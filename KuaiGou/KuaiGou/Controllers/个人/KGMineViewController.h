//
//  KGMineViewController.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/12.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGSelectedButton.h"
#import "ZXRefreshTableViewController.h"
#import "KGLocationManager.h"
#import "HCSStarRatingView.h"

@interface KGMineViewController : ZXRefreshTableViewController<UITableViewDelegate,UITableViewDataSource,BMKLocationServiceDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic , weak) IBOutlet KGSelectedButton *myGoodsButton;
@property (nonatomic , weak) IBOutlet KGSelectedButton *myPromoteButton;
@property (nonatomic , assign) float lat;
@property (nonatomic , assign) float lng;
@property (nonatomic , assign) NSInteger selectedIndex;

@property (nonatomic , weak) IBOutlet UIButton *headButton;
@property (nonatomic , weak) IBOutlet UIButton *nameButton;
@property (nonatomic , weak) IBOutlet HCSStarRatingView *ratingView;
@end
