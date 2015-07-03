//
//  CustomSessionViewHelper.h
//  NIM
//
//  Created by chrisRay on 15/4/10.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,CustomMessageType){
    CustomMessageTypeJanKenPon = 1, //自定义消息 - 剪子石头布
};


typedef NS_ENUM(NSInteger, CustomJanKenPonValue) {
    CustomJanKenPonValueKen     = 1,//石头
    CustomJanKenPonValueJan     = 2,//剪子
    CustomJanKenPonValuePon     = 3,//布
};

typedef struct{
    CustomMessageType type;
    CustomJanKenPonValue value;
}CustomMessageResult;

@interface CustomSessionViewHelper : NSObject

+ (NSString*)janKenPonContent;

+ (CustomMessageResult)valueForCustom:(NSString*)content;

@end
