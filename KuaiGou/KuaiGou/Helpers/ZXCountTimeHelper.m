//
//  ZXCountTimeHelper.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/14.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXCountTimeHelper.h"

@implementation ZXCountTimeHelper

+ (void)countDownWithTime:(int)time
           countDownBlock:(void (^)(int timeLeft))countDownBlock
                 endBlock:(void (^)())endBlock
{
    __block int timeout = time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (endBlock) {
                    endBlock();
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                timeout--;
                if (countDownBlock) {
                    countDownBlock(timeout);
                }
            });
        }
    });
    dispatch_resume(_timer);
}
@end
