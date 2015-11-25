//
//  KGAddOrderViewController.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/8/8.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGGoods.h"
#import "AdScrollView.h"

@interface KGAddOrderViewController : KGBaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger num;
}
@property (nonatomic , strong) KGGoods *goods;
@property (nonatomic , weak) IBOutlet AdScrollView *adsView;
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@end
