//
//  GVUserDefaults+KGUtil.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/12.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "GVUserDefaults.h"

@interface GVUserDefaults (KGUtil)
@property (nonatomic , assign) BOOL isLogin;
@property (nonatomic , strong) NSDictionary *user;
@property (nonatomic , copy) NSString *username;
@property (nonatomic , copy) NSString *password;
@end
