//
//  KGCity.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/8/8.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "KGCity.h"


@implementation KGCity

@dynamic cid;
@dynamic cstate;
@dynamic ctype;
@dynamic name;
@dynamic pinA;
@dynamic pinAS;
@dynamic pinJ;
@dynamic subCid;

+ (NSArray *)getProvinces
{
    NSArray *array = [KGCity where:@"subCid == 0"];
    if (array.count > 0) {
        return array;
    } else {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Cities" ofType:@"plist"];
        NSArray *arr = [[NSArray alloc] initWithContentsOfFile:path];
        for (NSDictionary *dic in arr) {
            KGCity *city = [KGCity insertWithAttribute:@"cid" value:[dic objectForKey:@"cid"]];
            [city update:dic];
            [city save];
        }

        array = [KGCity where:@"subCid == 0"];
        return array;
    }
}

+ (NSArray *)getCitiesWithProvinceid:(NSInteger)provinceid
{
    NSArray *array = [KGCity where:@"subCid == %@",provinceid];
    return array;
}
@end
