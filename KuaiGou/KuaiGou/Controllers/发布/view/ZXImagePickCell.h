//
//  ZXImagePickCell.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/20.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "MagicalMacro.h"

#define Image_Count_Max (4)

@interface ZXImagePickCell : UITableViewCell<UICollectionViewDelegate , UICollectionViewDataSource>
@property (nonatomic , weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic , strong) NSArray *imageArray;
@property (nonatomic , copy) void (^clickBlock)(NSIndexPath *indexPath);
+ (CGFloat)heightByImageArray:(NSArray *)imageArray;
@end
