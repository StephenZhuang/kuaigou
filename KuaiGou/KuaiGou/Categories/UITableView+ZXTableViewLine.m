//
//  UITableView+ZXTableViewLine.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/7.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "UITableView+ZXTableViewLine.h"

@implementation UITableView (ZXTableViewLine)

- (void)setExtrueLineHidden
{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 1)];
    [view setBackgroundColor:[UIColor clearColor]];
    [self setTableFooterView:view];
}

@end
