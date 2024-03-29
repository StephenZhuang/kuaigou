//
//  KGCategory.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/6/4.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGCategory : NSObject
@property (nonatomic , assign) NSInteger catid;
@property (nonatomic , assign) NSInteger pid;
@property (nonatomic , copy) NSString *name;
@property (nonatomic , copy) NSString *avatar;

@property (nonatomic , strong) NSArray *childArray;

+ (void)getParentCategoryWithCompletion:(void(^)(BOOL success,NSString *errorInfo,NSArray *array))completion;

+ (void)getChildCategoryWithPid:(NSInteger)pid
                     completion:(void(^)(BOOL success,NSString *errorInfo,NSArray *array))completion;

+ (void)getSevenCategoryWithCompletion:(void(^)(BOOL success,NSString *errorInfo,NSArray *array))completion;

+ (void)getAllCategoryWithCompletion:(void(^)(BOOL success,NSString *errorInfo,NSArray *array))completion;
@end
