//
//  TeamButtonCell.m
//  NIM
//
//  Created by chrisRay on 15/3/11.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "TeamButtonCell.h"
#import "UIView+NIMDemo.h"

@implementation TeamButtonCell

- (instancetype)initWithTeamButtonStyle:(TeamButtonCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *imageNormalName = @"";
        NSString *imageHighLightName  = @"";
        switch (style) {
            case TeamButtonCellStyleRed:
                imageNormalName = @"icon_cell_red_normal";
                imageHighLightName  = @"icon_cell_red_pressed";
                break;
            case TeamButtonCellStyleBlue:
                imageNormalName = @"icon_cell_blue_normal";
                imageHighLightName  = @"icon_cell_blue_pressed";
                break;
            default:
                break;
        }
        UIImage *imageNormal = [[UIImage imageNamed:imageNormalName] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
        UIImage *imageHighLight = [[UIImage imageNamed:imageHighLightName] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
        _button.size = CGSizeMake(self.width - 20, 45);
        _button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_button setBackgroundImage:imageNormal forState:UIControlStateNormal];
        [_button setBackgroundImage:imageHighLight forState:UIControlStateHighlighted];
        [self addSubview:_button];
    }
    return self;
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _button.centerX = self.width * .5f;
    _button.centerY = self.height * .5f;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [_button setSelected:selected];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [_button setHighlighted:highlighted];
}



@end
