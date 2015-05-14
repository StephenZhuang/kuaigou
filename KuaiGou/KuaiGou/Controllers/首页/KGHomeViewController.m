//
//  KGHomeViewController.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/12.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "KGHomeViewController.h"
#import "KGUploadManager.h"
#import "KGImageUrlHelper.h"

@implementation KGHomeViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[KGApiClient sharedClient] POST:@"/api/v1/sys" parameters:nil success:^(NSURLSessionDataTask *task, id data) {
        NSLog(@"%@",data);
    } failure:^(NSURLSessionDataTask *task, NSString *errorInfo) {
        NSLog(@"errorinfo : %@",errorInfo);
    }];
    
//    UIImage *image = [UIImage imageNamed:@"bt_fav_h"];
//    NSData *data = UIImagePNGRepresentation(image);
//    
//    image = [UIImage imageNamed:@"bg_usercenter_head_def"];
//    NSData *data2 = UIImagePNGRepresentation(image);
//    
//    [[KGUploadManager sharedInstance] uploadWithData:@[data,data2] completion:^(BOOL success, NSString *uploadAddress, NSString *errorInfo) {
//        
//    }];
    
    NSString *imageUrl = [KGImageUrlHelper imageUrlWithKey:@"FnZI9YDNrS06QYdHNaJYS8wQccgu"];
    NSLog(@"imageurl = %@",imageUrl);
}
@end
