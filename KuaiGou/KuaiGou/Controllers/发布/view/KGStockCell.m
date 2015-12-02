//
//  KGStockCell.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/6/3.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "KGStockCell.h"

@implementation KGStockCell
- (void)setStock:(NSInteger)stock
{
    _stock = stock;
    [_textField setText:[NSString stringWithFormat:@"%@",@(self.stock)]];
    !_stockChange?:_stockChange(stock);
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.stock = textField.text.integerValue;
}

- (IBAction)plusAction:(id)sender
{
    self.stock++;
}

- (IBAction)minusAction:(id)sender
{
    if (self.stock > 0) {
        self.stock--;
    }
}
@end
