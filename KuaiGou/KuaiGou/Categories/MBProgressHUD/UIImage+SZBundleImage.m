//
//  UIImage+SZBundleImage.m
//  SZShareKit
//
//  Created by Stephen Zhuang on 14/10/27.
//  Copyright (c) 2014年 udows. All rights reserved.
//

#import "UIImage+SZBundleImage.h"

@implementation UIImage (SZBundleImage)
+ (UIImage *)imagesNamedFromCustomBundle:(NSString *)name
{
    NSString *customBundleName = @"ProgressHUD";
    return [self imagesNamed:name fromBundle:customBundleName];
}

+ (UIImage *)imagesNamed:(NSString *)name fromBundle:(NSString *)bundleName
{
    NSString *main_images_dir_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/%@.bundle",bundleName];
    NSString *image_path = [main_images_dir_path stringByAppendingPathComponent:name];
    if (!IOS8_OR_LATER) {
        image_path = [image_path stringByAppendingString:@"@2x.png"];
    }
    return [UIImage imageWithContentsOfFile:image_path];
}
@end
