//
//  KGChangePasswordViewController.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/12/1.
//  Copyright © 2015年 Hatlab. All rights reserved.
//

#import "KGChangePasswordViewController.h"
#import "KGLoginManager.h"
#import "MBProgressHUD+ZXAdditon.h"

@implementation KGChangePasswordViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"修改密码";
}

- (IBAction)doneAction:(id)sender
{
    [self.view endEditing:YES];
    NSString *password = [self.pwdTextField text];
    NSString *passwordAgain = [self.pwdAgiainTextField text];
    if (password.length == 0) {
        return;
    }
    
    if ([password isEqualToString:passwordAgain]) {
        [MBProgressHUD showError:@"两次输入的密码不一致" toView:self.view];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:self.view];
    [[KGLoginManager sharedInstance] changePasswordWithNewpassword:password completion:^(BOOL success, NSString *errorInfo) {
        if (success) {
            [hud turnToSuccess:@"修改成功，请重新登录"];
            [self.navigationController popViewControllerAnimated:YES];
            [self.rdv_tabBarController setSelectedIndex:0];
        } else {
            [hud turnToError:errorInfo];
        }
    }];
}

#pragma mark - textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.pwdTextField) {
        [self.pwdAgiainTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}
@end
