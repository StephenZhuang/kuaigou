//
//  NIMKeychain.h
//  NIM
//
//  Created by Xuhui on 14-8-11.
//  Copyright (c) 2014年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
enum {
    kNIMKeychainErrorBadArguments = -1301,
    kNIMKeychainErrorNoPassword = -1302
};

@interface NIMKeychain : NSObject

+ (NIMKeychain *)defaultKeychain;

- (NSString *)passwordForService:(NSString *)service
                         account:(NSString *)account
                           error:(NSError **)error;

- (BOOL)removePasswordForService:(NSString *)service
                         account:(NSString *)account
                           error:(NSError **)error;

// OK to pass nil for the error parameter.
//
// accessibility should be one of the constants for kSecAttrAccessible
// such as kSecAttrAccessibleWhenUnlocked
- (BOOL)setPassword:(NSString *)password
         forService:(NSString *)service
      accessibility:(CFTypeRef)accessibility
            account:(NSString *)account
              error:(NSError **)error;

@end
