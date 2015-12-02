//
//  NSManagedObject+ZXRecord.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/12.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "NSManagedObject+ZXRecord.h"

@implementation NSManagedObject (ZXRecord)

+ (instancetype)insertWithAttribute:(NSString *)attribute value:(NSNumber *)value
{
    NSManagedObject *object = nil;
    NSArray *array = [self where:@{attribute:value} limit:@1];
    if (array && array.count > 0) {
        object = [array firstObject];
    } else {
        object = [self create];
    }
    return object;
}

@end
