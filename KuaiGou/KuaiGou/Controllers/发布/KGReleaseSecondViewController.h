//
//  KGReleaseSecondViewController.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/6/3.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGGoods.h"
#import <BaiduMapAPI/BMapKit.h>
#import "MBProgressHUD+ZXAdditon.h"

@interface KGReleaseSecondViewController : KGBaseViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UITextViewDelegate,CLLocationManagerDelegate>
@property (nonatomic , strong) KGGoods *goods;
@property (nonatomic , strong) NSMutableArray *imageArray;
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@property (nonatomic , strong) NSArray *tradeModeArray;
@property (nonatomic , strong) BMKLocationService *locationService;
@property (nonatomic , strong) BMKGeoCodeSearch *searcher;
@property (nonatomic , strong) MBProgressHUD *locationHUD;
@end
