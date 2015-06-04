//
//  TeamCardHeaderCell.h
//  NIM
//
//  Created by chrisRay on 15/3/7.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardDataSourceProtocol.h"
@class AvatarImageView;
@protocol TeamCardHeaderCellDelegate;



@interface TeamCardHeaderCell : UICollectionViewCell

@property (nonatomic,strong) AvatarImageView *imageView;

@property (nonatomic,strong) UIImageView *roleImageView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,weak) id<TeamCardHeaderCellDelegate>delegate;

@property (nonatomic,readonly) id<CardHeaderData> data;

- (void)refreshData:(id<CardHeaderData>)data;

@end


@protocol TeamCardHeaderCellDelegate <NSObject>

- (void)cellDidSelected:(TeamCardHeaderCell*)cell;

@end