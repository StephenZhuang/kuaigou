//
//  KGLoginManager.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/12.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGLoginManager : NSObject
+ (instancetype)sharedInstance;
- (BOOL)isLogin;
@end
