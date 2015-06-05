//
//  SessionMessageCellFactory.h
//  NIMDemo
//
//  Created by ght on 15-1-23.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class SessionMsgModel;
@class SessionViewCell;
@class SessionTipCell;
@interface SessionMsgCellFactory : NSObject

+ (Class)viewClassFromSessionMessageType:(NIMMessageType)messageType;

+ (Class)viewClassFromNotificationType:(NSString *)notifyName;

+ (UITableViewCell*)cellInTable:(UITableView*)tableView forModel:(id)model;

@end
