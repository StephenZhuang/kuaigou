//
//  GroupedUsrInfo.m
//  NIM
//
//  Created by Xuhui on 15/3/24.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "GroupedUsrInfo.h"

@implementation GroupedUsrInfo

- (instancetype)init
{
    self = [super init];
    if(self) {
        self.groupTitleComparator = ^NSComparisonResult(NSString *title1, NSString *title2) {
            return [title1 localizedCompare:title2];
        };
        self.groupMemberComparator = ^NSComparisonResult(NSString *key1, NSString *key2) {
            return [key1 localizedCompare:key2];
        };
    }
    return self;
}

- (instancetype)initWithContacts:(NSArray *)contacts {
    self = [self init];
    if(self) {
        self.members = contacts;
    }
    return self;
}


@end
