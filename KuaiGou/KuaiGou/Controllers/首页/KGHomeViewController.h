//
//  KGHomeViewController.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/12.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXBAdPageView.h"

@interface KGHomeViewController : UIViewController<JXBAdPageViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , weak) IBOutlet JXBAdPageView *adsView;
@property (nonatomic , strong) NSMutableArray *adsArray;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@end
