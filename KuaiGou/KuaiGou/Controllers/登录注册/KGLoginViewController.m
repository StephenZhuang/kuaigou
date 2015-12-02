//
//  KGLoginViewController.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/12.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "KGLoginViewController.h"
#import "KGLoginManager.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "KGRegisterViewController.h"

@interface KGLoginViewController ()

@end

@implementation KGLoginViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登录";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)cancelAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender
{
    [self.view endEditing:YES];
    NSString *username = [_usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [_passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"登录中" toView:self.view];
    [[KGLoginManager sharedInstance] loginWithUsername:username password:password completion:^(BOOL success, NSString *errorInfo) {
        if (success) {
            [hud turnToSuccess:@""];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [hud turnToError:errorInfo];
        }
    }];
}

#pragma -mark textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _usernameTextField) {
        [_passwordTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

- (IBAction)registerAction:(id)sender
{
    KGRegisterViewController *vc = [KGRegisterViewController viewControllerFromStoryboard];
    vc.isRegister = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)forgetAction:(id)sender
{
    KGRegisterViewController *vc = [KGRegisterViewController viewControllerFromStoryboard];
    vc.isRegister = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
