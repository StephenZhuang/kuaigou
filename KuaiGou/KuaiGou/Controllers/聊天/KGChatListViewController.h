//
//  KGChatListViewController.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/12.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGChatListViewController : KGBaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) IBOutlet UITableView * tableView;
@end
