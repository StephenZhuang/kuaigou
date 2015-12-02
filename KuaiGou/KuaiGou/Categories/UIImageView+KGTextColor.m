//
//  UIImageView+KGTextColor.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/12/2.
//  Copyright © 2015年 Hatlab. All rights reserved.
//

#import "UIImageView+KGTextColor.h"

@implementation UIImageView (KGTextColor)
- (void)setTextColor:(UIColor *)textColor
{
    NSLog(@"%@",[self class]);
    NSLog(@"%@",[self.superview class]);
}
@end

@implementation UIView (KGTextColor)

- (void)setTextColor:(UIColor *)textColor
{
    NSLog(@"%@",[self class]);
    NSLog(@"%@",[self.superview class]);
}

@end