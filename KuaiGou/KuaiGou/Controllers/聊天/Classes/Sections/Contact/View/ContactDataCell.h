//
//  ContactInfoCell.h
//  NIM
//
//  Created by chrisRay on 15/2/26.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactDefines.h"

@class AvatarImageView;

@interface ContactDataCell : UITableViewCell<ContactCell>

@property (nonatomic,strong) AvatarImageView * avatarImageView;

@end
