//
//  CreateNormalTeamCardViewController.m
//  NIM
//
//  Created by chrisRay on 15/3/11.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "CreateNormalTeamCardViewController.h"
#import "ContactUtil.h"
#import "CardMemberItem.h"
#import "TeamCardOperationItem.h"
#import "TeamCardRowItem.h"
#import "UIAlertView+Block.h"
#import "UIView+Toast.h"
#import "SessionViewController.h"
@interface CreateNormalTeamCardViewController ()

@property (nonatomic,copy)   UserCardMemberItem *user;

@property (nonatomic,copy)   NSString *groupName;

@property (nonatomic,strong) NSMutableArray *groupMembers;

@end

@implementation CreateNormalTeamCardViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSString *currentUserID = [[[NIMSDK sharedSDK] loginManager] currentAccount];
        _groupMembers = [@[currentUserID] mutableCopy];
    }
    return self;
}


- (instancetype)initWithUser:(NSString*)userId{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        DDLogWarn(@"init with initWithUser id:%@" ,userId);
        ContactDataMember *contactMember = [ContactUtil queryContactByUsrId:userId];
        if(contactMember){
            _user = [[UserCardMemberItem alloc] initWithMember:contactMember];
            [_groupMembers addObject:_user.memberId];
        }else{
            DDLogError(@"user id error!");
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *opearData = [self buildOpearationData];
    NSString *currentUserID = [[[NIMSDK sharedSDK] loginManager] currentAccount];
    ContactDataMember *member = [ContactUtil queryContactByUsrId:currentUserID];
    UserCardMemberItem *me = [[UserCardMemberItem alloc] initWithMember:member];
    NSArray *users;
    if (self.user) {
        users = @[self.user,me];
    }else{
        users = @[me];
    }
    NSArray *members   = [users arrayByAddingObjectsFromArray:opearData];
    [self refreshWithMembers:members];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSString*)title{
    return @"创建会话";
}

#pragma mark - Data

- (NSArray*)buildOpearationData{
    //加号
    TeamCardOperationItem *add = [[TeamCardOperationItem alloc] initWithOperation:CardHeaderOpeatorAdd];
    //减号
    TeamCardOperationItem *remove = [[TeamCardOperationItem alloc] initWithOperation:CardHeaderOpeatorRemove];
    return @[add,remove];
}

- (NSArray*)buildBodyData{
    TeamCardRowItem *teamName = [[TeamCardRowItem alloc] init];
    teamName.title             = @"群名称";
    teamName.subTitle          = self.groupName.length ? self.groupName : @"";
    teamName.action            = @selector(updateGroupInfoName);
    teamName.rowHeight         = 50.f;
    teamName.type              = TeamCardRowItemTypeCommon;
    
    TeamCardRowItem *addTeam = [[TeamCardRowItem alloc] init];
    addTeam.title             = @"创建普通群组";
    addTeam.action            = @selector(addTeamMember);
    addTeam.rowHeight         = 60.f;
    addTeam.type              = TeamCardRowItemTypeBlueButton;
    
    return @[
               @[teamName],
               @[addTeam]
            ];
}


- (void)addHeaderDatas:(NSArray*)members{
    [self addMembers:members];
    
}

- (void)removeHeaderDatas:(NSArray*)datas{
    [self removeMembers:datas];
}


#pragma mark - UITableViewAction
- (void)updateGroupInfoName{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"修改群名称" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    __block typeof(self) wself = self;
    [alert showAlertWithCompletionHandler:^(NSInteger index) {
        switch (index) {
            case 0://取消
                break;
            case 1:{
                NSString *name = [alert textFieldAtIndex:0].text;
                wself.groupName = name;
                [wself refreshTableBody];
                break;
            }
            default:
                break;
        }
    }];
}

- (void)addTeamMember{
    if (!self.groupName.length) {
        [self.view makeToast:@"请填写组名"];
        return;
    }
    if (!self.groupMembers) {
        [self.view makeToast:@"组员数据有误"];
        return;
    }
    __weak typeof(self) wself = self;
    NIMCreateTeamOption *option = [[NIMCreateTeamOption alloc] init];
    option.name = self.groupName;
    option.type = NIMTeamTypeNormal;
    
    [[NIMSDK sharedSDK].teamManager createTeam:option
                                         users:self.groupMembers
                                    completion:^(NSError *error, NSString *teamId) {
        if (!error) {
            UINavigationController *nav = wself.navigationController;
            [nav popToRootViewControllerAnimated:NO];
            NIMSession *session = [NIMSession session:teamId type:NIMSessionTypeTeam];
            SessionViewController *vc = [[SessionViewController alloc] initWithSession:session];
            [nav pushViewController:vc animated:YES];
        }else{
            [wself.view makeToast:@"创建失败"];
        }
    }];
}

#pragma mark - ContactSelectDelegate

- (void)didFinishedSelect:(NSArray *)selectedContacts{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (NSString *uid in selectedContacts) {
        ContactDataMember *contactMember = [ContactUtil queryContactByUsrId:uid];
        UserCardMemberItem *item = [[UserCardMemberItem alloc] initWithMember:contactMember];
        [array addObject:item];
    }
    switch (self.currentOpera) {
        case CardHeaderOpeatorAdd:{
            [self.groupMembers addObjectsFromArray:selectedContacts];
            [self addHeaderDatas:array];
            break;
        }
        case CardHeaderOpeatorRemove:{
            [self.groupMembers removeObjectsInArray:selectedContacts];
            [self removeHeaderDatas:array];
            break;
        }
        default:
            break;
    }
}

- (void)didCancelledSelect{
    self.currentOpera = CardHeaderOpeatorNone;
}

@end
