//
//  SessionViewController.m
//  NIMDemo
//
//  Created by ght on 15-1-21.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "SessionViewController.h"
#import "SessionMsgDatasource.h"
#import "SessionCellActionHandler.h"
#import "SessionMsgModel+SessionCellLayoutProtocol.h"
#import "SessionViewCell.h"
#import "SessionTipCell.h"
#import "InputView.h"
#import "InputMoreContainerView.h"
#import "UIView+NIMDemo.h"
#import "UITableView+ScrollToBottom.h"
#import "SessionMsgCellFactory.h"
#import "SessionViewLayoutManager.h"
#import "SessionMsgConverter.h"
#import "NIMSDK.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "UIView+Toast.h"
#import "CustomLeftBarView.h"
#import "BadgeView.h"
#import "GalleryViewController.h"
#import "LocationViewController.h"
#import "LocationPoint.h"
#import "NormalTeamCardViewController.h"
#import "CreateNormalTeamCardViewController.h"
#import "ContactUtil.h"
#import "UserCommandSender.h"
#import "M80TimerHolder.h"
#import "RegularTeamCardViewController.h"
#import "FileLocationHelper.h"
#import "TeamAnnouncementListViewController.h"
#import "FileTransSelectViewController.h"
#import "FilePreViewController.h"
#import "UIActionSheet+Block.h"
#import "SessionLogicImpl.h"
#import "SessionHistoryViewController.h"
#import "SessionUtil.h"
//#import "VideoChatViewController.h"
//#import "AudioChatViewController.h"
#import "Reachability.h"
#define MaxTextInputLenth 1000
@interface SessionViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
NIMChatManagerDelegate,
InputActionDelegate,
AVAudioRecorderDelegate,
NIMConversationManagerDelegate,
CustomLeftBarItemItemProtocol,
LocationViewControllerDelegate,
NIMMediaManagerDelgate,
NIMTeamManagerDelegate,
M80TimerHolderDelegate,
NIMSystemNotificationManagerDelegate>
{
    InputView       *_inputView;
    UIRefreshControl *_refreshControl;
    IBOutlet UIView *_teamTipView;
    IBOutlet UILabel *_teamTipTitleLabel;
    IBOutlet UILabel *_teamTipContentLabel;
    IBOutlet UIView  *_teamIsMineView;
    IBOutlet UILabel *_teamIsMineContentTip;
}
@property (nonatomic, strong) SessionViewLayoutManager *layoutManager;//管理输入框和tableview
@property (nonatomic, strong) SessionLogicImpl *logicImpl;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UserCommandSender *commandSender;
@property (nonatomic, strong) M80TimerHolder *titleTimer;

@end

@implementation SessionViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (instancetype)initWithSession:(NIMSession *)session
{
    if (self = [self initWithNibName:nil bundle:nil]) {
        DDLogDebug(@"session id : %@ " , session.sessionId);
        _session = session;
        if (session.sessionType == NIMSessionTypeTeam) {
            [[NIMSDK sharedSDK].teamManager addDelegate:self];
        }
    }
    return self;
}

- (NSString *)sessionTitle
{
    NSString *title = [SessionUtil showNick:self.session.sessionId inSession:self.session];
    NIMSessionType type = self.session.sessionType;
    if (type == NIMSessionTypeTeam)
    {
        NIMTeam *team = [[[NIMSDK sharedSDK] teamManager] teamById:self.session.sessionId];
        title = [self sessionTitleByTeam:team];
    }
    return title;
}

- (NSString *)sessionTitleByTeam:(NIMTeam *)team
{
    return [NSString stringWithFormat:@"%@(%zd)",[team teamName],[team memberNumber]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initHandlerAndDataSource];
}

