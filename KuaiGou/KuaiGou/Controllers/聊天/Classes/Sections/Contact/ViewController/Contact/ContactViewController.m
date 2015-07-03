//
//  ContactViewController.m
//  NIMDemo
//
//  Created by chrisRay on 15/2/2.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "ContactViewController.h"
#import "NIMSDK.h"
#import "SessionUtil.h"
#import "SessionViewController.h"
#import "ContactDataItem.h"
#import "ContactUtilItem.h"
#import "ContactDefines.h"
#import "GroupedContacts.h"
#import "ContactsData.h"
#import "UIView+Toast.h"
@interface ContactViewController () <GroupedContactsDelegate,NIMSystemNotificationManagerDelegate> {
    UIRefreshControl *_refreshControl;
    GroupedContacts *_contacts;
}

@property (nonatomic,strong) NSArray * datas;

@end

@implementation ContactViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(onPull2Refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:_refreshControl];
    [self prepareData];
    [[[NIMSDK sharedSDK] systemNotificationManager] addDelegate:self];
    
}

- (void)onPull2Refresh:(id)sender {
    [_contacts update];
}

- (void)prepareData{
    _contacts = [[GroupedContacts alloc] init];
    _contacts.delegate = self;
    _contacts.dataSource = [ContactsData sharedInstance];

    NSString *contactCellUtilIcon   = @"icon";
    NSString *contactCellUtilVC     = @"vc";
    NSString *contactCellUtilTitle  = @"title";
//原始数据
    
    NSInteger count = [[[NIMSDK sharedSDK] systemNotificationManager] allUnreadCount];
    NSString *systemText = [NSString stringWithFormat:@"系统通知 (%zd)",count];
    NSArray *utils =
    
          @[
              @{contactCellUtilIcon:@"icon_password",contactCellUtilTitle:@"我的高级群",
                contactCellUtilVC:@"AdvancedTeamListViewController"},
              @{contactCellUtilIcon:@"icon_password",contactCellUtilTitle:@"我的普通群",
                contactCellUtilVC:@"NormalTeamListViewController"},
              @{contactCellUtilIcon:@"icon_password",contactCellUtilTitle:@"创建普通群组",contactCellUtilVC:@"CreateNormalTeamCardViewController"},
              @{contactCellUtilIcon:@"icon_password",contactCellUtilTitle:@"创建高级群组",contactCellUtilVC:@"CreateRegularTeamCardViewController"},
              @{contactCellUtilIcon:@"icon_password",contactCellUtilTitle:@"搜索加入群组",contactCellUtilVC:@"SearchTeamViewController"},
              @{contactCellUtilIcon:@"icon_password",contactCellUtilTitle:systemText,
                contactCellUtilVC:@"SystemNotificationViewController"},
              ];

    self.navigationItem.title  =  _contacts.dataSource.contacts.count ? @"通讯录" :@"请下拉获取好友数据";

    if (_contacts.dataSource.contacts.count) {
        //构造显示的数据模型
        ContactUtilItem *contactUtil = [[ContactUtilItem alloc] init];
        NSMutableArray * members = [[NSMutableArray alloc] init];
        for (NSDictionary *item in utils) {
            ContactUtilMember *utilItem = [[ContactUtilMember alloc] init];
            utilItem.nick              = item[contactCellUtilTitle];
            utilItem.iconUrl           = item[contactCellUtilIcon];
            utilItem.vcName             = item[contactCellUtilVC];
            [members addObject:utilItem];
        }
        contactUtil.members = members;
        
        [_contacts addGroupAboveWithTitle:@"" members:contactUtil.members];
    }
}

#pragma mark - GroupedContactsDelegate

- (void)didFinishedContactsUpdate {
    [_refreshControl endRefreshing];
    [self prepareData];
    [_tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id<ContactItem> contactItem = (id<ContactItem>)[_contacts memberOfIndex:indexPath];
    if (contactItem.vcName.length) {
        Class clazz = NSClassFromString(contactItem.vcName);
        UIViewController * vc = [[clazz alloc] initWithNibName:nil bundle:nil];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([contactItem respondsToSelector:@selector(usrId)]){
        NSString * friendId   = contactItem.usrId;
        
        NSString *myId = [[[NIMSDK sharedSDK] loginManager] currentAccount];
        if (friendId && myId && [friendId isEqualToString:myId])
        {
            [self.view makeToast:@"不能和自己对话喔"
                        duration:2.0
                        position:CSToastPositionCenter];
            return;
        }
        
        NIMSession * session  = [NIMSession session:friendId type:NIMSessionTypeP2P];
        SessionViewController * vc = [[SessionViewController alloc] initWithSession:session];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id<ContactItem> contactItem = (id<ContactItem>)[_contacts memberOfIndex:indexPath];
    return contactItem.uiHeight;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_contacts memberCountOfGroup:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_contacts groupCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id<ContactItem> contactItem = (id<ContactItem>)[_contacts memberOfIndex:indexPath];
    NSString * cellId = contactItem.reuseId;
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        Class cellClazz = NSClassFromString(contactItem.cellName);
        cell = [[cellClazz alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    id<ContactCell> myCell = (id<ContactCell>)cell;
    [myCell refreshWithContactItem:contactItem];
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_contacts titleOfGroup:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _contacts.sortedGroupTitles;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index + 1;
}

#pragma mark - misc
- (void)onSystemNotificationCountChanged:(NSInteger)unreadCount
{
    [self prepareData];
    [self.tableView reloadData];
}

@end
