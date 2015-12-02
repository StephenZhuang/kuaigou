//
//  KGCategoryViewController.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/6/4.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGCategoryViewController : KGBaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , weak) IBOutlet UITableView *parentTableView;
@property (nonatomic , weak) IBOutlet UITableView *childTableView;
@property (nonatomic , strong) NSMutableArray *parentArray;
@property (nonatomic , strong) NSMutableArray *childArray;

@property (nonatomic , copy) void (^categoryBlock)(NSInteger catpid,NSInteger catid,NSString *name);
@end
