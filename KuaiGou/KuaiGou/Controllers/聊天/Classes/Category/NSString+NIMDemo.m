//
//  NSString+NIMDemo.m
//  NIMDemo
//
//  Created by chrisRay on 15/2/12.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NSString+NIMDemo.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (NIMDemo)

- (CGSize)stringSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
    if (IOS7) {
        return [self boundingRectWithSize:size
                                  options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                               attributes:@{NSFontAttributeName: font}
                                  context:nil].size;
    }else{
        return [self sizeWithFont:font constrainedToSize:size];
    }
}

- (NSString *)MD5String {
    const char *cstr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, strlen(cstr), result);
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


- (NSUInteger)getBytesLength
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return [self lengthOfBytesUsingEncoding:enc];
}


@end
