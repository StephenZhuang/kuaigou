//
//  KGResponseObject.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/13.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGResponseObject : NSObject
@property (nonatomic , assign) NSInteger code;
@property (nonatomic , copy) NSString *message;
@property (nonatomic , strong) NSDictionary *data;
@end
