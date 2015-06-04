//
//  TeamAnnouncementListViewController.m
//  NIM
//
//  Created by Xuhui on 15/3/31.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "TeamAnnouncementListViewController.h"
#import "UsrInfoData.h"
#import "CreateTeamAnnouncement.h"
#import "TeamAnnouncementListCell.h"
#import "UIView+toast.h"
#import "SVProgressHUD.h"

typedef NS_ENUM(NSInteger, TeamAnnouncementSectionType) {
    TeamAnnouncementSectionTitle = 1,
    TeamAnnouncementSectionInfo = 2,
    TeamAnnouncementSectionLine = 3,
    TeamAnnouncementSectionContent = 4
};

@interface TeamAnnouncementListViewController () <UITableViewDelegate, UITableViewDataSource, CreateTeamAnnouncementDelegate> {
    NSMutableArray *_announcements;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TeamAnnouncementListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(_canCreateAnnouncement) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新建" style:UIBarButtonItemStylePlain target:self action:@selector(onCreateAnnouncement:)];
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navigationItem.title = @"群公告";
    [self.tableView registerNib:[UINib nibWithNibName:@"TeamAnnouncementListCell" bundle:nil] forCellReuseIdentifier:@"TeamAnnouncementListCell"];
    self.tableView.rowHeight = 267;
    [self.tableView setTableFooterView:[UIView new]];
    NSArray *data = [NSJSONSerialization JSONObjectWithData:[self.team.announcement dataUsingEncoding:NSUTF8StringEncoding] options:0 error:0];
    _announcements = [NSMutableArray arrayWithArray:data];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onCreateAnnouncement:(id)sender {
    CreateTeamAnnouncement *vc = [[CreateTeamAnnouncement alloc] initWithNibName:nil bundle:nil];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate


/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 267;
}
 */


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _announcements.lastObject ? 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *announcement = _announcements.lastObject;
    TeamAnnouncementListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamAnnouncementListCell"];
    [cell refreshData:announcement];
    cell.userInteractionEnabled = NO;
    return cell;
}

#pragma mark - CreateTeamAnnouncementDelegate

- (void)createTeamAnnouncementCompleteWithTitle:(NSString *)title content:(NSString *)content {
    NSDictionary *announcement = @{@"title": title,
                                   @"content": content,
                                   @"creator": [[NIMSDK sharedSDK].loginManager currentAccount],
                                   @"time": @((NSInteger)[NSDate date].timeIntervalSince1970)};
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:@[announcement] options:0 error:&error];
    if(error) {
        DDLogError(error.localizedDescription);
        return;
    }
    self.team.announcement = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    __weak typeof(self) wself = self;
    [SVProgressHUD show];
    [[NIMSDK sharedSDK].teamManager updateTeamAnnouncement:[self.team.announcement copy] teamId:self.team.teamId completion:^(NSError *error) {
        [SVProgressHUD dismiss];
        if(!error) {
            [wself.view makeToast:@"创建成功"];
            DDLogDebug(@"%@", @"create announcement sucess!");
            NSArray *data = [NSJSONSerialization JSONObjectWithData:[self.team.announcement dataUsingEncoding:NSUTF8StringEncoding] options:0 error:0];
            _announcements = [NSMutableArray arrayWithArray:data];
            [self.tableView reloadData];
        } else {
            [wself.view makeToast:@"创建失败"];
            DDLogDebug(@"create announcement failed: %@", error.localizedDescription);
        }
    }];

}

@end
