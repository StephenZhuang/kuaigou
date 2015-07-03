//
//  KGNearbyViewController.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/12.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXRefreshTableViewController.h"

@interface KGNearbyViewController : ZXRefreshTableViewController
@property (nonatomic , weak) IBOutlet UIView *dropMenuView;
@property (nonatomic , strong) NSMutableArray *categoryArray;
@property (nonatomic , strong) NSArray *distanceArray;
@property (nonatomic , strong) NSArray *sortNameArray;
@property (nonatomic , strong) NSArray *sortArray;
@end
