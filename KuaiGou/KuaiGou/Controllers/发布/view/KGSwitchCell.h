//
//  KGSwitchCell.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/6/3.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGSwitchCell : UITableViewCell
@property (nonatomic , weak) IBOutlet UILabel *titleLabel;
@property (nonatomic , weak) IBOutlet UISwitch *contentSwitch;
@property (nonatomic , copy) void (^valueChangedBlock)(BOOL value);
@end
