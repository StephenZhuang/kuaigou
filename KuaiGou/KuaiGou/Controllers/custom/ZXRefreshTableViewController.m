//
//  ZXRefreshTableViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/7.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"
#import "UITableView+ZXTableViewLine.h"

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
}

- (void)addFooter
{
    __weak __typeof(&*self)weakSelf = self;
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        page ++;
        [weakSelf loadData];
    }];
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
    [self.tableView.header beginRefreshing];
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
            [self.tableView.header endRefreshing];
        } else {
            [self.tableView.footer endRefreshing];
            if (page == 5) {
                hasMore = NO;
                if (!hasMore) {
                    [self.tableView.footer noticeNoMoreData];
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
            [self.tableView.footer noticeNoMoreData];
        }
    } else {
        hasMore = NO;
        [self.tableView.footer noticeNoMoreData];
    }
    [self.tableView reloadData];
    if (page == 1) {
        [self.tableView.header endRefreshing];
    } else {
        [self.tableView.footer endRefreshing];
    }
}

- (void)configureArrayWithNoFooter:(NSArray *)array
{
    [self.dataArray removeAllObjects];
    if (array) {
        [self.dataArray addObjectsFromArray:array];
        [self.tableView reloadData];
    }
    [self.tableView.header endRefreshing];
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
