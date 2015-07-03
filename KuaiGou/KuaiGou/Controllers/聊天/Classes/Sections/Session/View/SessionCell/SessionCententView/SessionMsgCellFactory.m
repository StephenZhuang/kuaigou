//
//  SessionMessageCellFactory.m
//  NIMDemo
//
//  Created by ght on 15-1-23.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "SessionMsgCellFactory.h"
#import "SessionImageContentView.h"
#import "SessionMsgModel.h"
#import "NIMSDK.h"
#import "SessionTextContentView.h"
#import "SessionViewCell.h"
#import "SessionTipCell.h"
#import "SessionUtil.h"
#import "NIMNotificationObject.h"

@implementation SessionMsgCellFactory

+ (Class)viewClassFromSessionMessageType:(NIMMessageType)messageType
{
    Class cls = nil;
    NSString *contentType = [[self contentTypeDict] objectForKey:@(messageType)];
    if (contentType) {
        cls = NSClassFromString(contentType);
    }else{
        cls = NSClassFromString(@"SessionUnknowContentView");
    }
    return cls;
}

+ (Class)viewClassFromNotificationType:(NSString *)notifyName
{
    Class cls = nil;
    NSString *contentType = notifyName.length? [[self notifyNameDict] objectForKey:notifyName] : nil;
    if (contentType.length) {
        cls = NSClassFromString(contentType);
    }else{
        cls = NSClassFromString(@"SessionUnknowContentView");
    }
    return cls;
}

+ (UITableViewCell*)cellInTable:(UITableView*)tableView forModel:(id)cellModel
{
    
    if ([cellModel isKindOfClass:[SessionTimeModel class]]) {
        NSTimeInterval time = ((SessionTimeModel*)cellModel).messageTime;
        return [SessionMsgCellFactory tipCellInTable:tableView forTip:[SessionUtil showTime:time showDetail:YES]];
    }else if ([cellModel isKindOfClass:[SessionMsgModel class]]){
        SessionMsgModel *model = (SessionMsgModel *)cellModel;
        if (model.msgData.messageType == NIMMessageTypeNotification) {
            return [SessionMsgCellFactory notificationCellInTableView:tableView model:model];
        }
        NSString *cellIdentifier = [SessionViewCell cellIdentifierWithMsgType:model];
        SessionViewCell *cell = (SessionViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[SessionViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell reloadData:model];
        return cell;
    }
    return nil;
}

+(NSDictionary*)contentTypeDict
{
    static NSDictionary *typeDict = nil;
    static dispatch_once_t onceTypeToken;
    dispatch_once(&onceTypeToken, ^{
        typeDict =  @{@(NIMMessageTypeText):@"SessionTextContentView",
                      @(NIMMessageTypeImage):@"SessionImageContentView",
                      @(NIMMessageTypeAudio):@"SessionAudioContentView",
                      @(NIMMessageTypeLocation):@"SessionLocationContentView",
                      @(NIMMessageTypeVideo):@"SessionVideoContentView",
                      @(NIMMessageTypeFile):@"SessionFileTransContentView",
                      @(NIMMessageTypeCustom):@"SessionCustomContentView"};
    });
    return typeDict;
}

+(NSDictionary*)notifyNameDict
{
    static NSDictionary *notiDict = nil;
    static dispatch_once_t onceNotiToken;
    dispatch_once(&onceNotiToken, ^{
        notiDict =  @{
                      @"NIMNetCallNotificationContent":@"SessionNetChatNotifyContentView",
                    };
    });
    return notiDict;
}


#pragma mark - 单独处理通知类型的cell
+ (UITableViewCell *)notificationCellInTableView:(UITableView *)tableView model:(SessionMsgModel *)model{
    NIMNotificationObject *object = model.msgData.messageObject;
    if (object.notificationType == NIMNotificationTypeTeam) {
        return [SessionMsgCellFactory tipCellInTable:tableView forTip:((SessionNoticationMsgModel*)model).notificationFormatedMessage];
    }
    if (object.notificationType == NIMNotificationTypeNetCall) {
        NSString *cellIdentifier = [SessionViewCell cellIdentifierWithMsgType:model];
        SessionViewCell *cell = (SessionViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[SessionViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell reloadData:model];
        return cell;
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
}

+ (SessionTipCell*)tipCellInTable:(UITableView*)tableView forTip:(NSString*)tip
{
    SessionTipCell *timeCell = (SessionTipCell *)[tableView dequeueReusableCellWithIdentifier:@"NotifyCell"];
    if (timeCell == nil) {
        timeCell = [[[NSBundle mainBundle]loadNibNamed:@"SessionTipCell" owner:nil options:nil] lastObject];
        timeCell.backgroundColor = [UIColor clearColor];
        timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [timeCell setTimeStr:tip];
    return timeCell;
}
@end
