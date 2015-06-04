//
//  SystemNotificationViewController.m
//  NIM
//
//  Created by amao on 3/17/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "SystemNotificationViewController.h"
#import "NIMSDK.h"
#import "SystemNotificationCell.h"
#import "UIView+Toast.h"

static const NSInteger MaxNotificationCount = 20;
static NSString *reuseIdentifier = @"reuseIdentifier";

@interface SystemNotificationViewController ()<NIMSystemNotificationManagerDelegate,NIMSystemNotificationCellDelegate>
@property (nonatomic,strong)    NSMutableArray  *notifications;
@property (nonatomic,assign)    BOOL shouldMarkAsRead;
@end

@implementation SystemNotificationViewController

- (void)dealloc
{
    if (_shouldMarkAsRead)
    {
        [[[NIMSDK sharedSDK] systemNotificationManager] markAllNotificationAsRead];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:@"SystemNotificationCell" bundle:nil]
           forCellReuseIdentifier:reuseIdentifier];
    
    _notifications = [NSMutableArray array];
    
    id<NIMSystemNotificationManager> manager = [[NIMSDK sharedSDK] systemNotificationManager];
    [manager addDelegate:self];
    
    NSArray *notifications = [manager fetchSystemNotifications:nil
                                                         limit:MaxNotificationCount];
    
    if ([notifications count])
    {
        [_notifications addObjectsFromArray:notifications];
        if (![[notifications firstObject] read])
        {
            _shouldMarkAsRead = YES;
            
        }
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setFrame:CGRectMake(0, 0, 320, 40)];
    [button addTarget:self
               action:@selector(loadMore:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"载入更多" forState:UIControlStateNormal];
    self.tableView.tableFooterView = button;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(clearAll:)];
}

- (void)loadMore:(id)sender
{
    NSArray *notifications = [[[NIMSDK sharedSDK] systemNotificationManager] fetchSystemNotifications:[_notifications lastObject]
                                                                                                limit:MaxNotificationCount];
    if ([notifications count])
    {
        [_notifications addObjectsFromArray:notifications];
        [self.tableView reloadData];
    }
}

- (void)clearAll:(id)sender
{
    [[[NIMSDK sharedSDK] systemNotificationManager] deleteAllNotifications];
    [_notifications removeAllObjects];
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onReceiveSystemNotification:(NIMSystemNotification *)notification
{
    [_notifications insertObject:notification atIndex:0];
    _shouldMarkAsRead = YES;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_notifications count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SystemNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    NIMSystemNotification *notification = [_notifications objectAtIndex:[indexPath row]];
    [cell update:notification];
    cell.actionDelegate = self;
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger index = [indexPath row];
        NIMSystemNotification *notification = [_notifications objectAtIndex:index];
        [_notifications removeObjectAtIndex:index];
        [[[NIMSDK sharedSDK] systemNotificationManager] deleteNotification:notification];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - SystemNotificationCell
- (void)onAccept:(NIMSystemNotification *)notification
{
    __weak typeof(self) wself = self;
    switch (notification.type) {
        case NIMSystemNotificationTypeTeamApply:{
            [[NIMSDK sharedSDK].teamManager passApplyToTeam:notification.targetID userId:notification.sourceID completion:^(NSError *error, NIMTeamApplyStatus applyStatus) {
                if (!error) {
                    [wself.view makeToast:@"同意成功"];
                    notification.handleStatus = NotificationHandleTypeOk;
                    [wself.tableView reloadData];
                }else {
                    if(error.code == NIMRemoteErrorCodeTimeoutError) {
                        [wself.view makeToast:@"网络问题，请重试"];
                    } else {
                        notification.handleStatus = NotificationHandleTypeOutOfDate;
                    }
                    [wself.tableView reloadData];
                    DDLogDebug(error.localizedDescription);
                }
            }];
            break;
        }
        case NIMSystemNotificationTypeTeamInvite:{
            [[NIMSDK sharedSDK].teamManager acceptInviteWithTeam:notification.targetID invitorId:notification.sourceID completion:^(NSError *error) {
                if (!error) {
                    [wself.view makeToast:@"接受成功"];
                    notification.handleStatus = NotificationHandleTypeOk;
                    [wself.tableView reloadData];
                }else {
                    if(error.code == NIMRemoteErrorCodeTimeoutError) {
                        [wself.view makeToast:@"网络问题，请重试"];
                    } else {
                        notification.handleStatus = NotificationHandleTypeOutOfDate;
                    }
                    [wself.tableView reloadData];
                    DDLogDebug(error.localizedDescription);
                }
            }];
        }
            break;
        default:
            break;
    }
}

- (void)onRefuse:(NIMSystemNotification *)notification
{
    __weak typeof(self) wself = self;
    switch (notification.type) {
        case NIMSystemNotificationTypeTeamApply:{
            [[NIMSDK sharedSDK].teamManager rejectApplyToTeam:notification.targetID userId:notification.sourceID rejectReason:@"" completion:^(NSError *error) {
                if (!error) {
                    [wself.view makeToast:@"拒绝成功"];
                    notification.handleStatus = NotificationHandleTypeNo;
                    [wself.tableView reloadData];
                }else {
                    [wself.view makeToast:@"拒绝失败"];
                }
            }];
        }
           break;

        case NIMSystemNotificationTypeTeamInvite:{
            [[NIMSDK sharedSDK].teamManager rejectInviteWithTeam:notification.targetID invitorId:notification.sourceID rejectReason:@"" completion:^(NSError *error) {
                if (!error) {
                    [wself.view makeToast:@"拒绝成功"];
                    notification.handleStatus = NotificationHandleTypeNo;
                    [wself.tableView reloadData];
                }else {
                    [wself.view makeToast:@"拒绝失败"];
                }
            }];

        }
            break;
        default:
            break;
    }
}
@end
