//
//  SessionListViewController.m
//  NIMDemo
//
//  Created by chrisRay on 15/2/2.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "SessionListViewController.h"
#import "SessionViewController.h"
#import "SessionUtil.h"
#import "NIMSDK.h"
#import "NIMSession.h"
#import "NIMRecentSession.h"
#import "SessionListCell.h"
#import "UIView+NIMDemo.h"
#import "SessionListHeader.h"
#import "LogManager.h"

#define SessionListTitle @"网易云信"

extern NSString *NotificationLogout;
@interface SessionListViewController ()<NIMConversationManagerDelegate,UIAlertViewDelegate,UIActionSheetDelegate, NIMSystemNotificationManagerDelegate,NIMLoginManagerDelegate>

@property (nonatomic,strong) NSMutableArray * recentSessions;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,assign) NIMLoginStep lastStep;

@end

@implementation SessionListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)dealloc{
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
    [[NIMSDK sharedSDK].systemNotificationManager removeDelegate:self];
    [[NIMSDK sharedSDK].loginManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    self.tableView.tableFooterView = [[UIView alloc] init];

    NSString *userID = [[[NIMSDK sharedSDK] loginManager] currentAccount];
    self.navigationItem.titleView  = [self titleView:userID];
    
    self.recentSessions = [[NIMSDK sharedSDK].conversationManager.allRecentSession mutableCopy];
    
    if (!self.recentSessions) {
        self.recentSessions = [NSMutableArray array];
    }
    [[NIMSDK sharedSDK].conversationManager addDelegate:self];
    [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                           target:self
                                                                                           action:@selector(showActionSheet:)];
    extern NSString *ContactUpdateDidFinishedNotification;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onContactsDidFinishedUpdate:) name:ContactUpdateDidFinishedNotification object:nil];
}


#pragma mark - NIMLoginManagerDelegate
- (void)onLogin:(NIMLoginStep)step{
    switch (step) {
        case NIMLoginStepLinkFailed:
            self.titleLabel.text = [SessionListTitle stringByAppendingString:@"(未连接)"];
            break;
        case NIMLoginStepLinking:
            self.titleLabel.text = [SessionListTitle stringByAppendingString:@"(连接中)"];
            break;
        case NIMLoginStepLinkOK:
        case NIMLoginStepSyncOK:
            self.titleLabel.text = SessionListTitle;
            break;
        case NIMLoginStepSyncing:
            self.titleLabel.text = [SessionListTitle stringByAppendingString:@"(同步数据)"];
            break;
        default:
            break;
    }
    [self.titleLabel sizeToFit];
    self.titleLabel.centerX   = self.navigationItem.titleView.width * .5f;
    UIView *headerView = [SessionListHeader instanceWithStauts:step];
    [headerView sizeToFit];
    self.tableView.tableHeaderView = headerView;
}

- (void)onContactsDidFinishedUpdate:(NSNotification *)note {
    [_tableView reloadData];
}


- (UIView*)titleView:(NSString*)userID{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.text =  SessionListTitle;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
    [self.titleLabel sizeToFit];
    UILabel *subLabel  = [[UILabel alloc] initWithFrame:CGRectZero];
    subLabel.textColor = [UIColor grayColor];
    subLabel.font = [UIFont systemFontOfSize:12.f];
    subLabel.text = userID;
    [subLabel sizeToFit];
    
    UIView *titleView = [[UIView alloc] init];
    titleView.width  = subLabel.width;
    titleView.height = self.titleLabel.height + subLabel.height;
    
    subLabel.bottom = titleView.height;
    [titleView addSubview:self.titleLabel];
    [titleView addSubview:subLabel];
    
    return titleView;
}


- (void)showActionSheet:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"查看SDKLog",@"查看DemoLog", @"退出", nil];
    [actionSheet showInView:self.view];
}

- (void)showSDKLog
{
    UIViewController *vc = [[LogManager sharedManager] sdkLogViewController];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav
                       animated:YES
                     completion:nil];

}

- (void)showDemoLog {
    UIViewController *logViewController = [[LogManager sharedManager] demoLogViewController];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:logViewController];
    [self presentViewController:nav
                       animated:YES
                     completion:nil];
}

- (void)reload{
    if (!self.recentSessions.count) {
        
        self.tableView.hidden = YES;
    }else{
        [self.tableView reloadData];
    }

}

- (void)logout
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"退出当前账号？" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.delegate = self;
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIAlertViewDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        switch (buttonIndex) {
            case 0:
                [self showSDKLog];
                break;
            case 1:
                [self showDemoLog];
                break;
            case 2:
                [self logout];
                break;
            default:
                break;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [alertView cancelButtonIndex]) {
         [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error)
        {
             [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLogout object:nil];
         }];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NIMRecentSession * recentSession = self.recentSessions[indexPath.row];
    SessionViewController * vc = [[SessionViewController alloc] initWithSession:recentSession.session];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NIMRecentSession * recentSession = self.recentSessions[indexPath.row];
        [[NIMSDK sharedSDK].conversationManager deleteRecentSession:recentSession];
        [self.recentSessions removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [[[NIMSDK sharedSDK] conversationManager] deleteAllmessagesInSession:recentSession.session];
    }
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.recentSessions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"cellId";
    SessionListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SessionListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NIMRecentSession *session = self.recentSessions[indexPath.row];
    [cell refresh:session];
    return cell;
}


#pragma mark - NIMConversationManagerDelegate
- (void)didAddRecentSession:(NIMRecentSession *)recentSession
           totalUnreadCount:(NSInteger)totalUnreadCount{
    NSInteger find = [self findRecentSession:recentSession];
    if (find >=0) {
        [self.recentSessions removeObjectAtIndex:find];
    }
    NSInteger insert = [self findInsertPlace:recentSession];
    [self.recentSessions insertObject:recentSession atIndex:insert];
    [self reload];

}


- (void)didUpdateRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount{
    NSInteger find = [self findRecentSession:recentSession];
    if (find >=0) {
        [self.recentSessions replaceObjectAtIndex:find withObject:recentSession];
        [self reload];
    }

}


- (void)didRemoveRecentSession:(NIMRecentSession *)recentSession totalUnreadCount:(NSInteger)totalUnreadCount{

}




- (NSInteger)findRecentSession:(NIMRecentSession *)recentSession{
    __block NSUInteger matchIdx = -1;
    [self.recentSessions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([recentSession isEqual:obj]) {
            *stop = YES;
            matchIdx = idx;
        }
    }];
    return matchIdx;
}


- (NSInteger)findInsertPlace:(NIMRecentSession *)recentSession{
    __block NSUInteger matchIdx = 0;
    [self.recentSessions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NIMRecentSession *item = obj;
        if (item.lastMessage.timestamp <= recentSession.lastMessage.timestamp) {
            *stop = YES;
            matchIdx = idx;
        }
    }];
    return matchIdx;
}


@end
