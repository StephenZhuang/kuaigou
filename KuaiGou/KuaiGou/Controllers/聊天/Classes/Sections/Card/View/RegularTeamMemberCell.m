//
//  RegularTeamMemberCell.m
//  NIM
//
//  Created by chrisRay on 15/3/26.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "RegularTeamMemberCell.h"
#import "UIView+NIMDemo.h"
#import "UsrInfoData.h"
#import "AvatarImageView.h"
#import "SessionUtil.h"
typedef NS_ENUM(NSInteger, RegularTeamMemberType) {
    RegularTeamMemberTypeInvalid,
    RegularTeamMemberTypeAdd,
    RegularTeamMemberTypeMember,
};

@interface RegularTeamMemberView : UIView{
    UILabel *_titleLabel;
}

@property(nonatomic,copy) NSString *imageName;

@property(nonatomic,copy) NSString *title;

@property(nonatomic,strong) AvatarImageView *iconView;

@property(nonatomic,strong) NIMTeamMember *member;

@property(nonatomic,assign) RegularTeamMemberType type;

@end

#define RegularTeamMemberViewHeight 53
#define RegularTeamMemberViewWidth  38
@implementation RegularTeamMemberView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:12.f];
        [self addSubview:_titleLabel];
        _iconView   = [AvatarImageView demoInstanceTeamMember];
        [self addSubview:_iconView];
    }
    return self;
}

- (void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    _iconView.image = [UIImage imageNamed:imageName];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = title;
}

- (CGSize)sizeThatFits:(CGSize)size{
    return CGSizeMake(RegularTeamMemberViewWidth, RegularTeamMemberViewHeight);
}


#define RegularTeamMemberInvite
- (void)layoutSubviews{
    [super layoutSubviews];
    [_titleLabel sizeToFit];
    _titleLabel.width = _titleLabel.width > self.width ? self.width : _titleLabel.width;
    self.iconView.centerX = self.width * .5f;
    _titleLabel.centerX = self.width * .5f;
    _titleLabel.bottom = self.height;
}
@end


@interface RegularTeamMemberCell()

@property(nonatomic,strong) NSMutableArray *icons;

@property(nonatomic,strong) NIMTeam *team;

@property(nonatomic,copy)   NSArray *teamMembers;

@property(nonatomic,strong) UIButton *addBtn;

@end

#define MaxIconCount (UIScreenWidth - 28) / 49
@implementation RegularTeamMemberCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _icons = [[NSMutableArray alloc] init];
        for (int i = 0; i < MaxIconCount; i++) {
            RegularTeamMemberView *view = [[RegularTeamMemberView alloc]initWithFrame:CGRectZero];
            view.userInteractionEnabled = NO;
            [view sizeToFit];
            [self addSubview:view];
            [_icons addObject:view];
        }
        _addBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.width *.20f, self.height)];
        _addBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_addBtn addTarget:self action:@selector(onPress:) forControlEvents:UIControlEventTouchUpInside];
        _addBtn.userInteractionEnabled = NO;
        [self addSubview:_addBtn];
    }
    return self;
}

- (void)rereshWithTeam:(NIMTeam*)team
               members:(NSArray*)members{
    _team = team;
    _teamMembers = members;
    NIMTeamMember *myTeamInfo;
    for (NIMTeamMember *member in members) {
        if ([member.userId isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount]) {
            myTeamInfo = member;
            break;
        }
    }
    NSInteger count = 0;
    if (myTeamInfo.type == NIMTeamMemberTypeOwner || myTeamInfo.type == NIMTeamMemberTypeManager) {
        RegularTeamMemberView *view = _icons[0];
        view.imageName = @"icon_add_normal";
        view.title = @"邀请";
        view.type  = RegularTeamMemberTypeAdd;
        count = 1;
        self.addBtn.userInteractionEnabled = YES;
    }else{
        self.addBtn.userInteractionEnabled = NO;
    }
    NSInteger showMemberCount = members.count > MaxIconCount-count ? MaxIconCount-count : members.count;
    for (NSInteger i = 0; i < showMemberCount; i++) {
        RegularTeamMemberView *view = _icons[i+count];
        NIMTeamMember *member = members[i];
        UsrInfo *info = [[UsrInfoData sharedInstance] queryUsrInfoById:member.userId needRemoteFetch:NO fetchCompleteHandler:nil];
        view.imageName = info.iconUrl;
        view.member = member;
        view.type  = RegularTeamMemberTypeMember;
        view.title = [SessionUtil showNick:member.userId teamId:self.team.teamId];
        [view setNeedsLayout];
    }
}

- (void)onPress:(id)sender{
    if ([self.delegate respondsToSelector:@selector(didSelectAddOpeartor)]) {
        [self.delegate didSelectAddOpeartor];
    }
}


- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat left = 20.f;
    CGFloat top  = 17.f;
    self.textLabel.left = left;
    self.textLabel.top  = top;
    self.detailTextLabel.top = top;
    self.accessoryView.top = top;
    
    CGFloat spacing = 12.f;
    CGFloat bottom  = 10.f;
    for (int i = 0; i < _icons.count; i++) {
        RegularTeamMemberView *view = _icons[i];
        view.left = left;
        left += view.width;
        left += spacing;
        view.bottom = self.height - bottom;
    }
}



@end
