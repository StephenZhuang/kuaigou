//
//  NIMUserCommand.h
//  NIMLib
//
//  Created by Netease.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NIMSession;
/**
 *  用户透传指令
 *  @discussion 这种命令由客户端发起,且只支持在线消息,如果指令接受者不在线,这条命令会被服务器丢弃 应用场景:正在输入状态等
 */
@interface NIMUserCommand : NSObject

/**
 *  指令时间戳
 */
@property (nonatomic,assign,readonly)   NSTimeInterval timestamp;

/**
 *  发起者
 */
@property (nonatomic,copy,readonly) NSString *from;

/**
 *  发往的会话对象
 */
@property (nonatomic,copy,readonly) NIMSession *session;

/**
 *  透传内容
 */
@property (nonatomic,copy,readonly) NSString *content;

/**
 *  初始化方法
 *
 *  @param content 透传消息
 *
 *  @return 透传指令对象
 */
- (instancetype)initWithContent:(NSString *)content;

@end
