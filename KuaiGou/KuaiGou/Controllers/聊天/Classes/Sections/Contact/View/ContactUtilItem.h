//
//  ContactUtilItem.h
//  NIM
//
//  Created by chrisRay on 15/2/26.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactDefines.h"
#import "GroupedContacts.h"

@interface ContactUtilItem : NSObject<ContactItemCollection>

@property (nonatomic,copy) NSArray *members;

@end

@interface ContactUtilMember : NSObject<ContactItem, GroupMemberProtocol>

@property (nonatomic,copy) NSString *nick;

@property (nonatomic,copy) NSString *iconUrl;

@property (nonatomic,copy) NSString *vcName;

@end
