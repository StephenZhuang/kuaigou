//
//  KGSelectedButton.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/11/26.
//  Copyright © 2015年 Hatlab. All rights reserved.
//

#import "KGSelectedButton.h"

@implementation KGSelectedButton
- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self.icon setHighlighted:selected];
    [self.titleLabel setHighlighted:selected];
}
@end
