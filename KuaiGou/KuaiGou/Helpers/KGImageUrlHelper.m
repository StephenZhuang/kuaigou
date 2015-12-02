//
//  KGImageUrlHelper.m
//  KuaiGou
//
//  Created by Stephen Zhuang on 15/5/14.
//  Copyright (c) 2015年 Hatlab. All rights reserved.
//

#import "KGImageUrlHelper.h"
#import "KGUploadManager.h"
#import "NSString+KGhmac_sha1.h"

static NSString * const KGImageBaseUrl = @"http://7xidkl.com1.z0.glb.clouddn.com/";

@implementation KGImageUrlHelper
+ (NSString *)imageUrlWithKey:(NSString *)key
{
    NSString *secretKey = QNSecretKey;
    NSString *downloadUrl = [NSString stringWithFormat:@"%@%@?e=1451491200",KGImageBaseUrl,key];
    NSString *sign = [downloadUrl HmacSha1WithSecret:secretKey];
    NSString *token = [NSString stringWithFormat:@"%@:%@",QNAppKey,sign];
    NSString *imageUrl = [downloadUrl stringByAppendingFormat:@"&token=%@",token];
    return imageUrl;
}
@end
