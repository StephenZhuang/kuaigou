//
//  SessionListViewController.h
//  NIMDemo
//
//  Created by chrisRay on 15/2/2.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) IBOutlet UITableView * tableView;

@property (nonatomic,strong) IBOutlet UILabel *emptyTipLabel;

@end
