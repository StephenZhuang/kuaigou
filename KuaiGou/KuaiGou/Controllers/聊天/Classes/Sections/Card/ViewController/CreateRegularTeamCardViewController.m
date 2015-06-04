//
//  CreateRegularTeamCardViewController.m
//  NIM
//
//  Created by chrisRay on 15/3/18.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "CreateRegularTeamCardViewController.h"
#import "ContactUtil.h"
#import "CardMemberItem.h"
#import "TeamCardOperationItem.h"
#import "TeamCardRowItem.h"
#import "UIAlertView+Block.h"
#import "UIActionSheet+Block.h"
#import "UIView+Toast.h"
#import "SessionViewController.h"
#import "CreateTeamAnnouncement.h"
@interface CreateRegularTeamCardViewController ()<CreateTeamAnnouncementDelegate>

@property (nonatomic,copy)   UserCardMemberItem *user;

@property (nonatomic,copy)   NSString *teamName;

@property (nonatomic,copy)   NSString *teamIntro;

@property (nonatomic,copy)   NSString *teamAnnouncement;

@property (nonatomic,copy)   NSString *teamAnnouncementTitle;

@property (nonatomic,copy)   NSString *teamAnnouncementContent;

@property (nonatomic,assign) NIMTeamJoinMode joinMode;

@property (nonatomic,strong) NSMutableArray *groupMembers;

@end

@implementation CreateRegularTeamCardViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSString *currentUserID = [[[NIMSDK sharedSDK] loginManager] currentAccount];
        _groupMembers = [@[currentUserID] mutableCopy];
        _joinMode = NIMTeamJoinModeNeedAuth;
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
    return @"创建高级群";
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
    teamName.subTitle          = self.teamName.length ? self.teamName : @"";
    teamName.action            = @selector(updateTeamInfoName);
    teamName.rowHeight         = 50.f;
    teamName.type              = TeamCardRowItemTypeCommon;
    
    TeamCardRowItem *teamIntro = [[TeamCardRowItem alloc] init];
    teamIntro.title             = @"群介绍";
    teamIntro.subTitle          = self.teamIntro.length ? self.teamIntro : @"";
    teamIntro.action            = @selector(updateTeamIntro);
    teamIntro.rowHeight         = 50.f;
    teamIntro.type              = TeamCardRowItemTypeCommon;
    
    TeamCardRowItem *teamAnnouncement  = [[TeamCardRowItem alloc] init];
    teamAnnouncement.title             = @"群公告";
    teamAnnouncement.subTitle          = self.teamAnnouncement.length ? @"点击查看群公告" : @"";
    teamAnnouncement.action            = @selector(updateTeamAnnouncement);
    teamAnnouncement.rowHeight         = 50.f;
    teamAnnouncement.type              = TeamCardRowItemTypeCommon;
    
    
    TeamCardRowItem *teamAuthMode = [[TeamCardRowItem alloc] init];
    teamAuthMode.title             = @"身份验证";
    teamAuthMode.subTitle          = [self joinModeText:self.joinMode];
    teamAuthMode.action            = @selector(updateAuthMode);
    teamAuthMode.rowHeight         = 50.f;
    teamAuthMode.type              = TeamCardRowItemTypeCommon;


    
    TeamCardRowItem *addTeam = [[TeamCardRowItem alloc] init];
    addTeam.title             = @"创建高级群组";
    addTeam.action            = @selector(addTeamMember);
    addTeam.rowHeight         = 60.f;
    addTeam.type              = TeamCardRowItemTypeBlueButton;
    
    return @[
                @[teamName,teamIntro,teamAnnouncement],
                @[teamAuthMode],
                @[addTeam]
            ];
}

- (NSString*)joinModeText:(NIMTeamJoinMode)mode{
    switch (mode) {
        case NIMTeamJoinModeNoAuth:
            return @"允许任何人";
        case NIMTeamJoinModeNeedAuth:
            return @"需要验证";
        case NIMTeamJoinModeRejectAll:
            return @"拒绝任何人";
        default:
            break;
    }
}


- (void)addHeaderDatas:(NSArray*)members{
    [self addMembers:members];
    
}

- (void)removeHeaderDatas:(NSArray*)datas{
    [self removeMembers:datas];
}


#pragma mark - UITableViewAction
- (void)updateTeamInfoName{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"修改群名称" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    __block typeof(self) wself = self;
    [alert showAlertWithCompletionHandler:^(NSInteger index) {
        switch (index) {
            case 0://取消
                break;
            case 1:{
                NSString *name = [alert textFieldAtIndex:0].text;
                wself.teamName = name;
                [wself refreshTableBody];
                break;
            }
            default:
                break;
        }
    }];
}

- (void)updateTeamIntro{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"修改群介绍" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    __block typeof(self) wself = self;
    [alert showAlertWithCompletionHandler:^(NSInteger index) {
        switch (index) {
            case 0://取消
                break;
            case 1:{
                NSString *intro = [alert textFieldAtIndex:0].text;
                wself.teamIntro = intro;
                [wself refreshTableBody];
                break;
            }
            default:
                break;
        }
    }];
}


- (void)updateTeamAnnouncement{
    CreateTeamAnnouncement *vc = [[CreateTeamAnnouncement alloc] initWithNibName:nil bundle:nil];
    vc.defaultContent = self.teamAnnouncementContent;
    vc.defaultTitle   = self.teamAnnouncementTitle;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)updateAuthMode{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"更改验证方式" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"允许任何人",@"需要验证",@"拒绝任何人", nil];
    __block typeof(self) wself = self;
    [sheet showInView:self.view completionHandler:^(NSInteger index) {
        if (index != sheet.cancelButtonIndex) {
            wself.joinMode = index;
            [wself refreshTableBody];
        }
    }];
}

- (void)addTeamMember{
    if (!self.teamName.length) {
        [self.view makeToast:@"请填写组名"];
        return;
    }
    if (!self.groupMembers) {
        [self.view makeToast:@"组员数据有误"];
        return;
    }
    __weak typeof(self) wself = self;
    NIMCreateTeamOption *option = [[NIMCreateTeamOption alloc] init];
    option.name         = self.teamName;
    option.type         = NIMTeamTypeAdvanced;
    option.joinMode     = self.joinMode;
    option.postscript   = @"邀请你加入群组";
    option.intro        = self.teamIntro;
    option.announcement = self.teamAnnouncement;
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


#pragma mark - CreateTeamAnnouncementDelegate
- (void)createTeamAnnouncementCompleteWithTitle:(NSString *)title content:(NSString *)content
{
    self.teamAnnouncementTitle   = title;
    self.teamAnnouncementContent = content;
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
    self.teamAnnouncement = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self refreshTableBody];
}

@end
