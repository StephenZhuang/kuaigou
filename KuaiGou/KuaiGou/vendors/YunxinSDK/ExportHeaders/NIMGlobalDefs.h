//
//  NIMGlobalDefs.h
//  NIMLib
//
//  Created by Netease.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#ifndef NIMLib_NIMGlobalDefs_h
#define NIMLib_NIMGlobalDefs_h



/**
 *  消息内容类型枚举
 */
typedef NS_ENUM(NSInteger, NIMMessageType){
    /**
     *  文本类型消息
     */
    NIMMessageTypeText          = 0,
    /**
     *  图片类型消息
     */
    NIMMessageTypeImage         = 1,
    /**
     *  声音类型消息
     */
    NIMMessageTypeAudio         = 2,
    /**
     *  视频类型消息
     */
    NIMMessageTypeVideo         = 3,
    /**
     *  位置类型消息
     */
    NIMMessageTypeLocation      = 4,
    /**
     *  通知消息
     */
    NIMMessageTypeNotification  = 5,
    /**
     *  自定义消息
     */
    NIMMessageTypeCustom        = 100
};


/**
 *  NIM本地Error Domain
 */
extern NSString *const NIMLocalErrorDomain;

/**
 *  NIM服务器Error Domain
 */
extern NSString *const NIMRemoteErrorDomain;



/**
 *  本地错误码
 */
typedef NS_ENUM(NSInteger, NIMLocalErrorCode) {
    /**
     *  错误的参数
     */
    NIMLocalErrorCodeInvalidParam                 = 1,
    /**
     *  多媒体文件异常
     */
    NIMLocalErrorCodeInvalidMedia                 = 2,
    /**
     *  图片异常
     */
    NIMLocalErrorCodeInvalidPicture               = 3,
    /**
     *  url异常
     */
    NIMLocalErrorCodeInvalidUrl                   = 4,
    /**
     *  读取/写入文件失败
     */
    NIMLocalErrorCodeIOError                      = 5,
    /**
     *  无效的token
     */
    NIMLocalErrorCodeInvalidToken                 = 6,
    /**
     *  Http请求失败
     */
    NIMLocalErrorCodeHttpReqeustFailed            = 7,
    /**
     *  无录音权限
     */
    NIMLocalErrorCodeAudioRecordErrorNoPermission = 8,
    /**
     *  录音初始化失败
     */
    NIMLocalErrorCodeAudioRecordErrorInitFailed   = 9,
    /**
     *  录音失败
     */
    NIMLocalErrorCodeAudioRecordErrorRecordFailed   = 10,
    /**
     *  播放初始化失败
     */
    NIMLocalErrorCodeAudioPlayErrorInitFailed     = 11,
};




/**
 *  服务器错误码
 */
typedef NS_ENUM(NSInteger, NIMRemoteErrorCode) {
    /**
     *  登录IP或MAC被封锁
     */
    NIMRemoteErrorCodeIpBanError          = 310,
    /**
     *  内部帐户不允许在该地址登录
     */
    NIMRemoteErrorCodeIpNotAllowed        = 315,
    /**
     *  用户名不存在或密码错误
     */
    NIMRemoteErrorCodeUIDOrPassError      = 316,
    /**
     *  用户使用的版本过低
     */
    NIMRemoteErrorCodeLowVersion          = 317,
    /**
     *  用户被封禁
     */
    NIMRemoteErrorCodeForbidden           = 403,
    /**
     *  请求的目标（用户或对象）不存在
     */
    NIMRemoteErrorCodeNotExist            = 404,
    /**
     *  无权执行该操作
     */
    NIMRemoteErrorCodeAccessError         = 405,
    /**
     *  数据距上次更新无修改
     */
    NIMRemoteErrorCodeNoModify            = 406,
    /**
     *  请求过程超时
     */
    NIMRemoteErrorCodeTimeoutError        = 408,
    /**
     *  帐号或者验证码验证失败
     */
    NIMRemoteErrorCodeVerifyError         = 413,
    /**
     *  参数错误
     */
    NIMRemoteErrorCodeParameterError      = 414,
    /**
     *  网络连接出现错误
     */
    NIMRemoteErrorCodeConnectionError     = 415,
    /**
     *  操作太过频繁
     */
    NIMRemoteErrorCodeFrequently          = 416,
    /**
     *  对象已经存在
     */
    NIMRemoteErrorCodeExist               = 417,
    /**
     *  大小超过限制
     */
    NIMRemoteErrorCodeSizeLimit           = 419,
    /**
     *  操作出现异常
     */
    NIMRemoteErrorCodeOpException         = 420,
    /**
     *  未知错误，或者不方便告诉你
     */
    NIMRemoteErrorCodeUnknownError        = 500,
    /**
     *  服务器数据错误
     */
    NIMRemoteErrorCodeServerDataError     = 501,
    /**
     *  不足
     */
    NIMRemoteErrorCodeNotEnough           = 507,
    /**
     *  超过期限
     */
    NIMRemoteErrorCodeDomainExpireOld     = 508,
    /**
     *  已失效
     */
    NIMRemoteErrorCodeInvalid             = 509,
    /**
     *  用户不存在
     */
    NIMRemoteErrorCodeUserNotExist        = 510,
    /**
     *  初始成员不够
     */
    NIMRemoteErrorCodeTeamInitFailed      = 403,
    /**
     *  群组不存在
     */
    NIMRemoteErrorCodeTeamNotExists       = 802,
    /**
     *  没有操作群的权限
     */
    NIMRemoteErrorCodeTeamAccessError     = 803,
    /**
     *  群类型错误
     */
    NIMRemoteErrorCodeTeamInvaildType     = 805,
    /**
     *  超出群成员个数限制
     */
    NIMRemoteErrorCodeTeamMemberLimit     = 806,
    /**
     *  已经在群里
     */
    NIMRemoteErrorCodeTeamAlreadyIn       = 809,
    /**
     *   不是群成员
     */
    NIMRemoteErrorCodeTeamNotMember       = 810,
    /**
     *  在群黑名单中
     */
    NIMRemoteErrorCodeTeamBlackList       = 812,
    /**
     *  打包错误
     */
    NIMRemoteErrorCodeEPacket             = 999,
    /**
     *  解包错误
     */
    NIMRemoteErrorCodeEUnpacket           = 998
};




#endif
