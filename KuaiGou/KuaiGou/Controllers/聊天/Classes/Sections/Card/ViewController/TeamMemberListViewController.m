//
//  TeamMemberListViewController.m
//  NIM
//
//  Created by chrisRay on 15/3/26.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "TeamMemberListViewController.h"
#import "TeamCardHeaderCell.h"
#import "CardMemberItem.h"
#import "TeamMemberCardViewController.h"

#define CollectionCellReuseId @"cell"
#define CollectionItemWidth  55 * UIScreenWidth / 320
#define CollectionItemHeight 80 * UIScreenWidth / 320
#define CollectionItemNumber 4
#define CollectionEdgeInsetLeftRight (UIScreenWidth - CollectionItemWidth * CollectionItemNumber) / (CollectionItemNumber + 1)
#define CollectionEdgeInsetTopFirstLine 25
#define CollectionEdgeInsetTop 15

@interface TeamMemberListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,TeamCardHeaderCellDelegate, TeamMemberCardActionDelegate>

@property (nonatomic,strong) NIMTeam *team;

@property (nonatomic,copy)   NSArray *members;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,copy)   NSMutableArray *data;

@property (nonatomic,strong) NIMTeamMember *myTeamCard;

@end

@implementation TeamMemberListViewController

- (instancetype)initTeam:(NIMTeam*)team
                 members:(NSArray*)members{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _team = team;
        _members = members;
        _data = [[NSMutableArray alloc] init];
        for (NIMTeamMember *member in _members) {
            TeamCardMemberItem *item = [[TeamCardMemberItem alloc] initWithMember:member];
            [_data addObject:item];
            if([member.userId isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
                _myTeamCard = member;
            }
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"群成员";
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:241.0/255.0 blue:245.0/255.0 alpha:1];
    self.collectionView.delegate   = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[TeamCardHeaderCell class] forCellWithReuseIdentifier:CollectionCellReuseId];
    [self.view addSubview:self.collectionView];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger lastTotal = CollectionItemNumber * section;
    NSInteger remain    = self.data.count - lastTotal;
    return remain < CollectionItemNumber ? remain:CollectionItemNumber;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    NSInteger sections = self.data.count / CollectionItemNumber;
    return self.data.count % CollectionItemNumber ? sections + 1 : sections;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TeamCardHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionCellReuseId forIndexPath:indexPath];
    cell.delegate = self;
    ;
    id<CardHeaderData> data = [self dataAtIndexPath:indexPath];
    [cell refreshData:data];
    return cell;
}

- (id<CardHeaderData>)dataAtIndexPath:(NSIndexPath*)indexpath{
    NSInteger index = indexpath.section * CollectionItemNumber;
    index += indexpath.row;
    return self.data[index];
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
    NSIndexPath *indexpath = [self.collectionView indexPathForCell:cell];
    NSInteger index = indexpath.section * CollectionItemNumber;
    index += indexpath.row;
    TeamMemberCardViewController *vc = [[TeamMemberCardViewController alloc] init];
    vc.delegate = self;
    TeamCardMemberItem *member = [[TeamCardMemberItem alloc] initWithMember:self.members[index]];
    TeamCardMemberItem *viewer = [[TeamCardMemberItem alloc] initWithMember:self.myTeamCard];
    vc.member = member;
    vc.viewer = viewer;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TeamMemberCardActionDelegate

- (void)onTeamMemberKicked:(TeamCardMemberItem *)member {
    [_data removeObject:member];
    [_collectionView reloadData];
}

- (void)onTeamMemberInfoChaneged:(TeamCardMemberItem *)member {
    [_collectionView reloadData];
}

@end
