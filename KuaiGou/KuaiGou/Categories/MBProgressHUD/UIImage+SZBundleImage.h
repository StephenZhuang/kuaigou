//
//  UIImage+SZBundleImage.h
//  SZShareKit
//
//  Created by Stephen Zhuang on 14/10/27.
//  Copyright (c) 2014年 udows. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SZBundleImage)
/**
 *  从默认bundle中获取图片
 *
 *  @param name imagename
 *
 *  @return uiimage
 */
+ (UIImage *)imagesNamedFromCustomBundle:(NSString *)name;
/**
 *  bundle中获取image
 *
 *  @param name       imageName
 *  @param bundleName bundleName
 *
 *  @return uiimage
 */
+ (UIImage *)imagesNamed:(NSString *)name fromBundle:(NSString *)bundleName;
@end
