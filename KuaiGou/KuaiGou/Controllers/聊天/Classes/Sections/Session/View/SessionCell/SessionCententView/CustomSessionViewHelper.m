//
//  CustomSessionViewHelper.m
//  NIM
//
//  Created by chrisRay on 15/4/10.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "CustomSessionViewHelper.h"
#import "NSDictionary+Json.h"
@implementation CustomSessionViewHelper

+ (NSString*)janKenPonContent{
    //随机拿一个
    CustomJanKenPonValue JanKenPon = (arc4random() % CustomJanKenPonValuePon) + 1;
    NSDictionary *value = @{@"type":@(CustomMessageTypeJanKenPon),
                            @"data":@{@"value":@(JanKenPon)}};
    NSData *data = [NSJSONSerialization dataWithJSONObject:value options:0 error:nil];
    NSString *content = @"";
    if (data) {
        content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return content;
}


+ (CustomMessageResult)valueForCustom:(NSString*)content{
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    CustomMessageResult result;
    NSDictionary *valueDict;
    if (data) {
        valueDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([valueDict isKindOfClass:[NSDictionary class]]) {
            result.type  = [valueDict jsonInteger:@"type"];
            NSDictionary *data = [valueDict jsonDict:@"data"];
            if ([data isKindOfClass:[NSDictionary class]]) {
                result.value = [data jsonInteger:@"value"];
            }
        }
        
    }
    return result;
}

@end
