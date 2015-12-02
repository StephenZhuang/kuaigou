//
//  MBProgressHUD+ZXAdditon.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/10.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "MBProgressHUD.h"

UIKIT_EXTERN NSString *const ZXFailedString;

@interface MBProgressHUD (ZXAdditon)
+ (void)showSuccess:(NSString *)text toView:(UIView *)view;
+ (void)showError:(NSString *)text toView:(UIView *)view;
+ (void)showText:(NSString *)text toView:(UIView *)view;

+ (instancetype)showWaiting:(NSString *)text toView:(UIView *)view;
- (void)turnToSuccess:(NSString *)text;
- (void)turnToError:(NSString *)text;
- (void)turnToText:(NSString *)text;
@end
