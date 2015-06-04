//
//  ContactUtilCell.m
//  NIM
//
//  Created by chrisRay on 15/2/26.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "ContactUtilCell.h"
#import "UIView+NIMDemo.h"


@implementation ContactUtilCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)refreshWithContactItem:(id<ContactItem>)item{
    self.textLabel.text = item.nick;
    self.imageView.image = [UIImage imageNamed:item.iconUrl];
    [self.textLabel sizeToFit];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.left = ContactAvatarLeft;
    self.imageView.centerY = self.height * .5f;
}


@end
