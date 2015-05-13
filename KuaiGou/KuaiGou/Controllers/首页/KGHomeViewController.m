//
//  KGHomeViewController.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/12.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "KGHomeViewController.h"

@implementation KGHomeViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[KGApiClient sharedClient] POST:@"/api/v1/version" parameters:nil success:^(NSURLSessionDataTask *task, id data) {
        NSLog(@"%@",data);
    } failure:^(NSURLSessionDataTask *task, NSString *errorInfo) {
        NSLog(@"errorinfo : %@",errorInfo);
    }];
}
@end
