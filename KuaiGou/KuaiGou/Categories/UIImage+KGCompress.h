//
//  UIImage+KGCompress.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/6/4.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (KGCompress)
- (NSData *)toData;
- (UIImage *)compressImage;
@end
