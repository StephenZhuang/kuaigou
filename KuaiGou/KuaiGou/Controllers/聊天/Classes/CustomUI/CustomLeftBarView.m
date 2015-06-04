//
//  CumstonLeftBarItem.m
//  nim
//
//  Created by user on 14-6-6.
//  Copyright (c) 2014年 Netease. All rights reserved.
//

#import "CustomLeftBarView.h"
#import "BadgeView.h"
#import "UIView+NIMDemo.h"
@implementation CustomLeftBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews
{
    self.badgeView = [BadgeView viewWithBadgeTip:@""];
    self.badgeView.frame = CGRectMake(20, 8, 0, 0);
    self.badgeView.hidden = YES;
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonNormal = [UIImage imageNamed:@"icon_back_normal"];
    UIImage *buttonPressed= [UIImage imageNamed:@"icon_back_pressed"];
    
    [leftButton setImage:buttonNormal forState:UIControlStateNormal];
    [leftButton setImage:buttonPressed forState:UIControlStateHighlighted];
    [leftButton sizeToFit];
    leftButton.exclusiveTouch = YES;
    
    [leftButton addTarget:self
                       action:@selector(onLeftButtonPressed:)
             forControlEvents:UIControlEventTouchUpInside];
    
    self.frame = CGRectMake(0.0, 0.0, 50.0, 44.f);
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:leftButton];
    [self addSubview:self.badgeView];
}

- (void)onLeftButtonPressed:(id)sender
{
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(onLeftButtonPressed)])
        {
            [self.delegate onLeftButtonPressed];
        }
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    for (UIView *view in self.subviews) {
        view.centerY = self.height * .5f;
    }
}
@end
