//
//  KGNearbyViewController.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/12.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "KGNearbyViewController.h"
#import "DOPDropDownMenu.h"
#import "KGCategory.h"
#import "KGGoods.h"
#import "KGGoodsCell.h"
#import "KGGoodsDetailViewController.h"

@interface KGNearbyViewController ()<DOPDropDownMenuDelegate,DOPDropDownMenuDataSource>
{
    NSInteger pid;
    NSInteger catid;
    NSNumber *lat;
    NSNumber *lng;
    NSString *sort;
    NSString *sortmode;
    NSInteger dis;
    
}
@end

@implementation KGNearbyViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_t_logo"]];
    self.navigationItem.titleView = imageView;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bt_navb_search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"KGGoodsCell" bundle:nil] forCellReuseIdentifier:@"KGGoodsCell"];
    
    pid = -1;
    catid = -1;
    sortmode = @"desc";
    sort = @"price";
    dis = 1;
    
    [KGLocationManager sharedInstance].locationService.delegate = self;
    [[KGLocationManager sharedInstance].locationService startUserLocationService];
    
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
    menu.delegate = self;
    menu.dataSource = self;
    [self.view addSubview:menu];
    
    [menu selectDefalutIndexPath];
    
    [KGCategory getParentCategoryWithCompletion:^(BOOL success, NSString *errorInfo, NSArray *array) {
        if (array) {
            for (KGCategory *category in array) {
                [KGCategory getChildCategoryWithPid:category.catid completion:^(BOOL success, NSString *errorInfo, NSArray *array) {
                    category.childArray = array;
                    [self.categoryArray addObject:category];
                }];
            }
        }
    }];
    
}

- (void)searchAction
{
    
}

- (void)addHeader
{
    __weak __typeof(&*self)weakSelf = self;
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (!hasMore) {
            [weakSelf.tableView.footer resetNoMoreData];
        }
        page = 1;
        hasMore = YES;
        [weakSelf loadData];
    }];
}

- (void)loadData
{
    if (lat && lng && sort && sortmode) {
        [KGGoods getNearbyGoodsWithLat:lat lng:lng catpid:pid catid:catid sort:sort sortmode:sortmode pagenumber:page pagesize:pageCount dis:dis completion:^(BOOL success, NSString *errorInfo, NSArray *array) {
            [self configureArray:array];
        }];
    } else {
//        if (page == 1) {
//            [self.tableView.header endRefreshing];
//        } else {
//            [self.tableView.footer endRefreshing];
//        }
    }
}

#pragma mark - dropmenu delegate
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 4;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0) {
        return self.categoryArray.count;
    } else if (column == 1){
        return self.sortNameArray.count;
    } else if (column == 2) {
        return self.distanceArray.count;
    } else {
        return self.sortArray.count;
    }
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        KGCategory *category = self.categoryArray[indexPath.row];
        return category.name;
    } else if (indexPath.column == 1){
        return self.sortNameArray[indexPath.row];
    } else if (indexPath.column == 2) {
        return self.distanceArray[indexPath.row];
    } else {
        return self.sortArray[indexPath.row];
    }
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
{
    if (column == 0) {
        KGCategory *category = self.categoryArray[row];
        return category.childArray.count;
    }
    return 0;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        KGCategory *category = self.categoryArray[indexPath.row];
        KGCategory *childCategory = category.childArray[indexPath.item];
        return childCategory.name;
    }
    return nil;
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.item >= 0) {
        NSLog(@"点击了 %ld - %ld - %ld 项目",indexPath.column,indexPath.row,indexPath.item);
    }else {
        NSLog(@"点击了 %ld - %ld 项目",indexPath.column,indexPath.row);
    }
    
    if (indexPath.column == 0) {
        KGCategory *category = [self.categoryArray objectAtIndex:indexPath.row];
        
        if (indexPath.item >= 0) {
            KGCategory *child = [category.childArray objectAtIndex:indexPath.item];
            catid = child.catid;
        } else {
            pid = category.catid;
            if (category.childArray.count == 0) {
                catid = -1;
            }
        }
    } else if (indexPath.column == 1) {
        if (indexPath.row == 0) {
            sort = @"price";
        } else {
            sort = @"sells";
        }
        
    } else if (indexPath.column == 2) {
        NSString *kmString = [self.distanceArray objectAtIndex:indexPath.row];
        if ([kmString hasSuffix:@"km"]) {
            dis = [[kmString substringToIndex:kmString.length - 2] integerValue];
        }
    } else {
        if (indexPath.row == 0) {
            sortmode = @"desc";
        } else {
            sortmode = @"asc";
        }
    }
    [self.tableView.header beginRefreshing];
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [[KGLocationManager sharedInstance].locationService stopUserLocationService];
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    lat = @(userLocation.location.coordinate.latitude);
    lng = @(userLocation.location.coordinate.longitude);
    [self loadData];
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KGGoodsCell"];
    KGGoods *goods = [self.dataArray objectAtIndex:indexPath.row];
    [cell configureUIWithGoods:goods];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        double distance = [[KGLocationManager sharedInstance] distanceBetweenPoint1:CLLocationCoordinate2DMake(lat.doubleValue, lng.doubleValue) point2:CLLocationCoordinate2DMake(goods.lat.doubleValue, goods.lng.doubleValue)];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [cell.distanceLabel setText:[NSString stringWithFormat:@"%.2fm",distance]];
        });
    });
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGoods *goods = [self.dataArray objectAtIndex:indexPath.row];
    KGGoodsDetailViewController *vc = [KGGoodsDetailViewController viewControllerFromStoryboard:@"Nearby"];
    vc.itemid = goods.itemid;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - setters and getters
- (NSMutableArray *)categoryArray
{
    if (!_categoryArray) {
        _categoryArray = [[NSMutableArray alloc] init];
        KGCategory *category = [[KGCategory alloc] init];
        category.catid = -1;
        category.name = @"全部";
        KGCategory *childCategory = [[KGCategory alloc] init];
        childCategory.catid = -1;
        childCategory.pid = -1;
        childCategory.name = @"全部";
        category.childArray = @[childCategory];
        [_categoryArray addObject:category];
    }
    return _categoryArray;
}

- (NSArray *)distanceArray
{
    if (!_distanceArray) {
        _distanceArray = @[@"1km",@"3km",@"5km",@"10km"];
    }
    return _distanceArray;
}

- (NSArray *)sortNameArray
{
    if (!_sortNameArray) {
        _sortNameArray = @[@"价格",@"销量"];
    }
    return _sortNameArray;
}

- (NSArray *)sortArray
{
    if (!_sortArray) {
        _sortArray = @[@"降序",@"升序"];
    }
    return _sortArray;
}
@end
