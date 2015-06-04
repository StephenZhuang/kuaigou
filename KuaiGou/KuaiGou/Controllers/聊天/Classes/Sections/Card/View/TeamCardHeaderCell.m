//
//  TeamCardHeaderCell.m
//  NIM
//
//  Created by chrisRay on 15/3/7.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "TeamCardHeaderCell.h"
#import "AvatarImageView.h"
#import "UIView+NIMDemo.h"
#import "CardMemberItem.h"

@interface TeamCardHeaderCell()

@property (nonatomic,strong) id<CardHeaderData> data;

@end

@implementation TeamCardHeaderCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView                  = [AvatarImageView demoInstanceTeamCardHeader];
        [self addSubview:_imageView];
        _titleLabel                 = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font            = [UIFont systemFontOfSize:13.f];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment   = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        _roleImageView              = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_roleImageView];
    }
    return self;
}

- (void)refreshData:(id<CardHeaderData>)data{
    self.data = data;
    self.imageView.image = data.imageNormal;
    self.imageView.hilghtedImage = data.imageHighLight;
    [self.imageView addTarget:self action:@selector(onSelected:) forControlEvents:UIControlEventTouchUpInside];
    self.titleLabel.text = data.title;
    if([data isKindOfClass:[TeamCardMemberItem class]]) {
        TeamCardMemberItem *member = data;
        self.titleLabel.text = member.title.length ? member.title : member.memberId;
        switch (member.type) {
            case NIMTeamMemberTypeCreator:
                self.roleImageView.image = [UIImage imageNamed:@"icon_team_creator"];
                break;
            case NIMTeamMemberTypeManager:
                self.roleImageView.image = [UIImage imageNamed:@"icon_team_manager"];
                break;
            default:
                self.roleImageView.image = nil;
                break;
        }
    }else{
        self.roleImageView.image = nil;
    }
    [self.titleLabel sizeToFit];
}

- (void)onSelected:(id)sender{
    if ([self.delegate respondsToSelector:@selector(cellDidSelected:)]) {
        [self.delegate cellDidSelected:self];
    }
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.centerX = self.width * .5f;
    self.titleLabel.width = self.width;
    self.titleLabel.bottom = self.height;
    [self.roleImageView sizeToFit];
    self.roleImageView.bottom = self.imageView.bottom;
    self.roleImageView.right  = self.imageView.right;
    
}

@end
