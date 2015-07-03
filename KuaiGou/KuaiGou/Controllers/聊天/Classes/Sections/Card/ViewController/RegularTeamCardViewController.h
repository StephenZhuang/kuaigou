//
//  RegularViewController.h
//  NIM
//
//  Created by chrisRay on 15/3/25.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegularTeamCardViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) IBOutlet UITableView *tableView;

- (instancetype)initWithTeam:(NIMTeam*)team;

@end
