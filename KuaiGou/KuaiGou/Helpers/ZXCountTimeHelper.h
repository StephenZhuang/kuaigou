//
//  ZXCountTimeHelper.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/14.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXCountTimeHelper : NSObject
/**
 *  倒计时
 *
 *  @param time           总时间
 *  @param countDownBlock 每秒执行的方法
 *  @param endBlock       倒计时结束的方法
 */
+ (void)countDownWithTime:(int)time
           countDownBlock:(void (^)(int timeLeft))countDownBlock
                 endBlock:(void (^)())endBlock;
@end
