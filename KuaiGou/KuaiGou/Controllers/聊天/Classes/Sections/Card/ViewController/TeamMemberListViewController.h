//
//  TeamMemberListViewController.h
//  NIM
//
//  Created by chrisRay on 15/3/26.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamMemberListViewController : UIViewController

- (instancetype)initTeam:(NIMTeam*)team
                 members:(NSArray*)members;

@end
