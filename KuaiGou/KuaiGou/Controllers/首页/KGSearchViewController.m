//
//  KGSearchViewController.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/11/27.
//  Copyright © 2015年 Hatlab. All rights reserved.
//

#import "KGSearchViewController.h"
#import "KGGoodsDetailViewController.h"
#import "KGGoods.h"
#import "KGGoodsCell.h"

@implementation KGSearchViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.placeholder = @"搜索商品";
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    [self.tableView registerNib:[UINib nibWithNibName:@"KGGoodsCell" bundle:nil] forCellReuseIdentifier:@"KGGoodsCell"];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(nothingtodo)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)nothingtodo
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)loadData
{
    if (self.searchString) {
        [KGGoods searchGoodsWithString:self.searchString pagenumber:page pagesize:pageCount completion:^(BOOL success, NSString *errorInfo, NSArray *array) {
            [self configureArray:array];
        }];
    } else {
        [self.tableView.header endRefreshing];
    }
}

#pragma mark - searchbar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.searchString = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (self.searchString) {
        page = 1;
        [self loadData];
    }
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
    
    [cell.distanceLabel setText:@""];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGGoods *goods = [self.dataArray objectAtIndex:indexPath.row];
    KGGoodsDetailViewController *vc = [KGGoodsDetailViewController viewControllerFromStoryboard];
    vc.itemid = goods.itemid;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