- (void)initUI
{
    self.view.backgroundColor = [UIColor colorWithRed:228.0/255.0 green:231.0/255.0 blue:236.0/255.0 alpha:1];
    self.navigationItem.title = [self sessionTitle];
    _chatTableView.delegate = self;
    _chatTableView.dataSource = self;
    _chatTableView.backgroundColor = [UIColor colorWithRed:228.0/255.0 green:231.0/255.0 blue:236.0/255.0 alpha:1];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(headerRereshing:) forControlEvents:UIControlEventValueChanged];
    [_chatTableView addSubview:_refreshControl];
    
    //inputView
    CGRect inputViewRect = CGRectMake(0, CGRectGetHeight(self.view.bounds)-TopInputViewHeight, CGRectGetWidth(self.view.bounds), TopInputViewHeight);
    _inputView = [[InputView alloc] initWithFrame:inputViewRect sessionType:self.session.sessionType];
    _inputView.actionDelegate = self;
    _inputView.maxTextLength = MaxTextInputLenth;
    [self.view addSubview:_inputView];
//    [self setUpNav];
    [self updateTeamAnnouncement];
    
}

- (void)setUpNav{
    UIButton *enterTeamCard = [UIButton buttonWithType:UIButtonTypeCustom];
    [enterTeamCard addTarget:self action:@selector(enterTeamCard:) forControlEvents:UIControlEventTouchUpInside];
    [enterTeamCard setImage:[UIImage imageNamed:@"icon_tinfo_normal"] forState:UIControlStateNormal];
    [enterTeamCard setImage:[UIImage imageNamed:@"icon_tinfo_pressed"] forState:UIControlStateHighlighted];
    [enterTeamCard sizeToFit];
    UIBarButtonItem *enterTeamCardItem = [[UIBarButtonItem alloc] initWithCustomView:enterTeamCard];
    
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoBtn addTarget:self action:@selector(onTouchUpInfoBtn:) forControlEvents:UIControlEventTouchUpInside];
    [infoBtn setImage:[UIImage imageNamed:@"icon_tinfo_normal"] forState:UIControlStateNormal];
    [infoBtn setImage:[UIImage imageNamed:@"icon_tinfo_pressed"] forState:UIControlStateHighlighted];
    [infoBtn sizeToFit];
    UIBarButtonItem *enterUInfoItem = [[UIBarButtonItem alloc] initWithCustomView:infoBtn];
    
    UIButton *enterAnn = [UIButton buttonWithType:UIButtonTypeCustom];
    [enterAnn addTarget:self action:@selector(enterTeamAnn:) forControlEvents:UIControlEventTouchUpInside];
    [enterAnn setImage:[UIImage imageNamed:@"icon_tann_normal"] forState:UIControlStateNormal];
    [enterAnn setImage:[UIImage imageNamed:@"icon_tann_pressed"] forState:UIControlStateHighlighted];
    [enterAnn sizeToFit];
    UIBarButtonItem *enterAnnItem = [[UIBarButtonItem alloc] initWithCustomView:enterAnn];

    UIButton *historyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [historyBtn addTarget:self action:@selector(enterHistory:) forControlEvents:UIControlEventTouchUpInside];
    [historyBtn setImage:[UIImage imageNamed:@"icon_message_normal"] forState:UIControlStateNormal];
    [historyBtn setImage:[UIImage imageNamed:@"icon_message_pressed"] forState:UIControlStateHighlighted];
    [historyBtn sizeToFit];
    UIBarButtonItem *historyButtonItem = [[UIBarButtonItem alloc] initWithCustomView:historyBtn];

    if (self.session.sessionType == NIMSessionTypeTeam) {
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:self.session.sessionId];
        if (team.type == NIMTeamTypeAdvanced) {
            self.navigationItem.rightBarButtonItems = @[enterTeamCardItem,enterAnnItem,historyButtonItem];
        }else{
            self.navigationItem.rightBarButtonItems  = @[enterTeamCardItem,historyButtonItem];
        }
    }else if(self.session.sessionType == NIMSessionTypeP2P){
        self.navigationItem.rightBarButtonItems = @[enterUInfoItem,historyButtonItem];
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NIMSDK sharedSDK].mediaManager stopPlay];
}

