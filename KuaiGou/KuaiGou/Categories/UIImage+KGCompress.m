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
//    CGSize newSize;
//    if (self.size.width > self.size.height) {
//        newSize = CGSizeMake(640 * self.size.width / self.size.height, 640);
//    } else {
//        newSize = CGSizeMake(640, 640 * self.size.height / self.size.width);
//    }
//    
//    return [self resizedImageToSize:newSize];
    
    CGSize newSize;
    if (self.size.width > self.size.height) {
        newSize = CGSizeMake(640 * self.size.width / self.size.height, 640);
    } else {
        newSize = CGSizeMake(640, 640 * self.size.height / self.size.width);
    }
    
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    
    //    return [image resizedImageToSize:newSize];
    return newImage;
}
@end
