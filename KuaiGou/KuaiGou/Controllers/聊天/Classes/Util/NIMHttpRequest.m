//
//  YXHttpRequest.m
//  NIM
//
//  Created by amao on 2/10/14.
//  Copyright (c) 2014 Netease. All rights reserved.
//

#import "NIMHttpRequest.h"
#import "SessionUtil.h"
#import "NIMKeychain.h"
#import "AFNetworking.h"
#import "TokenManager.h"

@interface NIMHttpRequest ()
@property (nonatomic, strong)  NSMutableURLRequest *request;
@end

@implementation NIMHttpRequest
+ (NIMHttpRequest *)requestWithURL:(NSURL *)url
{
    NIMHttpRequest *instance = [[NIMHttpRequest alloc] init];
    [instance setRequestURL:url];
    return instance;
}

- (id)init
{
    if (self = [super init])
    {
    }
    return self;
}

- (void)setPostDict:(NSDictionary *)dict
{
    if (dict)
    {
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
       
        if (![self.request valueForHTTPHeaderField:@"Content-Type"]) {
            NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
            [self.request setValue:[NSString stringWithFormat:@"application/json; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
        }
        
        [self.request setHTTPBody:data];
    }
    else
    {
        DDLogDebug(@"%@", @"Error: Empty Post Dict");
    }
}

- (void)setPostJsonData:(NSData *)data {
    if (![self.request valueForHTTPHeaderField:@"Content-Type"]) {
        NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
        [self.request setValue:[NSString stringWithFormat:@"application/json; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
    }
    [self.request setHTTPBody:data];
}

- (void)addHttpHeader: (NSString *)key Value:(NSString *)value
{
    if([key length] <= 0 || [value length] <= 0)
    {
        DDLogDebug(@"%@", @"Error: NIMhttp Empty key and value");
    }
    else
    {
        [self.request setValue:value forHTTPHeaderField:key];
    }
}

- (void)startAsyncWithComplete:(CompleteBlock)result
{
    if(![TokenManager sharedInstance].accessToken || [TokenManager sharedInstance].updating) {
        result(kNIMHttpRequestCodeInvalidToken, nil);
        [[TokenManager sharedInstance] updateWithUsrId:[SessionUtil currentUsrId] password:[SessionUtil currectUsrPassword] completeHandler:nil];
        DDLogDebug(@"%@", @"Invalid Token");
        if(result) result(kNIMHttpRequestCodeInvalidToken, nil);
        return;
    } else {
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:_request];
        [self handle:operation withResult:result];
        [operation start];
    }
}


#pragma mark - 辅助方法
- (void)setRequestURL: (NSURL *)url
{
    NSParameterAssert(url);
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [mutableRequest setHTTPMethod:@"POST"];
    mutableRequest.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    mutableRequest.timeoutInterval = 30;
    [mutableRequest setValue:[TokenManager sharedInstance].accessToken forHTTPHeaderField:@"access-token"];
    self.request = mutableRequest;
}

- (void)handle:(AFHTTPRequestOperation *)requestOperation withResult:(CompleteBlock)result
{
    void (^responseBlock)(AFHTTPRequestOperation *operation) = ^(AFHTTPRequestOperation *operation){
        NSInteger	responseCode	= [operation.response statusCode];
        NSError		*error			= [operation error];
        NSData		*data           = [operation responseData];
        NSInteger	errorCode = kNIMHttpRequestCodeFailed;
        NSDictionary *resDict = nil;
        if ((responseCode == 200) && (error == nil)) {
            do {
                if (![data length]) {
                    errorCode = kNIMHttpRequestCodeDecryptError;
                    DDLogDebug(@"NIMHttp Request Decrypt Failed %@", [[operation.request URL] absoluteString]);
                    break;
                }
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:0];
                NSNumber *resCode = [result objectForKey:@"res"];
                if(resCode.integerValue != 200) {
                    errorCode = kNIMHttpRequestCodeFailed;
                    if(resCode.integerValue == 401) {
                        errorCode = kNIMHttpRequestCodeInvalidToken;
                        [[TokenManager sharedInstance] updateWithUsrId:[SessionUtil currentUsrId] password:[SessionUtil currectUsrPassword] completeHandler:nil];
                    }
                    DDLogDebug(@"NIMHttp Request Error: %@", [result objectForKey:@"errmsg"] ? : @"");
                    break;
                }
                resDict = [result objectForKey:@"msg"];
                errorCode = kNIMHttpRequestCodeSuccess;
                
            } while (false);
        } else if (responseCode == NSURLErrorTimedOut) {	// request timeout
            errorCode = kNIMHttpRequestCodeTimeout;
            DDLogDebug(@"NIMHttp Request Timeout: URL %@ Code %zd",[[operation.request URL] absoluteString],errorCode);
        }
        
        if (result) {
            result(errorCode, resDict);
        }
    };
    
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        responseBlock(operation);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        responseBlock(operation);
    }];
}


@end
