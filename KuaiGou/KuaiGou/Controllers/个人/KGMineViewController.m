//
//  KGMineViewController.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/12.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "KGMineViewController.h"
#import "KGLoginManager.h"

@implementation KGMineViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)logoutAction:(id)sender
{
    [[KGLoginManager sharedInstance] logoutWithCompletion:^(BOOL success, NSString *errorInfo) {
        
    }];
}
@end
