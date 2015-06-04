//
//  ContactInfoCell.m
//  NIM
//
//  Created by chrisRay on 15/2/26.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "ContactDataCell.h"
#import "AvatarImageView.h"
#import "UIView+NIMDemo.h"

@implementation ContactDataCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _avatarImageView = [AvatarImageView demoInstanceContactDataList];
        [self addSubview:_avatarImageView];
    }
    return self;
}

- (void)refreshWithContactItem:(id<ContactItem>)item{
    self.textLabel.text = item.nick;
    [self.textLabel sizeToFit];
    NSString *avatar = [item iconUrl] ? : @"DefaultAvatar";
    _avatarImageView.image = [UIImage imageNamed:avatar];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.avatarImageView.left = ContactAvatarLeft;
    self.avatarImageView.centerY = self.height * .5f;
    self.textLabel.left = self.avatarImageView.right + ContactAvatarAndTitleSpacing;
}

@end
