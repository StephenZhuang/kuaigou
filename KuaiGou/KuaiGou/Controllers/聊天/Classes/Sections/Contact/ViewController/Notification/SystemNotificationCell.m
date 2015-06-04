//
//  SystemNotificationCell.m
//  NIM
//
//  Created by amao on 3/17/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "SystemNotificationCell.h"
#import "NIMSystemNotification.h"
#import "ContactUtil.h"

@interface SystemNotificationCell ()
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (nonatomic,strong)    NIMSystemNotification *notification;
@end

@implementation SystemNotificationCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)update:(NIMSystemNotification *)notification{
    self.notification = notification;
    [self updateUI];
}

- (void)updateUI{
    NIMSystemNotificationType type = self.notification.type;
    BOOL hideActionButton = self.notification.handleStatus ? YES : type != NIMSystemNotificationTypeTeamApply && type != NIMSystemNotificationTypeTeamInvite;
    [self.acceptButton setHidden:hideActionButton];
    [self.refuseButton setHidden:hideActionButton];
    if(hideActionButton) {
        self.handleInfoLabel.hidden = NO;
        if(self.notification.handleStatus == NotificationHandleTypeOk) {
            self.handleInfoLabel.text = @"已同意";
        } else if(self.notification.handleStatus == NotificationHandleTypeNo) {
            self.handleInfoLabel.text = @"已拒绝";
        } else {
            self.handleInfoLabel.text = @"已过期";
        }
        
    } else {
        self.handleInfoLabel.hidden = YES;
    }
    NSString *source = [[UsrInfoData sharedInstance] queryUsrInfoById:self.notification.sourceID needRemoteFetch:NO fetchCompleteHandler:nil].nick;
    self.textLabel.text = source;
    NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:self.notification.targetID];
    switch (type) {
        case NIMSystemNotificationTypeTeamApply:
        {
            self.detailTextLabel.text = [NSString stringWithFormat:@"申请加入群 %@", team.teamName];
        }
            break;
        case NIMSystemNotificationTypeTeamApplyReject:
        {
            self.detailTextLabel.text = [NSString stringWithFormat:@"群 %@ 拒绝你加入", team.teamName];
        }
            break;
        case NIMSystemNotificationTypeTeamInvite:
        {
            self.detailTextLabel.text = [NSString stringWithFormat:@"群 %@ 邀请你加入", team.teamName];
        }
            break;
        case NIMSystemNotificationTypeTeamIviteReject:
        {
            self.detailTextLabel.text = [NSString stringWithFormat:@"拒绝了群 %@ 邀请", team.teamName];
        }
            break;
        default:
            break;
    }
    
    self.messageLabel.text = self.notification.postscript;
}

- (IBAction)onAccept:(id)sender {
    if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onAccept:)]){
        [_actionDelegate onAccept:self.notification];
    }
}
- (IBAction)onRefuse:(id)sender {
    if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onRefuse:)]){
        [_actionDelegate onRefuse:self.notification];
    }
}

@end
