//
//  ContactsData.h
//  NIM
//
//  Created by Xuhui on 15/3/7.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NIMService.h"

extern NSString *const ContactUpdateDidFinishedNotification;

@class ContactDataMember;

@interface ContactsData : NIMService

@property (nonatomic, readonly) NSArray *contacts;
@property (nonatomic, readonly) NSArray *contactIds;

@property (nonatomic, readonly, getter=isUpdating) BOOL updating;

- (ContactDataMember *)queryContactByUsrId:(NSString *)usrId;

- (void)update;

@end
