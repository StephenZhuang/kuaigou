//
//  ContactsData.m
//  NIM
//
//  Created by Xuhui on 15/3/7.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "ContactsData.h"
#import "NIMHttpRequest.h"
#import "ContactDataItem.h"
#import "SessionUtil.h"
#import "NSString+NIMDemo.h"

NSString *const ContactUpdateDidFinishedNotification = @"ContactUpdateDidFinishedNotification";
@interface ContactsData () {
    NSString *_cachePath;
    NSMutableDictionary *_contactDict;
}

@end

@implementation ContactsData

- (instancetype)init {
    self = [super init];
    if(self) {
        NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _cachePath = [NSString stringWithFormat:@"%@/contacts_cache_%@", [dirs objectAtIndex:0], [[SessionUtil currentUsrId] MD5String]];
    }
    return self;
}

- (NSArray *)contacts {
    return [_contactDict allValues];
}

- (NSArray*)contactIds{
    return [_contactDict allKeys];
}

- (NSDictionary *)queryContactByUsrId:(NSString *)usrId {
    return [_contactDict objectForKey:usrId];
}

- (void)setUpdating:(BOOL)updating {
    _updating = updating;
    if(!_updating) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ContactUpdateDidFinishedNotification object:nil];
    }
}

- (void)update {
    if(![self isUpdating]) {
        NSString *urlStr = [NSString stringWithFormat:@"%@/getAddressBook", WebApiBaseURL];
        NIMHttpRequest *request = [NIMHttpRequest requestWithURL:[NSURL URLWithString:urlStr]];
        [request startAsyncWithComplete:^(NSInteger responseCode, NSDictionary *responseData) {
            _contactDict = [NSMutableDictionary dictionary];
            if(responseCode == kNIMHttpRequestCodeSuccess && responseData) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^() {
                    [responseData writeToFile:_cachePath atomically:YES];
                });
            } else {
                responseData = [NSDictionary dictionaryWithContentsOfFile:_cachePath];
            }
            for (NSDictionary *item in [responseData objectForKey:@"list"]) {
                
                NSString *uid = [item objectForKey:@"uid"];
                NSString *name = [item objectForKey:@"name"];
                NSString *icon = [item objectForKey:@"icon"];
                ContactDataMember *member = [[ContactDataMember alloc] init];
                member.usrId = uid;
                member.nick = name;
                member.iconUrl = icon;
                [_contactDict setObject:member forKey:uid];
            }
            [self setUpdating:NO];
        }];
    }
}




@end
