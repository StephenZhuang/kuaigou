//
//  NSString+NIMDemo.h
//  NIMDemo
//
//  Created by chrisRay on 15/2/12.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (NIMDemo)

- (CGSize)stringSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

- (NSString *)MD5String;

- (NSUInteger)getBytesLength;

@end
