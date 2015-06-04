//
//  ContactDataItem.m
//  NIM
//
//  Created by chrisRay on 15/2/26.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "ContactDataItem.h"
#import "SpellingCenter.h"
#import "UsrInfoData.h"

@implementation ContactDataItem

- (NSString*)reuseId{
    return @"ContactDataItem";
}

- (NSString*)cellName{
    return @"ContactDataCell";
}

@end


@implementation ContactDataMember

- (CGFloat)uiHeight{
    return ContactDataRowHeight;
}

//userId和Vcname必有一个有值，根据有值的状态push进不同的页面

- (NSString*)vcName{
    return nil;
}

- (NSString*)reuseId{
    return @"ContactDataItem";
}

- (NSString*)cellName{
    return @"ContactDataCell";
}

- (NSString *)groupTitle {
    return [[SpellingCenter sharedCenter] firstLetter:self.nick].capitalizedString;
}

- (id)sortKey {
    return [[SpellingCenter sharedCenter] spellingForString:self.nick].shortSpelling;
}

@end