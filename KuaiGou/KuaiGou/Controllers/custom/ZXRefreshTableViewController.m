//
//  ZXRefreshTableViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/7.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"

NSString *const MJTableViewCellIdentifier = @"cell";

@implementation ZXRefreshTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    page = 1;
    pageCount = 10;
    hasMore = YES;
    if (!self.dataArray) {
        self.dataArray = [[NSMutableArray alloc] init];
    }
    [self addHeader];
    [self addFooter];
    [self setExtrueLineHidden];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorColor:[UIColor colorWithRed:237/255.0 green:235/255.0 blue:229/255.0 alpha:1.0]];
}

- (void)addFooter
{
    [self.tableView addFooterWithCallback:^(void){
        page ++;
        [self loadData];
    }];
}

- (void)addHeader
{
    [self.tableView addHeaderWithCallback:^(void) {
        if (!hasMore) {
            [self.tableView setFooterHidden:NO];
        }
        page = 1;
        hasMore = YES;
        [self loadData];
    }];
    [self.tableView headerBeginRefreshing];
}

- (void)loadData
{
    if (page == 1) {
        [self.dataArray removeAllObjects];
    }
    
    for (int i = 0; i < pageCount; i++) {
        int random = arc4random_uniform(1000000);
        [self.dataArray addObject:[NSString stringWithFormat:@"随机数据---%d", random]];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        if (page == 1) {
            [self.tableView headerEndRefreshing];
        } else {
            [self.tableView footerEndRefreshing];
            if (page == 5) {
                hasMore = NO;
                if (!hasMore) {
                    [self.tableView setFooterHidden:YES];
                }
            }
        }
    });
}

- (void)configureArray:(NSArray *)array
{
    if (page == 1) {
        [self.dataArray removeAllObjects];
    }
    if (array) {
        [self.dataArray addObjectsFromArray:array];
        if (array.count < pageCount) {
            hasMore = NO;
            [self.tableView setFooterHidden:YES];
        }
    } else {
        hasMore = NO;
        [self.tableView setFooterHidden:YES];
    }
    [self.tableView reloadData];
    if (page == 1) {
        [self.tableView headerEndRefreshing];
    } else {
        [self.tableView footerEndRefreshing];
    }
}

- (void)configureArrayWithNoFooter:(NSArray *)array
{
    [self.dataArray removeAllObjects];
    if (array) {
        [self.dataArray addObjectsFromArray:array];
        [self.tableView reloadData];
    }
    [self.tableView headerEndRefreshing];
}

- (void)setExtrueLineHidden
{
    [self.tableView setExtrueLineHidden];
}

#pragma mark - Table view data source
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
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MJTableViewCellIdentifier];
    
    if (indexPath.row < self.dataArray.count) {
        cell.textLabel.text = self.dataArray[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
