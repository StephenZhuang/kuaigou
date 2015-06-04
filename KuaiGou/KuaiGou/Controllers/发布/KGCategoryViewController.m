//
//  KGCategoryViewController.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/6/4.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "KGCategoryViewController.h"
#import "KGCategory.h"

@implementation KGCategoryViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选择类目";
    
    [self loadParentData];
    self.childTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
}

- (void)loadParentData
{
    [KGCategory getParentCategoryWithCompletion:^(BOOL success, NSString *errorInfo, NSArray *array) {
        [self.parentArray addObjectsFromArray:array];
        [self.parentTableView reloadData];
    }];
}

- (void)loadChildDataWithPid:(NSInteger)pid
{
    [KGCategory getChildCategoryWithPid:pid completion:^(BOOL success, NSString *errorInfo, NSArray *array) {
        [self.childArray removeAllObjects];
        [self.childArray addObjectsFromArray:array];
        [self.childTableView reloadData];
    }];
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.parentTableView) {
        return self.parentArray.count;
    } else {
        return self.childArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGCategory *category = nil;
    UITableViewCell *cell = nil;
    if (tableView == self.parentTableView) {
        category = [self.parentArray objectAtIndex:indexPath.row];
        cell = [tableView dequeueReusableCellWithIdentifier:@"parentCell"];
    } else {
        category = [self.childArray objectAtIndex:indexPath.row];
        cell = [tableView dequeueReusableCellWithIdentifier:@"childCell"];
    }
    [cell.textLabel setText:category.name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.parentTableView) {
        KGCategory *category = [self.parentArray objectAtIndex:indexPath.row];
        [self loadChildDataWithPid:category.catid];
    } else {
        NSIndexPath *parentIndexPath = [self.parentTableView indexPathForSelectedRow];
        KGCategory *parentCategory = [self.parentArray objectAtIndex:parentIndexPath.row];
        KGCategory *childCategory = [self.childArray objectAtIndex:indexPath.row];
        !_categoryBlock?:_categoryBlock(parentCategory.catid,childCategory.catid,[NSString stringWithFormat:@"%@ | %@",parentCategory.name,childCategory.name]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -setters and getters
- (NSMutableArray *)childArray
{
    if (!_childArray) {
        _childArray = [[NSMutableArray alloc] init];
    }
    return _childArray;
}

- (NSMutableArray *)parentArray
{
    if (!_parentArray) {
        _parentArray = [[NSMutableArray alloc] init];
    }
    return _parentArray;
}
@end
