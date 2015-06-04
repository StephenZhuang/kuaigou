//
//  BaseCardViewController.m
//  NIM
//
//  Created by chrisRay on 15/3/4.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "BaseCardViewController.h"
#import "UIView+NIMDemo.h"
#import "CardMemberItem.h"
#import "TeamCardOperationItem.h"
#import "ContactSelectViewController.h"
#import "ContactDemoDefine.h"
#import "ContactDataItem.h"
#import "TeamCardRowItem.h"
#import "GlobalMacro.h"
#import "TeamButtonCell.h"
#import "ContactUtil.h"
#import "GroupedUsrInfo.h"

#define CollectionItemWidth  55 * UIScreenWidth / 320
#define CollectionItemHeight 80 * UIScreenWidth / 320
#define CollectionItemNumber 4
#define CollectionEdgeInsetLeftRight (UIScreenWidth - CollectionItemWidth * CollectionItemNumber) / (CollectionItemNumber + 1)
#define CollectionEdgeInsetTopFirstLine 25
#define CollectionEdgeInsetTop 15
#define CollectionCellReuseId   @"collectionCell"
#define TableCellReuseId        @"tableCell"
#define TableButtonCellReuseId  @"tableButtonCell"

@interface BaseCardViewController ()<ContactSelectDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *headerData; //表头collectionView数据

@property (nonatomic,strong) NSArray *bodyData;   //表身数据

@end

@implementation BaseCardViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _headerData = [[NSMutableArray alloc] init];
        _bodyData   = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshTitle];
    self.tableView = [[UITableView alloc] initWithFrame:self.navigationController.view.bounds style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(0xecf1f5);
    [self.view addSubview:self.tableView];
}

#pragma mark - Data
- (NSArray*)buildBodyData{
//override
    return nil;
}

- (id<CardBodyData>)bodyDataAtIndexPath:(NSIndexPath*)indexpath{
    NSArray *sectionData = self.bodyData[indexpath.section];
    return sectionData[indexpath.row];
}

- (void)reloadMembers:(NSArray*)members{
    self.headerData = [members mutableCopy];
    [self refreshWithMembers:self.headerData];
}

- (void)addMembers:(NSArray*)members{
    NSInteger opeatorCount = 0;
    for (id<CardHeaderData> data in self.headerData.reverseObjectEnumerator.allObjects) {
        if ([data respondsToSelector:@selector(opera)]) {
            opeatorCount++;
        }else{
            break;
        }
    }
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.headerData.count - opeatorCount, members.count)];
    [self.headerData insertObjects:members atIndexes:indexSet];
    [self refreshWithMembers:self.headerData];
}

- (void)removeMembers:(NSArray*)members{
    for (id object in members) {
        if ([object isKindOfClass:[NSString class]]) {
            for (id<CardHeaderData> data in self.headerData) {
                if ([data respondsToSelector:@selector(memberId)] && [data.memberId isEqualToString:object]) {
                    [self.headerData removeObject:data];
                    break;
                }
            }
        }else{
            [self.headerData removeObject:object];
        }
    }
    [self refreshWithMembers:self.headerData];
}

- (NSArray*)headerUserIds{
    NSMutableArray * uids = [[NSMutableArray alloc] init];
    for (id<CardHeaderData> data in self.headerData) {
        if ([data respondsToSelector:@selector(memberId)]) {
            [uids addObject:data.memberId];
        }
    }
    return uids;
}


- (id<CardHeaderData>)headerDataAtIndexPath:(NSIndexPath*)indexpath{
    NSInteger index = indexpath.section * CollectionItemNumber;
    index += indexpath.row;
    return self.headerData[index];
}

#pragma mark - Refresh
- (void)refreshWithMembers:(NSArray*)members{
    self.headerData = [members mutableCopy];
    [self setUpTableView];
    [self refreshTableBody];
}

- (void)refreshTableHeader{
    [self setupTableHeader];
    [self.collectionView reloadData];
}

- (void)refreshTableBody{
    self.bodyData = [self buildBodyData];
    [self.tableView reloadData];
}

- (void)refreshTitle{
    self.navigationItem.title = self.title;
}

#pragma mark - View
- (NSString*)title{
    return @"";
}

- (void)setUpTableView{
    [self setupTableHeader];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
}

- (void)setupTableHeader{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:[self caculateHeaderFrame] collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:241.0/255.0 blue:245.0/255.0 alpha:1];
    self.collectionView.delegate   = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[TeamCardHeaderCell class] forCellWithReuseIdentifier:CollectionCellReuseId];
    self.tableView.tableHeaderView = self.collectionView;
}

- (CGRect)caculateHeaderFrame{
    NSInteger sectionNumber = [self numberOfSectionsInCollectionView:self.collectionView];
    CGFloat height = CollectionItemHeight * sectionNumber + CollectionEdgeInsetTop * (sectionNumber-1) + CollectionEdgeInsetTopFirstLine * 2;
    return CGRectMake(0,0,self.view.width, height);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.bodyData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *sectionData = self.bodyData[section];
    return sectionData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id<CardBodyData> bodyData = [self bodyDataAtIndexPath:indexPath];
    return bodyData.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.0f;
    }
    return 20.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = UIColorFromRGB(0xecf1f5);
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id<CardBodyData> bodyData = [self bodyDataAtIndexPath:indexPath];
    UITableViewCell * cell;
    TeamCardRowItemType type = bodyData.type;
    switch (type) {
        case TeamCardRowItemTypeCommon:
            cell = [self builidCommonCell:bodyData];
            break;
        case TeamCardRowItemTypeRedButton:
            cell = [self builidRedButtonCell:bodyData];
            break;
        case TeamCardRowItemTypeBlueButton:
            cell = [self builidBlueButtonCell:bodyData];
            break;
        default:
            break;
    }
    return cell;
}

