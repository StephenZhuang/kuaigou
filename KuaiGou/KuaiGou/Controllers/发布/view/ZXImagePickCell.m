//
//  ZXImagePickCell.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/20.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXImagePickCell.h"
#import "ZXBaseCollectionViewCell.h"

@implementation ZXImagePickCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    CGFloat itemWidth = (SCREEN_WIDTH - 75) / 4;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    layout.minimumLineSpacing = 15;
    layout.minimumInteritemSpacing = 15;
    [_collectionView setCollectionViewLayout:layout animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_imageArray) {
        return MIN(Image_Count_Max, _imageArray.count+1);
    } else {
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZXBaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row == _imageArray.count) {
        [cell.imageView setImage:[UIImage imageNamed:@"bt_add_image_n"]];
    } else {
        UIImage *image = _imageArray[indexPath.row];
        [cell.imageView setImage:image];
    }
    cell.imageView.layer.contentsGravity = kCAGravityResizeAspectFill;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.clickBlock) {
        self.clickBlock(indexPath);
    }
}

- (void)setImageArray:(NSArray *)imageArray
{
    _imageArray = imageArray;
    [_collectionView reloadData];
}

+ (CGFloat)heightByImageArray:(NSArray *)imageArray
{
    CGFloat itemWidth = (SCREEN_WIDTH - 75) / 4;
    return itemWidth + 30;
}

@end
