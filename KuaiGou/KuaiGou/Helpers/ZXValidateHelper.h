//
//  ZXValidateHelper.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/10.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD+ZXAdditon.h"

@interface ZXValidateHelper : NSObject
/**
 *  验证电话号码
 *
 *  @param str 电话号码
 *
 *  @return 是否是手机或者电话
 */
+ (BOOL)checkTel:(NSString *)str;

+ (BOOL)checkTel:(NSString *)str needsWarning:(BOOL)needsWarning;
@end
