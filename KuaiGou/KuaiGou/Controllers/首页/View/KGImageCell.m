//
//  KGImageCell.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/6/4.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "KGImageCell.h"

@implementation KGImageCell
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.logoImage.frame = self.contentView.bounds;
}

- (UIImageView *)logoImage
{
    if (!_logoImage) {
        _logoImage = [[UIImageView alloc] init];
        _logoImage.layer.contentsGravity = kCAGravityResizeAspectFill;
        _logoImage.layer.masksToBounds = YES;
        [self.contentView addSubview:_logoImage];
    }
    return _logoImage;
}
@end
