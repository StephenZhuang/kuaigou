//
//  YXKeychain.m
//  NIM
//
//  Created by Xuhui on 14-8-11.
//  Copyright (c) 2014年 Netease. All rights reserved.
//

#import "NIMKeychain.h"

@implementation NIMKeychain

+ (NIMKeychain *)defaultKeychain {
    static NIMKeychain *keychain = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keychain = [[self alloc] init];
    });
    return keychain;
}

+ (NSMutableDictionary *)keychainQueryForService:(NSString *)service account:(NSString *)account {
    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  (__bridge id)kSecClassGenericPassword, (__bridge id)kSecClass,
                                  @"NIMKeychain", (__bridge id)kSecAttrGeneric,
                                  account, (__bridge id)kSecAttrAccount,
                                  service, (__bridge id)kSecAttrService,
                                  nil];
    return query;
}

- (NSMutableDictionary *)keychainQueryForService:(NSString *)service account:(NSString *)account {
    return [[self class] keychainQueryForService:service account:account];
}

NSString *const kNIMKeychainErrorDomain = @"im.nim.NIMKeychain";

- (NSString *)passwordForService:(NSString *)service account:(NSString *)account error:(NSError **)error {
    OSStatus status = kNIMKeychainErrorBadArguments;
    NSString *result = nil;
    if (0 < [service length] && 0 < [account length]) {
        CFDataRef passwordData = NULL;
        NSMutableDictionary *keychainQuery = [self keychainQueryForService:service account:account];
        [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
        [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
        
        status = SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery,
                                     (CFTypeRef *)&passwordData);
        if (status == noErr && 0 < [(__bridge NSData *)passwordData length]) {
            result = [[NSString alloc] initWithData:(__bridge NSData *)passwordData
                                           encoding:NSUTF8StringEncoding];
        }
        if (passwordData != NULL) {
            CFRelease(passwordData);
        }
    }
    if (status != noErr && error != NULL) {
        *error = [NSError errorWithDomain:kNIMKeychainErrorDomain
                                     code:status
                                 userInfo:nil];
    }
    return result;
}

- (BOOL)removePasswordForService:(NSString *)service account:(NSString *)account error:(NSError **)error {
    OSStatus status = kNIMKeychainErrorBadArguments;
    if (0 < [service length] && 0 < [account length]) {
        NSMutableDictionary *keychainQuery = [self keychainQueryForService:service account:account];
        status = SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    }
    if (status != noErr && error != NULL) {
        *error = [NSError errorWithDomain:kNIMKeychainErrorDomain
                                     code:status
                                 userInfo:nil];
    }
    return status == noErr;
}

- (BOOL)setPassword:(NSString *)password
         forService:(NSString *)service
      accessibility:(CFTypeRef)accessibility
            account:(NSString *)account
              error:(NSError **)error {
    OSStatus status = kNIMKeychainErrorBadArguments;
    if (0 < [service length] && 0 < [account length]) {
        [self removePasswordForService:service account:account error:nil];
        if (0 < [password length]) {
            NSMutableDictionary *keychainQuery = [self keychainQueryForService:service account:account];
            NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
            [keychainQuery setObject:passwordData forKey:(__bridge id)kSecValueData];
            
            if (accessibility != NULL && &kSecAttrAccessible != NULL) {
                [keychainQuery setObject:(__bridge id)accessibility
                                  forKey:(__bridge id)kSecAttrAccessible];
            }
            status = SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
        }
    }
    if (status != noErr && error != NULL) {
        *error = [NSError errorWithDomain:kNIMKeychainErrorDomain
                                     code:status
                                 userInfo:nil];
    }
    return status == noErr;
}


@end
