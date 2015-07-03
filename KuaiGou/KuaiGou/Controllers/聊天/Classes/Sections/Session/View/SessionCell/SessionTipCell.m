//
//  SessionTipCell.m
//  NIMDemo
//
//  Created by ght on 15-1-28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "SessionTipCell.h"
#import "UIView+NIMDemo.h"

@implementation SessionTipCell

- (void)awakeFromNib {
    
   [ _timeBGView setImage:[[UIImage imageNamed:@"session_time_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(8,20,8,20) resizingMode:UIImageResizingModeStretch]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_timeLabel sizeToFit];
    _timeLabel.center = CGPointMake(self.centerX, 20);
    _timeBGView.frame = CGRectMake(_timeLabel.left - 7, _timeLabel.top - 2, _timeLabel.width + 14, _timeLabel.height + 4);
}

- (void)setTimeStr:(NSString*)time
{
    [_timeLabel setText:time];
}

@end
