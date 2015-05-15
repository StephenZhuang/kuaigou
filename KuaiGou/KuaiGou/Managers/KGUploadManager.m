//
//  KGUploadManager.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/14.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "KGUploadManager.h"
#import <QiniuSDK.h>

@implementation KGUploadManager
+ (instancetype)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (void)uploadWithData:(NSArray *)dataArray completion:(void(^)(BOOL success ,NSString *uploadAddress, NSString *errorInfo))completetion
{
    [self getQiniuUploadTokenWithCompletetion:^(BOOL success, NSString *token) {
        if (success) {
            QNUploadManager *upManager = [[QNUploadManager alloc] init];
            dispatch_group_t group = dispatch_group_create();
            
            __block NSMutableArray *array = [[NSMutableArray alloc] init];
            
            for (NSData *data in dataArray) {
                dispatch_group_enter(group);
                [upManager putData:data key:nil token:token
                          complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                              NSLog(@"%@", info);
                              NSLog(@"%@", resp);
                              [array addObject:[resp objectForKey:@"key"]];
                              dispatch_group_leave(group);
                          } option:nil];
            }

            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                if (array.count == dataArray.count) {
                    !completetion?:completetion(YES,[array componentsJoinedByString:@","],@"");
                } else {
                    !completetion?:completetion(NO,@"",@"上传出错，请重试");
                }
            });


        } else {
            !completetion?:completetion(NO,@"",token);
        }
    }];
}

- (void)getQiniuUploadTokenWithCompletetion:(void(^)(BOOL success, NSString *token))completetion
{
    [[KGApiClient sharedClient] POST:@"api/v1/app/qntoken" parameters:nil success:^(NSURLSessionDataTask *task, id data) {
        !completetion?:completetion(YES,data);
    } failure:^(NSURLSessionDataTask *task, NSString *errorInfo) {
        !completetion?:completetion(NO,errorInfo);
    }];
}

@end