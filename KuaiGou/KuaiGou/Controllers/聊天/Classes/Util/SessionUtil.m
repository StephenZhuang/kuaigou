//
//  NIMUtil.m
//  NIMDemo
//
//  Created by ght on 15-1-27.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "SessionUtil.h"

double OnedayTimeIntervalValue = 24*60*60;  //一天的秒数
@implementation SessionUtil

+ (CGSize)getImageSizeWithImageOriginSize:(CGSize)originSize
                                  minSize:(CGSize)imageMinSize
                                  maxSize:(CGSize)imageMaxSiz
{
    CGSize size;
    NSInteger imageWidth = originSize.width ,imageHeight = originSize.height;
    NSInteger imageMinWidth = imageMinSize.width, imageMinHeight = imageMinSize.height;
    NSInteger imageMaxWidth = imageMaxSiz.width, imageMaxHeight = imageMaxSiz.height;
    if (imageWidth > imageHeight) //宽图
    {
        size.height = imageMinHeight;  //高度取最小高度
        size.width = imageWidth * imageMinHeight / imageHeight;
        if (size.width > imageMaxWidth)
        {
            size.width = imageMaxWidth;
        }
    }
    else if(imageWidth < imageHeight)//高图
    {
        size.width = imageMinWidth;
        size.height = imageHeight *imageMinWidth / imageWidth;
        if (size.height > imageMaxHeight)
        {
            size.height = imageMaxHeight;
        }
    }
    else//方图
    {
        if (imageWidth > imageMaxWidth)
        {
            size.width = imageMaxWidth;
            size.height = imageMaxHeight;
        }
        else if(imageWidth > imageMinWidth)
        {
            size.width = imageWidth;
            size.height = imageHeight;
        }
        else
        {
            size.width = imageMinWidth;
            size.height = imageMinHeight;
        }
    }
    return size;
}

+(NSString*)showTimeInSession:(NSTimeInterval) messageTime
{
    NSString *result = nil;
  
    NSCalendarUnit components = (NSCalendarUnit)(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSHourCalendarUnit | NSMinuteCalendarUnit);
    NSDateComponents *dateComponents = [self stringFromTimeInterval:messageTime components:components];
    if ([self isTheSameDay:[[NSDate date] timeIntervalSinceNow] compareTime:dateComponents]) {
        result = [NSString stringWithFormat:@"%@ %02zd:%02zd",NSLocalizedString(@"今天 ", nil), dateComponents.hour,dateComponents.minute];
    } else if ([self isTheSameDay:([[NSDate date] timeIntervalSinceNow] - OnedayTimeIntervalValue) compareTime:dateComponents])
    {
        result = [NSString stringWithFormat:@"%@ %02zd:%02zd",NSLocalizedString(@"昨天 ", nil), dateComponents.hour,dateComponents.minute];;
    } else if ([self isTheSameDay:([[NSDate date] timeIntervalSinceNow] - OnedayTimeIntervalValue*2) compareTime:dateComponents])
    {
        result = [NSString stringWithFormat:@"%@ %02zd:%02zd",NSLocalizedString(@"前天 ", nil), dateComponents.hour,dateComponents.minute];;
    } else if ([self isTheSameDay:([[NSDate date] timeIntervalSinceNow] - OnedayTimeIntervalValue*7) compareTime:dateComponents])
    {
        result =[NSString stringWithFormat:@"%@ %02zd:%02zd",[self weekdayStr:dateComponents.weekday], dateComponents.hour,dateComponents.minute];;
        
    } else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        result = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:messageTime]];
    }
    return result;
}
                                                 
+(BOOL)isTheSameDay:(NSTimeInterval)currentTime compareTime:(NSDateComponents*)older
{
    NSCalendarUnit currentComponents = (NSCalendarUnit)(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSHourCalendarUnit | NSMinuteCalendarUnit);
    NSDateComponents *current = [[NSCalendar currentCalendar] components:currentComponents fromDate:[NSDate dateWithTimeIntervalSinceNow:currentTime]];
    
    return current.year == older.year && current.month == older.month && current.day == older.day;
}

