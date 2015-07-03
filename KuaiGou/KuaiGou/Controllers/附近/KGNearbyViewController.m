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

@interface KGNearbyViewController ()<DOPDropDownMenuDelegate,DOPDropDownMenuDataSource>

@end

@implementation KGNearbyViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_t_logo"]];
    self.navigationItem.titleView = imageView;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bt_navb_search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
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
