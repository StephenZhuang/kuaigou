//
//  SessionListCell.h
//  NIMDemo
//
//  Created by chrisRay on 15/2/10.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AvatarImageView;
@class NIMRecentSession;
@class BadgeView;

@interface SessionListCell : UITableViewCell

@property (nonatomic,strong) AvatarImageView *avatarImageView;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *messageLabel;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) BadgeView *badgeView;

- (void)refresh:(NIMRecentSession*)recent;

@end
