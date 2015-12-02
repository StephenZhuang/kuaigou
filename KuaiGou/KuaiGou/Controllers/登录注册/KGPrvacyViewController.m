//
//  KGPrvacyViewController.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/12/1.
//  Copyright © 2015年 Hatlab. All rights reserved.
//

#import "KGPrvacyViewController.h"

@implementation KGPrvacyViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"服务条款和隐私政策";
    NSString *path = [[NSBundle mainBundle] pathForResource:@"privacy" ofType:@"html"];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:path]]];
}
@end
