//
//  SessionViewController.h
//  NIMDemo
//
//  Created by ght on 15-1-21.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputView.h"

@class SessionCellActionHandler;
@class SessionInputActionHandler;
@class SessionMsgDatasource;
@class NIMSession;
@interface SessionViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *chatTableView;

@property (nonatomic, strong) NIMSession   *session;
@property (nonatomic, strong) SessionMsgDatasource *sessionDataSource;
@property (nonatomic, strong) SessionCellActionHandler *sessionCellHandler;

- (instancetype)initWithSession:(NIMSession*)session;
@end
