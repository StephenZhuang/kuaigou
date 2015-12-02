//
//  KGGoodsCell.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/7/7.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "KGGoodsCell.h"
#import "KGImageUrlHelper.h"

@implementation KGGoodsCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.goodsImageView.layer.cornerRadius = 5;
    self.goodsImageView.layer.contentsGravity = kCAGravityResizeAspectFill;
    self.goodsImageView.layer.masksToBounds = YES;
}

- (void)configureUIWithGoods:(KGGoods *)goods
{
    if (goods.image.length > 0) {
        NSString *key = [[goods.image componentsSeparatedByString:@","] firstObject];
        [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:[KGImageUrlHelper imageUrlWithKey:key]] placeholderImage:[UIImage imageNamed:@"bg_product_def"]];
    }
    [self.titleLabel setText:goods.title];
    [self.priceLabel setText:[NSString stringWithFormat:@"￥ %.2f",[goods displayPrice]]];
    NSArray *arr = @[@"送货上门",@"上门自提"];
    [self.tipLabel setText:arr[goods.trademodeid -1]];
}
@end
