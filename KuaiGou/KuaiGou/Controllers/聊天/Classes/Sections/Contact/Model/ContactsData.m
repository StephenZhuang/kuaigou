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
#import "NIMDemoConfig.h"
#import "FileLocationHelper.h"

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
        _cachePath = [[FileLocationHelper userDirectory] stringByAppendingPathComponent:@"contact_cache"];
        _contactDict = [NSMutableDictionary dictionary];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:_cachePath];
        [self saveDictionaryToUsers:dict];
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
        NSString *urlStr = [NSString stringWithFormat:@"%@/getAddressBook", [[NIMDemoConfig sharedConfig] apiURL]];
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
            [self saveDictionaryToUsers:responseData];
            [self setUpdating:NO];
        }];
    }
}

- (void)saveDictionaryToUsers:(NSDictionary *)dict
{
    for (NSDictionary *item in [dict objectForKey:@"list"]){
        
        NSString *uid = [item objectForKey:@"uid"];
        NSString *name = [item objectForKey:@"name"];
        NSString *icon = [item objectForKey:@"icon"];
        ContactDataMember *member = [[ContactDataMember alloc] init];
        member.usrId = uid;
        member.nick = name;
        member.iconUrl = icon;
        [_contactDict setObject:member forKey:uid];
    }

}



@end
