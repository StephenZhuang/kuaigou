//
//  UIImage+KGCompress.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/6/4.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "UIImage+KGCompress.h"
#import "UIImage+Resize.h"

@implementation UIImage (KGCompress)
- (NSData *)toData
{
    UIImage *image = [self compressImage];
    NSData *data = UIImageJPEGRepresentation(image, 0.8);
    return data;
}

- (UIImage *)compressImage
{
    CGSize newSize;
    if (self.size.width > self.size.height) {
        newSize = CGSizeMake(640 * self.size.width / self.size.height, 640);
    } else {
        newSize = CGSizeMake(640, 640 * self.size.height / self.size.width);
    }
    
    return [self resizedImageToSize:newSize];
}
@end
