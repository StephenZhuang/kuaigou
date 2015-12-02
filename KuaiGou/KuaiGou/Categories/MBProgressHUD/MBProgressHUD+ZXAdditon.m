//
//  MBProgressHUD+ZXAdditon.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/10.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "MBProgressHUD+ZXAdditon.h"
#import "UIImage+SZBundleImage.h"

NSString *const ZXFailedString = @"操作失败，请重试";

@implementation MBProgressHUD (ZXAdditon)
+ (void)showSuccess:(NSString *)text toView:(UIView *)view
{
    [self showWithText:text imageName:@"success-white" toView:view];
}

+ (void)showError:(NSString *)text toView:(UIView *)view
{
    [self showWithText:text imageName:@"error-white" toView:view];
}

+ (void)showWithText:(NSString *)text imageName:(NSString *)imageName toView:(UIView *)view
{
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    
    // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
    // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
    UIImage *image = [UIImage imagesNamedFromCustomBundle:imageName];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    
    // Set custom view mode
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = text;
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    [hud hide:YES afterDelay:1];
}

+ (void)showText:(NSString *)text toView:(UIView *)view
{
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    [hud hide:YES afterDelay:1];
}

+ (instancetype)showWaiting:(NSString *)text toView:(UIView *)view
{
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = text;
    
    [hud show:YES];
    return hud;
}

- (void)turnToSuccess:(NSString *)text
{
    self.customView = [[UIImageView alloc] initWithImage:[UIImage imagesNamedFromCustomBundle:@"success-white"]];
    self.mode = MBProgressHUDModeCustomView;
    self.labelText = text;
    [self hide:YES afterDelay:1];
}

- (void)turnToError:(NSString *)text
{
    UIImage *image = [UIImage imagesNamedFromCustomBundle:@"error-white"];
    self.customView = [[UIImageView alloc] initWithImage:image];
    self.mode = MBProgressHUDModeCustomView;
    self.labelText = text;
    [self hide:YES afterDelay:1];
}

- (void)turnToText:(NSString *)text
{
    self.mode = MBProgressHUDModeText;
    self.labelText = text;
    [self hide:YES afterDelay:1];
}
@end