- (void)initHandlerAndDataSource
{

    
    _layoutManager = [[SessionViewLayoutManager alloc] initWithInputView:_inputView tableView:_chatTableView];
    
    //数据
    _sessionDataSource = [[SessionMsgDatasource alloc] initWithSession:_session];
    [_chatTableView reloadData];
    [[[NIMSDK sharedSDK] chatManager] addDelegate:self];
    [[[NIMSDK sharedSDK] conversationManager] addDelegate:self];
    [[[NIMSDK sharedSDK] systemNotificationManager] addDelegate:self];
    
    //会话cell
    _sessionCellHandler    = [[SessionCellActionHandler alloc] init];
    self.logicImpl = [[SessionLogicImpl alloc] initWithLayoutManager:_layoutManager dataSource:_sessionDataSource];
    _sessionCellHandler.logicDelegate = self.logicImpl;
    
    
    _commandSender = [[UserCommandSender alloc] init];
    
    if (_session.sessionType == NIMSessionTypeTeam)
    {
        __weak typeof(self) weakSelf = self;
        NSString *teamId = _session.sessionId;
        [[[NIMSDK sharedSDK] teamManager] fetchTeamInfo:teamId
                                             completion:^(NSError *error, NIMTeam *team) {
                                                 if (!error && team)
                                                 {
                                                     NSString *title = [weakSelf sessionTitleByTeam:team];
                                                     weakSelf.navigationItem.title = title;
                                                 }
                                             }];
    }
}

- (void)initImagePicker
{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
}

-(void)viewWillLayoutSubviews
{
    [self changeLeftBarBadge:[[NIMSDK sharedSDK] conversationManager].allUnreadCount];
    [_layoutManager setViewRect:self.view.frame];
    [_chatTableView scrollToBottom:NO];
}

-(void)dealloc
{
    _chatTableView.delegate = nil;
    _chatTableView.dataSource = nil;
    _imagePicker.delegate = nil;
    _inputView.actionDelegate = nil;
    [[[NIMSDK sharedSDK] chatManager] removeDelegate:self];
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
    [[NIMSDK sharedSDK].teamManager removeDelegate:self];
}

#pragma mark - CustomLeftBarItemItemProtocol
- (void)onLeftButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - touches Event
- (void)onTouchUpInfoBtn:(id)sender{
    [_inputView endEditing:YES];
    CreateNormalTeamCardViewController *vc = [[CreateNormalTeamCardViewController alloc] initWithUser:self.session.sessionId];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)enterHistory:(id)sender{
    [_inputView endEditing:YES];
    SessionHistoryViewController *vc = [[SessionHistoryViewController alloc] initWithSession:self.session];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)enterTeamAnn:(id)sender{
    TeamAnnouncementListViewController *vc = [[TeamAnnouncementListViewController alloc] initWithNibName:nil bundle:nil];
    NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:self.session.sessionId];
    vc.team = team;
    vc.canCreateAnnouncement = NO;
    [self.navigationController pushViewController:vc animated:YES];

}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_inputView endEditing:YES];
    [_chatTableView setUserInteractionEnabled:YES];
}

#pragma mark - tableview LoadHistoryMessages
- (void)headerRereshing:(id)sender
{
    NSInteger scrollToIndex = [_sessionDataSource loadHistoryMessages];
    [_layoutManager reloadDataToIndex:scrollToIndex withAnimation:NO];
    [_refreshControl endRefreshing];
}

- (void)enterTeamCard:(id)sender{
    [_inputView endEditing:YES];
    NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:self.session.sessionId];
    UIViewController *vc;
    switch (team.type) {
        case NIMTeamTypeNormal:
            vc = [[NormalTeamCardViewController alloc] initWithTeam:team];
            break;
        case NIMTeamTypeAdvanced:
            vc = [[RegularTeamCardViewController alloc] initWithTeam:team];
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_sessionDataSource msgCount];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [_sessionDataSource msgCount]) {
        id obj = [[_sessionDataSource msgArray] objectAtIndex:indexPath.row];
        UITableViewCell *cell = [SessionMsgCellFactory cellInTable:tableView forModel:obj];
        if ([cell isKindOfClass:[SessionViewCell class]]) {
            SessionViewCell * sessionCell = (SessionViewCell*)cell;
            sessionCell.cellEventHandlerDelegate = _sessionCellHandler;
            sessionCell.needDelete = YES;
        }
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id obj = [[_sessionDataSource msgArray] objectAtIndex:indexPath.row];
    return [obj isKindOfClass:[SessionMsgModel class]] ? [((SessionMsgModel *)obj) cellHeight]: 40;
}


