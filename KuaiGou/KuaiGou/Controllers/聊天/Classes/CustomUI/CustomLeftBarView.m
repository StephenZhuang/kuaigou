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
@implementation CustomLeftBarView{
    UIImageView *_leftBtnView;
}

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
    _leftBtnView = [[UIImageView alloc] initWithFrame:CGRectZero];
    UIImage *buttonNormal = [UIImage imageNamed:@"icon_back_normal"];
    UIImage *buttonPressed= [UIImage imageNamed:@"icon_back_pressed"];
    
    _leftBtnView.image = buttonNormal;
    _leftBtnView.highlightedImage = buttonPressed;
    [_leftBtnView sizeToFit];

    [self addTarget:self
                       action:@selector(onLeftButtonPressed:)
             forControlEvents:UIControlEventTouchUpInside];
    self.exclusiveTouch = YES;
    self.frame = CGRectMake(0.0, 0.0, 50.0, 44.f);
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:_leftBtnView];
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

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    [_leftBtnView setHighlighted:highlighted];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    for (UIView *view in self.subviews) {
        view.centerY = self.height * .5f;
    }
}
@end
