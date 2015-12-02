//
//  KGCategoryGoodsViewController.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/11/27.
//  Copyright © 2015年 Hatlab. All rights reserved.
//

#import "ZXRefreshTableViewController.h"
#import "KGCategory.h"
#import "KGLocationManager.h"

@interface KGCategoryGoodsViewController : ZXRefreshTableViewController<BMKLocationServiceDelegate>
@property (nonatomic , strong) KGCategory *category;
@property (nonatomic , assign) float lat;
@property (nonatomic , assign) float lng;
@end
