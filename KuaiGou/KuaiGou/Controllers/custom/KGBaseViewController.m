//
//  KGBaseViewController.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/11/25.
//  Copyright © 2015年 Hatlab. All rights reserved.
//

#import "KGBaseViewController.h"

@implementation KGBaseViewController
+ (instancetype)viewControllerFromStoryboard
{
    NSLog(@"必须重写viewControllerFromStoryboard");
    return nil;
}

- (void)addBackButton
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = item;
    
    [self.view setBackgroundColor: [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addBackButton];
}
@end
