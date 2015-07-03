//
//  ContactUtilItem.m
//  NIM
//
//  Created by chrisRay on 15/2/26.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "ContactUtilItem.h"

@implementation ContactUtilItem

- (NSString*)reuseId{
    return @"ContactUtilItem";
}

- (NSString*)cellName{
    return @"ContactUtilCell";
}

- (NSString*)title{
    return nil;
}

@end

@implementation ContactUtilMember
@synthesize usrId;

- (CGFloat)uiHeight{
    return ContactUtilRowHeight;
}

- (NSString*)reuseId{
    return @"ContactUtilItem";
}

- (NSString*)cellName{
    return @"ContactUtilCell";
}

- (NSString *)groupTitle {
    return nil;
}

- (id)sortKey {
    return nil;
}

@end