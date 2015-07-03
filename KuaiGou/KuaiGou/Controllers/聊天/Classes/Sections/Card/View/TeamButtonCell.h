//
//  TeamButtonCell.h
//  NIM
//
//  Created by chrisRay on 15/3/11.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TeamButtonCellStyle){
    TeamButtonCellStyleRed,
    TeamButtonCellStyleBlue,
};

@interface TeamButtonCell : UITableViewCell

- (instancetype)initWithTeamButtonStyle:(TeamButtonCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic,strong) UIButton *button;

@end
