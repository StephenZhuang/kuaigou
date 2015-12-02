//
//  NSManagedObject+ZXRecord.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/12.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <ObjectiveRecord.h>

@interface NSManagedObject (ZXRecord)
+ (instancetype)insertWithAttribute:(NSString *)attribute value:(NSNumber *)value;
@end
