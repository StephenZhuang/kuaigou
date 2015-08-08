//
//  KGCity.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/8/8.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObject+ZXRecord.h"

@interface KGCity : NSManagedObject

@property (nonatomic) int32_t cid;
@property (nonatomic) int16_t cstate;
@property (nonatomic) int16_t ctype;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * pinA;
@property (nonatomic, retain) NSString * pinAS;
@property (nonatomic, retain) NSString * pinJ;
@property (nonatomic) int32_t subCid;

+ (NSArray *)getProvinces;
+ (NSArray *)getCitiesWithProvinceid:(NSInteger)provinceid;
@end