- (UITableViewCell*)builidCommonCell:(id<CardBodyData>) bodyData{
    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:TableCellReuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TableCellReuseId];
        CGFloat left = 15.f;
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(left, cell.height, cell.width, 1.f)];
        sep.backgroundColor = UIColorFromRGB(0xebebeb);
        [cell addSubview:sep];
        sep.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
    cell.textLabel.text = bodyData.title;
    if ([bodyData respondsToSelector:@selector(subTitle)]) {
        cell.detailTextLabel.text = bodyData.subTitle;
    }
    
    if ([bodyData respondsToSelector:@selector(actionDisabled)] && bodyData.actionDisabled) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;

}

- (UITableViewCell*)builidRedButtonCell:(id<CardBodyData>) bodyData{
    TeamButtonCell * cell = [self.tableView dequeueReusableCellWithIdentifier:TableButtonCellReuseId];
    if (!cell) {
        cell = [[TeamButtonCell alloc] initWithTeamButtonStyle:TeamButtonCellStyleRed reuseIdentifier:TableButtonCellReuseId];
        cell.backgroundColor = UIColorFromRGB(0xecf1f5);
    }
    NSString * title = bodyData.title;
    [cell.button setTitle:title forState:UIControlStateNormal];
    return cell;
}


- (UITableViewCell*)builidBlueButtonCell:(id<CardBodyData>) bodyData{
    TeamButtonCell * cell = [self.tableView dequeueReusableCellWithIdentifier:TableButtonCellReuseId];
    if (!cell) {
        cell = [[TeamButtonCell alloc] initWithTeamButtonStyle:TeamButtonCellStyleBlue reuseIdentifier:TableButtonCellReuseId];
        cell.backgroundColor = UIColorFromRGB(0xecf1f5);
    }
    NSString * title = bodyData.title;
    [cell.button setTitle:title forState:UIControlStateNormal];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *scections = self.bodyData[indexPath.section];
    id<CardBodyData> bodyData = scections[indexPath.row];
    if ([bodyData respondsToSelector:@selector(actionDisabled)] && bodyData.actionDisabled) {
        return;
    }
    if ([bodyData respondsToSelector:@selector(action)]) {
        if (bodyData.action) {
            SuppressPerformSelectorLeakWarning([self performSelector:bodyData.action]);
        }
    }
}



#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger lastTotal = CollectionItemNumber * section;
    NSInteger remain    = self.headerData.count - lastTotal;
    return remain < CollectionItemNumber ? remain:CollectionItemNumber;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    NSInteger sections = self.headerData.count / CollectionItemNumber;
    return self.headerData.count % CollectionItemNumber ? sections + 1 : sections;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TeamCardHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionCellReuseId forIndexPath:indexPath];
    cell.delegate = self;
    id<CardHeaderData> data = [self headerDataAtIndexPath:indexPath];
    [cell refreshData:data];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(CollectionItemWidth, CollectionItemHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return UIEdgeInsetsMake(CollectionEdgeInsetTopFirstLine, CollectionEdgeInsetLeftRight, 0, CollectionEdgeInsetLeftRight);
    }
    return UIEdgeInsetsMake(CollectionEdgeInsetTop, CollectionEdgeInsetLeftRight, 0, CollectionEdgeInsetLeftRight);
}

#pragma mark - TeamCardHeaderCellDelegate
- (void)cellDidSelected:(TeamCardHeaderCell*)cell{
    id<CardHeaderData> data = cell.data;
    if ([data respondsToSelector:@selector(opera)] && data.opera != CardHeaderOpeatorNone) {
        self.currentOpera = data.opera;
        NSMutableArray *users;
        NSString *currentUserID = [[[NIMSDK sharedSDK] loginManager] currentAccount];
        if (self.currentOpera == CardHeaderOpeatorAdd) {
            users = [[ContactUtil allContactUserId] mutableCopy];
            [users removeObjectsInArray:self.headerUserIds];
        }else if(self.currentOpera == CardHeaderOpeatorRemove){
            users = [self.headerUserIds mutableCopy];
        }
        NSMutableArray *members = [NSMutableArray array];
        for (NSString *usr in users) {
            if ([usr isEqualToString:currentUserID]) {
                continue;
            }
            UsrInfo *member = [[UsrInfoData sharedInstance] queryUsrInfoById:usr needRemoteFetch:NO fetchCompleteHandler:nil];
            [members addObject:member];
        }
        GroupedUsrInfo *teamContacts = [[GroupedUsrInfo alloc] initWithContacts:members];
        ContactSelectViewController *vc = [[ContactSelectViewController alloc] initWithNibName:nil bundle:nil];
        vc.dataCollection = teamContacts;
        vc.delegate = self;
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
    }
}
#pragma mark - ContactSelectDelegate
- (void)didFinishedSelect:(NSArray *)selectedContacts{
    //override
}

- (void)didCancelledSelect{
    //override
}


@end
