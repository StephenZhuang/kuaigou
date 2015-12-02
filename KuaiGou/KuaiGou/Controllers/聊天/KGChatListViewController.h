//
//  KGChatListViewController.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/12.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMSessionListViewController.h"

@interface KGChatListViewController : NIMSessionListViewController<UITableViewDataSource,UITableViewDelegate,NIMLoginManagerDelegate>
@property (nonatomic,strong) UILabel *emptyTipLabel;
@end
