//
//  UIViewController+KGStoryboard.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/12.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (KGStoryboard)
+ (instancetype)viewControllerFromStoryboard:(NSString *)storyboardName;
@end
