//
//  UIResponder+Router.m
//  NIMDemo
//
//  Created by ght on 15-1-28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "UIResponder+Router.h"

@implementation UIResponder (Router)

- (void)nim_routerEvent:(id)data
{
    [[self nextResponder] nim_routerEvent:data];
}

@end
