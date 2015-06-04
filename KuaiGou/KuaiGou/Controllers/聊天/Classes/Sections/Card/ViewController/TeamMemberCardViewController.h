//
//  TeamMemberCardViewController.h
//  NIM
//
//  Created by Xuhui on 15/3/19.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TeamCardMemberItem;

@protocol TeamMemberCardActionDelegate <NSObject>
@optional

- (void)onTeamMemberKicked:(TeamCardMemberItem *)member;
- (void)onTeamMemberInfoChaneged:(TeamCardMemberItem *)member;

@end

@interface TeamMemberCardViewController : UIViewController

@property (nonatomic, strong) id<TeamMemberCardActionDelegate> delegate;
@property (nonatomic, strong) TeamCardMemberItem *member;
@property (nonatomic, strong) TeamCardMemberItem *viewer;

@end
