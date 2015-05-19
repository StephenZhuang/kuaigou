//
//  KGUser.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/19.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGUser : NSObject
@property (nonatomic , copy) NSString *phone;
@property (nonatomic , copy) NSString *idcard;
@property (nonatomic , copy) NSString *nickname;
@property (nonatomic , assign) NSInteger state;
@property (nonatomic , copy) NSString *avatar;
@property (nonatomic , copy) NSString *userid;
@property (nonatomic , copy) NSString *token;
@end
