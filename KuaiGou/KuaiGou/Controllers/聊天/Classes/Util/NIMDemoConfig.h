//
//  NIMDemoConfig.h
//  NIM
//
//  Created by amao on 4/21/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIMDemoConfig : NSObject
+ (instancetype)sharedConfig;

- (NSString *)appKey;

- (NSString *)apiURL;

@end
