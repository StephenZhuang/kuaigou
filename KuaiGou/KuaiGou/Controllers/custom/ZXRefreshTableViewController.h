//
//  ZXRefreshTableViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/7.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "MJRefresh.h"

@interface ZXRefreshTableViewController : KGBaseViewController<UITableViewDelegate ,UITableViewDataSource>
{
@protected
    BOOL hasMore;
    NSInteger pageCount;
    NSInteger page;
}
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *dataArray;
- (void)addHeader;
- (void)addFooter;
- (void)loadData;
- (void)configureArray:(NSArray *)array;
- (void)configureArrayWithNoFooter:(NSArray *)array;
- (void)setExtrueLineHidden;

//重写tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end
