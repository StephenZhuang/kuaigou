//
//  KGRegisterViewController.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/19.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "KGRegisterViewController.h"
#import "ZXCountTimeHelper.h"
#import "KGLoginManager.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXValidateHelper.h"
#import "KGRegisterPasswordViewControlelr.h"
#import "KGPrvacyViewController.h"

@implementation KGRegisterViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    if (self.isRegister) {
        self.title = @"注册";
    } else {
        self.title = @"忘记密码";
    }
}

#pragma -mark textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma -mark event
- (IBAction)getCode:(id)sender
{
    [self.view endEditing:YES];
    NSString *phone = [_usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([ZXValidateHelper checkTel:phone needsWarning:YES]) {
        MBProgressHUD *hud = [MBProgressHUD showWaiting:@"验证手机中" toView:self.view];
        [[KGLoginManager sharedInstance] checkPhone:phone isRegister:self.isRegister completion:^(BOOL success, NSString *code) {
            if (success) {
                [hud hide:YES];
                NSLog(@"验证码：%@",code);
                codeString = code;
                [self startCount];
            } else {
                [hud turnToError:code];
            }
        }];
        
    }
    
}

- (IBAction)netxAction:(id)sender
{
    [self.view endEditing:YES];
    NSString *code = [_codeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *phone = [_usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([code isEqualToString:codeString]) {
        KGRegisterPasswordViewControlelr *vc = [KGRegisterPasswordViewControlelr viewControllerFromStoryboard];
        vc.phone = phone;
        vc.isRegister = self.isRegister;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [MBProgressHUD showError:@"验证码不正确" toView:self.view];
    }
}

#pragma -mark private method
- (void)startCount
{
    [ZXCountTimeHelper countDownWithTime:60 countDownBlock:^(int timeLeft) {
        int seconds = timeLeft % 60;
        NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
        //设置界面的按钮显示 根据自己需求设置
        [_countDownButton setTitle:[NSString stringWithFormat:@"%@ s",strTime] forState:UIControlStateNormal];
        [_countDownButton setTitle:[NSString stringWithFormat:@"%@ s",strTime] forState:UIControlStateSelected];
        _countDownButton.userInteractionEnabled = NO;
        _countDownButton.selected = YES;
    } endBlock:^(void) {
        [_countDownButton setTitle:@"重新获取" forState:UIControlStateNormal];
        [_countDownButton setTitle:@"重新获取" forState:UIControlStateSelected];
        _countDownButton.userInteractionEnabled = YES;
        _countDownButton.selected = NO;
    }];
}

- (IBAction)privacyAction:(id)sender
{
    KGPrvacyViewController *vc = [KGPrvacyViewController viewControllerFromStoryboard];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
