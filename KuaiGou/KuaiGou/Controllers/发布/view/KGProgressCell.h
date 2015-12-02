//
//  KGProgressCell.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/6/3.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGProgressCell : UITableViewCell
@property (nonatomic , weak) IBOutlet UILabel *titileLabel;
@property (nonatomic , weak) IBOutlet UILabel *contentLabel;
@property (nonatomic , weak) IBOutlet UISlider *slider;
@property (nonatomic , copy) void (^valueChangedBlock)(float value);
@end
