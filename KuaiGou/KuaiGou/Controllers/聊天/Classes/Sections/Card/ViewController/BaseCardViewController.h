//
//  BaseCardViewController.h
//  NIM
//
//  Created by chrisRay on 15/3/4.
//  Copyright (c) 2015年 Netease. All rights reserved.
//
#import "CardDataSourceProtocol.h"
#import "TeamCardHeaderCell.h"
@interface BaseCardViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate,TeamCardHeaderCellDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) CardHeaderOpeator currentOpera;

- (void)reloadMembers:(NSArray*)members;

- (void)addMembers:(NSArray*)members;

- (void)removeMembers:(NSArray*)members;

@end

@interface BaseCardViewController (Override)

- (NSString*)title;

- (NSArray*)buildBodyData;

@end


@interface BaseCardViewController (Refresh)

- (void)refreshTitle;
- (void)refreshWithMembers:(NSArray*)members;
- (void)refreshTableHeader;
- (void)refreshTableBody;

@end