#pragma mark - NIMChatManagerDelegate
//发送消息
- (void)willSendMessage:(NIMMessage *)message
{
    if ([message.session isEqual:_session]) {
        [_layoutManager insertTableViewCellAtRows:[_sessionDataSource addMessages:@[message]]];
        [_layoutManager updateCellUIAtIndex:[_sessionDataSource indexAtMsgArray:message] message:message];
    }
}

//发送结果
- (void)sendMessage:(NIMMessage *)message didCompleteWithError:(NSError *)error
{
    if ([message.session isEqual:_session]) {
        [_layoutManager updateCellUIAtIndex:[_sessionDataSource indexAtMsgArray:message] message:message];
    }
}

//发送进度
-(void)sendMessage:(NIMMessage *)message progress:(CGFloat)progress
{
    if ([message.session isEqual:_session]) {
        [_layoutManager updateCellProgressAtIndex:[_sessionDataSource indexAtMsgArray:message] progress:progress];
    }
}

//接收消息
- (void)onRecvMessages:(NSArray *)messages
{
    NIMSession *session = [[messages firstObject] session];
    if (![session isEqual:self.session]){
        return;
    }
    [_layoutManager insertTableViewCellAtRows:[_sessionDataSource addMessages:messages]];
    [[NIMSDK sharedSDK].conversationManager markAllMessageReadInSession:self.session];
}

- (void)fetchMessageAttachment:(NIMMessage *)message progress:(CGFloat)progress
{
    if ([message.session isEqual:_session]) {
        [_layoutManager updateCellProgressAtIndex:[_sessionDataSource indexAtMsgArray:message] progress:progress];
    }
}

- (void)fetchMessageAttachment:(NIMMessage *)message didCompleteWithError:(NSError *)error
{
    if ([message.session isEqual:_session]) {
        [_layoutManager updateCellUIAtIndex:[_sessionDataSource indexAtMsgArray:message] message:message];
    }
}

- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification
{
    //目前DEMO会话窗口只处理"正在输入"这种自定义通知,而这种通知必然是只发给在线用户,如果不是 直接丢弃
    if (!notification.sendToOnlineUsersOnly) {
        return;
    }
    
    NSString *content = notification.content;
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    if (data)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:nil];
        if ([dict isKindOfClass:[NSDictionary class]])
        {
            if ([[dict objectForKey:NIMCommandID] integerValue] == NIMCommandTyping)
            {
                if (self.session.sessionType == NIMSessionTypeP2P &&
                    notification.receiverType == NIMSessionTypeP2P &&
                    [notification.sender isEqualToString:self.session.sessionId])
                {
                    self.navigationItem.title = @"正在输入...";
                    if (_titleTimer == nil) //5秒后reset
                    {
                        _titleTimer = [[M80TimerHolder alloc] init];
                    }
                    [_titleTimer startTimer:5
                                   delegate:self
                                    repeats:NO];
                }
                
            }
        }
    }

}




#pragma mark - M80TimerDelegate
- (void)onM80TimerFired:(M80TimerHolder *)holder
{
    if (_titleTimer == holder)
    {
        self.navigationItem.title = [self sessionTitle];
    }
}

#pragma mark - NIMConversationManagerDelegate
- (void)didAddRecentSession:(NIMRecentSession *)recentSession
           totalUnreadCount:(NSInteger)totalUnreadCount{
    [self changeUnreadCount:recentSession totalUnreadCount:totalUnreadCount];
}

- (void)didUpdateRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount{
    [self changeUnreadCount:recentSession totalUnreadCount:totalUnreadCount];
}

- (void)didRemoveRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount{
    [self changeUnreadCount:recentSession totalUnreadCount:totalUnreadCount];
}

- (void)changeUnreadCount:(NIMRecentSession *)recentSession
         totalUnreadCount:(NSInteger)totalUnreadCount{
    if ([recentSession.session isEqual:self.session]) {
        return;
    }
    [self changeLeftBarBadge:totalUnreadCount];
}

- (void)changeLeftBarBadge:(NSInteger)unreadCount{
    CustomLeftBarView *leftBarView = (CustomLeftBarView*)self.navigationItem.leftBarButtonItem.customView;
    leftBarView.badgeView.badgeValue = @(unreadCount).stringValue;
    leftBarView.badgeView.hidden = !unreadCount;
}

