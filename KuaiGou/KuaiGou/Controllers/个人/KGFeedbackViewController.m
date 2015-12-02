//
//  KGFeedbackViewController.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/11/27.
//  Copyright © 2015年 Hatlab. All rights reserved.
//

#import "KGFeedbackViewController.h"
#import "KGLoginManager.h"
#import "MBProgressHUD+ZXAdditon.h"

@implementation KGFeedbackViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"意见反馈";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submitAction:)];
    self.navigationItem.rightBarButtonItem = item;
    [self.textView becomeFirstResponder];
}

#pragma mark - textView delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (IBAction)submitAction:(id)sender
{
    [self.view endEditing:YES];
    NSString *content = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (content.length > 0) {
        MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:self.view];
        [[KGLoginManager sharedInstance].user feedbackWithContent:content completion:^(BOOL success, NSString *errorInfo) {
            if (success) {
                [hud turnToSuccess:@"提交成功"];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [hud turnToError:errorInfo];
            }
        }];
    }
}
@end

