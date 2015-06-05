//
//  SessionCellActionHandler.m
//  NIMDemo
//
//  Created by ght on 15-1-23.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "SessionCellActionHandler.h"
#import "NIMSDK.h"
#import "SessionMsgModel.h"

@interface SessionCellActionItem : NSObject
@property (nonatomic,strong) NSString *selectorString;
@property (nonatomic,strong) NSString *paramClassString;

+ (SessionCellActionItem*)actionItem:(NSString *)selString
                         paramString:(NSString *)paramString;

@end

@implementation SessionCellActionItem
+ (SessionCellActionItem*)actionItem:(NSString *)selString
                         paramString:(NSString *)paramString
{
    SessionCellActionItem *item = [[SessionCellActionItem alloc] init];
    item.selectorString = selString;
    item.paramClassString = paramString;
    return item;
}

@end

@implementation SessionCellEventParam
- (id)initSessionCellEventParam:(SessionMessageEventID)eID
                         param:(id)param
{
    self = [super init];
    if (self)
    {
        self.eventID = eID;
        self.eventParam = param;
    }
    return self;
}
@end



@implementation SessionCellActionHandler

- (NSDictionary*)actionsDict
{
    static NSDictionary *dict = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dict = @{
                 @(SessionMessageEventIDTapVideoCell):[SessionCellActionItem actionItem:@"onVideoCellTap"
                                                                            paramString:@"NIMVideoObject"],//点击视频单元格
                 
                 @(SessionMessageEventIDTapPhoneNumber):[SessionCellActionItem actionItem:@"onPhoneNumberTap"
                                                                              paramString:@"NSString"],//点击手机号或者电话号
                 
                 @(SessionMessageEventIDOpenUrl):[SessionCellActionItem actionItem:@"openURLWithCellEventParam"
                                                                       paramString:@"NSString"] ,//根据url打开webview
                 
                 @(SessionMessageEventIDPreviewPicture):[SessionCellActionItem actionItem:@"onPreviewPicture"
                                                                              paramString:@"NIMImageObject"] ,//点击查看图片
                 
                 @(SessionMessageEventIDPreviewLocation):[SessionCellActionItem actionItem:@"onPreviewLocation"
                                                                               paramString:@"NIMLocationObject"],//点击查看位置
                 
                 @(SessionMessageEventIDPreviewFile):[SessionCellActionItem actionItem:@"onPreviewFile"
                                                                               paramString:@"NIMFileObject"],//点击查看位置
                 
                 @(SessionMessageEventIDRetryReceiveMsg): [SessionCellActionItem actionItem:@"retryReceiveMsg"
                                                                                paramString:@"NIMMessage"] ,//重收消息
                 
                 @(SessionMessageEventIDRetrySendMsg):[SessionCellActionItem actionItem:@"retrySendMsg"
                                                                            paramString:@"NIMMessage"], //重发消息
                 
                 @(SessionMessageEventIDDeleteMessage):[SessionCellActionItem actionItem:@"deleteMessage"
                                                                             paramString:@"SessionMsgModel"] ,//删除消息

                 
                 };
    });
    return dict;
}

- (void)sessionMessageEventHandle:(SessionCellEventParam *)param
{
    BOOL eventHandled = NO;
    SessionCellActionItem *actionItem = [[self actionsDict] objectForKey:@(param.eventID)];
    if ([param.eventParam isKindOfClass:NSClassFromString(actionItem.paramClassString)]) {
        if ([actionItem.selectorString length]> 0) {
            NSString *seletorStr = [actionItem.selectorString  stringByAppendingString:@":"];
            SEL selector = NSSelectorFromString(seletorStr);
            if ([self respondsToSelector:selector]) {
                SuppressPerformSelectorLeakWarning([self performSelector:selector withObject:param.eventParam]);
                eventHandled = YES;
            }
        }
    }
    
    if (!eventHandled)
    {
        assert(0);
        DDLogWarn(@"action %@ param %@ param type %@",@(param.eventID),param.eventParam,actionItem.paramClassString);
    }
}

#pragma mark - actions
- (void)retryReceiveMsg:(NIMMessage*)message
{
    [[[NIMSDK sharedSDK] chatManager] fetchMessageAttachment:message error:nil];
}

- (void)retrySendMsg:(NIMMessage*)message
{
    message.timestamp = [NSDate date].timeIntervalSince1970;
    [[[NIMSDK sharedSDK] chatManager] resendMessage:message error:nil];
}

- (void)deleteMessage:(SessionMsgModel*)model
{
    if (self.logicDelegate && [self.logicDelegate respondsToSelector:@selector(onDeleteMessage:)]) {
        [self.logicDelegate onDeleteMessage:model];
    }
}

- (void)onPreviewPicture:(NIMImageObject *)object
{
    if (self.logicDelegate && [self.logicDelegate respondsToSelector:@selector(toGalleryVC:)]) {
        [self.logicDelegate toGalleryVC:object];
    }
}

- (void)onVideoCellTap:(NIMVideoObject *)object
{
    if (self.logicDelegate && [self.logicDelegate respondsToSelector:@selector(toVideoVC:)]) {
        [self.logicDelegate toVideoVC:object];
    }
}

- (void)onPreviewLocation:(NIMLocationObject *)object
{
    if (self.logicDelegate && [self.logicDelegate respondsToSelector:@selector(toLocationVC:)]) {
        [self.logicDelegate toLocationVC:object];
    }
}

- (void)onPreviewFile:(NIMFileObject *)object
{
    if (self.logicDelegate && [self.logicDelegate respondsToSelector:@selector(toFileVC:)]) {
        [self.logicDelegate toFileVC:object];
    }
}


@end