#pragma mark - InputActionDelegate
- (void)sendTextMessage:(NSString *)text
{
    [self sendMessage:[SessionMsgConverter msgWithText:text]];
}

- (void)onTextChanged:(id)sender
{
    [_commandSender sendTypingState:self.session];
}

- (void)delegatePicturePressed
{
    [self initImagePicker];
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:_imagePicker animated:YES completion:nil];
}


- (void)delegateShootPressed
{
    if ([self initCamera]) {
#if TARGET_IPHONE_SIMULATOR
        //
#elif TARGET_OS_IPHONE
        self.imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        [self.navigationController presentViewController:self.imagePicker animated:YES completion:nil];
#endif
    }
}

- (BOOL)initCamera{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"检测不到相机设备"
                                   delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil] show];
        return NO;
    }
    if (IOS7) {
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            [[[UIAlertView alloc] initWithTitle:nil
                                        message:@"相机权限受限"
                                       delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil] show];
            return NO;
            
        }
    }
    [self initImagePicker];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
    return YES;
}


- (void)delegatePositionPressed
{
    LocationViewController *vc = [[LocationViewController alloc] initWithNibName:nil bundle:nil];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)startRecording {
    [[NIMSDK sharedSDK].mediaManager recordAudioForDuration:60.f withDelegate:self];
}

- (void)stopRecording {
    [[NIMSDK sharedSDK].mediaManager stopRecord];
}

- (void)cancelRecording {
    [[NIMSDK sharedSDK].mediaManager cancelRecord];
}

- (void)delegateCustomChatPressed
{
    [self sendMessage:[SessionMsgConverter msgWithCustom:CustomMessageTypeJanKenPon]];
}


