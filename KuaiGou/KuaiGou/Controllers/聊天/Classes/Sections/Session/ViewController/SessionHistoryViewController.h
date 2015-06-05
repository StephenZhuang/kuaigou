//
//  SessionHistoryViewController.h
//  NIM
//
//  Created by chrisRay on 15/4/22.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionHistoryViewController : UIViewController

@property (nonatomic,strong) IBOutlet UITableView *tableView;

- (instancetype)initWithSession:(NIMSession *)session;

@end