+(NSString*)weekdayStr:(NSInteger)dayOfWeek
{
    static NSDictionary *daysOfWeekDict = nil;
    daysOfWeekDict = @{@(0):@"星期日",
                       @(1):@"星期一",
                       @(2):@"星期二",
                       @(3):@"星期三",
                       @(4):@"星期四",
                       @(5):@"星期五",
                       @(6):@"星期六",
                       @(7):@"星期日"};
    return [daysOfWeekDict objectForKey:@(dayOfWeek)];
}


+(NSDateComponents*)stringFromTimeInterval:(NSTimeInterval)messageTime components:(NSCalendarUnit)components
{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:components fromDate:[NSDate dateWithTimeIntervalSince1970:messageTime]];
    return dateComponents;
}


+(NSString*)showTime:(NSTimeInterval) msglastTime
{
    //今天的时间
    NSDate * nowDate = [NSDate date];
    NSDate * msgDate = [NSDate dateWithTimeIntervalSince1970:msglastTime];
    NSString *result = nil;
    NSCalendarUnit components = (NSCalendarUnit)(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSHourCalendarUnit | NSMinuteCalendarUnit);
    NSDateComponents *nowDateComponents = [[NSCalendar currentCalendar] components:components fromDate:nowDate];
    NSDateComponents *msgDateComponents = [[NSCalendar currentCalendar] components:components fromDate:msgDate];

    if(nowDateComponents.day == msgDateComponents.day) //同一天,显示时间
    {
        NSInteger hour = msgDateComponents.hour;
        result = [SessionUtil getPeriodOfTime:hour withMinute:msgDateComponents.minute];
        if (hour > 12)
        {
            hour = hour - 12;
        }
        result = [[NSString alloc] initWithFormat:@"%@ %zd:%02d",result,hour,(int)msgDateComponents.minute];
    }
    else if(nowDateComponents.day == (msgDateComponents.day+1))//昨天
    {
        result = @"昨天";
    }
    else if(nowDateComponents.day == (msgDateComponents.day+2)) //前天
    {
        result = @"前天";
    }
    else if([nowDate timeIntervalSinceDate:msgDate] < 7 * OnedayTimeIntervalValue)//一周内
    {
        result = [SessionUtil weekdayStr:msgDateComponents.weekday];
    }
    else//显示日期
    {
        result = [NSString stringWithFormat:@"%zd-%zd-%zd", msgDateComponents.year, msgDateComponents.month, msgDateComponents.day];
    }
    return result;
}

+ (NSString *)getPeriodOfTime:(NSInteger)time withMinute:(NSInteger)minute
{
    NSInteger totalMin = time *60 + minute;
    NSString *showPeriodOfTime = @"";
    if (totalMin > 0 && totalMin <= 5 * 60)
    {
        showPeriodOfTime = @"凌晨";
    }
    else if (totalMin > 5 * 60 && totalMin < 12 * 60)
    {
        showPeriodOfTime = @"上午";
    }
    else if (totalMin >= 12 * 60 && totalMin <= 18 * 60)
    {
        showPeriodOfTime = @"下午";
    }
    else if ((totalMin > 18 * 60 && totalMin <= (23 * 60 + 59)) || totalMin == 0)
    {
        showPeriodOfTime = @"晚上";
    }
    return showPeriodOfTime;
}

+ (NSString *)currentUsrId {
    return [[NSUserDefaults standardUserDefaults] objectForKey:NIMUSERNAME];
}

+ (NSString *)currectUsrPassword {
    return [[NSUserDefaults standardUserDefaults] objectForKey:NIMUSERPASSWORD];
}

+ (void)sessionWithInputURL:(NSURL*)inputURL
                  outputURL:(NSURL*)outputURL
               blockHandler:(void (^)(AVAssetExportSession*))handler
{
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset
                                                                     presetName:AVAssetExportPresetMediumQuality];
    session.outputURL = outputURL;
    session.outputFileType = AVFileTypeMPEG4;   // 支持安卓某些机器的视频播放
    session.shouldOptimizeForNetworkUse = YES;
    [session exportAsynchronouslyWithCompletionHandler:^(void)
     {
         handler(session);
     }];
}

@end
