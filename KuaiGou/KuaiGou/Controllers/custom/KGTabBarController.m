//
//  KGTabBarController.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/12.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "KGTabBarController.h"
#import "KGLoginManager.h"
#import "KGLoginViewController.h"
#import "KGReleaseViewController.h"

@implementation KGTabBarController
- (BOOL)tabBar:(RDVTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index
{
    if (index == 2 || index == 3 || index == 4) {
        if ([[KGLoginManager sharedInstance] isLogin]) {
            if (index == 2) {                
                KGReleaseViewController *vc = [KGReleaseViewController viewControllerFromStoryboard];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                [self presentViewController:nav animated:YES completion:nil];
            }
        } else {
            KGLoginViewController *vc = [KGLoginViewController viewControllerFromStoryboard];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
            return NO;
        }
        if (index == 2) {
            return NO;
        }
    }
    return [super tabBar:tabBar shouldSelectItemAtIndex:index];
}
@end
