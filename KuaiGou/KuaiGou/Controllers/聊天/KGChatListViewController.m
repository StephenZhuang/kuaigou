//
//  KGChatListViewController.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/12.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "KGChatListViewController.h"
#import "SessionViewController.h"

@implementation KGChatListViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"快聊";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"聊天" style:UIBarButtonItemStylePlain target:self action:@selector(chat)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)chat
{
    NIMSession * session  = [NIMSession session:@"hatlab001" type:NIMSessionTypeP2P];
    SessionViewController * vc = [[SessionViewController alloc] initWithSession:session];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
}
@end
