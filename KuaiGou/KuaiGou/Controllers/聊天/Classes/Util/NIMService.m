//
//  NIMManager.m
//  NIM
//
//  Created by amao on 11/13/13.
//  Copyright (c) 2013 Netease. All rights reserved.
//

#import "NIMService.h"
#import "SessionUtil.h"

#pragma mark - NIMServiceManagerImpl
@interface NIMServiceManagerImpl : NSObject
@property (nonatomic,strong)    NSString                *key;
@property (nonatomic,strong)    NSMutableDictionary     *singletons;
@end


@implementation NIMServiceManagerImpl

+ (NIMServiceManagerImpl *)coreImpl:(NSString *)key
{
    NIMServiceManagerImpl *impl = [[NIMServiceManagerImpl alloc]init];
    impl.key = key;
    return impl;
}

- (id)init
{
    if (self = [super init])
    {
        _singletons = [[NSMutableDictionary alloc]init];
    }
    return self;
}



- (instancetype)singletonByClass:(Class)singletonClass
{
    NSString *singletonClassName = NSStringFromClass(singletonClass);
    id singleton = [_singletons objectForKey:singletonClassName];
    if (!singleton) {
        singleton = [[singletonClass alloc]init];
        [_singletons setObject:singleton forKey:singletonClassName];
    }
    return singleton;
}

- (void)callSingletonSelector: (SEL)selecotr
{
    NSArray *array = [_singletons allValues];
    for (id obj in array)
    {
        if ([obj respondsToSelector:selecotr])
        {
            SuppressPerformSelectorLeakWarning([obj performSelector:selecotr]);
        }
    }
}

@end

#pragma mark - NIMServiceManager()
@interface NIMServiceManager ()
@property (nonatomic,strong)    NSRecursiveLock *lock;
@property (nonatomic,strong)    NIMServiceManagerImpl *core;
+ (instancetype)sharedManager;
- (id)singletonByClass:(Class)singletonClass;
@end

#pragma mark - NIMService
@implementation NIMService
+ (instancetype)sharedInstance
{
    return [[NIMServiceManager sharedManager] singletonByClass:[self class]];
}

- (void)start
{
    DDLogDebug(@"NIMServiceManager %@ Started", self);
}
@end

#pragma mark - NIMServiceManager
@implementation NIMServiceManager

+ (instancetype)sharedManager
{
    static NIMServiceManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NIMServiceManager alloc]init];
    });
    return instance;
}

- (id)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)start {
    [_lock lock];
    NSString *key = [SessionUtil currentUsrId];
    _core = [NIMServiceManagerImpl coreImpl:key];
    [_lock unlock];
}

- (void)destory {
    [_lock lock];
    [self callSingletonClean];
    _core = nil;
    [_lock unlock];
}

- (id)singletonByClass: (Class)singletonClass
{
    id instance = nil;
    [_lock lock];
    instance = [_core singletonByClass:singletonClass];
    [_lock unlock];
    return instance;
}

#pragma mark - Call Functions
- (void)callSingletonClean
{
    [self callSelector:@selector(onCleanData)];
}


- (void)callReceiveMemoryWarning
{
    [self callSelector:@selector(onReceiveMemoryWarning)];
}


- (void)callEnterBackground
{
    [self callSelector:@selector(onEnterBackground)];
}

- (void)callEnterForeground
{
    [self callSelector:@selector(onEnterForeground)];
}

- (void)callAppWillTerminate
{
    [self callSelector:@selector(onAppWillTerminate)];
}

- (void)callSelector: (SEL)selector
{
    [_core callSingletonSelector:selector];
}


@end