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

+ (UITableViewCell*)cellInTable:(UITableView*)tableView forModel:(SessionMsgModel*)model
{
    
    if ([model isKindOfClass:[SessionTimeModel class]]) {
        NSTimeInterval time = ((SessionTimeModel*)model).messageTime;
        return [SessionMsgCellFactory tipCellInTable:tableView forTip:[SessionUtil showTimeInSession:time]];
    }else if ([model isKindOfClass:[SessionMsgModel class]]){
        if (model.msgData.messageType == NIMMessageTypeNotification) {
            return [SessionMsgCellFactory tipCellInTable:tableView forTip:((SessionNoticationMsgModel*)model).notificationFormatedMessage];
        }
        NSString *cellIdentifier = [SessionViewCell cellIdentifierWithMsgType:model.msgData.messageType isFromMe:model.isFromMe];
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

+ (SessionTipCell*)tipCellInTable:(UITableView*)tableView forTip:(NSString*)tip
{
    SessionTipCell *timeCell = (SessionTipCell *)[tableView dequeueReusableCellWithIdentifier:@"MessageCellTime"];
    if (timeCell == nil) {
        timeCell = [[[NSBundle mainBundle]loadNibNamed:@"SessionTipCell" owner:nil options:nil] lastObject];
        timeCell.backgroundColor = [UIColor clearColor];
        timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [timeCell setTimeStr:tip];
    return timeCell;
}

+(NSDictionary*)contentTypeDict
{
    static NSDictionary *typeDict = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        typeDict =  @{@(NIMMessageTypeText):@"SessionTextContentView",
                      @(NIMMessageTypeImage):@"SessionImageContentView",
                      @(NIMMessageTypeAudio):@"SessionAudioContentView",
                      @(NIMMessageTypeLocation):@"SessionLocationContentView",
                      @(NIMMessageTypeVideo):@"SessionVideoContentView",
                      @(NIMMessageTypeCustom):@"SessionCustomContentView"};
        
    });
    return typeDict;
}
@end
