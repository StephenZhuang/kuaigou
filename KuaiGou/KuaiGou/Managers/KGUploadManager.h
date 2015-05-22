//
//  KGUploadManager.h
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/14.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const QNSecretKey = @"5I-aCQ7aLCdL4RCow8LIMT8xPFXHMwFbsj5DEG2H";
static NSString * const QNAppKey = @"NJ3LNnMA03K4hKgaLzSr-6zFCYWypHS-EnHzC8NL";

@interface KGUploadManager : NSObject
+ (instancetype)sharedInstance;

- (void)uploadWithData:(NSArray *)dataArray completion:(void(^)(BOOL success ,NSString *uploadAddress, NSString *errorInfo))completion;
@end
