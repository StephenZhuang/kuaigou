//
//  RegularTeamMemberCell.h
//  NIM
//
//  Created by chrisRay on 15/3/26.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegularTeamMemberCellActionDelegate <NSObject>

- (void)didSelectAddOpeartor;

@end


@interface RegularTeamMemberCell : UITableViewCell

@property(nonatomic,weak) id<RegularTeamMemberCellActionDelegate>delegate;

- (void)rereshWithTeam:(NIMTeam*)team
               members:(NSArray*)members;
@end
