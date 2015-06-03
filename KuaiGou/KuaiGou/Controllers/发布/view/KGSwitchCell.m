//
//  KGSwitchCell.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/6/3.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "KGSwitchCell.h"

@implementation KGSwitchCell
- (IBAction)valueChanged:(UISwitch *)sender
{
    BOOL value = sender.on;
    !_valueChangedBlock?:_valueChangedBlock(value);
}
@end
