//
//  NTESUserUtil.m
//  NIM
//
//  Created by chris on 15/9/17.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESUserUtil.h"

@implementation NTESUserUtil

+ (BOOL)isMyFriend:(NSString *)userId{
    for (NIMUser *user in [NIMSDK sharedSDK].userManager.myFriends) {
        if ([user.userId isEqualToString:userId]) {
            return YES;
        }
    }
    return NO;
}

+ (NSString *)genderString:(NIMUserGender)gender{
    NSString *genderStr = @"";
    switch (gender) {
        case NIMUserGenderMale:
            genderStr = @"男";
            break;
        case NIMUserGenderFemale:
            genderStr = @"女";
            break;
        case NIMUserGenderUnknown:
            genderStr = @"未知";
        default:
            break;
    }
    return genderStr;
}

@end
