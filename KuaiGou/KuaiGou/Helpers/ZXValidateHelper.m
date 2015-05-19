//
//  ZXValidateHelper.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/10.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXValidateHelper.h"

@implementation ZXValidateHelper

+ (BOOL)checkTel:(NSString *)str
{
    if ([str length] == 0) {
        [MBProgressHUD showError:@"电话号码不能为空" toView:nil];
        return NO;
    }
    
    //1[0-9]{10}
    
    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    
    //    NSString *regex = @"[0-9]{11}";
    
    NSString *regex = @"^0{0,1}(13[0-9]|15[0-9]|17[0-9]|18[0-9])[0-9]{8}|(?:0(?:10|2[0-57-9]|[3-9]\\d{2}))?\\d{7,8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        [MBProgressHUD showError:@"请输入正确的电话号码" toView:nil];
        return NO;
    }   
    return YES;
    
}

+ (BOOL)checkTel:(NSString *)str needsWarning:(BOOL)needsWarning
{
    if ([str length] == 0) {
        [MBProgressHUD showError:@"电话号码不能为空" toView:nil];
        return NO;
    }
    
    //1[0-9]{10}
    
    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    
    //    NSString *regex = @"[0-9]{11}";
    
    NSString *regex = @"^0{0,1}(13[0-9]|15[0-9]|17[0-9]|18[0-9])[0-9]{8}|(?:0(?:10|2[0-57-9]|[3-9]\\d{2}))?\\d{7,8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        if (needsWarning) {
            [MBProgressHUD showError:@"请输入正确的电话号码" toView:nil];
        }
        return NO;
    }
    return YES;
    
}
@end
