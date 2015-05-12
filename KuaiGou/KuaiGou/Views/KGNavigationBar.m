//
//  KGNavigationBar.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/12.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "KGNavigationBar.h"

@implementation KGNavigationBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [self setBarTintColor: [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:1.0]];
    NSDictionary* attrs = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [self setTitleTextAttributes:attrs];
    [self setTintColor:[UIColor whiteColor]];
    if(IOS8_OR_LATER && [UINavigationBar conformsToProtocol:@protocol(UIAppearanceContainer)]) {
        [self setTranslucent:NO];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *view in self.subviews) {
        view.exclusiveTouch = YES;
    }
}

@end
