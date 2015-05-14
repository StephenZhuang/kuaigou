//
//  NSString+KGhmac_sha1.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/14.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QNUrlSafeBase64.h>

@interface NSString (KGhmac_sha1)
- (NSString *)HmacSha1WithSecret:(NSString *)key;
@end
