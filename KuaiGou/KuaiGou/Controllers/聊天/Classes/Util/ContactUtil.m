//
//  ContactUtil.m
//  NIM
//
//  Created by Xuhui on 15/3/11.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "ContactUtil.h"
#import "NIMHttpRequest.h"
#import "ContactsData.h"

@implementation ContactUtil

+ (ContactDataMember *)queryContactByUsrId:(NSString *)uid{
    return [[ContactsData sharedInstance] queryContactByUsrId:uid];
}

+ (NSArray *)allContactUserId{
    return [ContactsData sharedInstance].contactIds;
}

@end
