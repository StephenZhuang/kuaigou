//
//  KGSettingViewController.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/11/27.
//  Copyright © 2015年 Hatlab. All rights reserved.
//

#import "KGSettingViewController.h"
#import "KGLoginManager.h"
#import "KGFeedbackViewController.h"
#import "KGChangePasswordViewController.h"

@implementation KGSettingViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设置";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)logoutAction:(id)sender
{
    [[KGLoginManager sharedInstance] logoutWithCompletion:^(BOOL success, NSString *errorInfo) {
        [self.navigationController popViewControllerAnimated:YES];
        [self.rdv_tabBarController setSelectedIndex:0];
    }];
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row == 0) {
        [cell.textLabel setText:@"意见反馈"];
    } else {
        [cell.textLabel setText:@"修改密码"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        KGFeedbackViewController *vc = [KGFeedbackViewController viewControllerFromStoryboard];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        KGChangePasswordViewController *vc = [KGChangePasswordViewController viewControllerFromStoryboard];
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
