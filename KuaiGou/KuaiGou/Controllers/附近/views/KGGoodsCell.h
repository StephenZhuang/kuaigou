//
//  KGGoodsCell.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/7/7.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGGoods.h"

@interface KGGoodsCell : UITableViewCell
@property (nonatomic , weak) IBOutlet UIImageView *goodsImageView;
@property (nonatomic , weak) IBOutlet UILabel *titleLabel;
@property (nonatomic , weak) IBOutlet UILabel *tipLabel;
@property (nonatomic , weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic , weak) IBOutlet UILabel *priceLabel;

- (void)configureUIWithGoods:(KGGoods *)goods;
@end
