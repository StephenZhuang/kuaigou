//
//  ContactDataItem.h
//  NIM
//
//  Created by chrisRay on 15/2/26.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactDefines.h"

@class UsrInfo;

@interface ContactDataItem : NSObject<ContactItemCollection>

@property (nonatomic,copy)   NSString *title;

@property (nonatomic,strong) NSArray  *members;

@end

@interface ContactDataMember : UsrInfo <ContactItem>

@property (nonatomic,copy) NSString *usrId;

@property (nonatomic,copy) NSString *iconUrl;

@property (nonatomic,copy) NSString *nick;

@end