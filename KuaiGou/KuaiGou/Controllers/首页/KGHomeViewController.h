//
//  KGHomeViewController.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/12.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdScrollView.h"
#import "ZXRefreshTableViewController.h"
#import "KGLocationManager.h"

@interface KGHomeViewController : ZXRefreshTableViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,BMKLocationServiceDelegate>
@property (nonatomic , weak) IBOutlet AdScrollView *adsView;
@property (nonatomic , strong) NSMutableArray *adsArray;
@property (nonatomic , strong) NSMutableArray *catArray;
@property (nonatomic , weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic , assign) float lat;
@property (nonatomic , assign) float lng;
@end
