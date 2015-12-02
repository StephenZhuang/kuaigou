//
//  KGStockCell.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/6/3.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGStockCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic , assign) NSInteger stock;
@property (nonatomic , weak) IBOutlet UITextField *textField;
@property (nonatomic , copy) void (^stockChange)(NSInteger stock);
@end