- (void)delegateCustomFileTrans{
    FileTransSelectViewController *vc = [[FileTransSelectViewController alloc]
                                         initWithNibName:nil bundle:nil];
    vc.completionBlock = ^void(id sender,NSString *ext){
        if ([sender isKindOfClass:[NSString class]]) {
            [self sendMessage:[SessionMsgConverter msgWithFilePath:sender]];
        }else if ([sender isKindOfClass:[NSData class]]){
            [self sendMessage:[SessionMsgConverter msgWithFileData:sender extension:ext]];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)delegateCardPressed
{
    [self.view makeToast:@"该版本暂不支持该功能" duration:2.0 position:CSToastPositionCenter];
}

- (void)delegateVideoChatPressed
{
    if (![[Reachability reachabilityForInternetConnection] isReachable]) {
        [self.view makeToast:@"请检查网络" duration:2.0 position:CSToastPositionCenter];
        return;
    }
//    VideoChatViewController *vc = [[VideoChatViewController alloc] initWithCallee:self.session.sessionId];
//    [self presentViewController:vc animated:NO completion:nil];
}

- (void)delegateAudioChatPressed
{
    if (![[Reachability reachabilityForInternetConnection] isReachable]) {
        [self.view makeToast:@"请检查网络" duration:2.0 position:CSToastPositionCenter];
        return;
    }
//    AudioChatViewController *vc = [[AudioChatViewController alloc] initWithCallee:self.session.sessionId];
//    [self presentViewController:vc animated:NO completion:nil];
}

#pragma mark - NIMMediaManagerDelgate

- (void)recordAudio:(NSString *)filePath didBeganWithError:(NSError *)error {
    if(!filePath && error) {
        DDLogWarn(@"%@", error.localizedDescription);
    } else {
        _inputView.recording = YES;
    }
}

- (void)recordAudio:(NSString *)filePath didCompletedWithError:(NSError *)error {
    if(!error) {
        NSURL    *movieURL = [NSURL fileURLWithPath:filePath];
        AVURLAsset *urlAsset = [[AVURLAsset alloc]initWithURL:movieURL options:nil];
        CMTime time = urlAsset.duration;
        CGFloat mediaLength = CMTimeGetSeconds(time);
        if(mediaLength < 2) {
            [self.view makeToast:@"录音时间太短" duration:0.2f position:CSToastPositionCenter];
        } else {
            [self sendMessage:[SessionMsgConverter msgWithAudio:filePath]];
        }
    } else {
        DDLogWarn(@"%@", error.localizedDescription);
    }
    _inputView.recording = NO;
}

- (void)recordAudioDidCancelled {
    DDLogWarn(@"%@", @"Record cancelled");
    _inputView.recording = NO;
}

- (void)recordAudioProgress:(NSTimeInterval)currentTime {
    DDLogWarn(@"record current time: %f", currentTime);
    //[_inputView updateVoicePower:[[NIMSDK sharedSDK].mediaManager recordAveragePower]];
    [_inputView updateAudioRecordTime:currentTime];
}

- (void)recordAudioInterruptionBegin {
    DDLogDebug(@"record interruptted by phone call");
    [[NIMSDK sharedSDK].mediaManager cancelRecord];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        [picker dismissViewControllerAnimated:YES completion:^{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSURL *inputURL  = [info objectForKey:UIImagePickerControllerMediaURL];
                NSString *outputFileName = [FileLocationHelper genFilenameWithExt:VideoExt];
                NSString *outputPath = [FileLocationHelper filepathForVideo:outputFileName];
                AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
                AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset
                                                                                 presetName:AVAssetExportPresetMediumQuality];
                session.outputURL = [NSURL fileURLWithPath:outputPath];
                session.outputFileType = AVFileTypeMPEG4;   // 支持安卓某些机器的视频播放
                session.shouldOptimizeForNetworkUse = YES;
                [session exportAsynchronouslyWithCompletionHandler:^(void)
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         if (session.status == AVAssetExportSessionStatusCompleted) {
                             [self sendMessage:[SessionMsgConverter msgWithVideo:outputPath]];
                         }
                         else {
                             [self.view makeToast:@"发送失败"];
                         }
                     });
                 }];
                
            });
        }];
    }else{
        UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
        [picker dismissViewControllerAnimated:YES completion:^{
            [self sendMessage:[SessionMsgConverter msgWithImage:orgImage]];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}

//位置
#pragma mark - LocationViewControllerDelegate
- (void)onSendLocation:(LocationPoint*)locationPoint{
    [self sendMessage:[SessionMsgConverter msgWithLocation:locationPoint]];
}


#pragma mark - NIMTeamManagerDelegate
- (void)onTeamUpdated:(NIMTeam *)team{
    if ([team.teamId isEqualToString:self.session.sessionId]) {
        self.navigationItem.title = team.teamName;
        [self updateTeamAnnouncement];
    }
}

- (void)onTeamMemberChanged:(NIMTeam *)team{
    if ([team.teamId isEqualToString:self.session.sessionId]) {
        [self.chatTableView reloadData];
        self.navigationItem.title = [self sessionTitle];
    }
}


#pragma mark - private
- (void)sendMessage:(NIMMessage *)message
{
    [[[NIMSDK sharedSDK] chatManager] sendMessage:message toSession:_session error:nil];
}

#pragma mark - 群公告相关

- (void)updateTeamAnnouncement {
    if(self.session.sessionType == NIMSessionTypeTeam) {
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:self.session.sessionId];
        if (![[NIMSDK sharedSDK].teamManager.allMyTeams containsObject:team]) {
            _teamIsMineContentTip.text = @"您已退出该群";
            _teamIsMineView.width = self.view.width;
            [self.view addSubview:_teamIsMineView];
            _teamIsMineView.top = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.height;
            return;
        }
        if(team.announcement.length) {
            NSArray *announcements = [NSJSONSerialization JSONObjectWithData:[team.announcement dataUsingEncoding:NSUTF8StringEncoding] options:0 error:0];
            if(announcements.lastObject) {
                NSString *title = [announcements.lastObject objectForKey:@"title"];
                NSString *content = [announcements.lastObject objectForKey:@"content"];
                _teamTipTitleLabel.text = title;
                _teamTipContentLabel.text = content;
                _teamTipView.width = self.view.width;
                _teamTipView.top = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.height;
                [self.view addSubview:_teamTipView];
            }
        }
    }

}

- (IBAction)onHideTeamAnnouncementBtnClick:(id)sender {
    [_teamTipView removeFromSuperview];
}

@end
