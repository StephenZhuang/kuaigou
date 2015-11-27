//
//  KGSettingViewController.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/11/27.
//  Copyright © 2015年 Hatlab. All rights reserved.
//

#import "KGBaseViewController.h"

@interface KGSettingViewController : KGBaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@end
