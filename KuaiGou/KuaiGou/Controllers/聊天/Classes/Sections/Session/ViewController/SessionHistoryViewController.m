//
//  SessionHistoryViewController.m
//  NIM
//
//  Created by chrisRay on 15/4/22.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "SessionHistoryViewController.h"
#import "SessionMsgCellFactory.h"
#import "SessionViewCell.h"
#import "SessionCellActionHandler.h"
#import "SessionLogicImpl.h"
#import "SessionViewLayoutManager.h"
#import "RemoteHistoryDataSource.h"
#import "SessionMsgModel+SessionCellLayoutProtocol.h"
#import "UIView+Toast.h"
#import "SVProgressHUD.h"
@interface SessionHistoryViewController ()<NIMChatManagerDelegate>

@property (nonatomic,strong) SessionCellActionHandler *sessionCellHandler;

@property (nonatomic,strong) RemoteHistoryDataSource *sessionDataSource;

@property (nonatomic,strong) NIMSession *session;

@property (nonatomic,strong) UIRefreshControl *refreshControl;

@property (nonatomic,strong) SessionViewLayoutManager *layoutManager;

@property (nonatomic,strong) SessionLogicImpl *impl;

@end

@implementation SessionHistoryViewController

- (instancetype)initWithSession:(NIMSession *)session{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _session = session;
        [[NIMSDK sharedSDK].chatManager addDelegate:self];
    }
    return self;
}

- (void)dealloc{
        [[NIMSDK sharedSDK].chatManager removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"历史消息";
    self.tableView.backgroundColor = [UIColor colorWithRed:228.0/255.0 green:231.0/255.0 blue:236.0/255.0 alpha:1];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onPull2Refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];

    self.layoutManager = [[SessionViewLayoutManager alloc] initWithInputView:nil tableView:self.tableView];
    //数据
    self.sessionDataSource = [[RemoteHistoryDataSource alloc] initWithSession:self.session];

    //会话cell
    _sessionCellHandler    = [[SessionCellActionHandler alloc] init];
    self.impl = [[SessionLogicImpl alloc] initWithLayoutManager:self.layoutManager dataSource:self.sessionDataSource];
    
    self.sessionCellHandler = [[SessionCellActionHandler alloc] init];
    self.sessionCellHandler.logicDelegate = self.impl;
    [SVProgressHUD show];
    __weak typeof(self) wself = self;
    [self remoteFetchDataComplete:^(NSError *error) {
        [wself scrollToBottom];
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NIMSDK sharedSDK].mediaManager stopPlay];
}

- (void)scrollToBottom{
    if (self.sessionDataSource.dataArray.count) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.sessionDataSource.dataArray.count-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}


- (void)remoteFetchDataComplete:(void(^)(NSError *error))complete{
    __weak typeof(self) wself = self;
    [self.sessionDataSource remoteFetchPreMsgs:^(NSError *error, NSArray *messages) {
        [SVProgressHUD dismiss];
        [wself.refreshControl endRefreshing];
        if (!error) {
            [wself.tableView reloadData];
        }else{
            [wself.view makeToast:@"加载失败"];
        }
        if (complete) {
            complete(error);
        }
    }];
}

- (void)onPull2Refresh:(id)sender{
    [self remoteFetchDataComplete:nil];
}


#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sessionDataSource.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id obj = self.sessionDataSource.dataArray[indexPath.row];
    UITableViewCell *cell = [SessionMsgCellFactory cellInTable:tableView forModel:obj];
    if ([cell isKindOfClass:[SessionViewCell class]]) {
        SessionViewCell * sessionCell = (SessionViewCell*)cell;
        sessionCell.cellEventHandlerDelegate = _sessionCellHandler;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id obj = self.sessionDataSource.dataArray[indexPath.row];
    return [obj isKindOfClass:[SessionMsgModel class]] ? [((SessionMsgModel *)obj) cellHeight]: 40;
}


#pragma mark - NIMChatManagerDelegate
- (void)fetchMessageAttachment:(NIMMessage *)message progress:(CGFloat)progress
{
    if ([message.session isEqual:_session]) {
        [self.layoutManager updateCellProgressAtIndex:[self.sessionDataSource indexAtMsgArray:message] progress:progress];
    }
}

- (void)fetchMessageAttachment:(NIMMessage *)message didCompleteWithError:(NSError *)error
{
    if ([message.session isEqual:_session]) {
        [self.layoutManager updateCellUIAtIndex:[self.sessionDataSource indexAtMsgArray:message] message:message];
    }
}

@end
