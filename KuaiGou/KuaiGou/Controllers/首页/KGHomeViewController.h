//
//  KGHomeViewController.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/12.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXBAdPageView.h"

@interface KGHomeViewController : UIViewController<JXBAdPageViewDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic , weak) IBOutlet JXBAdPageView *adsView;
@property (nonatomic , strong) NSMutableArray *adsArray;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) NSMutableArray *catArray;
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@property (nonatomic , weak) IBOutlet UICollectionView *collectionView;
@end
