//
//  KGProgressCell.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/6/3.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "KGProgressCell.h"

@implementation KGProgressCell
- (IBAction)valueChanged:(UISlider *)sender
{
    float value = sender.value;
    !_valueChangedBlock?:_valueChangedBlock(value);
}
@end
