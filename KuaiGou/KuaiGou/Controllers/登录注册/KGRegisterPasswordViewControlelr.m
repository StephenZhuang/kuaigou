//
//  KGRegisterPasswordViewControlelr.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/19.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "KGRegisterPasswordViewControlelr.h"
#import "KGLoginManager.h"
#import "MBProgressHUD+ZXAdditon.h"

@implementation KGRegisterPasswordViewControlelr

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"注册";
}

- (IBAction)registerAction:(id)sender
{
    [self.view endEditing:YES];
    NSString *password = [_passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *passwordAgain = [_passwordAgainTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:self.view];
    if (![password isEqualToString:passwordAgain]) {
        [hud turnToError:@"两次输入密码不一致"];
        return;
    }
    
    if (password.length >= 6 && password.length <= 12) {
        [[KGLoginManager sharedInstance] registerWithPhone:_phone password:password completion:^(BOOL success, NSString *errorInfo) {
            if (success) {
                [hud turnToSuccess:@""];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                [hud turnToError:errorInfo];
            }
        }];
    } else {
        [hud turnToError:@"密码长度在6-12位之间"];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _passwordTextField) {
        [_passwordAgainTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}
@end
