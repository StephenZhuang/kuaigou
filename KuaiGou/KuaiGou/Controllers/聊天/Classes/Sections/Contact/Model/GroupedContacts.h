//
//  GroupedContacts.h
//  NIM
//
//  Created by Xuhui on 15/3/2.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "GroupedDataCollection.h"

@protocol GroupedContactsDelegate <NSObject>

- (void)didFinishedContactsUpdate;

@end

@class ContactsData;

@interface GroupedContacts : GroupedDataCollection

@property (nonatomic, weak) id<GroupedContactsDelegate> delegate;
@property (nonatomic, strong) ContactsData *dataSource;

- (instancetype)initWithContacts:(NSArray *)contacts;

- (void)update;

@end
