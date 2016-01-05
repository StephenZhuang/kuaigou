//
//  KGApiClient.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/13.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "KGApiClient.h"
#import "KGResponseObject.h"
#import "KGLoginManager.h"

static NSString * const KGAPIBaseURLString = @"http://www.t9o.net/";

@implementation KGApiClient
+ (instancetype)sharedClient {
    static KGApiClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[[self class] alloc] init];
    });
    
    return _sharedClient;
}

- (id)init
{
    self = [super initWithBaseURL:[NSURL URLWithString:KGAPIBaseURLString]];
    if (self) {
        NSLog(@"BASE %@", self.baseURL);
        [self setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]];
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/x-zip-compressed",@"text/html",@"application/json",@"application/x-www-form-urlencode"]];
        [self setResponseSerializer:responseSerializer];
        AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
#ifdef DEBUG
        requestSerializer.timeoutInterval = 60;
#else
        requestSerializer.timeoutInterval = 20;
#endif
        [self setRequestSerializer:requestSerializer];
        self.requestSerializer.HTTPShouldHandleCookies = YES;
        [self startReachabilityMonitor];
    }
    return self;
}

- (void)startReachabilityMonitor
{
    NSOperationQueue *operationQueue = self.operationQueue;
    [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                NSLog(@"Reachability Ok");
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                [operationQueue setSuspended:YES];
                NSLog(@"Reachability Ok");
                break;
        }
    }];
    
    [self.reachabilityManager startMonitoring];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id data))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSString *errorInfo))failure
{
    if (parameters) {
        URLString = [URLString stringByAppendingString:@"?"];
    }
    return [super POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task , id responseObject) {
        
        [self postSuccessLog:task responseObject:responseObject parameters:parameters];
        KGResponseObject *object = [KGResponseObject objectWithKeyValues:responseObject];
        
        if (object.code == 1) {
            if (success) {
                success(task , object.data);
            }
        } else if (object.code == 2) {
            [KGLoginManager sharedInstance].isLogin = NO;
            [KGLoginManager sharedInstance].user = nil;
            [GVUserDefaults standardUserDefaults].user = nil;
            [[KGLoginManager sharedInstance] doLogout];
            if (failure) {
                failure(task, object.message);
            }
        } else {
            if (failure) {
                failure(task , object.message);
            }
        }
        
    } failure:^(NSURLSessionDataTask *task , NSError *error) {
        
        [self postFailureLog:task error:error parameters:parameters];
        
        if (failure) {
            failure(task , error.localizedFailureReason);
        }
    }];
}

- (void)postSuccessLog:(NSURLSessionDataTask *)task responseObject:(id)responseObject parameters:(id)parameters
{
#ifdef DEBUG
    NSString *jsonString = @"";
    
    for (NSString *key in [parameters keyEnumerator]) {
        jsonString = [jsonString stringByAppendingFormat:@"%@=%@&",key,[parameters objectForKey:key]];
    }
    NSLog(@"------ REQUEST SUCCESS LOG ------");
    NSLog(@"Request %@%@", [task.response.URL absoluteString] ,jsonString);
    NSLog(@"response %@", task.response);
    NSLog(@"-------------------------------");
#endif
}

- (void)postFailureLog:(NSURLSessionDataTask *)task error:(NSError *)error parameters:(id)parameters
{
#ifdef DEBUG
    NSString *jsonString = @"";
    
    for (NSString *key in [parameters keyEnumerator]) {
        jsonString = [jsonString stringByAppendingFormat:@"%@=%@&",key,[parameters objectForKey:key]];
    }
    NSLog(@"------ REQUEST ERROR LOG START ------");
    NSLog(@"Request %@%@", [task.response.URL absoluteString] ,jsonString);
    NSLog(@"response %@", task.response);
    NSLog(@"Error %@", error.localizedDescription);
    NSLog(@"------ REQUEST ERROR LOG END ------");
    
    if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"statusCode: %i",response.statusCode] message:error.description delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Ok", @"Ok"), nil] show];
        });
    }
#endif
}
@end
