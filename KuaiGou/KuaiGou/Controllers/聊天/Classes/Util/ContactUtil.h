//
//  ContactUtil.h
//  NIM
//
//  Created by Xuhui on 15/3/11.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactDataItem.h"

@interface ContactUtil : NSObject

+ (ContactDataMember *)queryContactByUsrId:(NSString *)uid;

+ (NSArray *)allContactUserId;

@end
